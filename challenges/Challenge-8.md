# Transition to platform web-hosting services

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_optimize.png" alt="Optimize phase of migration" /></td>
</tr>
</table>

## Challenge

With the migration to a platform database service completed, IT leadership would like to continue to explore transitioning their application portfolio to PaaS. The phase will explore migrating the existing web tiers of **Contoso Mortgage** and **Contoso Mortgage Admin** to an Azure-based website-hosting service. IT leadership views the full transition to PaaS as truly taking advantage of their move to the cloud and will allow them to embrace new services faster to better serve the business. If they can prove to business owners that their applications can be hosted in PaaS, they will be better positioned to assume a default position where all new services will run in PaaS.

With the variety of hosting services available in Azure, the existing application support team has had difficulty making a final recommendation for a website hosting service. Besides not knowing which platform service(s) to select, they are also unsure of how a secure implementation can be built out that will meet the existing security requirements and allow them to implement features such as SSL. There are also concerns about the performance of any new service. The stability of any new service will be called into question by the business and must be as stable, if not more than the existing implementation while also having the same, if not better, performance characteristics.

In their on-premises and IaaS-hosted environment, business owners have a clear line of sight into billing for the hosted websites and the cost of each server is charged back to the appropriate cost center. They are worried that introducing PaaS services will lead to less visibility in cost.

IT leadership and the business owners understand that even this level of modernization will still leave them with technical debt. Without access to the source code, being able to transition the existing applications to PaaS for the web tiers meets the overarching goal of not needing to start from scratch to implement applications in Azure and will provide a working model for future migrations and modernization efforts.

## Customer requirements

Contoso Mortgage has the following requirements which you should take into consideration:

* SSL is required for both the **Contoso Mortgage** (CM) and **Contoso Mortgage Admin** (CMA) websites.
* Each website should continue to be hosted on the same URL it is today and Contoso Mortgage requires minimal downtime for any migration.
* Each website must be billed separately to the business unit that manages it.

The website for **Contoso Mortgage Admin** uses Windows authentication in its current deployment and after migrating to PaaS it must remain a website which requires authentication. Contoso Mortgage would like to explore leveraging Azure AD for this functionality to reduce their dependency on Active Directory.

* Users will continue to access the application using their same username (user principal name or UPN).
* Users should have access to the site through the My Apps portal.

If one or more of these requirements cannot be met due to limitations in Azure or a lack of licensing, the feature should not be implemented.

## Success Criteria

* SSL has been implemented for each front end (user accessible) website. Be prepared to demonstrate to your coach how SSL was implemented for each site.
* Each website is available through the same URL as when the application was hosted in IaaS. Ports can be updated for a given application as long as the fully qualified domain name (FQDN) remains consistent between IaaS and PaaS.
* A clear line of sight for chargeback/showback for each application has been implemented. Be prepared to explain to your coach how the cost for each application can be shown to business owners.
* **Contoso Mortgage Admin** is available through the MyApps portal for any user in the *CM Users* OU on-premises.

Be ready to answer the following questions:

* What features and functionality of the platform service(s) you selected drove your decision?
* Do you feel that your selection of service(s) will work for other applications with a similar toolset (language, platform, etc.)? What if the platform was Linux-based?

Your coach will discuss your implementation before you move on to the next challenge.

## References

* <a href="https://docs.microsoft.com/en-us/azure/app-service/overview" target="_blank">App Service overview</a>
* <a href="https://docs.microsoft.com/azure/app-service/web-sites-purchase-ssl-web-site" target="_blank">Buy and configure an SSL certificate for Azure App Service</a>
* <a href="https://docs.microsoft.com/azure/app-service/configure-authentication-provider-aad" target="_blank">Configure your App Service app to use Azure Active Directory sign-in</a>
* <a href="https://docs.microsoft.com/azure/architecture/guide/technology-choices/compute-decision-tree" target="_blank">Decision tree for Azure compute services</a>
* <a href="https://azure.microsoft.com/blog/introducing-the-app-service-migration-assistant-for-asp-net-applications/" target="_blank">Introducing the App Service Migration Assistant for ASP.NET applications</a>
* <a href="https://appmigration.microsoft.com/" target="_blank">Migrate to Azure App Service</a>
