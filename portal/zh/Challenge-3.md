# 实施混合标识

***请按下立即冲向键盘开始操作的想法！现在需要先暂停下来，以团队的思维方式好好考虑一下要在 Azure 中使用的标识架构，以及如何借助该架构加速你的迁移过程。***

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_migrate.png" alt="迁移的迁移和现代化阶段" /></td>
</tr>
</table>

## 挑战

随着 Contoso Mortgage 将工作负载从本地转移至 Azure，对于 Azure 中存储的数据以及整个环境的管理工作，他们需要继续使用现有的本地标识进行保护，这就需要建立混合连接。

在安装和配置混合标识所需的任何工具前，该公司的安全和 Active Directory 团队需要了解这些工具需要安装到环境中的哪些位置，以及具体该如何配置。安全团队担心与本地业务流程有关的非必要帐户，以及特权帐户也被托管至诸如 Azure Active Directory 这样的云目录中。Active Directory 团队则希望使用来自供应商的最佳实践部署用到的所有此类工具，并确保不会对现有的生产域造成任何影响。

IT 主管则在考虑到底该如何在让用户能使用本地凭据登录到 Azure 的同时，无需额外部署任何安全解决方案（如果确实不需要的话）。例如，*CM Server Admins* 安全组中的用户有权登录到域中的所有服务器，而这些用户不仅需要能访问和管理服务器，还要能访问并管理与 Azure 中服务器有关的资源，例如必须能停止和启动虚拟机，以及针对虚拟机进行排错。

根据他们的需求，Contoso Mortgage 决定使用 Azure Active Directory（Azure AD）作为自己的云端标识提供程序，并在 Azure 中建立混合连接。

## 客户需求

Contoso Mortgage 的下列需求必须考虑在内：

- 基础结构支持团队听说，在域控制器上部署标识同步工具，这并不是最佳实践，但同时他们也不希望在承载了其他应用程序的服务器上部署任何额外的代理程序。此外，他们还不希望使用任何新的软件或脚本，因为这可能会对现有生产工作负载产生影响。
- Contoso Mortgage 的本地目录包含大量用户和组，其中很多是为了对始终需要在本地运行的应用程序和流程提供支持，安全团队不希望这些标识被转移到云目录，例如 Azure AD 中。Active Directory 团队在 AD 中为需要在 Azure 中使用的标识创建了两个组织单位（OU），并有针对性地将一系列标识移动到了如下这两个 OU 中：
    - *Azure Users*
    - *Azure Security Groups*
- 目前，为本地标识提供支持的团队并不需要为标识的同步过程提供高可用性保障，但想要了解如果以后 Azure 对业务的重要性进一步提高并且规模继续扩大而希望提供这种保障时，自己都需要做些什么。

## 成功标准

在安装任何工具并验证你的方法前，请将你有关混合标识的实现方案展示给教练。

你的实现应考虑到下列因素：

- 位于 *Azure Users* 和 *Azure Security Groups* OU 中的标识要在本地域和 Azure AD 之间同步。
- 域控制器上无需安装同步工具。
- 向 Azure AD 添加了自定义域并且已经验证。
- 任何同步的标识都应该能在云端使用新建的公共域（*例如* user@newcontosomortage123.com）的登录进行身份验证。若要验证这一点，可以登录至 <a href="https://myapps.microsoft.com" target="_blank">MyApps</a>。

此外请准备好回答下列问题：

- 标识同步工具需要安装在哪里？安装和配置该工具需要具备怎样的权限？
- Contoso Mortgage 如何为标识的同步实施高可用性？
- 如何确保用户可以使用本地环境中相同的用户名和密码登录到 Azure，同时确保安全性不受影响？
- 将本地标识选择性地同步到 Azure AD，这种做法有何利弊？

请在与教练讨论过你的实现之后，再继续迎接下一步挑战。

## 参考

- <a href="https://docs.microsoft.com/azure/active-directory/fundamentals/add-custom-domain" target="_blank">使用 Azure Active Directory 门户添加你的自定义域名</a>
- <a href="https://docs.microsoft.com/azure/active-directory/hybrid/how-to-connect-sync-whatis" target="_blank">Azure AD Connect sync：理解并自定义同步</a>
- <a href="https://docs.microsoft.com/azure/app-service/manage-custom-dns-buy-domain" target="_blank">为 Azure 应用服务购买自定义域名</a>
- <a href="https://docs.microsoft.com/azure/security/azure-ad-choose-authn" target="_blank">为你的 Azure Active Directory 混合标识解决方案选择恰当的身份验证方法</a>
- <a href="https://azure.microsoft.com/resources/hybrid-cloud-identity/" target="_blank">设计你的混合云策略：标识和访问管理</a>
- <a href="https://docs.microsoft.com/azure/active-directory/hybrid/" target="_blank">混合标识文档</a>
- <a href="https://docs.microsoft.com/office365/enterprise/prepare-a-non-routable-domain-for-directory-synchronization" target="_blank">为目录同步准备一个不可路由的域</a>
- <a href="https://docs.microsoft.com/azure/active-directory/hybrid/whatis-azure-ad-connect" target="_blank">Azure AD Connect 是什么？</a>

## Implement hybrid identity

***Resist the initial temptation to rush to the keyboard! This is the time to pause and think as a team about your identity architecture within Azure and how it can be used to accelerate your migration.***

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_migrate.png" alt="Migrate and modernize phase of migration" /></td>
</tr>
</table>

## Challenge

As Contoso Mortgage transitions their on-premises workloads to Azure, they will need to be secured for access using existing on-premises identities on both the management and data planes of Azure, which requires establishing hybrid identity.

Before the installation and configuration of any tooling to support hybrid identity, the Security and Active Directory teams need to understand where it will be installed in their environment and how it will be configured. The Security team has concerns about non-essential and privileged accounts related to on-premises business processes being hosted in a cloud directory such as Azure Active Directory. The Active Directory team would like to deploy any such tooling using known best practices from the vendor and make sure there are no impacts to the existing production domain.

IT leadership also has concerns about how their users will sign in to Azure using their on-premises credentials but does not want to deploy additional security solutions if it can be avoided. For example, users in the *CM Server Admins* security group have logon rights to all servers in the domain today and these same users will need to be able to access and manage not only the servers but also resources related to the servers in Azure such as being able to stop and start virtual machines and perform VM troubleshooting.

Based on their needs, Contoso Mortgage has determined that Azure Active Directory (Azure AD) will be their cloud-based identity provider and where hybrid identities in Azure will reside.

## Customer requirements

Contoso Mortgage has the following requirements which you should take into consideration:

- The Infrastructure support team has read that it is not a best practice to deploy identity synchronization tools on a domain controller and does not want any additional agents installed where other applications are already hosted. They also do not want to impact existing production workloads by introducing new software or scripts.
- Contoso Mortgage has numerous users and groups in their on-premises directory, many of which are in place to support applications and processes that will always be on-premises and the Security team does not want these identities in a cloud directory such as Azure AD. The Active Directory team has created two organizational units (OUs) in their AD for entities that will be used in Azure and has moved a targeted set of entities into each one:
    - *Azure Users*
    - *Azure Security Groups*
- The current team that supports on-premises identity does not see a need for high availability for identity synchronization at this time but would like to understand what would need to be done to implement it in the future as the scale and importance of Azure grows within the business.

## Success Criteria

Present to your coach your plan for implementing hybrid identity before installing any tooling to validate your approach.

Your implementation should account for the following:

- Identities in the *Azure Users* and *Azure Security Groups* OUs are synchronized between the on-premises domain and Azure AD.
- Synchronization tooling has not been installed on a domain controller.
- A custom domain has been added to Azure AD and verified.
- Any synchronized identities should be able to authenticate in the cloud using the login with their new public domain (*e.g.* user@newcontosomortage123.com). To validate, login to <a href="https://myapps.microsoft.com" target="_blank">MyApps</a>.

Be ready to answer the following questions:

- Where was the identity synchronization tooling installed and what rights were required to install and configure the tooling?
- How would Contoso Mortgage implement high availability for identity synchronization?
- How will you make sure users can sign in to Azure with the same user name and password they use on-premises while remaining secure?
- What are the pros and cons of selective synchronization of on-premises identities to Azure AD?

Your coach will discuss your implementation before you move on to the next challenge.

## References

- <a href="https://docs.microsoft.com/azure/active-directory/fundamentals/add-custom-domain" target="_blank">Add your custom domain name using the Azure Active Directory portal</a>
- <a href="https://docs.microsoft.com/azure/active-directory/hybrid/how-to-connect-sync-whatis" target="_blank">Azure AD Connect sync: Understand and customize synchronization</a>
- <a href="https://docs.microsoft.com/azure/app-service/manage-custom-dns-buy-domain" target="_blank">Buy a custom domain name for Azure App Service</a>
- <a href="https://docs.microsoft.com/azure/security/azure-ad-choose-authn" target="_blank">Choose the right authentication method for your Azure Active Directory hybrid identity solution</a>
- <a href="https://azure.microsoft.com/resources/hybrid-cloud-identity/" target="_blank">Designing your Hybrid Cloud Strategy: Identity and Access Management</a>
- <a href="https://docs.microsoft.com/azure/active-directory/hybrid/" target="_blank">Hybrid identity documentation</a>
- <a href="https://docs.microsoft.com/office365/enterprise/prepare-a-non-routable-domain-for-directory-synchronization" target="_blank">Prepare a non-routable domain for directory synchronization</a>
- <a href="https://docs.microsoft.com/azure/active-directory/hybrid/whatis-azure-ad-connect" target="_blank">What is Azure AD Connect?</a>
