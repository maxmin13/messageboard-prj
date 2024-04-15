# AWS messageboard project

The project deploys a Django web application in AWS.</br>
The web application runs in Gunicorn.</br>
It uses a PostgreSql database.</br>

## Requirements: ##

- Fedora 38
- Python 3.11.4
- ansible 2.14.5
- aws-cli/2.13.0

## Configure the AWS credentials and default region in your work machine: ##

Log into in AWS management console as root, go to Iam, Users, create a new AWS user,
provide the user with access to the AWS Management Console.</br>
Select the user and create the access keys for access from the Command Line Interface (CLI).</br>
Associate the user with an identity-based policy that allows access to route53 webservices, for ex: AmazonRoute53FullAccess.</br>
Associate the user with an identity-based policy that allows access to ec2 webservices, for ex: AmazonEC2FullAccess.</br>

In you terminal, install AWS Command Line Interface (CLI).</br>
Enter the access key, the secret access key, your AWS region:

```
aws configure
```

## Clone the project: ##

git clone git@github.com:maxmin13/messageboard-prj.git

## Configure the project: ##

edit **config/datacenter.json** and **config/hostedzone.json** and set the Vpc and DNS values according 
to your AWS account: <br>

* VPC CIDR (eg: "Cidr": "10.0.0.0/16")<br>
* VPC region (eg: "Region": "eu-west-1")<br>
* Availability zone (eg: "Az": "eu-west-1a")<br>
* Subnet CIDR (eg: "Cidr": "10.0.20.0/24")<br>
* Instance private IP (eg: "PrivateIp": "10.0.20.35")<br>
* Set instance user name and instance user password with your AWS user credentials<br>
* (Not mandatory) DNS registered domain (your domain registered with the AWS registrar, eg: "RegisteredDomain": "maxmin.it")<br>


## Install the web application: ##

```
export AWS_REMOTE_USER=<remote AWS instance user, eg: awsadmin>
export AWS_REMOTE_USER_PASSWORD=<remote AWS instance user pwd, eg: awsadmin>

cd messageboard-prj/bin
chmod +x make.sh

./make.sh
```

## Log in the remote AWS instance: ##

```
cd messageboard-prj/access

rm -f ~/.ssh/known_hosts && ssh -v -i admin-key -p 22 awsadmin@<remote AWS instance IP address>

```

## Access Django admin site at: ##

*https://messageboard.maxmin.it:8443/admin*
<br>
*https://AWS-instance-public-IP-address:8443/admin*

userid: admin<br>
password: admin


## Access the messageboard webapp at: ##

*https://messageboard.maxmin.it:8443*<br>
*https://AWS-instance-public-IP-address:8443*


## Delete the datacenter and the application: ##

```
cd messageboard-prj/bin
chmod +x delete.sh

./delete.sh

```

<br>
