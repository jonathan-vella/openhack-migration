# Finalize migration

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_migrate.png" alt="Migrate and modernize phase of migration" /></td>
</tr>
</table>

## Reminders

* Use an InPrivate/Incognito window in your browser to avoid any confusion with any other credentials that you may use to access Azure resources.
* The credentials you need to access the Azure subscription assigned to your team are available on the *OpenHack Environment* tab.

## Challenge

Now that the test migrations of the initial servers and applications is complete and the workloads have been validated in Azure, it is time to finalize the migration for the target applications and bring them to Azure permanently.

The final migration for both web application has a one hour window for downtime scheduled on the weekend to minimize impact to the Contoso Mortgage staff.

In this challenge, you will perform a full cutover of **Contoso Mortgage** and **Contoso Mortgage Admin** from on-premises to Azure. Migrating these applications to Azure will allow Contoso Mortgage to validate their process for migrating Windows Server workloads to the cloud and provide a path forward for assessing and migrating other workloads on-premises as Contoso continues to collapse its on-premises infrastructure in the future.

## Customer requirements

Contoso Mortgage has the following requirements which you should take into consideration:

* The existing applications have well-known URLs for Contoso's users. Contoso recognizes that transitioning to the cloud may require a new URL to access the applications but wants to minimize change and would like to have no more than one URL change for each application. The new URLs for each application should be the same before and after the migration to Azure.
* Downtime of no more than one hour is acceptable. If there is an error or problem during the migration, Contoso Mortgage must be able to fall back to the on-premises application as quickly as possible.
* Just as with the test implementation in Challenge 5:
    * A load balancing solution will be used in front of the public-facing web applications.
    * Network segmentation and security should be implemented in the same manner, maintaining constrained connectivity between application layers. For example, the public-facing web front-end for the Contoso Mortgage application can only communicate with the API server for the application, and the application server can only communicate with the database server.
    * The servers must be fully operational, including having the ability to access the servers using domain credentials without connectivity to any on-premises domain controllers.
    * Due to security requirements, server administrators will not be able to use Remote Desktop over the public internet and no public IPs can be associated with Azure-hosted servers.

## Success Criteria

* Create an execution plan for your migration and before beginning your final migration share the plan with your coach.
* Network segmentation is in place and limits lateral movement between application layers, including non-application communication such as RDP access.
* The URL you select for providing access to each application needs to be resolvable from the public internet. The technology you select to allow access to the IaaS hosted applications should also allow access to the applications in the future if they are ever hosted in a PaaS environment.
* Server administrators in the *CM Server Admins* security group can access all the migrated servers in a secure manner which does not require opening RDP access to the public internet for any migrated servers.
* If **cmad1** is turned off or hybrid network connectivity between on-premises and Azure is lost, the applications in the production environment can still function.
* For any migrated servers, native Azure functionality such as the *Run Command* should be available as if the server was provisioned from the Azure Marketplace.
* If the migration to Azure is not completed within one hour, immediate fallback to the on-premises applications will be required.

Be ready to answer the following questions:

* Did anything change from your test design and implementation regarding network segmentation and security?
* How does your solution allow for quick failover to on-premises in the event an error occurs during the migration?

Your coach will discuss your implementation before you move on to the next challenge.

Before your team exits this challenge, be sure to clean up any resources which you no longer require.

## References

* <a href="https://docs.microsoft.com/azure/migrate/tutorial-migrate-hyper-v#migrate-vms" target="_blank">Migrate VMs</a>
* <a href="https://docs.microsoft.com/azure/virtual-machines/windows/run-command" target="_blank">Run PowerShell scripts in your Windows VM with Run Command</a>
* <a href="https://docs.microsoft.com/azure/load-balancer/load-balancer-overview" target="_blank">What is Azure Load Balancer?</a>
* <a href="https://docs.microsoft.com/azure/traffic-manager/traffic-manager-overview" target="_blank">What is Traffic Manager?</a>
