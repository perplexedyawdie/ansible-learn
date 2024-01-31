<h1 align="center">Welcome to Modularization & Debugging 👋</h1>
<p>
  <a href="#" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
</p>

> By understanding roles, you can create modular playbooks that are easier to extend and maintain. With error handling and debugging, you can ensure that your playbooks are reliable and easier to troubleshoot.

### 🏠 [Homepage](https://javel.dev)

## Practice

Our aim is to modularize the process of installing NGINX and updating the homepage. We also want to handle an error caused by incorrect package name and dynamically fix it.

1. Clone the repo
    

```bash
git clone https://github.com/perplexedyawdie/ansible-learn.git
```

2\. Change directory to **modularization-and-debugging**

```bash
cd ansible-learn/modularization-and-debugging
```

3\. Spin up the environment using docker-compose

```bash
docker compose up -d --build
```

4\. SSH into the Ansible server

```bash
ssh -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes root@localhost -p 2200# password: test123
```

### Roles & Modularization

5\. Create the roles directory with the relevant folders. For this task, we'll only require `tasks` , `templates` and `handlers`

```bash
cd ansible_learn

mkdir -p roles/nginx/tasks roles/nginx/templates roles/nginx/handlers

```

6\. Create the template that will generate the homepage.

Filename: `index.html.j2`

Location: `ansible_learn/roles/nginx/templates`

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

7\. Create the tasks that will install NGINX, generate the homepage, and copy it to the server.

* Filename: `main.yaml`
    
* Location: `ansible_learn/roles/nginx/tasks`
    

```yaml
- name: Install NGINX for Debian-based systems   
  ansible.builtin.apt:
   name: nginx
   state: present
- name: Create Homepage with Jinja2 Template for NGINX
  ansible.builtin.template:
   src: index.html.j2
   dest: /var/www/html/index.html
   mode: '644'
  notify: restart nginx
   
```

8\. Create the handler that will restart NGINX upon update.

* Filename: `main.yaml`
    
* Location: `ansible_learn/roles/nginx/handlers`
    

```yaml
- name: Restart NGINX
  listen: "restart nginx"
  ansible.builtin.service:
   name: nginx
   state: restarted
```

9\. Create the playbook.

* Filename: `nginx_setup.yaml`
    
* Location: `ansible_learn`
    

```yaml
- name: Install NGINX
  hosts: all
  roles:
   - role: nginx    

```

10\. Run the linter

```bash
ansible-lint nginx_setup.yaml

```

11\. Execute the playbook.

```bash
ansible-playbook --key-file /root/.ssh/id_rsa_ansible -u root -i inventory.yaml nginx_setup.yaml

```

12\. Confirm deployment by visiting [http://localhost:2203](http://localhost:2203/) in your browser.

### Error Handling

The aim is to use `block` and `rescue` to print a custom message on error.

  
13\. Create a new playbook that should install Apache but use the wrong package name then add block & rescue properties.Filename: `error_test.yaml`Location: `ansible_learn`

```yaml
- name: Install Apache on Ubuntu
  hosts: all
  tasks:
    - name: Install Apache for Debian-based systems
      block:
        - name: Installer
          ansible.builtin.apt:
            name: httpd
            state: present
      rescue:
        - name: Installer errors
          ansible.builtin.debug:
            msg: "Error installing Apache on {{ ansible_facts['distribution'] }}"
```

14\. Run the linter

```bash
ansible-lint error_test.yaml

```

15\. Execute the playbook

```bash
ansible-playbook --key-file /root/.ssh/id_rsa_ansible -u root -i inventory.yaml error_test.yaml
```

### Debugging

The aim is to use the `debugger` and dynamically fix an error in a task.

  
16\. Update the `error_test.yaml` playbook and add the `debugger` property

```yaml
- name: Install Apache on Ubuntu
  hosts: all
  debugger: on_failed  
  tasks:
    - name: Install Apache for Debian-based systems
      block:
        - name: Installer
          ansible.builtin.apt:
            name: httpd
            state: present
      rescue:
        - name: Installer errors
          ansible.builtin.debug:
            msg: "Error installing Apache on {{ ansible_facts['distribution'] }}"
```

17\. Run the linter

```bash
ansible-lint error_test.yaml

```

18\. Execute the playbook

```bash
ansible-playbook --key-file /root/.ssh/id_rsa_ansible -u root -i inventory.yaml error_test.yaml

```

19\. In the interactive debugger, run the following commands to update the package name

```bash
# display all args in the failed task, we are interested in the name, since that contains the name of the package
p task.args

# update the package name. When installing Apache on Ubuntu, we use apache2
task.args['name'] = 'apache2'

# rerun the task
redo

# exit the debugger
quit
```

20\. Confirm successful installation of Apache

```bash
ssh -i /root/.ssh/id_rsa_ansible root@server1 apache2 -V

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