# Notes

These are reference copies of the various templates used in the OpenHack.

- azuredeployCloud.json
    - This template formally resides at <https://github.com/opsgility/lab-support-public/blob/master/microsoft-open-hack-migration/azuredeployCloud.json>
    - This template creates a VNet and establishes a VNet peer between it and the selected VNet
- azuredeployDNSDomain.json
    - This template formally resides at <https://github.com/opsgility/lab-support-public/blob/master/microsoft-open-hack-migration/azuredeployDNSDomain.json>
    - It was an attempt to automated the creation of an App Service Domain that ultimately wasn't used but I have retained for reference
- azuredeployOnPrem.json
    - This template formally resides at <https://github.com/opsgility/labs/blob/master/microsoft-open-hack-migration/template/azuredeployOnPrem.json>
    - This template is responsible for bootstrapping the Hyper-V host in Azure which then runs a Custom Script Extension to deploy the guest VMs and configure the host
- vnet-peering.json
    - This template formally resides at <https://github.com/opsgility/lab-support-public/blob/master/microsoft-open-hack-migration/vnet-peering.json>
    - This template is called from azuredeployCloud.json to create the individual VNet peers
