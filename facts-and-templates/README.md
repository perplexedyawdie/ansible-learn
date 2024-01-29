<h1 align="center">Welcome to Ansible 101: Facts and Templates 👋</h1>
<p>
  <a href="#" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
</p>

> Ansible utilizes variables, facts, and templates to create adaptable automation workflows. Variables enable dynamic configuration management, facts provide system-specific information, and templates generate customizable configuration files. This approach ensures playbooks are reusable and flexible across different environments.

### 🏠 [Homepage](https://javel.dev/facts-and-templates)


## Usage

We're going to use the OS Family to determine whether to install NGINX of Lighttpd then we'll deploy a custom homepage to the remote host containing NGINX all without hardcoding hostnames.

1. Clone the repo
    

```bash
git clone https://github.com/perplexedyawdie/ansible-learn.git
```

2\. Change directory to **facts-and-templates**

```bash
cd ansible-learn/facts-and-templates

```

3\. Spin up the environment using docker-compose

```bash
docker compose up -d --build

```

4\. SSH into the Ansible server

```bash
ssh -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes root@localhost -p 2200
# password: test123
```
### Variables & facts

5\. Create a playbook called `server_setup.yaml`. Here, we'll setup NGINX & Lighttpd then output the name of the distro for each remote host

```yaml
- name: Install NGINX on Debian & Lighttpd on RedHat
  hosts: all
  vars:
   dev1: "Debian"
   dev2: "RedHat"
  tasks:
   - name: Install NGINX for Debian-based systems   
     ansible.builtin.apt:
      name: nginx
      state: present
     when: ansible_facts['os_family'] == dev1       

   - name: Install Lighttpd for RedHat-based systems 
     ansible.builtin.yum:
      name: lighttpd
      state: present
     when: ansible_facts['os_family'] == dev2       

   - name: Display the distribution
     ansible.builtin.debug:
      msg: "The server is running {{ ansible_facts['distribution'] }}"
```

6\. Run `ansible-lint`

```bash
ansible-lint server_setup.yaml
```

7\. Run the playbook

```bash
ansible-playbook --key-file /root/.ssh/id_rsa_ansible -u root -i inventory.yaml server_setup.yaml
```

8\. Confirm that setup was successful

```bash
ssh -i /root/.ssh/id_rsa_ansible root@server3 nginx -V

ssh -i /root/.ssh/id_rsa_ansible root@server2 lighttpd -v
ssh -i /root/.ssh/id_rsa_ansible root@server1 lighttpd -v
```

### Templates & Files

9\. Create a Jinja2 template file called `index.html.j2`

It will get auto populated with the OS Family & Distribution.

```Html
<html>
<head>
  <title>Welcome to {{ ansible_facts['os_family'] }}</title>
</head>
<body>
  <h1>Server running on {{ ansible_facts['distribution'] }}</h1>
</body>
</html>
```

10\. Create a playbook called `custom_homepage.yaml`

We're deploying the custom homepage created above to NGINX then restarting the server.

```yaml
- name: Deploy Custom Homepage and restart
  hosts: all
  vars:
   dev1: "Debian"
   dev2: "RedHat"
  tasks:
   - name: Create Homepage with Jinja2 Template for NGINX
     ansible.builtin.template:
      src: index.html.j2
      dest: /var/www/html/index.html
      mode: '644'
     when: ansible_facts['os_family'] == dev1
     notify: restart nginx

  handlers:
   - name: Restart NGINX
     listen: "restart nginx"
     ansible.builtin.service:
      name: nginx
      state: restarted
     when: ansible_facts['os_family'] == dev1
```

11\. Run the linter

```bash
ansible-lint custom_homepage.yaml

```

12\. Run the playbook

```bash

ansible-playbook --key-file /root/.ssh/id_rsa_ansible -u root -i inventory.yaml custom_homepage.yaml
```

13\. Confirm deployment by visiting [`http://localhost:2203`](http://localhost:2203) in your browser.


## Author

👤 **Javel Rowe**

* Website: https://javel.dev
* Github: [@perplexedyawdie](https://github.com/perplexedyawdie)
* LinkedIn: [@javel-rowe](https://linkedin.com/in/javel-rowe)

## Show your support

Give a ⭐️ if this project helped you!

***
_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_