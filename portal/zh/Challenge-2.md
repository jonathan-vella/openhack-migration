# 评估待迁移工作负载

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_assess.png" alt="迁移的评估阶段" /></td>
</tr>
</table>

## 挑战

在这个挑战中，你需要评估 Contoso Mortgage 现有运维环境中的应用程序 **Contoso Mortgage** 和 **Contoso Mortgage Admin**，并将其映射为 Azure 资源。评估过程中需要确定现有服务器和工作负载的连接方式，以及它们在 Azure 中的连接方式。别忘了，虽然最初只需要专注于当前数据中心内的部分服务器和应用程序，但你还需要负责制定一个适用于数百台服务器迁移任务的流程。

评估工作不仅仅是使用工具发现有关环境的各类信息，还需要安排好相关时间，并告知业务负责人、最终用户以及 IT 部门的其他成员，这样才能全面了解环境中正在发生什么，并掌握其他无法通过工具发现的事情。

Contoso Mortgage 的业务负责人目前需要为承载应用程序的服务器付费，他们认为这是一笔很高的成本。Contoso Mortgage 的 IT 主管团队希望在进行任何迁移工作之前，首先为每个应用程序进行成本评估，以便让业务负责人能够确信，就算迁移到 Azure，服务器的成本依然是可承受的。

根据从基础结构和应用程序支持团队收到的反馈，IT 主管团队还比较担心应用程序迁移之后对其他服务的依赖性问题。IT 主管认为自己依然无法全面理解自己当前的环境，因为本地环境之前曾中断过。此外他们还担心因为无法获得应用程序的源代码，如果在开始迁移前无法将依赖项映射至 Azure，自己将无法对应用程序进行必要的改动。

需要注意的是，目前的应用程序服务器架构如下图所示：

![应用程序服务器架构](images/application_server_architecture.png)

> **注意**：有关现有架构的更多细节请参阅*概述*。

## 客户需求

Contoso Mortgage 的下列需求必须考虑在内：

- 基础结构和应用程序支持团队认为自己已经很了解目前的运维环境，但他们依然希望在迁移前进行验证，并通过某种方式将当前状态汇报给 IT 主管。
- 迁移前，每个应用程序的业务负责人希望了解按照当前的 EA 定价协议，在 Azure 中托管自己服务器的预估月成本。
- 在现有环境中，应用程序已经通过子网和本地操作系统防火墙进行了分隔和保护。他们希望知道自己在 Azure 中的网络拓扑将会是什么样，以及在迁移之后，如何像保护本地环境那样，或者用更完善的方式进一步保护 Azure 中的资源。

## 成功标准

- 在迁移之前，能够对本地环境中不同服务器的依赖性进行可视化呈现，该呈现方式应能体现服务器之间的连接以及所用端口和协议。
- 网络设计能够对应用程序层之间的通信进行限制，只允许使用必须的端口和协议，同时能对网络内部的横向移动加以限制。
- 在迁移之前，待迁移服务器的规模必须适当，此外每台服务器的计算需求能够灵活调整，以满足应用程序负责人的需求。
- 每个应用程序的估算成本可以单独查看，并能体现获得与现有本地服务器一致性能时的最低可接受成本。

请在与教练讨论评估工作后，再继续迎接下一步挑战。

## 参考

- <a href="https://docs.microsoft.com/azure/migrate/migrate-services-overview" target="_blank">关于 Azure 迁移</a>
- <a href="https://azure.microsoft.com/migration/" target="_blank">Azure 迁移中心</a>
- <a href="https://docs.microsoft.com/azure/architecture/cloud-adoption/migrate/" target="_blank">Cloud Adoption Framework——云迁移</a>
- <a href="https://azure.microsoft.com/migration/get-started/#Rehost" target="_blank">云迁移策略——重新托管</a>
- <a href="https://docs.microsoft.com/azure/azure-monitor/platform/agent-windows" target="_blank">将 Windows 计算机连接至 Azure Monitor</a>
- <a href="https://savilltech.com/2018/01/21/deploying-the-oms-agent-automatically/" target="_blank">自动部署 OMS Agent</a>
- <a href="https://blog.orneling.se/2017/06/installing-oms-and-service-map-agents-with-powershell/" target="_blank">使用 PowerShell 安装 OMS 和 Service Map Agent</a>

## Assess workloads for migration

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_assess.png" alt="Assess phase of migration" /></td>
</tr>
</table>

## Challenge

In this challenge, you will assess Contoso Mortgage's existing operating environment for the applications **Contoso Mortgage** and **Contoso Mortgage Admin** and continue mapping them to Azure resources. Your assessment will include determining how existing servers and workloads are connected and how they will perform in Azure. Remember that while your initial focus is on a subset of servers and applications within the current datacenter, you are tasked with developing a process for assessment that can scale beyond just a handful of servers.

Assessments should not just be limited to using tooling to discover information about your environment, you should schedule in time to speak to business owners, end-users, other members within the IT department, etc. in order to get a full picture of what is happening within the environment and understand things tooling cannot tell you.

The business owners at Contoso Mortgage currently pay for the servers that host their applications and are cost-conscious. The IT leadership team at Contoso Mortgage wants to make sure that before any migrations begin, that a cost assessment is performed for each application to demonstrate the cost to the business owners who will continue to bear the cost of the servers, even in Azure.

The IT leadership team is also concerned about dependent services for migrated applications based on the feedback they have received from the Infrastructure and Application Support teams. IT leadership does not feel they understand their environment today based on previous outages in the on-premises environment and are concerned that they do not have access to the source code for these applications to make updates if dependencies cannot be mapped before migration.

As a reminder, the current application server architecture is as follows:

![Application Server Architecture](images/application_server_architecture.png)

> **Note**: More detail on the existing architecture can be found in the *Overview*.

## Customer requirements

Contoso Mortgage has the following requirements which you should take into consideration:

- While the Infrastructure and Application Support teams feel they understand their operating environment today, they would like verification before migrating and have a way to report the current state to IT leadership.
- Before migration, the business owners of each application need to know the estimated monthly cost to host their servers in Azure under the current EA pricing agreement.
- In the existing environment, applications are segmented and secured through subnets and local OS firewalls. They would like to know what their network topology in Azure will look like and how they can be as secure in Azure as in their current on-premises environment, if not more so, after the migration.

## Success Criteria

- Dependencies between servers in the on-premises environment can be visualized before migration and visualizations include server-to-server connections as well as ports and protocols.
- The network design limits communication between application tiers to only the required ports and protocols while limiting lateral movement within the network.
- The servers targeted for migration are sized appropriately and the compute needs of each server can be adjusted to meet application owner requirements before migration.
- The estimated cost for each application can be viewed independently and demonstrates the lowest acceptable cost with equivalent performance to the existing on-premises servers.

Your coach will discuss your assessment before you move on to the next challenge.

## References

- <a href="https://docs.microsoft.com/azure/migrate/migrate-services-overview" target="_blank">About Azure Migrate</a>
- <a href="https://azure.microsoft.com/migration/" target="_blank">Azure Migration Center</a>
- <a href="https://docs.microsoft.com/azure/architecture/cloud-adoption/migrate/" target="_blank">Cloud migration in the Cloud Adoption Framework</a>
- <a href="https://azure.microsoft.com/migration/get-started/#Rehost" target="_blank">Cloud migration strategies - Rehost</a>
- <a href="https://docs.microsoft.com/azure/azure-monitor/platform/agent-windows" target="_blank">Connect Windows computers to Azure Monitor</a>
- <a href="https://docs.microsoft.com/en-us/azure/azure-monitor/agents/agent-manage" target="_blank">Managing and maintaining the Log Analytics agent for Windows and Linux</a>
