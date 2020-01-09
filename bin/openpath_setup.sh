#!/bin/bash

clear
#Lets install some network tools to make sure we can download and run networking/troubleshooting steps. Some of these tools may already be installed.
#######################################################################################################
#########GIT and WGET INSTALLATION or PRE-INSTALLATION IS A MUST FOR THIS SCRIPT TO SUCCEED############
#######################################################################################################
echo "#Lets install some network tools to make sure we can download and run networking/troubleshooting steps."
sleep 3s
sudo yum install -y tcpdump telnet wget
sudo yum install -y epel-release
sudo yum install -y git 

#End of Package Installations

#######################################################################################################
#####################START OF SPLUNK INSTALLATIONS#####################################################
#######################################################################################################
sleep 4s
clear
echo "Okay, now we will start with the Splunk Installations by adding the users and dowloading the Splunk 8.0.1 Tar package"
sleep 4s

echo "This is OpenPath's AWS User Data Script. It is designed to add the splunk user at boot."
sudo useradd splunk
clear
echo "Let's set the splunk service account password"
sleep 2s
sudo passwd splunk
usermod -aG wheel splunk
cd /opt
sleep 3s
clear
echo "Splunk user has been created, we will now pull down the Splunk Packages from AWS."
echo "We are going to hardcode this link in here and change it in AWS and Github should things change..."
sleep 3s


#CHANGE THIS PATH FOR AN UPDATED VERSION 
SPLUNK_INSTALLATION_PACKAGE="https://publicopenpath.s3.amazonaws.com/splunk-7.3.3-7af3758d0d5e-Linux-x86_64.tar"

#We will save this file as splunk_package.tar since it's essentially a tar file we are dowloading from AWS S3
curl $SPLUNK_INSTALLATION_PACKAGE > /opt/splunk_package.tar
tar -xvf /opt/splunk_package.tar
echo "OK, Splunk is now installed..."
sleep 2s

echo "We will now start Splunk and then install the OpenPath app and a few other Splunkbase Apps"
sudo chown -R splunk:splunk /opt/splunk
sudo -u splunk /opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --gen-and-print-passwd
sudo /opt/splunk/bin/splunk enable boot-start -user splunk

#Now we will instlall the app from GitHub. The directory is saved as openpath in GitHub
sleep 2s
echo "We will pull down the openPath app from OpenPath's GitHub Page"
echo "."
sleep 1s
echo "..."
sleep 1s
echo "....."
sleep 1s
echo "........"
sleep 1s
echo "........"
sleep 1s
sleep 3s
OPENPATH_APP="https://github.com/sahrlebbie/openpath.git"
sudo git clone $OPENPATH_APP

sudo mv /opt/openpath /opt/splunk/etc/apps

#Now we will instlall the ImoTech app from GitHub. The directory is saved as imotech_secops in GitHub
sleep 2s
echo "We will pull down the ImoTech app from OpenPath's GitHub Page"
echo "."
sleep 1s
echo "..."
sleep 1s
echo "....."
sleep 1s
echo "........"
sleep 1s
echo "........"
sleep 1s
sleep 3s
IMOTECH_APP="https://github.com/sahrlebbie/imotech_secops.git"
sudo git clone $IMOTECH_APP

sudo mv /opt/imotech_secops /opt/splunk/etc/apps

#Moving to apps dorectory for staging of Splunkbase apps
cd /opt/splunk/etc/apps/

#######################################################################################################
#####################CUSTOM APP INSTALLATIONS##########################################################
#######################################################################################################
#Custom Apps Installation. These are OPTIONAL. Comment this out if you do NOT want these apps installed on your Splunk Instance.

#Next we will install the Palo Alto Add-on
PALO_ALTO_ADD_ON="https://publicopenpath.s3.amazonaws.com/palo-alto-networks-add-on-for-splunk_611.tar"
curl $PALO_ALTO_ADD_ON > palo-alto-networks-add-on-for-splunk_611.tar

#Next we will install the AWS Add-on
AWS_ADD_ON="https://publicopenpath.s3.amazonaws.com/splunk-add-on-for-amazon-web-services_461.tar"
curl $AWS_ADD_ON > splunk-add-on-for-amazon-web-services_461.tar

#Next we will install the Unix/Linux Add-on
UNIX_LINUX_ADD_ON="https://publicopenpath.s3.amazonaws.com/splunk-add-on-for-unix-and-linux_700.tar"
curl $UNIX_LINUX_ADD_ON > splunk-add-on-for-unix-and-linux_700.tar

tar -xvf  palo-alto-networks-add-on-for-splunk_611.tar
tar -xvf splunk-add-on-for-amazon-web-services_461.tar
tar -xvf splunk-add-on-for-unix-and-linux_700.tar

#Changing ownership to splunk
sudo chown -R splunk:splunk /opt/splunk*

sudo -u splunk /opt/splunk/bin/splunk restart
sudo -u splunk /opt/splunk/bin/splunk status


#Now let's create a backup directory for our installed apps/add-ons and move the apps/add-ons there for historical/audit purposes.
sudo mkdir /opt/splunk_installed_apps_addons
sudo mv *.tar /opt/splunk_installed_apps_addons/

sudo chown -R splunk:splunk /opt/splunk*

echo "."
sleep 1s
echo "..."
sleep 1s
echo "....."
sleep 1s
echo "........"
sleep 1s
echo "........"
sleep 1s
echo "Congratulations, you have a fully functioning Splunk Instance with SSL(Splunk default cert-so please change!!) enabled and using your custom login-page settings"
echo "Goodbye"
sleep 2s
