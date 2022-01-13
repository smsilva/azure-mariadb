# Create and manage Private Link for Azure Database for MariaDB using CLI
# https://docs.microsoft.com/en-us/azure/mariadb/howto-configure-privatelink-cli

RESOURCE_GROUP_NAME="wasp-sandbox-1"
RESOURCE_GROUP_LOCATION="westeurope"

az group create \
  --name "${RESOURCE_GROUP_NAME?}" \
  --location "${RESOURCE_GROUP_LOCATION?}"

az network vnet create \
  --name myVirtualNetwork \
  --resource-group "${RESOURCE_GROUP_NAME?}" \
  --subnet-name mySubnet

az network vnet subnet update \
  --name mySubnet \
  --resource-group "${RESOURCE_GROUP_NAME?}" \
  --vnet-name myVirtualNetwork \
  --disable-private-endpoint-network-policies true

az vm create \
  --admin-username silvios \
  --resource-group "${RESOURCE_GROUP_NAME?}" \
  --name myVm \
  --image Win2019Datacenter \
  --public-ip-sku Standard

# Create a server in the resource group
MARIADB_SERVER_NAME="silvios-wasp-demo"
MARIADB_ADMIN_USER_NAME="silvios"
MARIADB_ADMIN_USER_PASSWORD="TTyop770"

az mariadb server create \
  --name "${MARIADB_SERVER_NAME?}" \
  --resource-group "${RESOURCE_GROUP_NAME?}" \
  --location "${RESOURCE_GROUP_LOCATION?}" \
  --admin-user "${MARIADB_ADMIN_USER_NAME?}" \
  --admin-password "${MARIADB_ADMIN_USER_PASSWORD?}" \
  --sku-name GP_Gen5_2

MARIADB_SERVER_ID=$(az resource show \
    -g "${RESOURCE_GROUP_NAME?}" \
    -n "${MARIADB_SERVER_NAME?}" \
    --resource-type "Microsoft.DBforMariaDB/servers" \
    --query "id" -o tsv)

az network private-endpoint create \
  --name myPrivateEndpoint \
  --resource-group "${RESOURCE_GROUP_NAME?}" \
  --vnet-name myVirtualNetwork \
  --subnet mySubnet \
  --private-connection-resource-id ${MARIADB_SERVER_ID?} \
  --group-id mariadbServer \
  --connection-name myConnection

az network private-dns zone create \
  --resource-group "${RESOURCE_GROUP_NAME?}" \
  --name  "privatelink.mariadb.database.azure.com"

az network private-dns link vnet create \
  --resource-group "${RESOURCE_GROUP_NAME?}" \
  --zone-name "privatelink.mariadb.database.azure.com" \
  --name MyDNSLink \
  --virtual-network myVirtualNetwork \
  --registration-enabled false

#Query for the network interface ID  
networkInterfaceId=$(az network private-endpoint show \
  --name myPrivateEndpoint \
  --resource-group "${RESOURCE_GROUP_NAME?}" \
  --query 'networkInterfaces[0].id' \
  --output tsv)

az resource show \
  --ids $networkInterfaceId \
  --api-version 2019-04-01 \
  --output json
# Copy the content for privateIPAddress and FQDN matching the Azure database for MariaDB name
# FQDN silvios-wasp-demo.mariadb.database.azure.com
# privateIPAddress 10.0.0.5

#Create DNS records 
az network private-dns record-set a create \
  --name "${MARIADB_SERVER_NAME?}" \
  --zone-name privatelink.mariadb.database.azure.com \
  --resource-group "${RESOURCE_GROUP_NAME?}"

az network private-dns record-set a add-record \
  --record-set-name "${MARIADB_SERVER_NAME?}" \
  --zone-name privatelink.mariadb.database.azure.com \
  --resource-group "${RESOURCE_GROUP_NAME?}" \
  -a 10.0.0.5
