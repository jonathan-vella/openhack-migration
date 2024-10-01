# Transition to platform database services

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_optimize.png" alt="Optimize phase of migration" /></td>
</tr>
</table>

## Challenge

With the migration to IaaS complete, IT leadership at Contoso Mortgage would like to see how far they can go in their journey to Azure by transitioning from IaaS to PaaS services across their application portfolio, beginning with database hosting. There is a desire both within leadership and the business to improve the uptime, performance, and potential costs associated with database hosting and support.

As the infrastructure and application support teams at Contoso Mortgage are both lean, any administration that can be delegated to Microsoft Azure such as managing database performance, applying patches, or taking backups will allow them to spend more time on the migration and modernization of their legacy workloads.

IT leadership and the business also hope to achieve the following through the transition to PaaS services:

* Reduce the burden of infrastructure management. Much of the time of the existing support teams are dedicated to solving issues related to the legacy nature of Contoso Mortgage's operating environment.
* Address business growth. There have always been limitations to the scale of existing workloads due to lack of compute resources on-premises.
* Reduce costs. Contoso Mortgage wants to minimize licensing costs for components such as Windows Server and Microsoft SQL Server where possible.
* Increase efficiency. Improve the resiliency, backup, and retention of data as systems transition to PaaS services.

By retiring the existing IaaS database implementation, they can stop supporting Windows Server 2008 R2 and SQL Server 2008 R2. If this can be done without a significant investment in the existing application, IT leadership and the business both win.

## Customer requirements

Contoso Mortgage has the following requirements which you should take into consideration:

* Contoso Mortgage cannot migrate to any platform database service unless the database service is as secure as their on-premises (and now Azure IaaS) implementations are. Any solution must ensure that the database is only available to the application tier of each client-facing web application.
* When evaluating services, Contoso Mortgage would like the most cost-effective solution that allows them to move to a Microsoft SQL compatible PaaS service which will work with their existing databases.
* The server selected must support an uptime of at least 99.99%.
* Any migration must have minimal downtime.
* Database backups must be retained for at least 30 days within any PaaS service.
* Members of the *CM Server Admins* security group should have access to manage any Azure resources related to the database service and databases, but not the data in the databases.
* Members of the *CM Database Admins* security group should have access to any database-related resources, but not any server-related resources.

## Success Criteria

* The platform service you select must be compatible with the existing applications, including the existing database schema and consumed features.
* The platform service must perform as well as, if not better than, the existing IaaS SQL server.
* Before any data is migrated to a platform service, a formal assessment must be generated which shows that the databases will be compatible with the selected service.
* Database backups must be retained for at least 30 days for each database.
* The platform service must limit ingress and only allow known administrators and network segments to access the database.
* Access to the management plane of any Azure resources created to support the databases for the applications is constrained to the required security groups.

Your coach will discuss your implementation before you move on to the next challenge.

Before your team exits this challenge, be sure to clean up any resources which you no longer require. For example, with the IaaS database server migrated, it can be retired along with any tooling or resources provisioned to perform the migration.

## References

* <a href="https://docs.microsoft.com/azure/sql-database/sql-database-security-overview" target="_blank">An overview of Azure SQL Database security capabilities</a>
* <a href="https://datamigration.microsoft.com/" target="_blank">Azure Database Migration Guide</a>
* <a href="https://azure.microsoft.com/mediahandler/files/resourcefiles/choosing-your-database-migration-path-to-azure/Choosing_your_database_migration_path_to_Azure.pdf" target="_blank">Choosing your database migration path to Azure</a>
* <a href="https://datamigration.microsoft.com/scenario/sql-to-azuresqldb" target="_blank">Migrate SQL Server to Azure SQL Database</a>
* <a href="https://docs.microsoft.com/sql/dma/dma-overview" target="_blank">Overview of Data Migration Assistant</a>
* <a href="https://docs.microsoft.com/azure/dms/dms-overview" target="_blank">What is Azure Database Migration Service?</a>
* <a href="https://docs.microsoft.com/azure/sql-database/sql-database-technical-overview" target="_blank">What is Azure SQL Database service?</a>
* <a href="https://docs.microsoft.com/azure/role-based-access-control/overview" target="_blank">What is role-based access control (RBAC) for Azure resources?</a>
