#/!bin/bash 

#Requirements

mkdir /tmp/subdomain_takeover
cd /opt/subdomain_takeover

# Subfinder Subdomain finder
sudo apt install subfinder

# Assetfinder Subdomain finder
sudo apt install assetfinder

# Sublist3r Subdomain finder
git clone https://github.com/aboul3la/Sublist3r.git

# Installing dependencies
sudo apt-get install python-requests
sudo apt-get install python-dnspython
sudo apt-get install python-argparse

# Findomain Subdomain finder
curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux-i386.zip
unzip findomain-linux-i386.zip
chmod +x findomain
sudo mv findomain /usr/bin/findomain

# Clone this repository
git clone https://github.com/tdubs/crt.sh.git 
cd crt.sh | mv crt.sh /usr/bin

#----------------------------------------------------

# Subdomain Takeover Tools

# Navigate to the /opt directory (optional)
cd /tmp/subdomain_takeover

# Clone this repository
git clone https://github.com/PushpenderIndia/subdover.git

# Navigate to subdover folder
cd subdover

# Installing dependencies
chmod +x installer_linux.py
sudo python3 installer_linux.py

# Giving Executable Permission & Checking Help Menu
chmod +x subdover.py

# Go repository 
go install -v github.com/lukasikic/subzy@latest

# Please Manual chack
# Please chack this file Desktop go folder ya root go folder
 



