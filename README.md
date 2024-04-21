# AWS messageboard project

The project deploys a Django web application to AWS.</br>
The web application runs on Gunicorn HTTP server backed by a PostgreSql database.</br>

## Local work machine requirements: ##

- Fedora 38
- Python 3.11.4
- ansible 2.14.5

## Configure the AWS credentials and default region in your work machine: ##

Log into AWS management console as root, go to IAM, Users, create a new user.</br>
Select the user and create the access keys.</br>
Associate the user with an identity-based policy that allows access to route53 webservices, for ex: AmazonRoute53FullAccess.</br>
Associate the user with an identity-based policy that allows access to ec2 webservices, for ex: AmazonEC2FullAccess.</br>
The access key, the secret access key, the AWS region associated with the user have to be exported before running the scripts.


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
* (Not mandatory) DNS registered domain (your domain registered with the AWS registrar, eg: "RegisteredDomain": "maxmin.it")<br>


## Install the web application: ##

```
export AWS_ACCESS_KEY_ID=<AWS IAM user credentials>
export AWS_SECRET_ACCESS_KEY=<AWS IAM user credentials>
export AWS_DEFAULT_REGION=<AWS IAM user credentials>

cd messageboard-prj/bin
chmod +x make.sh

./make.sh
```

## Log in the remote AWS instance: ##

```
// log into the remote instance, with your AWS user and the public IP assigned to the AWS instance, ex:
cd messageboard-prj/access

rm -f ~/.ssh/known_hosts && ssh -v -i <instance private key, eg: messageboard-box> -p 22 <instance user, see datacenter.json, eg: msgadmin>@176.34.196.38
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
export AWS_ACCESS_KEY_ID=<AWS IAM user credentials>
export AWS_SECRET_ACCESS_KEY=<AWS IAM user credentials>
export AWS_DEFAULT_REGION=<AWS IAM user credentials>

cd messageboard-prj/bin
chmod +x delete.sh

./delete.sh

```

<br>
