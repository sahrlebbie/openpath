#!/bin/bash
#This script will look to find all the users inside of the users.conf file located in /opt/splunk/etc/apps/openpath/default/user.conf.
#It will then attempt to add each user to this instance with a for loop.

for USER in $(cat /opt/splunk/etc/apps/openpath/default/user.conf)
do
/opt/splunk/bin/splunk add user $USER -password Splunk18! -role admin -auth admin:KrBpqtHnRpswx$$6mQEyzkdrWn!
echo "The following user has been added to OpenPath Prod: $USER"
sleep 3s
done

#Now that the users have been added. We are going to disable this script it's input from Splunk.
sed -i 's/disabled = 0/disabled = 1/g' /opt/splunk/etc/apps/openpath/local/inputs.conf
