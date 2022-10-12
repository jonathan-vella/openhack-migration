# 测试迁移

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_migrate.png" alt="迁移的迁移和现代化阶段" /></td>
</tr>
</table>

## 挑战

IT 总监希望验证迁移策略，确保迁移后的应用程序不仅能正常运行，而且可以受到安全保护并维持合规。为了顺利迁移至 Azure，必须与业务人员建立这样的信任。而通过这样的验证，不仅可以验证你设计的架构，还可以验证具体采取的方法，进而确保业务用户会支持后续的迁移上云工作。

这就需要在隔离的环境中进行测试，以便不对现有的本地环境造成任何影响。借此，Contoso Mortgage 的相关团队即可进行自动化测试，并让应用程序负责人有机会提供自己的重要反馈，同时保证了只要需要，随时都可以执行这样的迁移，并获得大家都需要的结果。

除了维持当前的分隔，IT 主管还希望对基础结构进行必要调整，以便应对未来的增长需求。迁移至 Azure 即可让 IaaS 方式托管的应用程序具备更高弹性，因为此时可以使用只能在云环境中使用的，由 Azure 平台提供的某些功能。

为了让 **Contoso Mortgage** 和 **Contoso Mortgage Admin** 这两个 Web 应用程序获得更高弹性，网络运维团队希望在架构中引入负载均衡器，借此提高应用程序前端层的灵活性和可缩放性。

![应用程序访问和端口](images/cm_apps_azure_architecture_w_admin.png)

## 客户需求

Contoso Mortgage 的下列需求必须考虑在内：

- 迁移后的应用程序必须在网络层实现分隔。例如，面向客户的 **Contoso Mortgage** 应用程序的 Web 前端只能与应用程序服务器通信，而应用程序服务器只能与数据库服务器通信。
- 服务器必须能全功能运转，包括能使用域凭据访问服务器，而不需要连接到任何本地的域控制器。
- 由于安全方面的要求，服务器管理员不能跨越公共互联网使用远程桌面，并且 Azure 中托管的服务器不允许关联公共 IP 地址。
    - *CM Server Admins* 安全组的成员应当有权使用任何 RDP 或远程连接解决方案。
    - 虽然管理员可以借助之前建立的站点到站点连接进行访问，但所实施的解决方案不能依赖现有的站点到站点连接。如果该连接中断或无法从本地站点使用，必须保证管理员依然可以建立连接。
- 每个应用程序必须有一个专用的测试 URL，以便供测试人员使用。
- 对于任何面向用户的服务器（Web 前端），必须实现负载均衡技术。

## 成功标准

向教练展示被隔离在 Azure 测试环境中的应用程序 **Contoso Mortgage** 和 **Contoso Mortgage Admin**。

- 网络分隔已就绪，可以限制应用程序层之间的横向移动，包括非应用程序通信，例如 RDP 访问。
- 为测试和验证每个应用程序而选择的 URL 需要能从公共互联网上解析。
- *CM Server Admins* 安全组中的服务器管理员可以用安全的方式访问所有迁移后的服务器，同时迁移后的任何服务器都不需要启用面向公共互联网的 RDP 访问。
- 如果 **cmad1** 被关闭或本地和 Azure 之间的混合网络连接丢失，隔离测试环境中的应用程序依然可以正常运行。
- 任何面向用户的 Web 服务器之前引入了负载均衡技术，并且目标应用程序依然可以正常运行。
- 对于任何迁移后的服务器，原生的 Azure 功能，例如 *Run Command* 依然是可用的，就好像这些服务器是通过 Azure Marketplace 配置的一样。

请在与教练讨论过你的实现之后，再继续迎接下一步挑战。

在你的团队结束该挑战前，请务必清理掉测试过程中使用的所有资源，这可能会对最终的迁移产生影响。

## 参考

- <a href="https://docs.microsoft.com/azure/site-recovery/site-recovery-overview" target="_blank">关于站点恢复</a>
- <a href="https://docs.microsoft.com/azure/migrate/migrate-appliance" target="_blank">Azure Migrate 设备</a>
- <a href="https://docs.microsoft.com/azure/virtual-machines/troubleshooting/guest-os-firewall-blocking-inbound-traffic" target="_blank">Azure 虚拟机来宾操作系统防火墙阻止了入站通信</a>
- <a href="https://docs.microsoft.com/azure/site-recovery/migrate-tutorial-windows-server-2008#limitations-and-known-issues" target="_blank">将运行 Windows Server 2008 的服务器迁移至 Azure——局限和已知问题</a>
- <a href="https://docs.microsoft.com/azure/migrate/migrate-replication-appliance" target="_blank">Replication 设备</a>
- <a href="https://docs.microsoft.com/azure/migrate/tutorial-migrate-hyper-v#run-a-test-migration" target="_blank">进行测试迁移</a>
- <a href="https://docs.microsoft.com/azure/virtual-machines/windows/run-command" target="_blank">在 Windows 虚拟机中使用运行命令运行 PowerShell 脚本</a>
- <a href="https://blog.elmah.io/the-ultimate-guide-to-connection-strings-in-web-config/" target="_blank">web.config 连接字符串终极指南</a>
- <a href="https://docs.microsoft.com/azure/dns/dns-overview" target="_blank">Azure DNS 是什么？</a>
- <a href="https://docs.microsoft.com/azure/load-balancer/load-balancer-overview" target="_blank">Azure 负载均衡器是什么？</a>
- <a href="https://docs.microsoft.com/previous-versions/windows/desktop/ics/windows-firewall-profiles" target="_blank">Windows 防火墙配置文件</a>

## Test migration

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_migrate.png" alt="Migrate and modernize phase of migration" /></td>
</tr>
</table>

## Challenge

The Director of IT wants to validate that the migration strategy is sound, and the migrated applications will not only be operational but also secure and compliant. Building this trust with the business is a key component of the migration to Azure. By validating not only your architecture but also your approach, you can make sure that the business is a partner in the move to the cloud.

This will require testing in isolation so that the existing on-premises environment is not impacted. This will allow the relevant teams at Contoso Mortgage to perform automated testing, offers application owners the opportunity to provide meaningful feedback, and allows for the migration to be performed as many times as it is needed to get it right.

In addition to maintaining their current segmentation, IT leadership would also like to introduce infrastructure to better position their applications for growth in the future. Moving to Azure will allow IaaS hosted applications to be more resilient by adopting features of the Azure platform that are only available in the cloud.

To position themselves for better resiliency for both the **Contoso Mortgage** and **Contoso Mortgage Admin** web applications, the Network Operations team would like to incorporate a load balancer into their architecture to allow for greater flexibility and elasticity in the front-end layer of their applications.

![Application Access and Ports](images/cm_apps_azure_architecture_w_admin.png)

## Customer requirements

Contoso Mortgage has the following requirements which you should take into consideration:

- The migrated applications must maintain their segmentation at the network layer. For example, the customer-accessible web front-end for the **Contoso Mortgage** application can only communicate with the application server, and the application server can only communicate with the database server.
- The servers must be fully operational, including having the ability to access the servers using domain credentials without connectivity to any on-premises domain controllers.
- Due to security requirements, server administrators will not be able to use Remote Desktop over the public internet and no public IPs can be associated with Azure-hosted servers.
    - Members of the *CM Server Admins* security group should be granted rights to use any RDP or remote connectivity solution.
    - While administrators can connect across the previously established site-to-site connection, a solution must be implemented which does not rely on the presence of the site-to-site connection. Administrators must be able to connect if the connection is down or they are not working from their on-premises site.
- Each application must have a dedicated testing URL that can be distributed to testers.
- A load-balancing technology should be implemented for any user-facing servers (web front ends).

## Success Criteria

Present to your coach the applications **Contoso Mortgage** and **Contoso Mortgage Admin** in an isolated testing environment in Azure.

- Network segmentation is in place and limits lateral movement between application layers, including non-application communication such as RDP access.
- The URL you select for testing and validating each application needs to be resolvable from the public internet.
- Server administrators in the *CM Server Admins* security group can access all of the migrated servers in a secure manner which does not require opening RDP access to the public internet for any migrated servers.
- If **cmad1** is turned off or hybrid network connectivity between on-premises and Azure is lost, the applications in the isolated testing environment can still function.
- A load-balancing technology has been introduced in front of any user-facing web servers and the target applications remain functional.
- For any migrated servers, native Azure functionality such as the *Run Command* should be available as if the server was provisioned from the Azure Marketplace.

Your coach will discuss your implementation before you move on to the next challenge.

Before your team exits this challenge, be sure to clean up any testing resources which could impact your final migration.

## References

- <a href="https://docs.microsoft.com/azure/site-recovery/site-recovery-overview" target="_blank">About Site Recovery</a>
- <a href="https://docs.microsoft.com/azure/migrate/migrate-appliance" target="_blank">Azure Migrate appliance</a>
- <a href="https://docs.microsoft.com/azure/virtual-machines/troubleshooting/guest-os-firewall-blocking-inbound-traffic" target="_blank">Azure VM Guest OS firewall is blocking inbound traffic</a>
- <a href="https://docs.microsoft.com/azure/site-recovery/migrate-tutorial-windows-server-2008#limitations-and-known-issues" target="_blank">Migrate servers running Windows Server 2008 to Azure - Limitations and known issues</a>
- <a href="https://docs.microsoft.com/azure/migrate/migrate-replication-appliance" target="_blank">Replication appliance</a>
- <a href="https://docs.microsoft.com/azure/migrate/tutorial-migrate-hyper-v#run-a-test-migration" target="_blank">Run a test migration</a>
- <a href="https://docs.microsoft.com/azure/virtual-machines/windows/run-command" target="_blank">Run PowerShell scripts in your Windows VM with Run Command</a>
- <a href="https://blog.elmah.io/the-ultimate-guide-to-connection-strings-in-web-config/" target="_blank">The ultimate guide to connection strings in web.config</a>
- <a href="https://docs.microsoft.com/azure/dns/dns-overview" target="_blank">What is Azure DNS?</a>
- <a href="https://docs.microsoft.com/azure/load-balancer/load-balancer-overview" target="_blank">What is Azure Load Balancer?</a>
- <a href="https://docs.microsoft.com/previous-versions/windows/desktop/ics/windows-firewall-profiles" target="_blank">Windows Firewall Profiles</a>
