#!/bin/sh
appID=$1
password=$2
tenantID=$3
storageAcc=$4
sudo apt-get update
sudo apt-get install openjdk-8-jdk -y
addgroup hab
sudo useradd -g hab hab
usermod -aG sudo hab
sleep 30
curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash
echo "---Configure Repos for Azure Cli 2.0---" 
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893 
sudo apt-get update
sudo apt-get -y install apt-transport-https azure-cli
mkdir /scripts
echo "#!/bin/sh" >> /scripts/uploadhart.sh
echo "HARTFILE=\$1" >> /scripts/uploadhart.sh
echo "storageAccount='$storageAcc'" >> /scripts/uploadhart.sh
echo "export AZURE_STORAGE_ACCOUNT='$storageAccount'" >> /scripts/uploadhart.sh
echo "az login --service-principal -u '$appID' --password '$password' --tenant '$tenantID' > /dev/null" >> /scripts/uploadhart.sh
echo "az storage container create --name AppHart --output table > /dev/null" >> /scripts/uploadhart.sh
echo "az storage blob upload --container-name AppHart -f \$HARTFILE -n \$HARTFILE > /dev/null" >> /scripts/uploadhart.sh