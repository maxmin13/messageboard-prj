# AWS messageboard project

The project deploys a Django web application to the AWS cloud,</br>
with Gunicorn application server and Nginx reverse proxy.</br>
The store is a PostgreSql database.</br>

**Requirements:**

- Fedora 38
- Python 3.11.4
- ansible 2.14.5
- aws-cli/2.13.0

**Clone the project:**

git clone git@github.com:maxmin13/messageboard-prj.git


**Configure the AWS credentials and default region in the controller machine:**

```
aws configure
```

**Configure the project:**

edit **datacenter.json** and **hostedzone.json** and set the Vpc and DNS values accourding to your AWS account: <br>

* VPC CIDR (eg: "Cidr": "10.0.0.0/16")<br>
* VPC region (eg: "Region": "eu-west-1")<br>
* Availability zone (eg: "Az": "eu-west-1a")<br>
* Subnet CIDR (eg: "Cidr": "10.0.20.0/24")<br>
* instance private IP (eg: "PrivateIp": "10.0.20.35")<br>
* DNS registered domain (eg: "RegisteredDomain": "maxmin.it")<br>

**Install the web application:**

```
export REMOTE_USER=<SSH remote instance user, eg: awsadmin>
export REMOTE_USER_PASSWORD=<SSH remote instance user pwd, eg: awsadmin>

cd messageboard-prj/bin
chmod +x make.sh

./make.sh
```

**Log in the remote instance:**

```
cd messageboard-prj/access

rm -f ~/.ssh/known_hosts && ssh -v -i admin-key -p 22 awsadmin@<remote instance IP address>

```

**Access Django admin site at:**

https://msg.maxmin.it:8443/admin

userid: admin
password: admin


**Access the messageboard webapp at:**

https://msg.maxmin.it:8443


**Delete the datacenter and the application:**

```
cd messageboard-prj/bin

./delete.sh

```

<br>
