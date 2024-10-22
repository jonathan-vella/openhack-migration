# Establish your plan

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

* How will you establish your migration priorities?
* How will you involve your stakeholders throughout the project?
* How will you create an inventory of your existing servers and determine dependencies?

As you design your plan, remember that the IT leadership team at Contoso Mortgage has worked closely with business partners to define the business drivers for this migration effort, which include:

* Limiting risk. While the applications selected for this migration effort are representative of Contoso Mortgage's on-premises estate, the are also production systems.
* Extend in a stable way. Without access to the source code, the applications cannot be easily modified and are considered stable today. Stability during and after the migration is critical.

These drivers have led to the following technical migration goals:

* Validate the migration of workloads hosted on legacy Windows operating systems including Windows Server 2008 R2, and Windows Server 2012 R2, as well as systems hosted on Microsoft SQL Server 2008 R2, to take advantage of the additional time offered for vendor support.
* Modernize systems to improve availability and resiliency where possible within the timelines needed for rapid migration. While the overarching goal is to rehost existing systems, where meaningful improvements can be made, they should be.
* Investigate the potential modernization of application components by evaluating and eventually transitioning to platform services where possible *after* issues around vendor support have been addressed.
* Educate the business and Contoso Mortgage's management on the processes and tooling that can be used to eventually move the remaining servers to Microsoft Azure, drastically reducing their on-premises presence.

> **Note**: More detail on the business and technical drivers for this effort can be found in the *Overview*.

## Customer requirements

Contoso Mortgage has the following requirements which you should take into consideration:

* Any assessment of the existing environment must provide a clear line of sight into server dependencies. While the Infrastructure and Application Support teams feel they understand their operating environment today, they would like verification before migrating to demonstrate to IT leadership.
* Before a migration occurs, IT needs to know the estimated monthly cost to host their servers in Azure to perform chargebacks to business owners. Under Contoso Mortgage's current Enterprise Agreement, they have negotiated a discount with Microsoft and may have existing Windows Server licenses that can be reused. They would like to understand their cost under both models * one where they reuse their existing licensing and one where they procure new licenses from Microsoft for their Windows Servers hosted in Microsoft Azure.
* In the current Azure subscription, cloud identities are used to secure Azure resources. The Security team would like to leverage their existing on-premises identities in the cloud if possible, to control access to Azure resources using role-based access control.
* The Security and Operations teams have determined that any domain-joined servers in Azure must be able to authenticate to Contoso Mortgage's domain even if connectivity between on-premises and Azure is lost. Any solution must account for a lack of network connectivity between Contoso's on-premises environment and Azure-hosted resources *after* the initial migration is complete.
* The existing applications have well-known URLs for Contoso Mortgage's users. IT leadership and business owners recognize that transitioning to the cloud may require a new URL to access each of the applications but want to minimize change and would like to have no more than one URL change for each application.
* The migrated applications must maintain their segmentation at the network layer. For example, the customer-accessible web front-end for the **Contoso Mortgage** application can only communicate with the application server, and the application server can only communicate with the database server.
* While the current migration effort is focused on a subset of applications, Contoso Mortgage's on-premise environment consists of over 500 servers. Any processes, tools, or technologies that are selected to support the migration of a workload must scale to the entire datacenter and not just these initial applications.

## Cheat sheet

To prepare for hybrid network connectivity between their on-premises environment and Microsoft Azure, Contoso Mortgage's Network Operations team has established a virtual network in Azure and created the base resources necessary to implement connectivity between on-premises and Azure. These resources reside in the resource group **openhackcloudrg** and include:

* A virtual network called **azurevnet** with the following attributes:
    * Address space: **10.1.0.0/16**
    * Subnets:
        * Azure: **10.1.0.0/24**
        * GatewaySubnet: **10.1.254.0/24**

## Success Criteria

Present to your coach your general migration plan, including how you will structure your team and how you will interact with your stakeholders throughout the project.

Also, present a high-level architecture which shows:

* The tools and technologies you will use to migrate the existing servers to Microsoft Azure.
* The tools and technologies you will use to migrate any existing on-premises identities (users and groups) to Microsoft Azure.
* The target topology for any migrated servers in Azure, including resource groups, virtual networks and subnets, and any other Azure resources required to execute the migration.

Your architecture should be presented as one or more diagrams.

As a component of your architecture, present to your coach a naming standard for Azure resources that you will use as you progress through your migration.

Be ready to answer the following questions:

* What tools or technologies will be used to show server dependencies to Contoso Mortgage?  
* Before migrating any servers to Azure, a cost estimate must be performed. This estimation must be presented under Contoso Mortgage's current pricing offer and their negotiated price with Microsoft. How will you perform this calculation?
* What tools or technologies will be used to allow servers to be domain-joined in Azure and logged on to with existing identities that will persist should hybrid connectivity not be available between Contoso Mortgage's on-premises datacenter and Azure?
* How will Contoso Mortgage host its public DNS in Azure and manage DNS records for its migrated web applications?

Your coach will discuss your process and selection of technologies before you move on to the next challenge.

## References

* <a href="https://azure.microsoft.com/mediahandler/files/resourcefiles/azure-virtual-datacenter-lift-and-shift-guide/Azure_Virtual_Datacenter_Lift_and_Shift_Guide.pdf" target="_blank">Azure Virtual Datacenter: Lift and Shift Guide</a>
* <a href="https://docs.microsoft.com/azure/architecture/cloud-adoption/migrate/azure-best-practices/" target="_blank">Azure migration best practices</a>
* <a href="https://azure.microsoft.com/migration/" target="_blank">Azure Migration Center</a>
* <a href="https://docs.microsoft.com/azure/app-service/manage-custom-dns-buy-domain" target="_blank">Buy a custom domain name for Azure App Service</a>
* <a href="https://docs.microsoft.com/azure/architecture/cloud-adoption/migrate/" target="_blank">Cloud migration in the Cloud Adoption Framework</a>
* <a href="https://azure.microsoft.com/en-us/migration/migration-journey/#migration-steps" target="_blank">Cloud migration strategies</a>
* <a href="https://docs.microsoft.com/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/" target="_blank">Group Policy Overview</a>
* <a href="https://azure.microsoft.com/pricing/" target="_blank">How Azure pricing works</a>
* <a href="https://docs.microsoft.com/azure/architecture/best-practices/naming-conventions" target="_blank">Naming conventions for Azure resources</a>
* <a href="https://azure.microsoft.com/migration/windows-server/" target="_blank">Windows Server * Azure Migration Center</a>
* <a href="https://github.com/jonathan-vella/architecting-for-success/blob/main/102-Azure-Landing-Zones/docs/Azure%20Network%20Documentation%20Template.xlsx" target="_blank">IP Address Planning Template</a>
* <a href="https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/" target="_blank">Cloud Adoption Framework * Adopt: Migrate</a>
* <a href="https://github.com/Azure/migration" target="_blank">Cloud Adoption Framework * Adopt: Migration Execution Guide</a>