# This script will deploy a Hub and Spoke network topology in Azure. It will create the following resources:
# 1. Hub network with Azure Firewall and VPN Gateway
# 2. Azure Bastion Virtual Network with Azure Bastion
# 3. Shared Services network for ADDS
# 4. Spoke network for workloads
# 5. Virtual Network Peerings
# 6. Route Tables
# 7. Network Security Groups
# 8. Some NSG Rules
# 9. Azure Firewall Policy with an Allow-All Azure Firewall Rule

# Set variables for Azure environment
# Note. You can change the values of these variables to suit your environment.
# Define the Azure location where you want to deploy the resources
location=swedencentral

# Define the name of the resource groups
rghub=rg-cmc-hub-swc01
rgbst=rg-cmc-bst-swc01
rgshsvc=rg-cmc-sharedsvc-swc01
rgwload=rg-cmc-spoke-swc01
rgmgmt=rg-cmc-mgmt-swc01

# Note. This script assumes that you do NOT have already created a resource group in Azure. If you have, comment the following lines.
# Create resource groups
az group create -n $rghub -l $location
az group create -n $rgbst -l $location
az group create -n $rgshsvc -l $location
az group create -n $rgwload -l $location
az group create -n $rgmgmt -l $location

######## Deploy Hub Virtual Network ########
# Set Variables for Hub Network
hub_vnet_name=vnet-hub-swc01
hub_vnet_prefix=10.1.0.0/24
azfw_subnet_name=AzureFirewallSubnet
azfw_subnet_prefix=10.1.0.0/26 # This is the default prefix for AzureFirewallSubnet. You can change it if you want to.
azfw_mgmt_subnet_name=AzureFirewallManagementSubnet
azfw_mgmt_subnet_prefix=10.1.0.64/26
gw_subnet_name=GatewaySubnet
gw_subnet_prefix=10.1.0.128/27 # This is the default prefix for GatewaySubnet. You can change it if you want to.

# Create Hub virtual network
az network vnet create -g $rghub -n $hub_vnet_name --address-prefix $hub_vnet_prefix -l $location
az network vnet subnet create -g $rghub -n $gw_subnet_name --vnet-name $hub_vnet_name --address-prefix $gw_subnet_prefix
az network vnet subnet create -g $rghub -n $azfw_subnet_name --vnet-name $hub_vnet_name --address-prefix $azfw_subnet_prefix

######## Deploy Azure Bastion Virtual Network ########
# Set Variables for Azure Bastion Virtual Network
bst_vnet_name=vnet-bst-swc01
bst_vnet_prefix=10.1.1.0/24
bst_subnet_name=AzureBastionSubnet
bst_subnet_prefix=10.1.1.0/26 # This is the default prefix for AzureBastionSubnet. You can change it if you want to.

# Create Azure Bastion Virtual Network
az network vnet create -g $rgbst -n $bst_vnet_name --address-prefix $bst_vnet_prefix -l $location
az network vnet subnet create -g $rgbst -n $bst_subnet_name --vnet-name $bst_vnet_name --address-prefix $bst_subnet_prefix
# az network vnet subnet create -g $rgbst -n $bst_subnet_name --vnet-name $bst_vnet_name --address-prefix $bst_subnet_prefix --network-security-group bst-nsg

######## Deploy Shared Services Network ########
# Set Variables for Shared Services Network
sharedsvc_vnet_name=vnet-sharedsvc-swc01
sharedsvc_vnet_prefix=10.1.2.0/24
ad_subnet_name=AdSubnet
ad_subnet_prefix=10.1.2.0/27

# Create Network Security Group for ADDS subnet in the Shared Services network
az network nsg create -n ad-nsg -g $rgshsvc -l $location

# Create Shared Services virtual network
az network vnet create -g $rgshsvc -n $sharedsvc_vnet_name --address-prefix $sharedsvc_vnet_prefix -l $location
az network vnet subnet create -g $rgshsvc -n $ad_subnet_name --vnet-name $sharedsvc_vnet_name --address-prefix $ad_subnet_prefix --network-security-group ad-nsg

######## Deploy Spoke Network aka Workload Network ########
# Set Variables for Spoke Network
spoke_vnet_name=vnet-spoke-swc01
spoke_vnet_prefix=10.1.4.0/23
waf_subnet_name=WafSubnet
waf_subnet_prefix=10.1.4.0/24
web_subnet_name=WebSubnet
web_subnet_prefix=10.1.5.0/27
weba_subnet_name=WebASubnet
weba_subnet_prefix=10.1.5.32/27
cma_subnet_name=CmaSubnet
cma_subnet_prefix=10.1.5.64/27
cmaa_subnet_name=CmaASubnet
cmaa_subnet_prefix=10.1.5.96/27
db_subnet_name=DbSubnet
db_subnet_prefix=10.1.5.128/27

# Create Network Security Groups for Spoke subnets
az network nsg create -n waf-nsg -g $rgwload -l $location
az network nsg create -n web-nsg -g $rgwload -l $location
az network nsg create -n weba-nsg -g $rgwload -l $location
az network nsg create -n cma-nsg -g $rgwload -l $location
az network nsg create -n cmaa-nsg -g $rgwload -l $location
az network nsg create -n db-nsg -g $rgwload -l $location

# Create spoke virtual network
az network vnet create -g $rgwload -n $spoke_vnet_name --address-prefix $spoke_vnet_prefix -l $location
az network vnet subnet create -g $rgwload -n $waf_subnet_name --vnet-name $spoke_vnet_name --address-prefix $waf_subnet_prefix --network-security-group waf-nsg
az network vnet subnet create -g $rgwload -n $web_subnet_name --vnet-name $spoke_vnet_name --address-prefix $web_subnet_prefix --network-security-group web-nsg
az network vnet subnet create -g $rgwload -n $weba_subnet_name --vnet-name $spoke_vnet_name --address-prefix $weba_subnet_prefix --network-security-group weba-nsg
az network vnet subnet create -g $rgwload -n $cma_subnet_name --vnet-name $spoke_vnet_name --address-prefix $cma_subnet_prefix --network-security-group cma-nsg
az network vnet subnet create -g $rgwload -n $cmaa_subnet_name --vnet-name $spoke_vnet_name --address-prefix $cmaa_subnet_prefix --network-security-group cmaa-nsg
az network vnet subnet create -g $rgwload -n $db_subnet_name --vnet-name $spoke_vnet_name --address-prefix $db_subnet_prefix --network-security-group db-nsg

######## Update NSG Rules for Spoke Network ########
# Update NSG Rules for Spoke Network (These are just sample starter rules. You will need to update them to allow and deny your specific traffic.)
echo "Updating NSGs Rules..."
az network nsg rule create -n WebIn --nsg-name "web-nsg" -g $rgwload --priority 1000 --destination-port-ranges 80 --access Allow --protocol Tcp -o none
az network nsg rule create -n AdminIn --nsg-name "web-nsg" -g $rgwload --priority 1020 --destination-port-ranges 22 3389 --access Allow --protocol Tcp -o none
az network nsg rule create -n webaIn --nsg-name "weba-nsg" -g $rgwload --priority 1010 --destination-port-ranges 8080 --access Allow --protocol Tcp -o none
az network nsg rule create -n AdminIn --nsg-name "weba-nsg" -g $rgwload --priority 1020 --destination-port-ranges 22 3389 --access Allow --protocol Tcp -o none
az network nsg rule create -n CmaIn --nsg-name "cma-nsg" -g $rgwload --priority 1010 --destination-port-ranges 2901 --access Allow --protocol Tcp -o none
az network nsg rule create -n AdminIn --nsg-name "cma-nsg" -g $rgwload --priority 1020 --destination-port-ranges 22 3389 --access Allow --protocol Tcp -o none
az network nsg rule create -n CmaaIn --nsg-name "cmaa-nsg" -g $rgwload --priority 1010 --destination-port-ranges 2901 --access Allow --protocol Tcp -o none
az network nsg rule create -n AdminIn --nsg-name "cmaa-nsg" -g $rgwload --priority 1020 --destination-port-ranges 22 3389 --access Allow --protocol Tcp -o none
az network nsg rule create -n SqlDbiIn --nsg-name "db-nsg" -g $rgwload --priority 1010 --destination-port-ranges 1433 --access Allow --protocol Tcp -o none
az network nsg rule create -n AdminIn --nsg-name "db-nsg" -g $rgwload --priority 1020 --destination-port-ranges 22 3389 --access Allow --protocol Tcp -o none
az network vnet subnet update -n $web_subnet_name --vnet-name $spoke_vnet_name -g $rgwload --network-security-group web-nsg -o none
az network vnet subnet update -n $weba_subnet_name --vnet-name $spoke_vnet_name -g $rgwload --network-security-group weba-nsg -o none
az network vnet subnet update -n $cma_subnet_name --vnet-name $spoke_vnet_name -g $rgwload --network-security-group cma-nsg -o none
az network vnet subnet update -n $cmaa_subnet_name --vnet-name $spoke_vnet_name -g $rgwload --network-security-group cmaa-nsg -o none
az network vnet subnet update -n $db_subnet_name --vnet-name $spoke_vnet_name -g $rgwload --network-security-group db-nsg -o none

######## Deploy Azure Bastion ########
# Create Azure Bastion
az network public-ip create -g $rgbst -n bst-pip --sku standard -l $location
az network bastion create -n bastion -g $rgbst -l $location --public-ip-address bst-pip --vnet-name $bst_vnet_name --sku standard --no-wait
# Note. The --no-wait parameter allows Bastion to be created in the background. It does not mean that Bastion is created immediately. Bastion deployment can take 20 minutes or more. 
# You can't modify the Vnet whilst Bastion is being created. You can check the status of Bastion with the following command: az network bastion show -n bastion -g $rg -o table

######## Deploy Azure Firewall and VPN Gateway ########
# Create Azure Firewall
# Azure Firewall Tier and Azure Firewall Policy SKU
sku=Standard
az network firewall policy create -n azfwpolicy -g $rghub --sku $sku
az network public-ip create -g $rghub -n azfw-pip --sku standard --allocation-method static -l $location
azfw_ip=$(az network public-ip show -g $rghub -n azfw-pip --query ipAddress -o tsv)
az network firewall create -n azfw -g $rghub -l $location --tier $sku --threat-intel-mode Deny
azfw_id=$(az network firewall show -n azfw -g $rghub -o tsv --query id)
az network firewall ip-config create -f azfw -n azfw-ipconfig -g $rghub --public-ip-address azfw-pip --vnet-name $hub_vnet_name
az network firewall update -n azfw -g $rghub
# the following command may take a few minutes to return the private IP address, and it could fail if the firewall is still being provisioned. If that happens, just run the command again or if you did not change your network space use 10.1.0.4
azfw_private_ip=$(az network firewall show -n azfw -g $rghub --query 'ipConfigurations[0].privateIpAddress' -o tsv)
echo $azfw_private_ip

# Create an Azure Firewall Policy (This is a Test rule to allow everything)
# You need to manually assign the policy to the Azure Firewall after creating it.
az network firewall policy rule-collection-group create -n TestRules --policy-name azfwpolicy -g $rghub --priority 100
az network firewall policy rule-collection-group collection add-filter-collection --policy-name azfwpolicy --rule-collection-group-name TestRules -g $rghub \
--name NetworkTraffic --collection-priority 150 --action Allow --rule-name permitAny --rule-type NetworkRule --description "Permit all traffic - TEST" \
--destination-addresses '*' --destination-ports '*' --source-addresses '*' --ip-protocols Tcp Udp Icmp

# Assign Azure Firewall Policy
# You need to manually assign the policy to the Azure Firewall after creating it.
# Work in progress

######## Create Virtual Network Gateway ########
# Create VPN Gateway (est. provisioning time is 30-40mins)
# Set variables for VPN Gateway
gw_hub_name=vpn-hub-swc01
gw_hub_pip_name=pip-vpn-hub-swc01

# Create Public IP for VPN Gateway
az network public-ip create -n $gw_hub_pip_name -g $rghub --allocation-method Static

# Create VPN Gateway
az network vnet-gateway create -n $gw_hub_name -l $location --public-ip-address $gw_hub_pip_name -g $rghub --vnet $hub_vnet_name --gateway-type Vpn --sku VpnGw1 --vpn-type RouteBased --no-wait
watch bash -c "'echo $(date); echo ---; ls'"
# Note. The --no-wait parameter allows the gateway to be created in the background. It does not mean that the VPN gateway is created immediately. A VPN gateway can take 45 minutes or more to create. 
# You can't modify the Vnet whilst the gateway is being created. You can check the status of the gateway with the following command: az network vnet-gateway list -g $rg -o table

######## Create Virtual Network Peerings ########
# Do not proceed unless Gateway and Bastion have been created.
# Remember that Cloud Shell is designed to timeout your session after 20mins. If you are using Cloud Shell, you will need to run the following commands to keep your session alive:
# while sleep 600; do echo "Session is alive!"; done
# or
# watch ls

# Peer Hub <-> Shared Services networks
# Get the id for the hub network
hubvnetId=$(az network vnet show \
--resource-group $rghub \
--name $hub_vnet_name \
--query id --out tsv)

# Get the id for the shared services network
sharedsvcvnetId=$(az network vnet show \
--resource-group $rgshsvc \
--name $sharedsvc_vnet_name \
--query id \
--out tsv)

# Create Peering from Hub to Shared Services
az network vnet peering create \
--name hub2sharedsvc \
--resource-group $rghub \
--vnet-name $hub_vnet_name \
--remote-vnet $sharedsvcvnetId \
--allow-vnet-access \
--allow-gateway-transit # This assumes that the gateway has been provisioned already

# Create Peering from Shared Services to Hub
az network vnet peering create \
--name sharedsvc2hub \
--resource-group $rgshsvc \
--vnet-name $sharedsvc_vnet_name \
--remote-vnet $hubvnetId \
--allow-vnet-access \
--allow-forwarded-traffic \
--use-remote-gateways # This assumes that the gateway has been provisioned already

# Peer Hub <-> Spoke networks
# Get the id for the hub network
hubvnetId=$(az network vnet show \
--resource-group $rghub \
--name $hub_vnet_name \
--query id --out tsv)

# Get the id for the spoke network
spokevnetId=$(az network vnet show \
--resource-group $rgwload \
--name $spoke_vnet_name \
--query id \
--out tsv)

# Create Peering from Hub to Spoke
az network vnet peering create \
--name hub2spoke \
--resource-group $rghub \
--vnet-name $hub_vnet_name \
--remote-vnet $spokevnetId \
--allow-vnet-access \
--allow-gateway-transit # This assumes that the gateway has been provisioned already

# Create Peering from Spoke to Hub
az network vnet peering create \
--name spoke2hub \
--resource-group $rgwload \
--vnet-name $spoke_vnet_name \
--remote-vnet $hubvnetId \
--allow-vnet-access \
--allow-forwarded-traffic \
--use-remote-gateways # This assumes that the gateway has been provisioned already

# Peer Shared Services <-> Azure Bastion networks
# Get the id for the Shared Services network
sharedsvcvnetId=$(az network vnet show \
--resource-group $rgshsvc \
--name $sharedsvc_vnet_name \
--query id --out tsv)

# Get the id for the Azure Bastion network
bastionvnetId=$(az network vnet show \
--resource-group $rgbst \
--name $bst_vnet_name \
--query id \
--out tsv)

# Create Peering from Shared Services to Azure Bastion
az network vnet peering create \
--name sharedsvc2bastion \
--resource-group $rgshsvc \
--vnet-name $sharedsvc_vnet_name \
--remote-vnet $bastionvnetId \
--allow-vnet-access \
--allow-forwarded-traffic

# Create Peering from Azure Bastion to Shared Services
az network vnet peering create \
--name bastion2sharedsvc \
--resource-group $rgbst \
--vnet-name $bst_vnet_name \
--remote-vnet $sharedsvcvnetId \
--allow-vnet-access \
--allow-forwarded-traffic

# Peer Spoke <-> Azure Bastion networks
# Get the id for the Spoke network
spokevnetId=$(az network vnet show \
--resource-group $rgwload \
--name $spoke_vnet_name \
--query id --out tsv)

# Get the id for the Azure Bastion network
bastionvnetId=$(az network vnet show \
--resource-group $rgbst \
--name $bst_vnet_name \
--query id \
--out tsv)

# Create Peering from Spoke to Azure Bastion
az network vnet peering create \
--name spoke2bastion \
--resource-group $rgwload \
--vnet-name $spoke_vnet_name \
--remote-vnet $bastionvnetId \
--allow-vnet-access

# Create Peering from Azure Bastion to Spoke
az network vnet peering create \
--name bastion2spoke \
--resource-group $rgbst \
--vnet-name $bst_vnet_name \
--remote-vnet $spokevnetId \
--allow-vnet-access

######## Create Route Tables ########
# Note. Before proceeding check that the "azfw_private_ip" variable has been populated.
echo $azfw_private_ip
# If the variable is empty, then run the following command to populate it:
azfw_private_ip=$(az network firewall show -n azfw -g $rghub --query 'ipConfigurations[0].privateIpAddress' -o tsv)
# If the variable is still empty, then you can manually set it to the private IP address of the Azure Firewall.
azfw_private_ip=10.1.0.4 # This is just an example. You will need to set it to the private IP address of your Azure Firewall.
# Check that the variable has been populated
echo $azfw_private_ip

# Create Route table for Shared Services subnets
az network route-table create -n udr-sharedsvc -g $rgshsvc -l $location --disable-bgp-route-propagation
az network route-table route create -n sharedsvc2any --route-table-name udr-sharedsvc -g $rgshsvc \
--next-hop-type VirtualAppliance --address-prefix "0.0.0.0/0" --next-hop-ip-address $azfw_private_ip

# Associate Route Table to AD Subnet. Make sure to create the VNET peerings first.
sharedsvc_rt_id=$(az network route-table show -n udr-sharedsvc -g $rgshsvc -o tsv --query id)
az network vnet subnet update -g $rgshsvc --vnet-name $sharedsvc_vnet_name -n $ad_subnet_name --route-table $sharedsvc_rt_id

# Create Route table for workload subnets
az network route-table create -n udr-wload -g $rgwload -l $location --disable-bgp-route-propagation
az network route-table route create -n wload2any --route-table-name udr-wload -g $rgwload \
--next-hop-type VirtualAppliance --address-prefix "0.0.0.0/0" --next-hop-ip-address $azfw_private_ip

# Associate Route Table to Web, weba, cma, cmaA and DB Subnets. Make sure to create the VNET peerings first.
wload_rt_id=$(az network route-table show -n udr-wload -g $rgwload -o tsv --query id)
az network vnet subnet update -g $rgwload --vnet-name $spoke_vnet_name -n $web_subnet_name --route-table $wload_rt_id
az network vnet subnet update -g $rgwload --vnet-name $spoke_vnet_name -n $weba_subnet_name --route-table $wload_rt_id
az network vnet subnet update -g $rgwload --vnet-name $spoke_vnet_name -n $cma_subnet_name --route-table $wload_rt_id
az network vnet subnet update -g $rgwload --vnet-name $spoke_vnet_name -n $cmaa_subnet_name --route-table $wload_rt_id
az network vnet subnet update -g $rgwload --vnet-name $spoke_vnet_name -n $db_subnet_name --route-table $wload_rt_id

# Create Route table for Gateway Subnet
az network route-table create -n udr-gwsubnet -g $rghub -l $location
az network route-table route create -n onprem2spoke --route-table-name udr-gwsubnet -g $rghub \
--next-hop-type VirtualAppliance --address-prefix $spoke_vnet_prefix --next-hop-ip-address $azfw_private_ip
az network route-table route create -n onprem2sharedsvc --route-table-name udr-gwsubnet -g $rghub \
--next-hop-type VirtualAppliance --address-prefix $sharedsvc_vnet_prefix --next-hop-ip-address $azfw_private_ip

# Associate Route Table to Gateway Subnet. Make sure to create the VNET peerings first.
gw_rt_id=$(az network route-table show -n udr-gwsubnet -g $rghub -o tsv --query id)
az network vnet subnet update -g $rghub --vnet-name $hub_vnet_name -n $gw_subnet_name --route-table $gw_rt_id

########--------------------------########