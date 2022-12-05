# Implement hybrid identity

***Resist the initial temptation to rush to the keyboard! This is the time to pause and think as a team about your identity architecture within Azure and how it can be used to accelerate your migration.***

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_migrate.png" alt="Migrate and modernize phase of migration" /></td>
</tr>
</table>

## Reminders

* Use an InPrivate/Incognito window in your browser to avoid any confusion with any other credentials that you may use to access Azure resources.
* The credentials you need to access the Azure subscription assigned to your team are available on the *OpenHack Environment* tab.

## Challenge

As Contoso Mortgage transitions their on-premises workloads to Azure, they will need to be secured for access using existing on-premises identities on both the management and data planes of Azure, which requires establishing hybrid identity.

Before the installation and configuration of any tooling to support hybrid identity, the Security and Active Directory teams need to understand where it will be installed in their environment and how it will be configured. The Security team has concerns about non-essential and privileged accounts related to on-premises business processes being hosted in a cloud directory such as Azure Active Directory. The Active Directory team would like to deploy any such tooling using known best practices from the vendor and make sure there are no impacts to the existing production domain.

IT leadership also has concerns about how their users will sign in to Azure using their on-premises credentials but does not want to deploy additional security solutions if it can be avoided. For example, users in the *CM Server Admins* security group have logon rights to all servers in the domain today and these same users will need to be able to access and manage not only the servers but also resources related to the servers in Azure such as being able to stop and start virtual machines and perform VM troubleshooting.

Based on their needs, Contoso Mortgage has determined that Azure Active Directory (Azure AD) will be their cloud-based identity provider and where hybrid identities in Azure will reside.

## Customer requirements

Contoso Mortgage has the following requirements which you should take into consideration:

* The Infrastructure support team has read that it is not a best practice to deploy identity synchronization tools on a domain controller and does not want any additional agents installed where other applications are already hosted. They also do not want to impact existing production workloads by introducing new software or scripts.
* Contoso Mortgage has numerous users and groups in their on-premises directory, many of which are in place to support applications and processes that will always be on-premises and the Security team does not want these identities in a cloud directory such as Azure AD. The Active Directory team has created two organizational units (OUs) in their AD for entities that will be used in Azure and has moved a targeted set of entities into each one:

    * *CM Users*
    * *CM Security Groups*

* The current team that supports on-premises identity does not see a need for high availability for identity synchronization at this time but would like to understand what would need to be done to implement it in the future as the scale and importance of Azure grows within the business.

## Success Criteria

Present to your coach your plan for implementing hybrid identity before installing any tooling to validate your approach.

Your implementation, including the installation and configuration of any tooling should account for the following:

* Identities in the *CM Users* and *CM Security Groups* OUs are synchronized between the on-premises domain and Azure AD.
* Synchronization tooling has not been installed on a domain controller.
* A custom domain has been added to Azure AD and verified.
* Any synchronized identities should be able to authenticate in the cloud using the login with their new public domain (*e.g.* user@newcontosomortage123.com). To validate, login to <a href="https://myapps.microsoft.com" target="_blank">MyApps</a>.

Be ready to answer the following questions:

* Where was the identity synchronization tooling installed and what rights were required to install and configure the tooling?
* How would Contoso Mortgage implement high availability for identity synchronization?
* How will you make sure users can sign in to Azure with the same user name and password they use on-premises while remaining secure?
* What are the pros and cons of selective synchronization of on-premises identities to Azure AD?

Your coach will discuss your implementation before you move on to the next challenge.

## References

* <a href="https://docs.microsoft.com/azure/active-directory/fundamentals/add-custom-domain" target="_blank">Add your custom domain name using the Azure Active Directory portal</a>
* <a href="https://docs.microsoft.com/azure/active-directory/hybrid/how-to-connect-sync-whatis" target="_blank">Azure AD Connect sync: Understand and customize synchronization</a>
* <a href="https://docs.microsoft.com/azure/app-service/manage-custom-dns-buy-domain" target="_blank">Buy a custom domain name for Azure App Service</a>
* <a href="https://docs.microsoft.com/en-us/azure/active-directory/hybrid/choose-ad-authn" target="_blank">Choose the right authentication method for your Azure Active Directory hybrid identity solution</a>
* <a href="https://docs.microsoft.com/en-us/azure/active-directory/hybrid/plan-hybrid-identity-design-considerations-overview" target="_blank">Designing your Hybrid Cloud Strategy: Identity and Access Management</a>
* <a href="https://docs.microsoft.com/azure/active-directory/hybrid/" target="_blank">Hybrid identity documentation</a>
* <a href="https://docs.microsoft.com/office365/enterprise/prepare-a-non-routable-domain-for-directory-synchronization" target="_blank">Prepare a non-routable domain for directory synchronization</a>
* <a href="https://docs.microsoft.com/azure/active-directory/hybrid/whatis-azure-ad-connect" target="_blank">What is Azure AD Connect?</a>
