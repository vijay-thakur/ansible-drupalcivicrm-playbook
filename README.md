# DrupalCivicrm Setup on Ubuntu 16.04 machine on AWS.

#### STEP 1 :--> Setup New Running Server on AWS

If we don't have any server running to setup drupal and civicrm on AWS cloud, then we have to first setup running server. ec2_playbook.yml file is used to setup runing server ubuntu 16.04 on AWS. But first we have to manually create keypair on aws acount and downalod to the current directory from where you run this playbook. After downloading replace keypairname and keypairfilename in local.yml file under vars directory. We also need to setup aws credentials on your local machine so that we can create new EC2 instance on the AWS account. How to setup aws credentials for that you can search on Google. For to crreate EC2 instance please chnage follwing variables according to your environment in local.yml file

instancetype: "t2.micro"    # Chnage Instance Type

securitygroup: "ansible-webserver"   # Give Name to Security Group

awsaminame: "ami-41e9c52e"      # Please change ami name as per the AWS region 

keypairname: "sample"      # Replace with your keypair name don't add extension .pem in this.

keypairfilename: "sample.pem"      # Replace with your keypair name with .pem extenison

regionname: "ap-south-1"    # Replace with your aws Region name

#### Also you have to replace more things in local.yml file. Please change according to your need.

After doing all these things, Now we can run ec2_playbook.yml file with the following command from the directory where you clone this repo.

                    sudo ansible-playbook ec2_playbook.yml

#### STEP 2 :---> Already Have Running Server then you can skip Step 1

Now you have to simply copy your exsiting keypair to the clone directory and replace all variables according to your need. Create vault file to store your secret password like mysql root password, drupal admin password etc. 
Run follwing command to setup vault.yml under vars directoy :-->
#### Remove the existing vault.yml file from vars directory but don't remove local.yml file then create vault.yml file
                  cd vars
                  ansible-vault create vault.yml
Please provide the password while creating vault.yml file and then add entries in the file like below :-->
 
vault_drupal_password: "xxxxxxxx"

vault_civicrm_password: "xxxxxxx"

vault_account_password: "xxxxxxxx"

vault_mysql_root_password: "xxxxxxxx"

Replace "x" character with your own passowrds which you want to keep and then save the file after adding all secret info. Also create vault_password.txt file in this file simply add your vault password which you have created eariler while creating vault.yml file and keep vault_password.txt file under parent directory and remove the existing one first.

#### After that run the following playbook from your local machine

      sudo ansible-playbook setup.yml --ask-become-pass --vault-password-file=vault_password.txt



