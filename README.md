# AWS messageboard project

Ansible playbooks to deploy a Django project to the AWS cloud.</br>
The Django webapp runs on Gunicorn application server with Nginx reverse proxy.</br>
The webapp uses a PostgreSql database.</br>

**Requirements:**

- Fedora 38
- Python 3.11.4
- ansible 2.14.5

**Create the datacenter on AWS:**

see project: github.com:maxmin13/datacenter-prj.git

**Clone the project:**

git clone git@github.com:maxmin13/messageboard-prj.git

**Upgrade all the instances and install some basic programs:**

```
cd provision
ansible-playbook -b -K playbooks/upgrade.yml
```

**Create the database:**

```
cd provision
ansible-playbook -b -K playbooks/postgresql.yml
```

**Install Gunicorn and deploy the Django project:**

```
cd provision
ansible-playbook -b -K playbooks/deploy-django.yml
```

**Access Django admin site at:**

https://admin.maxmin.it:8443/admin

<br>
