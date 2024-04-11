#!/bin/bash
nomad status -address=http://198.19.249.156:4646 -region=east | awk '/^'${1}'/' | awk '{ print $1 }' | while read line 
do
   nomad stop -address=http://198.19.249.156:4646 -region=east -purge ${line}
done