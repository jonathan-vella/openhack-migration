# 完成迁移

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_migrate.png" alt="迁移的迁移和现代化阶段" /></td>
</tr>
</table>

## 挑战

首批服务器和应用程序测试迁移已经完成，这些工作负载在 Azure 中的运行已经通过了验证，是时候最终完成目标应用程序的迁移，让它们在 Azure 中永久运行了。

这些 Web 应用程序的最终迁移需要一小时的时间窗口，为了将停机对 Contoso Mortgagefor 员工的影响降至最低，迁移工作被安排到周末进行。

在这个挑战中，你需要将 **Contoso Mortgage** 和 **Contoso Mortgage Admin** 从本地环境完全割接至 Azure。将这些应用程序迁移至 Azure，即可帮助 Contoso Mortgage 验证他们将 Windows Server 工作负载迁移到云端的流程，进而提供一种行之有效的方法，帮助 Contoso 未来继续减小本地基础结构的规模，评估本地的其他工作负载并将其迁移至 Azure。

## 客户需求

Contoso Mortgage 的下列需求必须考虑在内：

- 现有应用程序的一些常用 URL 已经被 Contoso 的用户熟知。Contoso 已经明确，迁移上云后可能需要用新的 URL 来访问各个应用程序，但希望将 URL 的变化维持在最小限度，希望每个应用程序最多只改变一个 URL。每个应用程序的新 URL 在迁移到 Azure 之前和之后必须保持不变。
- 可接受不超过一小时的停机时间。如果迁移过程出现错误或其他问题，Contoso Mortgage 必须能尽可能快速地回滚至本地应用程序。
- 正如挑战 5 的测试实施中所提到的：
    - 对外 Web 应用程序之前需要实施负载均衡解决方案。
    - 应当用相同的方法实现网络分隔和安全保护，在不同的应用程序层之间维持受限的连接能立。例如 Contoso Mortgage 应用程序对外的 Web 前端只能与该应用程序的 API 服务器通信，而应用程序服务器只能与数据库服务器通信。
    - 服务器必须能全功能运转，包括能使用域凭据访问服务器，而不需要连接到任何本地的域控制器。
    - 由于安全方面的要求，服务器管理员不能跨越公共互联网使用远程桌面，并且 Azure 中托管的服务器不允许关联公共 IP 地址。

## 成功标准

- 为迁移工作创建执行方案，在开始最终迁移之前，将其共享给教练。
- 网络分隔已就绪，可以限制应用程序层之间的横向移动，包括非应用程序通信，例如 RDP 访问。
- 为访问每个应用程序而选择的 URL 需要能从公共互联网上解析。为了允许访问 IaaS 托管应用程序而选择的技术同时也要能允许未来哪怕托管到 PaaS 环境中，同样可以用于访问应用程序。
- *CM Server Admins* 安全组中的服务器管理员可以用安全的方式访问所有迁移后的服务器，同时迁移后的任何服务器都不需要启用面向公共互联网的 RDP 访问。
- 如果 **cmad1** 被关闭或本地和 Azure 之间的混合网络连接丢失，生产环境中的应用程序依然可以正常运行。
- 对于任何迁移后的服务器，原生的 Azure 功能，例如 *Run Command* 依然是可用的，就好像这些服务器是通过 Azure Marketplace 配置的一样。
- 如果到 Azure 的迁移没能在一小时内完成，可以立即回滚到本地应用程序。

此外请准备好回答下列问题：

- 在网络分隔和安全性方面，你的测试设计和实现是否产生了哪些变化？
- 如果迁移过程中出错，你的解决方案如何快速故障转移至本地应用程序？

请在与教练讨论过你的实现之后，再继续迎接下一步挑战。

在你的团队结束该挑战前，请务必清理掉所有不再需要的资源。

## 参考

- <a href="https://docs.microsoft.com/azure/migrate/tutorial-migrate-hyper-v#migrate-vms" target="_blank">迁移虚拟机</a>
- <a href="https://docs.microsoft.com/azure/virtual-machines/windows/run-command" target="_blank">在 Windows 虚拟机中使用运行命令运行 PowerShell 脚本</a>
- <a href="https://docs.microsoft.com/azure/load-balancer/load-balancer-overview" target="_blank">Azure 负载均衡器是什么？</a>
- <a href="https://docs.microsoft.com/azure/traffic-manager/traffic-manager-overview" target="_blank">流量管理器是什么？</a>

## Finalize migration

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_migrate.png" alt="Migrate and modernize phase of migration" /></td>
</tr>
</table>

## Challenge

Now that the test migrations of the initial servers and applications is complete and the workloads have been validated in Azure, it is time to finalize the migration for the target applications and bring them to Azure permanently.

The final migration for both web application has a one hour window for downtime scheduled on the weekend to minimize impact to the Contoso Mortgage staff.

In this challenge, you will perform a full cutover of **Contoso Mortgage** and **Contoso Mortgage Admin** from on-premises to Azure. Migrating these applications to Azure will allow Contoso Mortgage to validate their process for migrating Windows Server workloads to the cloud and provide a path forward for assessing and migrating other workloads on-premises as Contoso continues to collapse its on-premises infrastructure in the future.

## Customer requirements

Contoso Mortgage has the following requirements which you should take into consideration:

- The existing applications have well-known URLs for Contoso's users. Contoso recognizes that transitioning to the cloud may require a new URL to access the applications but wants to minimize change and would like to have no more than one URL change for each application. The new URLs for each application should be the same before and after the migration to Azure.
- Downtime of no more than one hour is acceptable. If there is an error or problem during the migration, Contoso Mortgage must be able to fall back to the on-premises application as quickly as possible.
- Just as with the test implementation in Challenge 5:
    - A load balancing solution will be used in front of the public-facing web applications.
    - Network segmentation and security should be implemented in the same manner, maintaining constrained connectivity between application layers. For example, the public-facing web front-end for the Contoso Mortgage application can only communicate with the API server for the application, and the application server can only communicate with the database server.
    - The servers must be fully operational, including having the ability to access the servers using domain credentials without connectivity to any on-premises domain controllers.
    - Due to security requirements, server administrators will not be able to use Remote Desktop over the public internet and no public IPs can be associated with Azure-hosted servers.

## Success Criteria

- Create an execution plan for your migration and before beginning your final migration share the plan with your coach.
- Network segmentation is in place and limits lateral movement between application layers, including non-application communication such as RDP access.
- The URL you select for providing access to each application needs to be resolvable from the public internet. The technology you select to allow access to the IaaS hosted applications should also allow access to the applications in the future if they are ever hosted in a PaaS environment.
- Server administrators in the *CM Server Admins* security group can access all the migrated servers in a secure manner which does not require opening RDP access to the public internet for any migrated servers.
- If **cmad1** is turned off or hybrid network connectivity between on-premises and Azure is lost, the applications in the production environment can still function.
- For any migrated servers, native Azure functionality such as the *Run Command* should be available as if the server was provisioned from the Azure Marketplace.
- If the migration to Azure is not completed within one hour, immediate fallback to the on-premises applications will be required.

Be ready to answer the following questions:

- Did anything change from your test design and implementation regarding network segmentation and security?
- How does your solution allow for quick failover to on-premises in the event an error occurs during the migration?

Your coach will discuss your implementation before you move on to the next challenge.

Before your team exits this challenge, be sure to clean up any resources which you no longer require.

## References

- <a href="https://docs.microsoft.com/azure/migrate/tutorial-migrate-hyper-v#migrate-vms" target="_blank">Migrate VMs</a>
- <a href="https://docs.microsoft.com/azure/virtual-machines/windows/run-command" target="_blank">Run PowerShell scripts in your Windows VM with Run Command</a>
- <a href="https://docs.microsoft.com/azure/load-balancer/load-balancer-overview" target="_blank">What is Azure Load Balancer?</a>
- <a href="https://docs.microsoft.com/azure/traffic-manager/traffic-manager-overview" target="_blank">What is Traffic Manager?</a>
