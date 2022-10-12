# 将 Microsoft 工作负载迁移至 Azure

***此 OpenHack 目前为预览版。***

在本次 OpenHack 活动中，你的团队需要对本地 Windows Server 2008 R2 和 Microsoft SQL Server 2008 R2 中运行的现有工作负载进行评估，将其以安全的方式迁移至 Microsoft Azure，并对其进行现代化和优化。虽然每个迁移工作各不相同，但通过参加本次 OpenHack 活动，你的团队将会掌握将应用程序和运行老版本 Windows 操作系统的虚拟机迁移至 Azure，通过从 IaaS 转换为 PaaS 服务以便实现应用程序的现代化革新，针对应用程序的性能和行为获得深入见解，以及保护组织机密所需的知识。

在活动中，你所面对的任何与真实场景、问题或痛点相似的情况都*不*仅仅是巧合。本次活动中你将要遇到的挑战均源自现实生活。

## 背景介绍

Contoso Mortgage 是一家抵押贷款公司，通过收购其他贷款公司和贷款服务机构，该公司实现了长足的增长。近年来，Contoso Mortgage 不仅业务飞速增长，其本地部署的私有数据中心也大幅扩张。目前，Contoso Mortgage 的数据中心内运行着超过 500 台服务器，这些设施由一个专业的基础结构和应用程序支持团队提供支撑。

最近在对本地数据中心进行审计时，他们发现了一些值得警醒的问题。审计报告中提到，Contoso Mortgage 的很多关键业务工作负载均运行在老旧的基础设施上，这些设施很快将无法继续获得支持，甚至对某些设施的支持早已停止。包括物理硬件以及软件，例如操作系统和 Windows Server 2008 R2 上运行的工作负载都面临这样的情况。Contoso Mortgage 还在数据中心内使用了虚拟化技术，他们使用 Hyper-V 作为虚拟机监控程序运行了很多工作负载。但审计发现，甚至某些虚拟化的系统也即将或已经面临支持终止的问题。这个问题非常严重，不容忽视，Contoso Mortgage 的管理层希望能采取措施缓解这种风险，让自己的基础设施能够立即重新获得支持。

Contoso Mortgage 与微软合作已久，并且已经签署了 Enterprise Agreement 协议，是微软的企业级客户。你的团队负责 Contoso Mortgage 的迁移项目。而你需要负责评估用于评估、测试并最终将工作负载迁移到 Microsoft Azure 的完整流程和所用的工具。

对 Contoso Mortgage 的基础结构和应用程序支持团队来说，公有云计算依然是个新概念。他们现有的应用程序都运行在本地，迁移至公有云基础结构将会是一项相当复杂的任务，因为会涉及到大量现有服务器和应用程序，此外该团队也缺乏将一切迁移至 Microsoft Azure 所需的背景知识。更麻烦的是，Contoso Mortgage 并不具备自己所使用的很多应用程序的源代码，这也会造成一定的风险，因为这些应用程序不具备必要的文档，在迁移到云端的过程中，无法针对新平台进行必要的改动。

为了验证 Microsoft Azure 是否能适应 Contoso Mortgage 现有的服务器和应用程序，IT 和业务主管首先指定了一组服务器，这些服务器很有代表性，能够代表 Contoso 在本地运行的各类系统。虽然这些服务器可以代表该公司目前的本地系统，但同时它们也是对业务至关重要的现有生产系统。

相关工作的业务驱动因素包括：

- 限制风险。为本次迁移工作选择的应用程序可以代表 Contoso Mortgage 的本地系统，但同时它们依然是生产系统。
- 以稳定的方式扩展。由于不具备源代码，因此这些应用程序无法轻易修改，可以视作是稳定的。因此迁移前后都必须确保它们能稳定运行，不能在现代化革新的过程中遇到问题。

对于迁移至 Azure 的初始计划，IT 主管提出的目标包括：

- 对老版本 Windows 操作系统，包括 Windows Server 2008 R2 和 Windows Server 2012 R2 中运行的工作负载，以及 Microsoft SQL Server 2008 R2 中运行的系统的迁移情况进行验证，以便充分利用供应商额外提供的支持时限。
- 通过对系统进行现代化革新改善其可用性和弹性，并且最好能在快速迁移所需的时间期限内完成。虽然首要目标是重新托管现有系统，但如果有可能在这期间做出任何有意义的改进，这样的改进也必须实施。
- 在与供应商的支持时限有关的问题解决*之后*，尽可能评估并最终转换为平台服务，借此调查是否有哪些应用程序组件适合进行现代化革新。
- 针对所涉及的流程和工具，为业务用户和 Contoso Mortgage 的管理层提供培训，最终将其余服务器迁移至 Microsoft Azure，尽可能减少要在本地运行的服务器数量。

由于使用了不同的技术并且有着不同的依赖性，每个工作负载无疑都是不同的，但本次演练中获得的经验可以帮助团队逐渐积累所需实践，借此即可以可靠并且可预测的方式将 Contoso Mortgage 在本地运行的更多服务器陆续迁移至 Microsoft Azure。

## 架构

Contoso Mortgage 目前使用了一系列本地部署的 Web 应用程序提供与贷款有关的服务。第一个应用程序 **Contoso Mortgage** 是个对外网站，客户可以通过该网站申请抵押贷款，查看自己申请的处理情况，并了解该公司提供的其他服务。除了对外网站，Contoso Mortgage 还运行了一个名为 **Contoso Mortgage Admin** 的网站，该网站仅限具备域凭据的员工访问，负责贷款业务的员工和其他员工借此处理客户的抵押贷款申请。

在迁移这些应用程序的过程中，为了尽可能不对 Contoso Mortgage 的客户造成影响，必须将停机时间降至最低。在可能的情况下，Contoso Mortgage 还希望尽量采用云计算原则，从传统的基础结构既服务（IaaS）模式转变为平台即服务（Paas）和软件既服务（SaaS）模式。

**无论是否接受，但你的使命不仅仅是将现有应用程序迁移为 IaaS 模式，你还需要以确保应用程序正常运行为前提，尽可能将其转换为 PaaS 模式，以便为后续的应用程序现代化革新做好准备。**

你的团队最终能否成功完成任务，这取决于执行迁移的能力，以及能否将应用程序的停机时间降至最低。

### 本地架构

Contoso Mortgage 目前将 **Contoso Mortgage** 和 **Contoso Mortgage Admin** 运行在 Hyper-V 虚拟机中运行的多个版本的 Windows Server 操作系统中。这些虚拟机承载于同一台宿主机上，每个应用程序包含一个 Web 层，一个应用程序（API）层，以及一个共享的数据层，该数据层被对外和对内网站共用。除了共享的数据层，每个应用程序层都位于自己的专用虚拟机内。

应用程序层通过 Windows 防火墙进行分段并借此对通信进行隔离。Web 前端可被最终用户通过 80 和 8080 端口访问，但目前并未使用 SSL。应用程序层只能通过 2901 端口由相应的应用程序服务器访问，数据库层只能通过 1433 端口由应用程序层访问。

对外应用程序 **Contoso Mortgage**（即 **CM**）是一个 ASP.NET MVC 的 Web 应用程序，包含一个 Microsoft SQL Server 后端，客户登录则使用了基于表单的身份验证（FBA）。对内应用程序 **Contoso Mortgage Admin**（即 **CMA**）也是一个 ASP.NET MVC 的 Web 应用程序，使用了一个 Microsoft SQL Server 后端。员工访问该网站时，**CMA** 会使用集成的 Windows 身份验证（IWA）。

应用程序服务器的架构示意图如下所示：

![应用程序服务器架构](images/application_server_architecture.png)

生产环境中每台服务器都已加入了域。环境的管理员并不会通过公共互联网连接，而是会通过内部网络访问来宾虚拟机。Hyper-V 宿主机上现有的来宾系统如下图所示：

![Hyper-V 来宾架构](images/hyperv_server_architecture.png)

目前使用的来宾系统如下：

| 服务器名称 | 操作系统       | 用途                                                                                                   |
| ----------- | ---------------------- | --------------------------------------------------------------------------------------------------------- |
| **cmad1**   | Windows Server 2012 R2 | 主要的 Active Directory 域控制器                                                                |
| **cmaweb1** | Windows Server 2008 R2 | **Contoso Mortgage Admin**（员工专用）的 Web 前端                                            |
| **cmaapp1** | Windows Server 2008 R2 | **Contoso Mortgage Admin**（员工专用）的应用程序前端                                    |
| **cmdb1**   | Windows Server 2008 R2 | 共享的数据库服务器，运行了 SQL Server 2008 R2，被 **Contoso Mortgage** 和 **Contoso Mortgage Admin** 使用 |
| **cmid1**   | Windows Server 2016    | 未配置的服务器                                                                                    |
| **cmweb1**  | Windows Server 2008 R2 | **Contoso Mortgage**（面向客户）的 Web 前端                                                  |
| **cmapp1**  | Windows Server 2008 R2 | **Contoso Mortgage**（面向客户）的应用程序前端                                          |
| **cmvpn1**  | Windows Server 2016    | 主机路由和远程访问服务（RRAS）                                                           |

- 服务器 **cmid1** 原本是为 Contoso Mortgage 之前的一个项目创建的，但一直未使用。该服务器运行了标准安装的 Windows Server 2016 Datacenter，未部署其他软件或角色。该服务器目前*并未*加入域。
- 服务器 **cmvpn1** 由 Contoso Mortgage 的网络运维团队创建，用于在 Azure 和 Contoso Mortgage 的本地环境之间建立站点到站点 VPN 连接。虽然该服务器已经设置完毕，加入了域，并且已经安装了 RRAS 角色，但服务器本身尚未进行配置。

Hyper-V 宿主机本身包含 16 个内核和 64GB 内存。所有来宾系统都连接到同一个内部交换机：*InternalNATSwitch*。现有来宾系统的 CPU 和内存分配情况以及其他配置细节如下表所示：

| 服务器名称 | 虚拟 CPU | 内存（GiB） | IP 地址  |
| ----------- | :----------: | :----------: | :---------: |
| **cmad1**   | 1            | 4            | 192.168.0.2 |
| **cmaweb1** | 1            | 4            | 192.168.0.4 |
| **cmaapp1** | 1            | 4            | 192.168.0.5 |
| **cmdb1**   | 2            | 8            | 192.168.0.3 |
| **cmid1**   | 1            | 2            | 192.168.0.8 |
| **cmweb1**  | 1            | 4            | 192.168.0.6 |
| **cmapp1**  | 1            | 4            | 192.168.0.7 |
| **cmvpn1**  | 1            | 2            | 192.168.0.9 |

服务器 **cmad1** 还充当了所有虚拟机来宾系统的 DNS 服务器。contosomortgage.local 的正向查找区域配置了如下的记录。应用程序的正确运行依赖这些记录（*例如* Web 应用程序 **Contoso Mortgage** 就被明确配置为通过 <http://api.contosomortgage.local> 与应用程序服务器通信。）

| 名称         | 记录类型 | 值        |
| ------------ | :---------: | :----------: |
| **adminapi** | A           | 192.168.0.5  |
| **api**      | A           | 192.168.0.7  |

### 云架构

Contoso Mortgage 目前有一个现有的 Azure 订阅和 Azure Active Directory 租户。该租户只包含云用户。这些云用户主要用于保护 Azure 中的资源。

***欢迎使用我们提供的登录凭据浏览现有基础结构。Contoso Mortgage 可能已经使用了某些服务，而在本次 OpenHack 活动中，你完全可以利用这些现有服务。***

--------------

## 小提示

本节列出了一些提示，可以帮你熟悉 Migration OpenHack 活动中可能会用到的各类技术。

### 获取你的团队环境所需的凭据

1. 打开 **OPEN HACK ENVIRONMENT** 选项卡。
2. 此处显示的用户名和密码可用于访问你的 Azure 订阅。

### 连接至对外应用程序

1. 打开 **OPEN HACK ENVIRONMENT** 选项卡。
2. 此处显示的用户名和密码可用于访问你的 Azure 订阅。
3. 搜索资源 **cmhostip**。资源的 FQDN 可用于分别通过 80 和 8080 端口访问匿名网站和 Windows 身份验证网站。FQDN 的格式为 **cmfinance\[unique string\].\[region\].cloudapp.azure.com**。例如：

    - 面向客户的网站（**Contoso Mortgage**）：**cmfinancep24roka67fyjo.southcentralus.cloudapp.azure.com**
    - 员工专用的网站（**Contoso Mortgage Admin**）：**cmfinancep24roka67fyjo.southcentralus.cloudapp.azure.com:8080**

### 连接到 Hyper-V 宿主机

1. 打开 Azure 中的 **openhackonpremrg** 资源组。
2. 选择虚拟机 **cmhost**。
3. 使用宿主机的公共 IP 地址用 RDP 方式连接到服务器。

### 连接到 Hyper-V 来宾虚拟机

每个来宾虚拟机均已启用 RDP。可以在宿主机上通过专用 IP 地址访问这些来宾虚拟机。

#### 宿主机凭据

Hyper-V 宿主机 **cmhost** 可通过下列凭据访问：

- 用户名：**demouser**
- 密码：**demo@pass123**

为了便于多个用户同时连接到宿主机，我们还提供了一组额外的凭据。额外提供的登录名为：

- 用户名：**demouser2**

所有这些帐户的密码为：

- 密码：**demo@pass123**

### 域凭据

Hyper-V 宿主机中所有已经加入域的虚拟机，可通过下列凭据访问：

- 用户名：**CONTOSOMORTGAGE\\Administrator**
- 密码：**demo@pass123**

域中的所有帐户使用了相同的密码（*例如*  *Azure Users* OU 中的用户帐户）：

- 密码：**demo@pass123**

Hyper-V 宿主机中所有未加入域的虚拟机，可通过下列凭据访问：

- 用户名：**.\\Administrator**
- 密码：**demo@pass123**

### 数据库凭据

现有数据库实例启用了多个帐户。

- 管理用帐户
    - 用户名：**sa**
    - 密码：**demo@pass123**
- 应用程序帐户
    - 用户名：**financeUser**
    - 密码：**financeAdmin001!**

### 应用程序配置

每台 API 服务器，在网站的 **web.config** 配置文件 *connectionStrings* 元素下包含两个连接字符串：

```xml
<connectionStrings>
    <add name="ContosoFinance" connectionString="Server=[databaseserver];Database=contosomortgagedb;User Id=[user id];Password=[password];MultipleActiveResultSets=False;Connection Timeout=30;" providerName="System.Data.SqlClient" />
    <add name="ContosoIdentity" connectionString="Server=[databaseserver];Database=contosomortgageidentity;User Id=[user id];Password=[password];MultipleActiveResultSets=False;Connection Timeout=30;" providerName="System.Data.SqlClient" />
  </connectionStrings>
```

每个 Web 前端在 **web.config** 配置文件中有一个名为 **ApiBaseUrl** 的 *appSettings* 键，借此定义了 API 服务器的 URL：

```xml
<appSettings>
    <add key="webpages:Version" value="3.0.0.0" />
    <add key="webpages:Enabled" value="false" />
    <add key="ClientValidationEnabled" value="true" />
    <add key="UnobtrusiveJavaScriptEnabled" value="true" />
    <add key="ApiBaseUrl" value="http://[api url]:2901/" />
  </appSettings>
```

## 参考

- <a href="https://go.microsoft.com/fwlink/?linkid=872689" target="_blank">Windows Server 迁移指南</a>
- <a href="https://www.microsoft.com/cloud-platform/windows-server-2008" target="_blank">为 Windows Server 2008 终止支持做好准备</a>

## 词汇表

### 基础结构既服务（Infrastructure-as-a-Service）

基础结构既服务（<a href="https://azure.microsoft.com/overview/what-is-iaas/" target="_blank">IaaS</a>）是一种可通过互联网配置和管理的即时计算基础结构。这是云服务的四种类型之一，此外还有软件既服务（<a href="https://azure.microsoft.com/overview/what-is-saas/">SaaS</a>）、平台即服务（<a href="https://azure.microsoft.com/overview/what-is-paas/" target="_blank">PaaS</a>）以及<a href="https://azure.microsoft.com/overview/serverless-computing/" target="_blank">无服务器</a>。

IaaS 可以根据需要快速扩展或收缩，因此用户只需要为实际使用的资源付费。这种服务使得用户无需购买并管理物理服务器和其他数据中心基础结构，因而有助于节约开支并降低复杂度。每种资源都以单独的服务组件形式提供，因此用户只需要在真正需要时租用特定组件。诸如 Azure 等云计算服务提供商负责管理整个基础结构，用户负责购买、安装、配置并管理自己的软件，包括操作系统、中间件以及应用程序。

### 平台既服务（Platform-as-a-Service）

平台即服务（<a href="https://azure.microsoft.com/overview/what-is-paas/" target="_blank">PaaS</a>）是一种在云端提供的完整开发和部署环境，借此获得的资源可以帮助用户交付从简单的云应用到复杂的云端企业应用程序在内的一切应用程序。用户只需要按照现用现付的方式从<a href="https://azure.microsoft.com/overview/choosing-a-cloud-service-provider/" target="_blank">云服务提供商</a>处购买所需资源，随后即可通过安全的互联网连接访问这些资源。

与 <a href="https://azure.microsoft.com/overview/what-is-iaas/" target="_blank">IaaS</a> 类似，PaaS 也包含基础结构（服务器、存储、网络），但同时还包含中间件、开发工具、数据服务、数据库管理系统等。PaaS 在设计上可以支持 Web 应用程序的完整生命周期：构建、测试、部署、管理 和更新。

PaaS 使得用户无需购买和管理软件许可、底层应用程序基础结构和中间件，以及开发工具和其他资源，因而有助于节约开支并降低复杂度。用户负责管理自己所部署的应用程序和服务，而云服务提供商通常负责管理其他一切。

### Azure Active Directory

Azure Active Directory（<a href="https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-whatis" target="_blank">Azure AD</a>）是微软的云端标识和访问管理服务，可供员工登录并访问下列资源：

- 外部资源，例如 Microsoft Office 365、Azure 门户，以及数千种其他 SaaS 应用程序。
- 内部资源，例如企业网络中的应用和内网，以及你的组织自行部署的其他任何云应用。
