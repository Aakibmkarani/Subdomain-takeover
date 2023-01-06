#!/bin/bash

# ---------------------------------
# Requirements; Subdomain Finder
#----------------------------------
# subfinder
# assetfinder
# Sublist3r
# findomain
# crt.sh
# ---------------------------------
# Requirements; Subdomain Takeover
#----------------------------------
# subzy
# subdover

if [ -z $1 ]
then
        echo './subdomain.sh <list of domains>'
        exit 1
fi

echo 'FINDING SUBDOMAINS...'

while read line
do
        for var in $line
        do
                echo 'enumerating:' $var

                subfinder -silent -d $var > out1 
                cat out1 >> subs1


                assetfinder -subs-only $var > out2 
                cat out2 >> subs2
                
             	python3 /opt/Sublist3r/sublist3r.py -d $var -t 50 -b -o out4
                cat out4 >> subs4
                
                findomain -t $var > out3
                cat out3 >> subs3
		
		crt.sh $var 
		cat /tmp/crt/domains.txt > out5
		cat out5 >> subs5
                rm out1 out2 out3 out4 out5
        done
done < $1

cat subs* > all_domains 

duplicut all_domains -t 4 -o all_subs
rm subs1 subs2 subs3 subs4 subs5

echo 'saved subdomains to all_subs'

echo 'FINDING LIVE HOSTS...'
cat all_subs | httprobe > live_subs
echo 'saved live hosts to live_subs'

echo 'CHECKING FOR SUBDOMAIN TAKEOVER...'

subzy -targets live_subs -hide_fails > subz_result.txt

python3 /opt/subdover/subdovr.py -l live_subs -skip -o subdover_result.txt

echo 'DONE'
