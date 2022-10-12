# 转换为平台数据库服务

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_optimize.png" alt="迁移的优化阶段" /></td>
</tr>
</table>

## 挑战

随着全面迁移至 IaaS 模式，Contoso Mortgage 的 IT 主管想要看看 Azure 迁移这条路还能走多远，因而希望将某些应用程序从 IaaS 模式转换为 PaaS 模式，并打算从数据库着手尝试。管理层和业务用户都希望能尽可能提高持续运行时间和性能，并降低数据库的托管和支持成本。

Contoso Mortgage 的基础结构和应用程序支持团队人手有限，如果能将管理数据库性能、安装补丁，或对数据库进行备份等管理工作委托给 Azure 负责，他们就可以将更多时间用于遗留工作负载的迁移和现代化项目中。

IT 主管和业务用户还希望通过转换为 PaaS 服务实现下列目标：

- 降低基础结构管理负担。现有支持团队的大部分时间都被用于解决与 Contoso Mortgage 遗留运维环境有关的问题。
- 支撑业务增长。由于本地缺乏足够的计算资源，现有工作负载的扩展方面总是会遇到限制。
- 降低成本。Contoso Mortgage 希望尽可能节约 Windows Server 和 Microsoft SQL Server 等组件的许可成本。
- 提高效率。随着将系统转换为 PaaS 服务，有助于改善弹性，简化备份，促进数据保留能力。

通过退役现有的 IaaS 数据库，他们可以停止对 Windows Server 2008 R2 和 SQL Server 2008 R2 提供支持。如果可以在无需对现有应用程序继续进行大量投入的前提下实现这一点，IT 主管和业务用户将获得双赢的局面。

## 客户需求

Contoso Mortgage 的下列需求必须考虑在内：

- 除非数据库服务的安全性与本地（以及现在使用的 Azure IaaS）实现相同，否则 Contoso Mortgage 不会迁移至任何平台的数据库服务。所选的任何解决方案必须确保数据库只能被每个面向客户的 Web 应用程序的应用程序层所使用。
- 在评估不同服务时，Contoso Mortgage 希望选择最具成本效益的解决方案，借此迁移至可兼容 Microsoft SQL 的 PaaS 服务，并继续使用原有的数据库。
- 所选服务必须支持至少 99.99% 的持续运行时间。
- 任何迁移操作的停机时间必须尽可能短。
- 对于任何 PaaS 服务，数据库备份必须至少保留 30 天。
- *CM Server Admins* 安全组成员应该能访问并管理与数据库服务和数据库有关的任何 Azure 资源，但无法管理数据库中的数据。
- *CM Database Admins* 安全组成员应该能访问与数据库有关的任何资源，但无法访问与服务器有关的任何资源。

## 成功标准

- 所选平台服务必须兼容现有应用程序，包括现有的数据库架构和所用到的功能。
- 该平台服务必须在运行过程中必须能提供与现有 IaaS SQL 服务器相同，甚至更出色的表现。
- 在将任何数据迁移至平台服务前，必须进行正式评估，借此确认数据库可以兼容所选服务。
- 每个数据库的数据库备份必须保留至少 30 天。
- 该平台服务必须能对数据入口进行限制，只允许已知管理员和网络段访问数据库。
- 为了支持应用程序的数据库所创建的任何 Azure 资源，在访问其管理界面时必须受到必要安全组的控制。

请在与教练讨论过你的实现之后，再继续迎接下一步挑战。

在你的团队结束该挑战前，请务必清理掉所有不再需要的资源。例如被迁移的 IaaS 数据库服务器，可将其与执行迁移所用到的任何工具或所配置的资源一起清理掉。

## 参考

- <a href="https://docs.microsoft.com/azure/sql-database/sql-database-security-overview" target="_blank">Azure SQL 税局库安全功能概述</a>
- <a href="https://datamigration.microsoft.com/" target="_blank">Azure 数据库迁移指南</a>
- <a href="https://azure.microsoft.com/mediahandler/files/resourcefiles/choosing-your-database-migration-path-to-azure/Choosing_your_database_migration_path_to_Azure.pdf" target="_blank">选择数据库的 Azure 迁移路径</a>
- <a href="https://datamigration.microsoft.com/scenario/sql-to-azuresqldb" target="_blank">将 SQL Server 迁移至 Azure SQL 数据库</a>
- <a href="https://docs.microsoft.com/sql/dma/dma-overview" target="_blank">数据迁移助手概述</a>
- <a href="https://docs.microsoft.com/azure/dms/dms-overview" target="_blank">Azure 数据库迁移服务是什么？</a>
- <a href="https://docs.microsoft.com/azure/sql-database/sql-database-technical-overview" target="_blank">Azure SQL 数据库服务是什么？</a>
- <a href="https://docs.microsoft.com/azure/role-based-access-control/overview" target="_blank">Azure 资源的基于角色的访问控制（RBAC）是什么？</a>

## Transition to platform database services

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_optimize.png" alt="Optimize phase of migration" /></td>
</tr>
</table>

## Challenge

With the migration to IaaS complete, IT leadership at Contoso Mortgage would like to see how far they can go in their journey to Azure by transitioning from IaaS to PaaS services across their application portfolio, beginning with database hosting. There is a desire both within leadership and the business to improve the uptime, performance, and potential costs associated with database hosting and support.

As the infrastructure and application support teams at Contoso Mortgage are both lean, any administration that can be delegated to Microsoft Azure such as managing database performance, applying patches, or taking backups will allow them to spend more time on the migration and modernization of their legacy workloads.

IT leadership and the business also hope to achieve the following through the transition to PaaS services:

- Reduce the burden of infrastructure management. Much of the time of the existing support teams are dedicated to solving issues related to the legacy nature of Contoso Mortgage's operating environment.
- Address business growth. There have always been limitations to the scale of existing workloads due to lack of compute resources on-premises.
- Reduce costs. Contoso Mortgage wants to minimize licensing costs for components such as Windows Server and Microsoft SQL Server where possible.
- Increase efficiency. Improve the resiliency, backup, and retention of data as systems transition to PaaS services.

By retiring the existing IaaS database implementation, they can stop supporting Windows Server 2008 R2 and SQL Server 2008 R2. If this can be done without a significant investment in the existing application, IT leadership and the business both win.

## Customer requirements

Contoso Mortgage has the following requirements which you should take into consideration:

- Contoso Mortgage cannot migrate to any platform database service unless the database service is as secure as their on-premises (and now Azure IaaS) implementations are. Any solution must ensure that the database is only available to the application tier of each client-facing web application.
- When evaluating services, Contoso Mortgage would like the most cost-effective solution that allows them to move to a Microsoft SQL compatible PaaS service which will work with their existing databases.
- The server selected must support an uptime of at least 99.99%.
- Any migration must have minimal downtime.
- Database backups must be retained for at least 30 days within any PaaS service.
- Members of the *CM Server Admins* security group should have access to manage any Azure resources related to the database service and databases, but not the data in the databases.
- Members of the *CM Database Admins* security group should have access to any database-related resources, but not any server-related resources.

## Success Criteria

- The platform service you select must be compatible with the existing applications, including the existing database schema and consumed features.
- The platform service must perform as well as, if not better than, the existing IaaS SQL server.
- Before any data is migrated to a platform service, a formal assessment must be generated which shows that the databases will be compatible with the selected service.
- Database backups must be retained for at least 30 days for each database.
- The platform service must limit ingress and only allow known administrators and network segments to access the database.
- Access to the management plane of any Azure resources created to support the databases for the applications is constrained to the required security groups.

Your coach will discuss your implementation before you move on to the next challenge.

Before your team exits this challenge, be sure to clean up any resources which you no longer require. For example, with the IaaS database server migrated, it can be retired along with any tooling or resources provisioned to perform the migration.

## References

- <a href="https://docs.microsoft.com/azure/sql-database/sql-database-security-overview" target="_blank">An overview of Azure SQL Database security capabilities</a>
- <a href="https://datamigration.microsoft.com/" target="_blank">Azure Database Migration Guide</a>
- <a href="https://azure.microsoft.com/mediahandler/files/resourcefiles/choosing-your-database-migration-path-to-azure/Choosing_your_database_migration_path_to_Azure.pdf" target="_blank">Choosing your database migration path to Azure</a>
- <a href="https://datamigration.microsoft.com/scenario/sql-to-azuresqldb" target="_blank">Migrate SQL Server to Azure SQL Database</a>
- <a href="https://docs.microsoft.com/sql/dma/dma-overview" target="_blank">Overview of Data Migration Assistant</a>
- <a href="https://docs.microsoft.com/azure/dms/dms-overview" target="_blank">What is Azure Database Migration Service?</a>
- <a href="https://docs.microsoft.com/azure/sql-database/sql-database-technical-overview" target="_blank">What is Azure SQL Database service?</a>
- <a href="https://docs.microsoft.com/azure/role-based-access-control/overview" target="_blank">What is role-based access control (RBAC) for Azure resources?</a>
