#!/bin/bash

clear
#Lets install some network tools to make sure we can download and run networking/troubleshooting steps.
echo "#Lets install some network tools to make sure we can download and run networking/troubleshooting steps."
sleep 3s
sudo yum install -y tcpdump telnet wget
sudo yum install -y epel-release
sudo yum install -y git

#End of Package Installations

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
echo "Splunk user has been created, we will now pull down the Splunk Image from AWS."
echo "You should have a link from your Cloud Admin which references what Package to download from your S3 bucket."
sleep 2s
echo "Please paste the link now:"
read AWS_LINK
sleep 1s

#We will save this file as splunk_package.tar since it's essentially a tar file we are dowloading from AWS S3
curl $AWS_LINK > /opt/splunk_package.tar
tar -xvf /opt/splunk_package.tar
echo "OK, Splunk is now installed..."
sleep 2s

echo "We will now start Splunk and then install the openPath app"
sudo chown -R splunk:splunk /opt/splunk
sudo -u splunk /opt/splunk/bin/splunk start --accept-license
sudo -u splunk /opt/splunk/bin/splunk enable boot-start -user splunk

#Now we will instlall the app from GitHub. The directory is saved as openpath in GitHub
sleep 2s
echo "We will pull down the openPath app from OpenPath's GitHub Page"
sleep 4s
GITHUB_APP="https://github.com/sahrlebbie/openpath.git"
sudo git clone $GITHUB_APP

sudo mv /opt/openpath /opt/splunk/etc/apps
sudo chown -R splunk:splunk /opt/splunk

sudo -u splunk /opt/splunk/bin/splunk start
sudo -u splunk /opt/splunk/bin/splunk status
