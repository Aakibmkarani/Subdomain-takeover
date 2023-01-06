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

                subfinder -silent -d $var > /tmp/sub/out1 
                cat /tmp/sub/out1 >> /tmp/sub/subs1

                assetfinder -subs-only $var > /tmp/sub/out2 
                cat /tmp/sub/out2  >> /tmp/sub/subs2
                
             	python3 /opt/subdomain_takeover/Sublist3r/sublist3r.py -d $var -t 50 -b -o /tmp/sub/out3
                cat /tmp/sub/out3 >> /tmp/sub/subs3
                
                findomain -t $var > /tmp/sub/out4
                cat /tmp/sub/out4 >> /tmp/sub/subs4
		
		crt.sh $var 
		cat /opt/subdomain_takeover/crt/domains.txt > /tmp/sub/out5
		cat /tmp/sub/out5 >> /tmp/sub/subs5
                
                rm /tmp/sub/out1 out2 out3 out4 out5
        done
done < $1

cat /tmp/sub/subs* > all_domains 

duplicut /tmp/sub/all_domains -t 4 -o all_subs
rm /tmp/sub/subs1 subs2 subs3 subs4 subs5

echo 'saved subdomains to all_subs'

echo 'FINDING LIVE HOSTS...'
cat all_subs | httprobe > live_subs
echo 'saved live hosts to live_subs'

echo 'CHECKING FOR SUBDOMAIN TAKEOVER...'

subzy -targets live_subs -hide_fails > subz_result.txt

python3 /opt/subdomain_takeover/subdover/subdovr.py -l live_subs -skip -o /tmp/sub/subdover_result.txt

echo 'DONE'
