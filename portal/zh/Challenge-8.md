# 转换为平台 Web 托管服务

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_optimize.png" alt="迁移的优化阶段" /></td>
</tr>
</table>

## 挑战

随着到平台数据库服务的迁移完成，IT 主管希望继续尝试着将应用程序组合转换为 PaaS 模式。这一阶段，他们打算将 **Contoso Mortgage** 和 **Contoso Mortgage Admin** 的 Web 层迁移至基于 Azure 的网站托管服务。IT 主管将全面迁移至 PaaS 视作上云的最终目标，这样才能更快速地拥抱新服务，为业务提供更好的支撑。如果他们能向业务负责人证明应用程序可以托管到 PaaS 服务中，那么就可以更确信地用 PaaS 服务运行所有新服务。

Azure 提供了多种多样的托管服务，应用程序支持团队很难确定到底该推荐用哪一种网站托管服务。除了不知道要选择哪个平台服务，他们也不确定如何通过足够安全的实现满足现有安全要求，并且可以让他们实现诸如 SSL 等功能。此外还有人对新服务的性能持怀疑态度。业务用户则很看重新服务的稳定性，因此所选的新服务必须足够稳定，就算无法好过现有实现，至少也要与现有实现的稳定性持平。对于性能指标，也有着类似的要求。

在该公司的本地和 IaaS 托管环境中，业务负责人能够明确了解托管网站的费用，并且每台服务器的成本都会记录到相应的成本中心。但他们担心在使用 PaaS 服务后，会导致成本变得不透明。

IT 主管和业务负责人都明白，就算这种程度的现代化革新也会给他们留下某些技术债务。在不具备源代码的情况下，将现有应用程序的 Web 层迁移至 PaaS 服务必须满足的一个首要目标就是：无需从零开始在 Azure 中实现应用程序，并且要能为未来的迁移和现代化工作提供一种可行的模型。

## 客户需求

Contoso Mortgage 的下列需求必须考虑在内：

- **Contoso Mortgage**（CM）和 **Contoso Mortgage Admin**（CMA）网站都需要使用 SSL。
- 每个网站应当继续托管在和目前相同的 URL 下，对于任何迁移，Contoso Mortgage 要求将停机时间降至最低。
- 每个网站必须能分别计费给负责管理该网站的业务部门。

**Contoso Mortgage Admin** 网站目前的部署使用了 Windows 身份验证，在迁移至 PaaS 服务后，必须继续使用这种方式。为了降低对 Active Directory 的依赖，Contoso Mortgage 希望尝试着使用 Azure AD 提供身份验证功能。

- 用户可以继续使用相同用户名（用户主体名或 UPN）访问应用程序。
- 用户可以通过 My Apps 门户访问这些网站。

如果因为 Azure 本身的局限，或因为缺乏许可，导致上述一个或多个要求无法满足，那么相应的功能就无法实现。

## 成功标准

- 每个（用户可以访问的）前端网站均实现了 SSL。请准备好向教练展示每个网站的 SSL 是如何实现的。
- 每个网站可以使用和 IaaS 模式托管应用程序时相同的 URL 访问。特定应用程序的端口可以更新，但前提是 IaaS 和 PaaS 模式下完全限定的域名（FQDN）保持不变。
- 每个应用程序可以提供清晰且明确的计费/收费能力。请准备好向你的教练解释每个应用程序的成本是如何展示给业务负责人的。
- **Contoso Mortgage Admin** 可通过 MyApps 门户被本地 *Azure Users* OU 中包含的任何用户访问。

此外请准备好回答下列问题：

- 你所选平台服务的哪些特性或功能最终促使你选择了它？
- 你觉得自己选择的服务是否可用于使用了类似工具集（语言、平台等）的其他应用程序？如果平台基于 Linux 呢？

请在与教练讨论过你的实现之后，再继续迎接下一步挑战。

## 参考

- <a href="https://docs.microsoft.com/en-us/azure/app-service/overview" target="_blank">应用服务概述</a>
- <a href="https://docs.microsoft.com/azure/app-service/web-sites-purchase-ssl-web-site" target="_blank">为 Azure 应用服务购买并配置 SSL 证书</a>
- <a href="https://docs.microsoft.com/azure/app-service/configure-authentication-provider-aad" target="_blank">配置你的应用服务应用使用 Azure Active Directory 登录</a>
- <a href="https://docs.microsoft.com/azure/architecture/guide/technology-choices/compute-decision-tree" target="_blank">Azure 计算服务决策树</a>
- <a href="https://azure.microsoft.com/blog/introducing-the-app-service-migration-assistant-for-asp-net-applications/" target="_blank">适用于 ASP.NET 应用程序的应用服务迁移助手简介</a>
- <a href="https://appmigration.microsoft.com/" target="_blank">迁移至 Azure 应用服务</a>

## Transition to platform web-hosting services

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

- SSL is required for both the **Contoso Mortgage** (CM) and **Contoso Mortgage Admin** (CMA) websites.
- Each website should continue to be hosted on the same URL it is today and Contoso Mortgage requires minimal downtime for any migration.
- Each website must be billed separately to the business unit that manages it.

The website for **Contoso Mortgage Admin** uses Windows authentication in its current deployment and after migrating to PaaS it must remain a website which requires authentication. Contoso Mortgage would like to explore leveraging Azure AD for this functionality to reduce their dependency on Active Directory.

- Users will continue to access the application using their same username (user principal name or UPN).
- Users should have access to the site through the My Apps portal.

If one or more of these requirements cannot be met due to limitations in Azure or a lack of licensing, the feature should not be implemented.

## Success Criteria

- SSL has been implemented for each front end (user accessible) website. Be prepared to demonstrate to your coach how SSL was implemented for each site.
- Each website is available through the same URL as when the application was hosted in IaaS. Ports can be updated for a given application as long as the fully qualified domain name (FQDN) remains consistent between IaaS and PaaS.
- A clear line of sight for chargeback/showback for each application has been implemented. Be prepared to explain to your coach how the cost for each application can be shown to business owners.
- **Contoso Mortgage Admin** is available through the MyApps portal for any user in the *Azure Users* OU on-premises.

Be ready to answer the following questions:

- What features and functionality of the platform service(s) you selected drove your decision?
- Do you feel that your selection of service(s) will work for other applications with a similar toolset (language, platform, etc.)? What if the platform was Linux-based?

Your coach will discuss your implementation before you move on to the next challenge.

## References

- <a href="https://docs.microsoft.com/en-us/azure/app-service/overview" target="_blank">App Service overview</a>
- <a href="https://docs.microsoft.com/azure/app-service/web-sites-purchase-ssl-web-site" target="_blank">Buy and configure an SSL certificate for Azure App Service</a>
- <a href="https://docs.microsoft.com/azure/app-service/configure-authentication-provider-aad" target="_blank">Configure your App Service app to use Azure Active Directory sign-in</a>
- <a href="https://docs.microsoft.com/azure/architecture/guide/technology-choices/compute-decision-tree" target="_blank">Decision tree for Azure compute services</a>
- <a href="https://azure.microsoft.com/blog/introducing-the-app-service-migration-assistant-for-asp-net-applications/" target="_blank">Introducing the App Service Migration Assistant for ASP.NET applications</a>
- <a href="https://appmigration.microsoft.com/" target="_blank">Migrate to Azure App Service</a>
