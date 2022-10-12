# 保护、优化和运维

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_secure.png" alt="迁移的保护和管理阶段" /></td>
</tr>
</table>

## 挑战

至此，源应用程序的 Web 和数据库层已经被迁移至 PaaS 服务，IT 运维和安全团队希望优化并保护自己的部署，其中就包括在 Azure 中实现的数据库、服务器和网站。运维和应用程序支持团队希望了解每个网站的性能，能查看每个网站的实时性能数据和历史性能数据。在迁移之后，他们依然运行着一些服务器，并希望针对这些服务器获得同样的性能监视能力。

IT 运维团队还希望能查看 Azure 平台本身的运行状况。由于他们已经在 Azure 中创建了大量资源，因此只有随时了解资源运行何时出现异常或服务何时变得不可用，才能帮助他们更好地借助 Microsoft Azure 交付工作负载。

另外请注意，所选的任何解决方案必须能缩放以涵盖更多的服务器和应用程序。在选择服务和实现的过程中必须注意到这一点。

## 客户需求

Contoso Mortgage 的下列需求必须考虑在内：

- *CM Operations* 安全组的成员需要能查看实时性能数据，其中应包含网站性能和数据库性能数据。
- 对于每个网站，Contoso Mortgage 希望能够充分利用云服务在弹性方面的优势。
- 所有高特权的应用程序配置，例如数据库连接字符串以及用户名和密码，都需要以安全的方式存储，只能被获得批准的人员和应用程序访问。
- 存储在任何数据库中的数据，在存储后必须使用由 Contoso Mortgage 管理和维护的密钥加密。
- 所部署的资源在遇到资源或服务运行状况故障时必须能得到通知。

## 成功标准

向你的教练展示如何为 **Contoso Mortgage** 和 **Contoso Mortgage Admin** 这两个 PaaS 托管的网站和数据库实现安全保护。

- 对于每个应用程序的 Web 层，必须实现横向缩放。前端层的每个网站任何时候应当至少包含两个实例，并能随着流量的变化按需纵向缩放。
- *CM Operations* 安全组的成员随时可以查阅实时性能数据。
- 任何与应用程序配置有关的机密和数据库连接字符串均受到保护，仅供必须的人员和应用程序访问。请准备好向教练解释并实现你的具体做法。
- 所有数据库中存储后的数据均使用自定义管理的加密密钥（CMK）进行加密。
- 服务和资源的故障事件可以记录在案。

请在与教练讨论过你的实现之后，再结束本次的 OpenHack 活动。

## 参考

- <a href="https://docs.microsoft.com/azure/app-service/faq-availability-performance-application-issues" target="_blank">Azure Web 应用的应用程序性能常见问题</a>
- <a href="https://docs.microsoft.com/azure/security/azure-database-security-best-practices" target="_blank">Azure 数据库安全性最佳实践</a>
- <a href="https://docs.microsoft.com/azure/security/fundamentals/encryption-atrest" target="_blank">Azure 存储后数据加密</a>
- <a href="https://docs.microsoft.com/azure/azure-monitor/overview" target="_blank">Azure Monitor 概述</a>
- <a href="https://docs.microsoft.com/azure/azure-portal/azure-portal-overview" target="_blank">Azure 门户概述</a>
- <a href="https://docs.microsoft.com/azure/azure-monitor/app/azure-web-apps" target="_blank">监视 Azure 应用服务的性能</a>
- <a href="https://docs.microsoft.com/azure/app-service/web-sites-scale" target="_blank">在 Azure 中对应用进行向上扩展</a>
- <a href="https://docs.microsoft.com/azure/key-vault/key-vault-whatis" target="_blank">Azure 密钥保管库是什么？</a>
- <a href="https://docs.microsoft.com/azure/service-health/overview" target="_blank">Azure Service Health 是什么？</a>

## Secure, optimize, and operate

<table style="width: 100%; background-color: #243A5E; text-align: center">
<tr>
<td align="center"><img style="border: 0px" src="images/migrate_header_secure.png" alt="Secure and manage phase of migration" /></td>
</tr>
</table>

## Challenge

Now that the web and database tiers of the source applications have been migrated to PaaS services, the IT Operations and Security teams would like to optimize and secure their implementation. This includes the databases, servers, and websites that they have implemented in Azure. Understanding the performance of each website is important to the Operations and Application Support teams, including the ability to view live site performance and past performance. After the migration, there are still servers operating as well which they do not want to lose sight of.

The IT Operations team also needs to have visibility into Azure platform health. With numerous resources now created in Azure, understanding when resource health is failing or services are unavailable is critical to delivering workloads hosted in Microsoft Azure.

Keep in mind that any solution must scale beyond the initial set of servers and migrated applications. Your selection of services and implementation should account for this.

## Customer requirements

Contoso Mortgage has the following requirements which you should take into consideration:

- Real-time performance needs to be visible to members of the *CM Operations* security group and should include website and database performance.
- For each website, Contoso Mortgage wants to be able to take advantage of the elasticity that cloud services bring.
- All privileged application configuration such as database connection strings, usernames, and passwords need to be stored securely, only accessible to approved personnel and applications.
- Data stored in any databases must be encrypted at rest using a key that is managed and maintained by Contoso Mortgage.
- Being informed of resource or service health failure for deployed resources.

## Success Criteria

Present to your coach how you approached the implementation of securing the PaaS-hosted websites and databases for both **Contoso Mortgage** and **Contoso Mortgage Admin**.

- For each applications' web tier, horizontal scale must be implemented. Each website in the front end tier should always present a minimum of two instances and scale horizontally as needed to accommodate additional traffic.
- Real-time performance data is always available to members of the *CM Operations* group.
- Any application configuration secrets and database connection strings are protected and available to only required persons and applications. Be prepared to explain your approach and implementation to your coach.
- All databases are encrypted at rest with a custom managed encryption key (CMK).
- Service and resource failures are captured.

Your coach will discuss your implementation before you end the OpenHack.

## References

- <a href="https://docs.microsoft.com/azure/app-service/faq-availability-performance-application-issues" target="_blank">Application performance FAQs for Web Apps in Azure</a>
- <a href="https://docs.microsoft.com/azure/security/azure-database-security-best-practices" target="_blank">Azure database security best practices</a>
- <a href="https://docs.microsoft.com/azure/security/fundamentals/encryption-atrest" target="_blank">Azure Data Encryption-at-Rest</a>
- <a href="https://docs.microsoft.com/azure/azure-monitor/overview" target="_blank">Azure Monitor overview</a>
- <a href="https://docs.microsoft.com/azure/azure-portal/azure-portal-overview" target="_blank">Azure portal overview</a>
- <a href="https://docs.microsoft.com/azure/azure-monitor/app/azure-web-apps" target="_blank">Monitor Azure App Service performance</a>
- <a href="https://docs.microsoft.com/azure/app-service/web-sites-scale" target="_blank">Scale up an app in Azure</a>
- <a href="https://docs.microsoft.com/azure/key-vault/key-vault-whatis" target="_blank">What is Azure Key Vault?</a>
- <a href="https://docs.microsoft.com/azure/service-health/overview" target="_blank">What is Azure Service Health?
</a>
