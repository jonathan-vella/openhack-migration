# Assess workloads for migration

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

* While the Infrastructure and Application Support teams feel they understand their operating environment today, they would like verification before migrating and have a way to report the current state to IT leadership.
* Before migration, the business owners of each application need to know the estimated monthly cost to host their servers in Azure under the current EA pricing agreement.
* In the existing environment, applications are segmented and secured through subnets and local OS firewalls. They would like to know what their network topology in Azure will look like and how they can be as secure in Azure as in their current on-premises environment, if not more so, after the migration.

## Current environment configuration

* A Hyper-V switch has been pre-created by the Infrastructure team to keep any discovery software or appliances segmented from the existing virtual machine network. The name of the switch is **InternalMigrateSwitch**.

## Success Criteria

* Dependencies between servers in the on-premises environment can be visualized before migration and visualizations include server-to-server connections as well as ports and protocols.
* The network design limits communication between application tiers to only the required ports and protocols while limiting lateral movement within the network.
* The servers targeted for migration are sized appropriately and the compute needs of each server can be adjusted to meet application owner requirements before migration.
* The estimated cost for each application can be viewed independently and demonstrates the lowest acceptable cost with equivalent performance to the existing on-premises servers including licensing and pricing options.

Your coach will discuss your assessment before you move on to the next challenge.

## References

* <a href="https://docs.microsoft.com/azure/migrate/migrate-services-overview" target="_blank">About Azure Migrate</a>
* <a href="https://azure.microsoft.com/migration/" target="_blank">Azure Migration Center</a>
* <a href="https://docs.microsoft.com/azure/architecture/cloud-adoption/migrate/" target="_blank">Cloud migration in the Cloud Adoption Framework</a>
* <a href="https://azure.microsoft.com/migration/get-started/#Rehost" target="_blank">Cloud migration strategies - Rehost</a>