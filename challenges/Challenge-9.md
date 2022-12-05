# Secure, optimize, and operate

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_secure.png" alt="Secure and manage phase of migration" /></td>
</tr>
</table>

## Reminders

* Use an InPrivate/Incognito window in your browser to avoid any confusion with any other credentials that you may use to access Azure resources.
* The credentials you need to access the Azure subscription assigned to your team are available on the *OpenHack Environment* tab.

## Challenge

Now that the web and database tiers of the source applications have been migrated to PaaS services, the IT Operations and Security teams would like to optimize and secure their implementation. This includes the databases, servers, and websites that they have implemented in Azure. Understanding the performance of each website is important to the Operations and Application Support teams, including the ability to view live site performance and past performance. After the migration, there are still servers operating as well which they do not want to lose sight of.

The IT Operations team also needs to have visibility into Azure platform health. With numerous resources now created in Azure, understanding when resource health is failing or services are unavailable is critical to delivering workloads hosted in Microsoft Azure.

Keep in mind that any solution must scale beyond the initial set of servers and migrated applications. Your selection of services and implementation should account for this.

## Customer requirements

Contoso Mortgage has the following requirements which you should take into consideration:

* Real-time performance needs to be visible to members of the *CM Operations* security group and should include website and database performance.
* For each website, Contoso Mortgage wants to be able to take advantage of the elasticity that cloud services bring.
* All privileged application configuration such as database connection strings, usernames, and passwords need to be stored securely, only accessible to approved personnel and applications.
* Data stored in any databases must be encrypted at rest using a key that is managed and maintained by Contoso Mortgage.
* Being informed of resource or service health failure for deployed resources.

## Success Criteria

Present to your coach how you approached the implementation of securing the PaaS-hosted websites and databases for both **Contoso Mortgage** and **Contoso Mortgage Admin**.

* For each applications' web tier, horizontal scale must be implemented. Each website in the front end tier should always present a minimum of two instances and scale horizontally as needed to accommodate additional traffic.
* Real-time performance data is always available to members of the *CM Operations* group.
* Any application configuration secrets and database connection strings are protected and available to only required persons and applications. Be prepared to explain your approach and implementation to your coach.
* All databases are encrypted at rest with a custom managed encryption key (CMK).
* Service and resource failures are captured.

Your coach will discuss your implementation before you end the OpenHack.

## References

* <a href="https://docs.microsoft.com/azure/app-service/faq-availability-performance-application-issues" target="_blank">Application performance FAQs for Web Apps in Azure</a>
* <a href="https://docs.microsoft.com/azure/security/azure-database-security-best-practices" target="_blank">Azure database security best practices</a>
* <a href="https://docs.microsoft.com/azure/security/fundamentals/encryption-atrest" target="_blank">Azure Data Encryption-at-Rest</a>
* <a href="https://docs.microsoft.com/azure/azure-monitor/overview" target="_blank">Azure Monitor overview</a>
* <a href="https://docs.microsoft.com/azure/azure-portal/azure-portal-overview" target="_blank">Azure portal overview</a>
* <a href="https://docs.microsoft.com/azure/azure-monitor/app/azure-web-apps" target="_blank">Monitor Azure App Service performance</a>
* <a href="https://docs.microsoft.com/azure/app-service/web-sites-scale" target="_blank">Scale up an app in Azure</a>
* <a href="https://docs.microsoft.com/azure/key-vault/key-vault-whatis" target="_blank">What is Azure Key Vault?</a>
* <a href="https://docs.microsoft.com/azure/service-health/overview" target="_blank">What is Azure Service Health?
</a>
