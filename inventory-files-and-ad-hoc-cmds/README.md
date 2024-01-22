<h1 align="center">Welcome to Inventory Files & Ad-hoc Commands 👋</h1>
<p>
</p>

> The inventory file is the place to you define the list of hosts (this can be a local instance of a machine, remote servers etc) that you want to manage using Ansible. While Ad-hoc commands are specific commands for one time tasks that you run directly in the terminal.

### 🏠 [Blog](https://javel.dev)

## Setup
1. After cloning the repo, change directory to this folder
```sh
cd ansible-learn/inventory-files-and-ad-hoc-cmds
```

2. Spin up the environment using docker-compose
```sh
docker compose up -d --build
```

3. SSH into the Ansible server
```sh
ssh -o StrictHostKeyChecking=no root@localhost -p 2200
# password: test123
```

4. Create an **inventory.yaml** file and populate with hosts
```sh
cd ansible_learn

touch inventory.yaml

nano inventory.yaml

# Paste the following in your inventory.yaml file.
webservers:
  hosts:
    server1:
    server2:
    server3:
# To save and exit the editor:
# Windows: CTRL + X || Mac: CMD + X
# SHIFT + Y
# Enter
# Enter
```

5. Ping the hosts to ensure that you can connect to them
```sh
ansible webservers -m ping --key-file /root/.ssh/id_rsa_ansible -u root -i inventory.yaml
```

6. Copy a file to each host
```sh
touch test.txt

nano test.txt

# add some random text in the file

# To save and exit the editor:
# Windows: CTRL + X || Mac: CMD + X
# SHIFT + Y
# Enter
# Enter

ansible webservers -m copy -a "src=test.txt dest=/root/" --key-file /root/.ssh/id_rsa_ansible -u root -i inventory.yaml
```

7. SSH into a host to see your copied file
```sh
ssh -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa_ansible root@server1

ls

cat test.txt

# Returns you to the Ansible server shell
exit

# Logs out of the Ansible SSH session
exit
```

8. Stop and remove containers to clean up
```sh
docker compose down
```
## Show your support

Give a ⭐️ if this project helped you!

***
_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_