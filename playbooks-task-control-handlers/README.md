<h1 align="center">Welcome to Playbooks, Task Control, and Handlers 👋</h1>
<p>
  <a href="#" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
</p>

> Playbooks allow you to declare tasks to be performed on remote hosts while Task Controls & handlers allow you to specify how and when your automation scripts are executed.

### 🏠 [Homepage](https://javel.dev/playbooks-task-control-handlers)

## Setup
We'll start with two pre-configured inventory files. Inventory-webserver1.yaml contains two hosts while inventory-webserver2.yaml contains one host.

1. Clone the repo
```sh
git clone https://github.com/perplexedyawdie/ansible-learn.git
```
2. Change directory to **playbooks-task-control-handlers**
```sh
cd ansible-learn/playbooks-task-control-handlers
```
3. Spin up the environment using docker-compose
```sh
docker compose up -d --build
```
4. SSH into the Ansible server
```sh
ssh -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes root@localhost -p 2200
# password: test123
```
### Working with Playbooks 
5. Create playbook file
```sh
cd ansible_learn

touch install_nginx.yaml

nano install_nginx.yaml
```
6. Add the following config to install nginx
```sh
# ansible_learn/install_nginx.yaml
# setting the state param to "present" will ensure that it is installed

- name: Install NGINX Web Server
  hosts: webserver1
  tasks:
    - name: Install NGINX
      ansible.builtin.apt:
        name: nginx
        state: present
```
7. Run the linter
```sh
ansible-lint install_nginx.yaml
```
8. Execute the playbook on inventory-webserver1.yaml
```sh
ansible-playbook --key-file /root/.ssh/id_rsa_ansible -u root -i inventory-webserver1.yaml install_nginx.yaml
```
9. Confirm installation on server1 & server2 then check if it's installed on server3
```sh
ssh -i /root/.ssh/id_rsa_ansible root@server1 nginx -V
ssh -i /root/.ssh/id_rsa_ansible root@server2 nginx -V


ssh -i /root/.ssh/id_rsa_ansible root@server3 nginx -V
```
### Task Controls & Handlers
We want to create a playbook that installs Apache on servers that do not have a specific file (e.g., /var/www/html/index.nginx-debian.html), and then use a handler to restart Apache if it is newly installed or updated.

10.  Create & open the install_nginx.yaml file
```sh
touch conditional_install_apache.yaml

nano conditional_install_apache.yaml
```
11. Add condition to install Apache if /var/www/html/index.nginx-debian.html doesn't exist then add a handler to restart Apache if it is newly installed.
```sh
- name: Conditional Install and Restart Apache
  hosts: all
  tasks:
    - name: Check if NGINX Default Page Exists
      ansible.builtin.stat:
        path: /var/www/html/index.nginx-debian.html
      register: nginx_page

    - name: Install Apache
      ansible.builtin.apt:
        name: apache2
        state: present
      when: not nginx_page.stat.exists
      notify: Restart Apache

  handlers:
    - name: Restart Apache
      listen: "Restart Apache"
      ansible.builtin.service:
        name: apache2
        state: restarted

# The stat module checks for the existence of the default NGINX page. The result is registered in nginx_page.
# The installation task uses the when condition to install Apache only if the file does not exist.
# If the installation task runs, it notifies the handler to restart Apache.
# The handler listens for the notification and uses the service module to restart Apache.
```
12. Run the linter
```sh
ansible-lint conditional_install_apache.yaml
```
13. Execute the playbook on inventory-webserver1.yaml & inventory-webserver2.yaml
```sh
# webserver1
ansible-playbook --key-file /root/.ssh/id_rsa_ansible -u root -i inventory-webserver1.yaml conditional_install_apache.yaml

#webserver2
ansible-playbook --key-file /root/.ssh/id_rsa_ansible -u root -i inventory-webserver2.yaml conditional_install_apache.yaml
```
14. Confirm installation on server3 then check if it's installed on server1 & server2
```sh
ssh -i /root/.ssh/id_rsa_ansible root@server1 apache2 -V
ssh -i /root/.ssh/id_rsa_ansible root@server2 apache2 -V


ssh -i /root/.ssh/id_rsa_ansible root@server3 apache2 -V
```

## Author

👤 **Javel Rowe**

* Website: https://javel.dev
* Github: [@perplexedyawdie](https://github.com/perplexedyawdie)
* LinkedIn: [@javel-rowe](https://linkedin.com/in/javel-rowe)

## Show your support

Give a ⭐️ if this project helped you!

***
_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_