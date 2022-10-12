# 建立你的方案

***请按下立即冲向键盘开始操作的想法！现在需要先暂停下来，以团队的思维方式好好考虑一下你需要为该公司实施的端到端迁移过程。***

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_assess.png" alt="迁移的评估阶段" /></td>
</tr>
</table>

## 挑战

你所面临的挑战在于，需要为 Contoso Mortgage 发起初始迁移工作，将其现有应用程序和基础结构迁移至 Azure。别忘了，你最初的目标仅仅是该公司当前数据中心里运行的一部分服务器和应用程序，同时你还需要负责验证迁移的完整过程还可用于未来的迁移工作。*在后续的每个挑战中，随着遇到新问题和注意事项，别忘了检查并调整你的方案。*

在这一阶段，你需要决定迁移至 Azure 过程中需要用到的流程、工具和技术。根据你对当前基础结构和目标平台的了解，你的团队必须满足客户的所有需求，决定如何迁移应用程序，如何确定新环境的成本，以及如何将迁移过程对用户造成影响的停机时间降至最低。

因此目前必须首先熟悉迁移上 Azure 所涉及的不同阶段。为此首先有必要回答下面这些问题：

- 如何确定迁移工作的优先级顺序？
- 项目进展过程中如何引入必要的利益相关者？
- 如何为现有服务器创建清单并确定依赖项？

在设计方案时，别忘了 Contoso Mortgage 的 IT 主管团队早已与业务合作伙伴密切合作，确定了此次迁移工作的业务驱动因素，包括：

- 限制风险。为本次迁移工作选择的应用程序可以代表 Contoso Mortgage 的本地系统，但同时它们依然是生产系统。
- 以稳定的方式扩展。由于不具备源代码，因此这些应用程序无法轻易修改，可以视作是稳定的。因此迁移前后都必须确保它们能稳定运行。

这些驱动因素也进而催生了下列与迁移有关的技术目标：

- 对老版本 Windows 操作系统，包括 Windows Server 2008 R2 和 Windows Server 2012 R2 中运行的工作负载，以及 Microsoft SQL Server 2008 R2 中运行的系统的迁移情况进行验证，以便充分利用供应商额外提供的支持时限。
- 通过对系统进行现代化革新改善其可用性和弹性，并且最好能在快速迁移所需的时间期限内完成。虽然首要目标是重新托管现有系统，但如果有可能在这期间做出任何有意义的改进，这样的改进也必须实施。
- 在与供应商的支持时限有关的问题解决*之后*，尽可能评估并最终转换为平台服务，借此调查是否有哪些应用程序组件适合进行现代化革新。
- 针对所涉及的流程和工具，为业务用户和 Contoso Mortgage 的管理层提供培训，最终将其余服务器迁移至 Microsoft Azure，尽可能减少要在本地运行的服务器数量。

> **注意**：有关此次迁移工作更具体的业务和技术驱动因素，请参阅*概述*。

## 客户需求

Contoso Mortgage 的下列需求必须考虑在内：

- 对现有环境的任何评估必须针对服务器的依赖性提供清晰且明确的见解。虽然基础结构和应用程序支持团队认为自己对目前运维的环境已经非常了解，但在迁移之前，他们依然希望确认这一点，以便向 IT 主管做出证明。
- 迁移进行前，IT 需要知道在 Azure 中托管自己服务器后预估的月成本，以便向业务负责人收取必要的费用。按照 Contoso Mortgage 目前的企业协议，他们可以从微软处获得折扣价格，并且可能拥有一些能够重复使用的 Windows Server 许可。他们希望明确两种模式下的成本分别是多少：一种模式为使用现有许可；另一种模式为针对 Microsoft Azure 中托管的 Windows Server，重新向微软购买许可。
- 在目前的 Azure 订阅中，他们使用云标识保护 Azure 资源。安全团队希望在可能的情况下，尽可能在云中继续使用自己现有的本地标识，借此通过基于角色的访问控制机制对 Azure 资源的访问加以控制。
- 安全和运维团队决定，Azure 中任何加入域的服务器必须能通过 Contoso Mortgage 的域进行身份验证，哪怕在本地和 Azure 之间的连接断开时也必须能做到这一点。因此在初始迁移完成*之后*，所采用的任何解决方案必须考虑到 Contoso 本地环境和 Azure 中所托管资源间网络连接可能断开这一情况。
- 现有应用程序的一些常用 URL 已经被 Contoso Mortgage 的用户熟知。IT 主管和业务负责人已经明确，迁移上云后可能需要用新的 URL 来访问各个应用程序，但希望将 URL 的变化维持在最小限度，希望每个应用程序最多只改变一个 URL。
- 迁移后的应用程序必须在网络层维持原先的分隔。例如，**Contoso Mortgage** 应用程序面向客户的 Web 前端只能与应用程序服务器通信，只有应用程序服务器能够与数据库服务器通信。
- 虽然目前的迁移工作只专注于一部分应用程序，但 Contoso Mortgage 的本地环境包含了超过 500 台服务器。为工作负载迁移所选择的任何流程、工具或技术必须能够扩展，以便用于整个数据中心，而不仅仅是最初迁移的那些应用程序。

## 小提示

为了准备好在本地环境和 Microsoft Azure 之间构建混合网络连接，Contoso Mortgage 的网络运维团队已经在 Azure 中建立了虚拟网络，并创建了在本地和 Azure 之间实现网络连接所需的必要资源。这些资源位于资源组 **openhackcloudrg** 中，包括：

- 一个虚拟网络，名为 **azurevnet**，具备下列属性：
    - 地址空间：**10.1.0.0/16**
    - 子网：
        - Azure: **10.1.0.0/24**
        - 网关子网：**10.1.254.0/24**

## 成功标准

将迁移方案，包括你的团队构成，以及项目进行过程中与利益相关者的交互方式信息展示给教教练。

此外请提供高层面架构构思，其中需要包含：

- 将现有服务器迁移至 Microsoft Azure 所用的工具和技术。
- 将现有本地标识（用户和组）迁移至 Microsoft Azure 所用的工具和技术。
- 任何服务器迁移至 Azure 之后的目标拓扑，包括资源组、虚拟网络和子网，以及执行该迁移所需的其他任何 Azure 资源。
- 作为架构组件，请向教练展示迁移之后要为 Azure 资源使用的命名标准。

另外请准备好回答下列问题：

- 该使用什么工具或技术向 Contoso Mortgage 展示服务器的依赖性？
- 在将任何服务器迁移至 Azure 之前必须进行成本估算。该估算必须考虑 Contoso Mortgage 目前实际享受的定价以及与微软协商后的优惠价。此时该如何计算？
- 该使用什么工具或技术才能让 Azure 中的服务器能够加入域，并且确保 Contoso Mortgage 的本地数据中心和 Azure 之间的混合网络连接不可用时，依然能让用户使用现有的标识登录？
- 对于迁移后的 Web 应用程序，Contoso Mortgage 该如何在 Azure 中托管自己的公共 DNS 并管理 DNS 记录？

请在与教练讨论，并确定了所需技术后，再继续迎接下一步挑战。

## 参考

- <a href="https://azure.microsoft.com/mediahandler/files/resourcefiles/azure-virtual-datacenter-lift-and-shift-guide/Azure_Virtual_Datacenter_Lift_and_Shift_Guide.pdf" target="_blank">Azure 虚拟数据中心：平移指南</a>
- <a href="https://docs.microsoft.com/azure/architecture/cloud-adoption/migrate/azure-best-practices/" target="_blank">Azure 迁移最佳实践</a>
- <a href="https://azure.microsoft.com/migration/" target="_blank">Azure 迁移中心</a>
-<a href="https://docs.microsoft.com/azure/app-service/manage-custom-dns-buy-domain" target="_blank">为 Azure 应用服务购买自定义域名</a>
- <a href="https://docs.microsoft.com/azure/architecture/cloud-adoption/migrate/" target="_blank">Cloud Adoption Framework：云迁移</a>
- <a href="https://azure.microsoft.com/migration/get-started/#Rehost" target="_blank">云迁移策略——重新托管</a>
- <a href="https://docs.microsoft.com/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/" target="_blank">组策略概述</a>
- <a href="https://azure.microsoft.com/pricing/" target="_blank">Azure 的定价机制</a>
- <a href="https://docs.microsoft.com/azure/architecture/best-practices/naming-conventions" target="_blank">Azure 资源的命名约定</a>
- <a href="https://azure.microsoft.com/migration/windows-server/" target="_blank">Windows Server——Azure 迁移中心</a>

## Establish your plan

***Resist the initial temptation to rush to the keyboard! This is the time to pause and think as a team about your end-to-end migration process that you would implement in this company.***

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_assess.png" alt="Assess phase of migration" /></td>
</tr>
</table>

## Challenge

Your challenge is to begin the initial planning for the migration of Contoso Mortgage's applications and existing infrastructure to Azure. Remember that while your initial focus is on a subset of servers and applications within the current datacenter, you are tasked with validating that the process you use throughout this journey can be used for future migrations. *Do not forget to review and adapt your plan as you encounter new aspects and considerations with each subsequent challenge.*

During this stage, you will determine the process, tools, and technologies you will use to execute your migration to Azure. Based on your knowledge of the current infrastructure and the target platform, your team must work through the customer requirements to choose how you will migrate your applications, how you will determine the cost of the new environment, and how you will minimize downtime for the users of the applications as migrations occur.

This time should be used to familiarize yourself with the general phases of migration to Azure. Answering the following questions can help you come to a consensus:

- How will you establish your migration priorities?
- How will you involve your stakeholders throughout the project?
- How will you create an inventory of your existing servers and determine dependencies?

As you design your plan, remember that the IT leadership team at Contoso Mortgage has worked closely with business partners to define the business drivers for this migration effort, which include:

- Limiting risk. While the applications selected for this migration effort are representative of Contoso Mortgage's on-premises estate, the are also production systems.
- Extend in a stable way. Without access to the source code, the applications cannot be easily modified and are considered stable today. Stability during and after the migration is critical.

These drivers have led to the following technical migration goals:

- Validate the migration of workloads hosted on legacy Windows operating systems including Windows Server 2008 R2, and Windows Server 2012 R2, as well as systems hosted on Microsoft SQL Server 2008 R2, to take advantage of the additional time offered for vendor support.
- Modernize systems to improve availability and resiliency where possible within the timelines needed for rapid migration. While the overarching goal is to rehost existing systems, where meaningful improvements can be made, they should be.
- Investigate the potential modernization of application components by evaluating and eventually transitioning to platform services where possible *after* issues around vendor support have been addressed.
- Educate the business and Contoso Mortgage's management on the processes and tooling that can be used to eventually move the remaining servers to Microsoft Azure, drastically reducing their on-premises presence.

> **Note**: More detail on the business and technical drivers for this effort can be found in the *Overview*.

## Customer requirements

Contoso Mortgage has the following requirements which you should take into consideration:

- Any assessment of the existing environment must provide a clear line of sight into server dependencies. While the Infrastructure and Application Support teams feel they understand their operating environment today, they would like verification before migrating to demonstrate to IT leadership.
- Before a migration occurs, IT needs to know the estimated monthly cost to host their servers in Azure to perform chargebacks to business owners. Under Contoso Mortgage's current Enterprise Agreement, they have negotiated a discount with Microsoft and may have existing Windows Server licenses that can be reused. They would like to understand their cost under both models - one where they reuse their existing licensing and one where they procure new licenses from Microsoft for their Windows Servers hosted in Microsoft Azure.
- In the current Azure subscription, cloud identities are used to secure Azure resources. The Security team would like to leverage their existing on-premises identities in the cloud if possible, to control access to Azure resources using role-based access control.
- The Security and Operations teams have determined that any domain-joined servers in Azure must be able to authenticate to Contoso Mortgage's domain even if connectivity between on-premises and Azure is lost. Any solution must account for a lack of network connectivity between Contoso's on-premises environment and Azure-hosted resources *after* the initial migration is complete.
- The existing applications have well-known URLs for Contoso Mortgage's users. IT leadership and business owners recognize that transitioning to the cloud may require a new URL to access each of the applications but want to minimize change and would like to have no more than one URL change for each application.
- The migrated applications must maintain their segmentation at the network layer. For example, the customer-accessible web front-end for the **Contoso Mortgage** application can only communicate with the application server, and the application server can only communicate with the database server.
- While the current migration effort is focused on a subset of applications, Contoso Mortgage's on-premise environment consists of over 500 servers. Any processes, tools, or technologies that are selected to support the migration of a workload must scale to the entire datacenter and not just these initial applications.

## Cheat sheet

To prepare for hybrid network connectivity between their on-premises environment and Microsoft Azure, Contoso Mortgage's Network Operations team has established a virtual network in Azure and created the base resources necessary to implement connectivity between on-premises and Azure. These resources reside in the resource group **openhackcloudrg** and include:

- A virtual network called **azurevnet** with the following attributes:
    - Address space: **10.1.0.0/16**
    - Subnets:
        - Azure: **10.1.0.0/24**
        - GatewaySubnet: **10.1.254.0/24**

## Success Criteria

Present to your coach your general migration plan, including how you will structure your team and how you will interact with your stakeholders throughout the project.

Also, present a high-level architecture which shows:

- The tools and technologies you will use to migrate the existing servers to Microsoft Azure.
- The tools and technologies you will use to migrate any existing on-premises identities (users and groups) to Microsoft Azure.
- The target topology for any migrated servers in Azure, including resource groups, virtual networks and subnets, and any other Azure resources required to execute the migration.
- As a component of your architecture, present to your coach a naming standard for Azure resources that you will use as you progress through your migration.

Be ready to answer the following questions:

- What tools or technologies will be used to show server dependencies to Contoso Mortgage?  
- Before migrating any servers to Azure, a cost estimate must be performed. This estimation must be presented under Contoso Mortgage's current pricing offer and their negotiated price with Microsoft. How will you perform this calculation?
- What tools or technologies will be used to allow servers to be domain-joined in Azure and logged on to with existing identities that will persist should hybrid connectivity not be available between Contoso Mortgage's on-premises datacenter and Azure?
- How will Contoso Mortgage host its public DNS in Azure and manage DNS records for its migrated web applications?

Your coach will discuss your process and selection of technologies before you move on to the next challenge.

## References

- <a href="https://azure.microsoft.com/mediahandler/files/resourcefiles/azure-virtual-datacenter-lift-and-shift-guide/Azure_Virtual_Datacenter_Lift_and_Shift_Guide.pdf" target="_blank">Azure Virtual Datacenter: Lift and Shift Guide</a>
- <a href="https://docs.microsoft.com/azure/architecture/cloud-adoption/migrate/azure-best-practices/" target="_blank">Azure migration best practices</a>
- <a href="https://azure.microsoft.com/migration/" target="_blank">Azure Migration Center</a>
-<a href="https://docs.microsoft.com/azure/app-service/manage-custom-dns-buy-domain" target="_blank">Buy a custom domain name for Azure App Service</a>
- <a href="https://docs.microsoft.com/azure/architecture/cloud-adoption/migrate/" target="_blank">Cloud migration in the Cloud Adoption Framework</a>
- <a href="https://azure.microsoft.com/en-us/migration/migration-journey/#migration-steps" target="_blank">Cloud migration strategies</a>
- <a href="https://docs.microsoft.com/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/" target="_blank">Group Policy Overview</a>
- <a href="https://azure.microsoft.com/pricing/" target="_blank">How Azure pricing works</a>
- <a href="https://docs.microsoft.com/azure/architecture/best-practices/naming-conventions" target="_blank">Naming conventions for Azure resources</a>
- <a href="https://azure.microsoft.com/migration/windows-server/" target="_blank">Windows Server - Azure Migration Center</a>
