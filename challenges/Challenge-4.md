# Implement hybrid networking and resilient authentication

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_migrate.png" alt="Migrate and modernize phase of migration" /></td>
</tr>
</table>

## Challenge

As Contoso Mortgage prepares to migrate servers to Azure, establishing hybrid connectivity between their on-premises datacenter and Azure will allow them to establish domain controllers in Azure, making their infrastructure for allowing users and service accounts to authenticate to Active Directory more resilient. Having domain controllers in Azure will also reduce latency for authentication to the domain.

To prepare for this connectivity, Contoso Mortgage's Network Operations team has established a virtual network in Azure and created the base resources necessary to implement connectivity between on-premises and Azure. These resources reside in the resource group **openhackcloudrg** and include:

* A virtual network called **azurevnet** with the following attributes:
    * Address space: **10.1.0.0/16**
    * Subnets:
        * Azure: **10.1.0.0/24**
        * GatewaySubnet: **10.1.254.0/24**
* A virtual network gateway called **azurevnetvpngateway**.
* A public IP address associated with the virtual network gateway called **azurevnetvpngatewayip**.

In the on-premises environment, a VPN server (cmvpn1) has been provisioned with the Routing and Remote Access Service (RRAS) role already configured. However, the Network Operations team has not validated that RRAS is their preferred solution and is open to the implementation of any other VPN technology that allows for connectivity between on-premises and Azure. They are also not sure if the solution they select today can carry them through a more large-scale migration of other servers in the datacenter.

## Customer requirements

Contoso Mortgage has the following requirements which you should take into consideration:

* The VPN connection must implement IKEv2 encryption.
* Any domain controller(s) established in Azure should be resilient and highly available.
    * Resiliency includes the ability to continue to authenticate to the domain should any hybrid connectivity fail.
    * High availability includes the ability to continue to authenticate should a single domain controller not be available.
    * To ensure the domain is available, a minimum SLA of 99.95% of virtual machine availability is required for any domain controllers hosted in Azure.
* Members of the *CM Server Admins* security group should have rights to manage the networking resources in Azure.

## Current environment configuration

* A local network gateway has not yet been created.
* The public IP of the on-premises VPN server will be the same IP address as the current Hyper-V host.
* Before creating a new domain controller, it is a best practice to establish a new site.
* After the installation and configuration of AD DS are complete, the server must be rebooted.
* A set of NAT rules are in place on the Hyper-V host **cmhost** for the following ports and protocols:

| External IP Address | External Port | Internal Port | Internal IP Address |
| :-----------------: | :-----------: | :-----------: | :-----------------: |
| 0.0.0.0             | 500           | 500           | 192.168.0.9         |
| 0.0.0.0             | 1701          | 1701          | 192.168.0.9         |
| 0.0.0.0             | 4500          | 4500          | 192.168.0.9         |

## Success Criteria

* Connectivity has been established between on-premises and Azure to allow the existing on-premises domain controller to replicate to Azure.
    * From the domain controller on-premises, it is possible to RDP to a domain controller hosted in Azure using its hostname (not its IP address).
    * From a domain controller in Azure, it is possible to RDP to the domain controller hosted on-premises using its hostname (not its IP address).
* One or more new AD DS servers have been provisioned in Azure and the on-premises domain is replicating to the Azure VMs.
* Any new servers meet or exceed a virtual machine availability SLA of 99.95%.
* Members of the *CM Server Admins* security group should have rights to manage the networking resources in Azure.

> **Note**: Due to security requirements, server administrators will not be able to use Remote Desktop over the public internet and no public IPs can be associated with Azure-hosted servers.

Be ready to answer the following questions:

* What solution would you recommend for long term connectivity between on-premises and Azure as future migrations occur?

Your coach will discuss your implementation before you move on to the next challenge.

## References

* <a href="http://www.thatlazyadmin.com/adding-subnets-active-directory-sites-and-services-powershell/" target="_blank">Adding Subnets Active Directory Sites and Services: PowerShell</a>
* <a href="http://www.buchatech.com/2016/09/azure-site-to-site-vpn-setup-azure-resource-manager/" target="_blank">Azure & RRAS Site to Site VPN Setup (Azure Resource Manager)</a>
* <a href="https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal" target="_blank">Create a Site-to-Site connection in the Azure portal</a>
* <a href="https://www.petri.com/best-practices-domain-controller-vms-azure" target="_blank">Best Practices for Domain Controller VMs in Azure</a>
* <a href="https://scomandothergeekystuff.com/2016/09/19/creating-a-site-to-site-vpn-with-azure-resource-manager-arm-and-windows-2012r2/" target="_blank">Creating a Site-to-Site (S2S) VPN with Azure Resource Manager (ARM) and Windows 2012R2</a>
* <a href="https://docs.microsoft.com/azure/architecture/reference-architectures/identity/adds-extend-domain" target="_blank">Extend your on-premises Active Directory domain to Azure</a>
    * <a href="https://docs.microsoft.com/azure/architecture/reference-architectures/identity/adds-extend-domain#active-directory-site" target="_blank">Active Directory site</a>
    * <a href="https://docs.microsoft.com/azure/architecture/reference-architectures/identity/adds-extend-domain#active-directory-operations-masters" target="_blank">Active Directory operations masters</a>
* <a href="https://vmarena.com/how-to-configure-replication-from-on-premise-domain-controller-to-azure-vm/" target="_blank">How To Configure Replication From On-Premise Domain Controller To Azure VM</a>
* <a href="https://dnsmadeeasy.com/support/subnet/" target="_blank">Subnet Mask Cheat Sheet</a>
[Windows Server RRAS to Azure Connection Guide](https://charbelnemnom.com/site-to-site-vpn-azure-and-windows-rras-server/)
