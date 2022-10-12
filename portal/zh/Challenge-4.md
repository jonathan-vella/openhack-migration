# 实现混合网络和弹性身份验证

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_migrate.png" alt="迁移的迁移和现代化阶段" /></td>
</tr>
</table>

## 挑战

随着 Contoso Mortgage 准备将服务器迁移至 Azure，在本地数据中心和 Azure 之间建立混合连接即可帮助他们在 Azure 中建立所需的域控制器，提供用户和服务帐户以高弹性方式通过 Azure Active Directory 验证身份所需的基础架构。在 Azure 中创建域控制器还有助于降低通过域进行身份验证的延迟。

为了准备创建这样的连接，Contoso Mortgage 的网络运维团队已经在 Azure 中建立了虚拟网络，并创建了在本地和 Azure 之间建立连接所需的基础资源。这些资源位于资源组 **openhackcloudrg** 中，包括：

- 一个名为 **azurevnet** 的虚拟网络，其属性如下：
    - 地址空间：**10.1.0.0/16**
    - 子网：
        - Azure：**10.1.0.0/24**
        - 网关子网：**10.1.254.0/24**
- 一个名为 **azurevnetvpngateway** 的虚拟网络网关。
- 一个公共 IP 地址，该地址被关联给名为 **azurevnetvpngatewayip** 的虚拟网络网关。

在本地环境中，他们已经配置了一台部署有路由和远程访问服务（RRAS）角色的 VPN 服务器（cmvpn1）。虽然网络运维团队并未验证 RRAS 是否是此时的首选解决方案，但可以接受实施任何其他 VPN 技术以便在本地和 Azure 之间建立连接。此外他们还不确定，当数据中心内更多服务器迁移完毕后，目前所选择的解决方案能否适应那么大的规模。

## 客户需求

Contoso Mortgage 的下列需求必须考虑在内：

- VPN 连接必须实现 IKEv2 加密方式。
- Azure 中建立的任何域控制器都必须有弹性并且高可用。
    - 弹性包括当任何混合连接故障后，依然能够通过域进行身份验证的能力。
    - 高可用性包括当一个域控制器不可用后，依然能进行身份验证的能力。
    - 为保证域的可用性，Azure 中托管的任何域控制器，都必须使用 SLA 至少为 99.95% 的虚拟机。
- *CM Server Admins* 安全组的成员应有权管理 Azure 中的网络资源。

## 当前环境配置

- 本地网络网关尚未创建。
- 本地 VPN 服务器的公共 IP 与当前 Hyper-V 宿主机的 IP 地址相同。
- 新建域控制器前，作为最佳实践，有必要新建一个站点。
- AD DS 的安装和配置完成后，服务器必须重启动。

## 成功标准

- 在本地和 Azure 之间成功建立网络连接，借此让现有的本地域控制器复制到 Azure。
    - 从本地的域控制器上，能够以 RDP 的方式使用主机名（而非 IP 地址）连接到 Azure 中托管的域控制器。
    - 从 Azure 域控制器上，能够以 RDP 的方式使用主机名（而非 IP 地址）连接到本地运行的域控制器。
- 在 Azure 中配置一台或多台新的 AD DS 服务器，并且本地域可以复制到 Azure 虚拟机。
- 任何新增服务器，其可用性必须满足或超过虚拟机 99.95% 的 SLA。
- *CM Server Admins* 安全组的成员应当有权管理 Azure 中的网络资源。

> **注意**：由于安全方面的要求，服务器管理员不能跨越公共互联网使用远程桌面，并且 Azure 中托管的服务器不允许关联公共 IP 地址。

此外请准备好回答下列问题：

- 随着未来更多服务器被迁移，从长期范围来看，你推荐在本地和 Azure 之间使用怎样的连接解决方案？

请在与教练讨论过你的实现之后，再继续迎接下一步挑战。

## 参考

- <a href="http://www.thatlazyadmin.com/adding-subnets-active-directory-sites-and-services-powershell/" target="_blank">添加子网 Active Directory 站点和服务：PowerShell</a>
- <a href="http://www.buchatech.com/2016/09/azure-site-to-site-vpn-setup-azure-resource-manager/" target="_blank">Azure 和 RRAS 站点到站点 VPN 配置（Azure 资源管理器）</a>
- <a href="https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal" target="_blank">在 Azure 门户中创建站点到站点连接</a>
- <a href="https://www.petri.com/best-practices-domain-controller-vms-azure" target="_blank">Azure 域控制器虚拟机最佳实践</a>
- <a href="https://scomandothergeekystuff.com/2016/09/19/creating-a-site-to-site-vpn-with-azure-resource-manager-arm-and-windows-2012r2/" target="_blank">使用 Azure 资源管理器（ARM）和 Windows 2012 R2 创建站点到站点（S2S）VPN</a>
- <a href="https://docs.microsoft.com/azure/architecture/reference-architectures/identity/adds-extend-domain" target="_blank">将本地 Active Directory 域扩展到 Azure</a>
    - <a href="https://docs.microsoft.com/azure/architecture/reference-architectures/identity/adds-extend-domain#active-directory-site" target="_blank">Active Directory 站点</a>
    - <a href="https://docs.microsoft.com/azure/architecture/reference-architectures/identity/adds-extend-domain#active-directory-operations-masters" target="_blank">Active Directory 操作主机</a>
- <a href="https://vmarena.com/how-to-configure-replication-from-on-premise-domain-controller-to-azure-vm/" target="_blank">如何配置从本地域控制器到 Azure 虚拟机的复制</a>
- <a href="https://dnsmadeeasy.com/support/subnet/" target="_blank">子网掩码使用技巧</a>

## Implement hybrid networking and resilient authentication

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_migrate.png" alt="Migrate and modernize phase of migration" /></td>
</tr>
</table>

## Challenge

As Contoso Mortgage prepares to migrate servers to Azure, establishing hybrid connectivity between their on-premises datacenter and Azure will allow them to establish domain controllers in Azure, making their infrastructure for allowing users and service accounts to authenticate to Active Directory more resilient. Having domain controllers in Azure will also reduce latency for authentication to the domain.

To prepare for this connectivity, Contoso Mortgage's Network Operations team has established a virtual network in Azure and created the base resources necessary to implement connectivity between on-premises and Azure. These resources reside in the resource group **openhackcloudrg** and include:

- A virtual network called **azurevnet** with the following attributes:
    - Address space: **10.1.0.0/16**
    - Subnets:
        - Azure: **10.1.0.0/24**
        - GatewaySubnet: **10.1.254.0/24**
- A virtual network gateway called **azurevnetvpngateway**.
- A public IP address associated with the virtual network gateway called **azurevnetvpngatewayip**.

In the on-premises environment, a VPN server (cmvpn1) has been provisioned with the Routing and Remote Access Service (RRAS) role already configured. However, the Network Operations team has not validated that RRAS is their preferred solution and is open to the implementation of any other VPN technology that allows for connectivity between on-premises and Azure. They are also not sure if the solution they select today can carry them through a more large-scale migration of other servers in the datacenter.

## Customer requirements

Contoso Mortgage has the following requirements which you should take into consideration:

- The VPN connection must implement IKEv2 encryption.
- Any domain controller(s) established in Azure should be resilient and highly available.
    - Resiliency includes the ability to continue to authenticate to the domain should any hybrid connectivity fail.
    - High availability includes the ability to continue to authenticate should a single domain controller not be available.
    - To ensure the domain is available, a minimum SLA of 99.95% of virtual machine availability is required for any domain controllers hosted in Azure.
- Members of the *CM Server Admins* security group should have rights to manage the networking resources in Azure.

## Current environment configuration

- A local network gateway has not yet been created.
- The public IP of the on-premises VPN server will be the same IP address as the current Hyper-V host.
- Before creating a new domain controller, it is a best practice to establish a new site.
- After the installation and configuration of AD DS are complete, the server must be rebooted.

## Success Criteria

- Connectivity has been established between on-premises and Azure to allow the existing on-premises domain controller to replicate to Azure.
    - From the domain controller on-premises, it is possible to RDP to a domain controller hosted in Azure using its hostname (not its IP address).
    - From a domain controller in Azure, it is possible to RDP to the domain controller hosted on-premises using its hostname (not its IP address).
- One or more new AD DS servers have been provisioned in Azure and the on-premises domain is replicating to the Azure VMs.
- Any new servers meet or exceed a virtual machine availability SLA of 99.95%.
- Members of the *CM Server Admins* security group should have rights to manage the networking resources in Azure.

> **Note**: Due to security requirements, server administrators will not be able to use Remote Desktop over the public internet and no public IPs can be associated with Azure-hosted servers.

Be ready to answer the following questions:

- What solution would you recommend for long term connectivity between on-premises and Azure as future migrations occur?

Your coach will discuss your implementation before you move on to the next challenge.

## References

- <a href="http://www.thatlazyadmin.com/adding-subnets-active-directory-sites-and-services-powershell/" target="_blank">Adding Subnets Active Directory Sites and Services: PowerShell</a>
- <a href="http://www.buchatech.com/2016/09/azure-site-to-site-vpn-setup-azure-resource-manager/" target="_blank">Azure & RRAS Site to Site VPN Setup (Azure Resource Manager)</a>
- <a href="https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal" target="_blank">Create a Site-to-Site connection in the Azure portal</a>
- <a href="https://www.petri.com/best-practices-domain-controller-vms-azure" target="_blank">Best Practices for Domain Controller VMs in Azure</a>
- <a href="https://scomandothergeekystuff.com/2016/09/19/creating-a-site-to-site-vpn-with-azure-resource-manager-arm-and-windows-2012r2/" target="_blank">Creating a Site-to-Site (S2S) VPN with Azure Resource Manager (ARM) and Windows 2012R2</a>
- <a href="https://docs.microsoft.com/azure/architecture/reference-architectures/identity/adds-extend-domain" target="_blank">Extend your on-premises Active Directory domain to Azure</a>
    - <a href="https://docs.microsoft.com/azure/architecture/reference-architectures/identity/adds-extend-domain#active-directory-site" target="_blank">Active Directory site</a>
    - <a href="https://docs.microsoft.com/azure/architecture/reference-architectures/identity/adds-extend-domain#active-directory-operations-masters" target="_blank">Active Directory operations masters</a>
- <a href="https://vmarena.com/how-to-configure-replication-from-on-premise-domain-controller-to-azure-vm/" target="_blank">How To Configure Replication From On-Premise Domain Controller To Azure VM</a>
- <a href="https://dnsmadeeasy.com/support/subnet/" target="_blank">Subnet Mask Cheat Sheet</a>
