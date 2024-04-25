#!/bin/bash
nomad status -address=http://198.19.249.178:4646 -region=west | awk '/^'${1}'/' | awk '{ print $1 }' | while read line 
do
   nomad stop -address=http://198.19.249.178:4646 -region=west -purge ${line}
done