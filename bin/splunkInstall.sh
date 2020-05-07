#!/bin/bash

#Let's Clear the Screen so we can think!
clear

echo "                     # _---_"
echo "                    #-       /--__"
echo "               #_--( /     \ )XXXXXXXXXXX"
echo "             #####(   O   O  )XXXXXXXXXXXXXXX"
echo "            ####(       U     )        XXXXXXX"
echo "          #XXXXX(              )--_  XXXXXXXXXXX"
echo "         #XXXXX/ (      O     )   XXXXXX   \XXXXX"
echo "         #XXXX/   /            XXXXXX   \__ \XXXXX"
echo "         #XXXXX_/          XXXXXX         \_---->"
echo "   #_  XXX_/          XXXXXX      \_         /"
echo "   #-  --_/   _/\  XXXXXX            /  __--/="
echo "    #-\    _/    XXXXXX              '--- XXXXXX"
echo "       ######\ XXXXXX                      /XXXXX"
echo "         #XXXXXXXXX   \                    /XXXXX"
echo "          #XXXXXX      >                 _/XXXXX"
echo "            #XXXXX--_/              _-- XXXX"
echo "             #XXXXXXXX---------------  XXXXXX"
echo "                #XXXXXXXXXXXXXXXXXXXXXXXXXX/"
echo "                  #VXXXXXXXXXXXXXXXXXXV"

echo "This is a Splunk Installation script"
sleep 1s
echo "Would you like to continue with this script?(y/n)"
read ANSWER

if [ "$ANSWER" == "y" ] || [ "$ANSWER" == "yes" ]
then
	echo "Let's continue with this script then..."
	sleep 3s
echo "First, lets set your Splunk Username & Password for the Splunk Application User!"
sleep 1s
echo "This is not for the OS user, that will be next!"
sleep 3s
clear
echo "So what is the username you would like to set?"
sleep 1s
read USERNAME
echo "So what is the password you would like to use for your admin user?"
sleep 1s
read PASSWORD

echo "Now we will create the splunk OS user"
sudo useradd splunk
#Setting the Splunk Password
sudo passwd splunk

#Let's give splunk permissions to read basic linux logs from var messages|audit|secure.
sudo setfacl -m u:splunk:r /var/log/messages
sudo setfacl -m u:splunk:r /var/log/audit/audit.log
sudo setfacl -m u:splunk:r /var/log/secure
sudo setfacl -Rm u:splunk:rwx /opt
cd /tmp
sudo yum -y install wget tcpdump telnet

#So we are downloading version 8.0.3 Splunk here but you can utilize any version you want.
wget -O splunk-8.0.3-a6754d8441bf-Linux-x86_64.tgz 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=8.0.3&product=splunk&filename=splunk-8.0.3-a6754d8441bf-Linux-x86_64.tgz&wget=true'
sudo tar -xvf /tmp/splunk-8.0.3-a6754d8441bf-Linux-x86_64.tgz -C /opt >> /tmp/splunkInstall.txt
sudo chown -R splunk:splunk /opt/splunk/
sudo -u splunk /opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd $PASSWORD
sudo -u splunk /opt/splunk/bin/splunk status >> /tmp/splunkInstall.txt
sudo -u splunk /opt/splunk/bin/splunk enable listen 9997 -auth $USERNAME:$PASSWORD >> /tmp/splunkInstall.txt

#Now let's make sure we enter the correct server name and hostname resporting for Splunk in the UI.
echo "What would you like to call this server?"
sleep 2s
read ANSWER

#We will pass the password that you originally set earlier in the script.
#We will also set the default hostname
#Next we will set the default servername
#Finally we enable Splunk Web SSL. Be sure to custom set your certs as this script does not do that.
sudo -u splunk /opt/splunk/bin/splunk set default-hostname $ANSWER -auth $USERNAME:$PASSWORD
sudo -u splunk /opt/splunk/bin/splunk set servername  $ANSWER -auth $USERNAME:$PASSWORD
sudo -u splunk /opt/splunk/bin/splunk enable web-ssl -auth $USERNAME:$PASSWORD
sudo -u splunk /opt/splunk/bin/splunk restart

#Be sure to ingest this file if you want to splunk your installation process and ensure the logs proclaim the script works.
sudo -u splunk /opt/splunk/bin/splunk status >> /tmp/splunkInstall.txt

#Finishing Splunk Installation
echo "Your installation is finished" >> /tmp/splunkInstall.txt
elif
	[ "$ANSWER" == "n" ] || [ "$ANSWER" == "no" ]
then
	echo "Ok, you have chosen not to continue, we will exit the script"
	sleep 2s
	exit
else
	echo "You entered an answer the program was not expecting from answers expected"
	sleep 2s
	echo "Would you like to exit?(y/n)"
	read EXIT_ANSWER
		if [ "$EXIT_ANSWER" == "y" ] || [ "$EXIT_ANSWER" == "yes" ] || [ "$EXIT_ANSWER" == "Yes" ]
		then
			echo "Ok Re-running Splunk Installation Script...."
			sleep 2s
		else
			echo "Ok Exiting..."
			sleep 2s
			exit
		fi
	exit
fi
