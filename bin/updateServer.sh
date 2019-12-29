#!/bin/bash

#This script was written to update the OpenPath SH's OS security packages.
#It does a basic yum updates and works at daily interval levels by default. Requires that splunk has root access to update the server.

yum update -y >> /tmp/updateYumPackages.log

