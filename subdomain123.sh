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
# nuclei

mkdir /tmp/sub

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
                
                echo 'enumerating:' $var
		
                assetfinder -subs-only $var > /tmp/sub/out2 
                cat /tmp/sub/out2  >> /tmp/sub/subs2
                
                echo 'enumerating:' $var
                
                findomain -t $var > /tmp/sub/out3
                cat /tmp/sub/out3 >> /tmp/sub/subs3
                
		#cd /opt/subdomain_takeover
		#crt.sh $var 
		#cat /opt/subdomain_takeover/crt/domains.txt > /tmp/sub/out4
		#cat /tmp/sub/out4 >> /tmp/sub/subs4
		
		echo 'enumerating:' $var
		
		python3 /opt/subdomain_takeover/Sublist3r/sublist3r.py -d $var -b -t 50  -o /tmp/sub/out5
                cat /tmp/sub/out5 >> /tmp/sub/subs5
                
                rm /tmp/sub/out1
                rm /tmp/sub/out2
                rm /tmp/sub/out3
                #rm /tmp/sub/out4
                rm /tmp/sub/out5
        done
done < $1

cd /tmp/sub/
cat /tmp/sub/subs* > all_domains 

duplicut /tmp/sub/all_domains -t 4 -o all_subs
rm /tmp/sub/subs1
rm /tmp/sub/subs2
rm /tmp/sub/subs3
#rm /tmp/sub/subs4
rm /tmp/sub/subs5

echo 'saved subdomains to all_subs'

echo 'FINDING LIVE HOSTS...'
cat all_subs | httprobe > live_subs
echo 'saved live hosts to live_subs'

echo 'CHECKING FOR SUBDOMAIN TAKEOVER...'

subzy -targets live_subs -hide_fails > subzy_result.txt

echo 'FINDING TAKEOVER HOSTS...'

python3 /opt/subdomain_takeover/subdover/subdover.py -l /tmp/sub/live_subs -o /tmp/sub/subdover_result.txt

echo 'FINDING NUCLEI TAKEOVER HOSTS...'

nuclei -l /tmp/sub/live_subs /root/.local/nuclei-templates/takeovers/

echo 'FINDING CNAME HOSTS...'
 
massdns -r /opt/subdomain_takeover/massdns/lists/resolvers.txt -t CNAME -o S -w /tmp/sub/live_subs_cname.txt /tmp/sub/live_subs

cat /tmp/take/live_subs_cname.txt | cut -f 3 -d " " | sed 's/.$//' > domain_cname.txt


echo 'CHECKING FOR SUBDOMAIN TAKEOVER...'

subzy -targets live_subs -hide_fails > subzy_result.txt

echo 'FINDING TAKEOVER HOSTS...'

python3 /opt/subdomain_takeover/subdover/subdover.py -l /tmp/sub/live_subs -o /tmp/sub/subdover_result.txt

echo 'FINDING NUCLEI TAKEOVER HOSTS...'

nuclei -l /tmp/sub/live_subs /root/.local/nuclei-templates/takeovers/

echo 'DONE'


