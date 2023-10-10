# AWS messageboard project

Ansible playbooks to deploy a Django project to the AWS cloud.</br>
The Django webapp runs on Gunicorn application server with Nginx reverse proxy.</br>
The webapp uses a PostgreSql database.</br>

**Requirements:**

- Fedora 38
- Python 3.11.4
- ansible 2.14.5
- aws-cli/2.13.0 configured with AWS access credentials

**Clone the project:**

git clone git@github.com:maxmin13/messageboard-prj.git

**Install the application:**

```
cd messageboard-prj
cd bin

./install.exp awsadmin
```

**Delete the application:**

```
cd messageboard-prj
cd bin

./delete.exp awsadmin
```

**Access Django admin site at:**

https://admin.maxmin.it:8443/admin

userid: admin
password: admin


**Access the messageboard app at:**

https://admin.maxmin.it:8443

<br>
