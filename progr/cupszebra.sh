#! /bin/bash

string=$1
printer=`echo "$1" | cut -c "3-20"`

#echo "/usr/bin/cupsenable $printer"
sudo /usr/sbin/cupsenable $printer





