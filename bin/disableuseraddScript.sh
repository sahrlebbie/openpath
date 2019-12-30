#!/bin/bash

#Now that the users have been added. We are going to disable the Useradd script and it's input from Splunk.
sed -i 's/disabled = 0/disabled = 1/g' /opt/splunk/etc/apps/openpath/local/inputs.conf

/opt/splunk/bin/splunk restart 
