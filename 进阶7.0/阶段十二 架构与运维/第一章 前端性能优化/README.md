# 前端性能优化

任何小型企业，博主或成长型公司在网上出现时面临的最大挑战之一就是“页面加载时间”问题，除非能确保尽可能快速无缝地加载每个页面，才可以拥有世界上最好最引人注目的网站，否则仍然无法赢得关注者的尊重和忠诚度。

根据当今网络上的所有主要浏览器公司的说法，如果每个网站都想要排名靠前，表现良好并确保客户满意，那么每个网站都需要快。毕竟，如果网页加载速度很慢，那么会立即增加客户开始在其它地方搜索信息，而不是坚持下去的风险。这也是为什么很多公司去找专门的技术人员来做SEO（**Search Engine Optimization**），即搜索引擎优化。 因为页面的加载会影响到爬虫的爬取，页面加载速度是一项非常重要的指标，且页面优化直接影响到了用户体验。

**从用户输入浏览器输入url到页面最后呈现的过程：**

①用户输入URL地址；②浏览器解析URL解析出主机名；③浏览器将主机名转换成服务器ip地址（浏览器先查找本地DNS缓存列表，没有则再向浏览器默认的DNS服务器发送查询请求，同时缓存）；④浏览器将端口号从URL中解析出来；⑤浏览器建立一条与目标Web服务器的TCP连接（三次握手）；⑥浏览器向服务器发送一条HTTP请求报文；⑦服务器向浏览器返回一条HTTP响应报文；⑧关闭连接，浏览器解析文档；⑨如果文档中有资源，重复6 7 8 动作，直至资源全部加载完毕。

![image-20230722093030064](README.assets/image-20230722093030064.png)

**影响页面性能的原因：**①HTTP请求；②复杂的页面逻辑（JS设计）；③重度的DOM操作；④服务端响应；⑤大量的数据等等。

**加速页面性能的办法：**资源压缩与合并（代码打包）、异步加载、CDN、DNS预解析、缓存等等。

## 页面性能优化

前端性能优化可以分为两大部分：浏览器部分（浏览器的前端性能优化）、代码部分（代码层面的性能优化）。

浏览器部分又可以分为：网络层面、浏览器渲染层面、服务端层面。
代码部分又可以分为：构建层面、编码层面、机制（SSR，Server Side Render：服务器端渲染）、规范。

### 浏览器

**目前使用的主流浏览器有五个：**Internet Explorer、Firefox、Safari、Chrome 和 Opera。根据 [StatCounter 浏览器统计数据](http://gs.statcounter.com/)，目前（2019年 6 月）Firefox、Safari 和 Chrome 浏览器的总市场占有率 62.7%，由此可见，开放源代码浏览器（即 Firefox、Chrome 和 Safari，部分开源）在浏览器市场中占据了非常坚实的部分。

**浏览器的主要作用：**浏览器的主要功能就是向服务器发出请求，在浏览器窗口中展示选择的网络资源，这些网络资源包括：HTML、CSS、JavaScript的、媒体（图片、视频等），也可以分为HTML文档（HTML/CSS/JS）、PDF、图片、视频和其它类型。

浏览器解释并显示 HTML 文件的方式是在 HTML 和 CSS 规范中指定的，这些规范由网络标准化组织 W3C（万维网联盟）进行维护。 多年以来，各浏览器都没有完全遵从这些规范，同时还在开发自己独有的扩展程序，这给网络开发人员带来了严重的兼容性问题，如今，大多数的浏览器都是或多或少地遵从规范。

浏览器的用户界面有很多彼此相同的元素，其中包括：用来输入 URI 的地址栏、前进和后退按钮、书签设置选项、用于刷新和停止加载当前文档的刷新和停止按钮、用于返回主页的主页按钮。奇怪的是，浏览器的用户界面并没有任何正式的规范，这是多年来的最佳实践自然发展以及彼此之间相互模仿的结果。HTML5也没有定义浏览器必须具有的用户界面元素，但列出了一些通用的元素（如地址栏、状态栏和工具栏等）。

**Safari和Chrome的竞争历史：**Safari是乔布斯在2003年的Macworld大会发布的，而08年才发展起来的Chrome用了不到Safari一半的时间远远把Safari甩在了后面，这让Safari情何以堪。两大浏览器都是基于苹果的布局引擎Webkit，按道理Safari是占优势的，因为两者都分别是自己操作系统的默认浏览器，许多人就顺便使用了，懒得去下载别的浏览器。许多人可能会想，这还不简单，Chrome运行于Windows操作系统，而Safari大部分时候都用于苹果自己的系统，Windows .VS. OS X里很显然是前者使用人群广，所以Chrome当然比Safari发真快，**但实际上Safari要比Chrome更早登陆Windows。**在2007年六月，Safari for Windows Beta版就已经发布，正式版于2008年三月发布，而Chrome直到2008年的九月才发布，Chrome只用了一年的时间就超过了Safari。另外，虽然大量Benchmark测试表明Chrome不管在网页打开还是JavaScript表现方面，速度都最快，但是，当Safari发布Windows版的时候，测试结果也是一样的，不管在Mac还是PC上测试，那时候都是最快的，如果仅仅是因为速度，那么Safari在2007年六月的表现就应该和chrome在2008年九月的时候一样。难道Chrome胜在插件，也许，不过Safari在2010年年中的时候也有了许多插件，当然，Chrome的插件质量更好更丰富，如果这也足够让Safari落后于Chrome，那么开发商们可能早就将游戏植入Chrome，而且，Firefox也先于Chrome和Safari植入插件，现在也败给了Chrome。
结论是主要原因：①Safari用起来不舒服，google推广给力；②独特的用户体验（UI、交互、云、Google全家桶）。
但是，Safari也有它的优点，Mac上的用户使用safari会更加的省电和省资源，稳定性会更好，插件也不需要爬梯子，有更低的学习成本。

**IE（Internet Explorer）的黑历史：**IE 浏览器的开发应该是在 1994 年中开始的，微软为了对抗当时的主流浏览器 NetScape，准备开发自己的浏览器并在 Windows 中默认捆绑销售。但是，留给微软的时间并不充裕（没时间从零开始），于是和 Spyglass 合作开发。于是，计算机历史上最著名也最臭名昭著的浏览器 IE 诞生了，因为强大的功能和捆绑策略，IE 迅速击败了 NetScape，成为浏览器市场的绝对霸主。在 2002 年，IE 已经拥有了95%的市场份额，几乎打败了所有的竞争对手。但是IE不思进取，于是颠覆者前仆后继，Firefox 开始迅速崛起，Chrome 后来居上，反观 IE 出现了各种安全漏洞和兼容性问题。2006年，IE 被评为“史上第八糟科技产品”，在相当长的时间里，**IE 浏览器是前端程序员员的噩梦**。总结：①软件迭代更新的重要性（居安思危）；②用户体验和用户感知的重要性（人性化产品）；③互联网时代，什么都是可以替代的；④分享、免费、共筑共赢才是互联网的精神。

#### 浏览器的组成结构

<img src="README.assets/layers.png" alt="img"  />

①**用户界面（User Interface）**：包括地址栏、前进/后退按钮、书签菜单等。除了浏览器主窗口显示的请求的页面外，其他显示的各个部分都属于用户界面。

②**浏览器引擎（Browser engine，js引擎）**：在用户界面和渲染引擎之间传送指令。

③**渲染引擎（Rendering engine）**：也可以叫呈现引擎（Rendering Engine）或布局引擎（Layout Engine），负责显示请求的内容。如果请求的内容是 HTML，它就负责解析 HTML 和 CSS 内容，并将解析后的内容显示在屏幕上。默认情况下，渲染引擎可显示HTML（CSS 格式化的 HTML 内容）和 XML 文档与图片；通过插件（或浏览器扩展程序），还可以显示其它类型的内容（如使用 PDF 查看器插件就能显示 PDF 文档）。

④**网络（Networking）**：用于网络调用（如 HTTP 请求），其接口与平台无关，并为所有平台提供底层实现。

⑤**用户界面后端（UI Backend）**：用于绘制基本的窗口小部件（如组合框和窗口）。其公开了与平台无关的通用接口，而在底层使用操作系统的用户界面方法。

⑥**JavaScript 解释器（JavaScript Interpreter）**：用于解析和执行 JavaScript 代码（如 V8 引擎），JS引擎线程负责解析Javascript脚本，运行代码。**JS引擎一直等待任务队列中任务的到来，然后加以处理，一个Tab页（renderer进程）中只有一个JS线程在运行。**

⑦**数据存储（Data Persistence）**：持久层，浏览器需要在硬盘上保存各种数据（如 Cookie），新的 HTML 规范 (HTML5) 定义了“网络数据库”，这是一个完整（但是轻便）的浏览器内数据库。

**另外，浏览器（Firefox、Chrome和Safari）是基于两种引擎构建的**：Firefox 使用的是 Gecko，这是 Mozilla 公司“自制”的渲染引擎，而 Safari 和 Chrome 浏览器使用的是 WebKit（WebKit 是一种开放源代码渲染引擎，起初用于 Linux 平台，随后由 Apple 公司进行修改，从而支持苹果机和 Windows。有关详情，请参阅 [webkit.org](http://webkit.org/) ）和Blink（基于WebKit？）；Firefox在2017年启用了新的web引擎Quantum，Quantum 以 Gecko 引擎为基础，同时利用了 [Rust](https://link.juejin.im/?target=https%3A%2F%2Fgithub.com%2Frust-lang%2Frust) 的良好并发性和 [Servo](https://github.com/servo/servo) 的高性能组件，为 Firefox 带来了更多的并行化和 GPU 运算，让 Firefox 更快更可靠；2015 年 3 月，微软将放弃自家Edge，转而开发Chromium内核浏览器。

| 浏览器  | 渲染引擎（开发语言） | 脚本引擎（开发语言）           |
| ------- | -------------------- | ------------------------------ |
| Chrome  | Blink (c++)          | V8 (c++)                       |
| Opera   | Blink (c++)          | V8 (c++)                       |
| Safari  | Webkit (c++)         | JavaScript Core (nitro)        |
| FireFox | Gecko (c++)          | SpiderMonkey (c/c++)           |
| Edge    | EdgeHTML (c++)       | Chakra JavaScript Engine (c++) |
| IE      | Trident (c++)        | Chakra JScript Engine (c++)    |

开发时间轴：

![image-20190618172835156](README.assets/image-20190618172835156.png)

#### 浏览器是多进程的

进程里面可以有多个线程（可理解为进程就是QQ，线程就是会话）。浏览器是多进程的；浏览器之所以能够运行，是因为系统给它的进程分配了资源（cpu、内存）；可理解为每打开一个Tab页，就相当于创建了一个独立的浏览器进程。

**浏览器里面的进程：**

①Browser进程：浏览器的主进程（负责协调、主控），只有一个，作用：负责浏览器界面显示，与用户交互（如前进、后退等）；负责各个页面的管理，创建和销毁其它进程；将Renderer进程得到的内存中的Bitmap，绘制到用户界面上；网络资源的管理、下载等。

②第三方插件进程：每种类型的插件对应一个进程，仅当使用该插件时才创建。

③GPU进程：最多一个，用于3D绘制等。

④渲染进程（浏览器内核）（Renderer进程，内部是多线程的）：默认每个Tab页面一个进程，互不影响，主要作用为页面渲染、脚本执行、事件处理等。

**渲染进程是多线程的：**

①GUI渲染线程：负责渲染浏览器界面、解析HTML和CSS、构建DOM树和RenderObject树、布局和绘制等。当界面由于某种操作引发回流（reflow）或需要重绘（Repaint）时，该线程就会执行。注意，**GUI渲染线程与JS引擎线程是互斥的**，当JS引擎执行时GUI线程会被挂起（相当于被冻结了，即**Javascript 阻塞 DOM 解析**），GUI更新会被保存在一个队列中等到JS引擎空闲时立即被执行，所以如果JS执行的时间过长，要放在body下面，否则就会导致页面渲染加载阻塞。

②js引擎线程：JS内核（如V8引擎），负责处理Javascript脚本程序，即JS引擎线程负责解析Javascript脚本，运行代码。JS引擎一直等待任务队列中任务的到来，然后加以处理，一个Tab页（renderer进程）中只有一个JS线程在运行。

③事件触发线程：管理着事件队列，监听事件，符合条件时把回调函数放入事件队列中。

④定时触发器线程：浏览器定时计数器并不是由JavaScript引擎计数的，因为JavaScript引擎是单线程的, 如果处于阻塞线程状态就会影响记计时的准确，因此通过单独线程来计时并触发定时，即setInterval与setTimeout在定时触发器线程中计时完毕后，把回调函数放入事件队列中，等待JS引擎空闲后执行。注意，W3C在HTML标准中规定，要求setTimeout中低于4ms的时间间隔算为4ms。

⑤异步http请求线程：检测到XHR对象状态变化时，将回调函数放入事件队列中，即检测到状态变更时，如果设置有回调函数，异步线程就产生状态变更事件，将这个回调再放入事件队列中，再由JavaScript引擎执行。

**执行线：**

<img src="README.assets/image-20190619165952240.png" alt="image-20190619165952240" style="zoom:80%;" />

**渲染线程与JS引擎线程互斥：**

由于JavaScript是可操纵DOM的，如果在修改这些元素属性同时渲染界面（即JS线程和UI线程同时运行），那么渲染线程前后获得的元素数据就可能不一致了。因此为了防止渲染出现不可预期的结果，浏览器设置GUI渲染线程与JS引擎为互斥的关系，当JS引擎执行时GUI线程会被挂起，GUI更新则会被保存在一个队列中等到JS引擎线程空闲时立即被执行。但是，JS如果执行时间过长就会阻塞页面，故要尽量避免JS执行时间过长，否则就会造成页面的渲染不连贯，导致页面渲染加载有阻塞的感觉。

`script`标签的处理：JS可以操作DOM来修改DOM结构，可以操作CSSOM来修改节点样式，这就导致了浏览器在解析HTML时，一旦碰到`script`，就会立即停止HTML的解析（而CSS不会），等执行完JS，再返还控制权。事实上，JS执行前不仅仅是停止了HTML的解析，它还必须等待CSS的解析完成（即当浏览器碰到`script`元素时，发现该元素前面的CSS还未解析完，就会等待CSS解析完成，再去执行JS）。JS阻塞了HTML的解析，也阻塞了其后的CSS解析，整个解析进程必须等待JS的执行完成才能够续，这就是所谓的JS阻塞页面。一个script标签，推迟了DOM的生成、CSSOM的生成以及之后的所有渲染过程，所以从性能角度上讲，将`script`放在页面底部，也就合情合理了。例子：

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>Document</title>
    <script>
      // 页面上的hello world不会变成红色
      document.getElementById("app").style.color = "red";
    </script>
  </head>
  <body>
    <div id="app">
      hello world!
    </div>
  </body>
</html>
```

#### 浏览器的渲染机制

设备刷新率：指设备屏幕渲染的频率（可理解为把屏幕当作墙，则设备刷新率就是多久重新粉刷一次墙面）。基本平常接触的设备（如手机、电脑），它们的默认刷新频率都是60FPS，即屏幕在1s内渲染60次，约16.7ms渲染一次屏幕。这意味着，浏览器最佳的渲染性能是所有的操作在一帧16.7ms内完成，能否做到一帧内完成直接决定着渲染性，影响用户交互。

**编码、解码形成DOM树的过程**（浏览器从网络或硬盘中获得`HTML`字节数据后，经过一个流程，将字节解析为`DOM`树）：
①编码： **先将HTML的原始字节数据转换为文件指定编码的字符。**
②令牌化： **浏览器会根据HTML规范来将字符串转换成各种令牌**（如`<html>`、`<body>`这样的标签以及标签中的字符串和属性等都会被转化为令牌，每个令牌具有特殊含义和一组规则）。令牌记录了标签的开始与结束，通过这个特性可以判断一个标签是否为子标签（如有`<html>`与`<body>`两个标签，当`<html>`标签的令牌还未遇到它的结束令牌`</html>`，就遇见了`<body>`标签令牌，则`<body>`就是`<html>`的子标签）。
③生成对象： **每个令牌都会被转换成定义其属性和规则的对象（这个对象就是节点对象）。**
④构建完毕： **DOM树构建完成，整个对象集合就像是一棵树形结构**（因为标签之间含有复杂的父子关系，树形结构正好可以诠释这个关系）。`CSSOS`同理，层叠样式也含有父子关系（如`div p {font-size: 18px}`，会先寻找所有`p`标签并判断它的父标签是否为`div`之后才会决定是否采用该样式进行渲染）。

整个`DOM`树的构建过程是： **字节 > 字符 > 令牌 > 节点对象 > 对象模型**。例子：

```html
<html>
  <head>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link href="style.css" rel="stylesheet">
    <title>Critical Path</title>
  </head>
  <body>
    <p>Hello <span>web performance</span> students!</p>
    <div><img src="awesome-photo.jpg"></div>
  </body>
</html>
```

![DOM Rendering](README.assets/63503acbly1fk2te7tuh0j20nv0dbjtl.jpg)

渲染引擎一开始会（从网络层？）获取请求文档的内容，内容的大小一般限制在 8000 个块以内，然后进行如下所示的**基本流程**：
渲染引擎将开始解析 HTML 文档，并将各标记逐个转化成“内容树”上的 [DOM](https://www.html5rocks.com/zh/tutorials/internals/howbrowserswork/#DOM) 节点，同时也会解析外部 CSS 文件以及样式元素中的样式数据，HTML 中这些带有视觉指令的样式信息将用于创建另一个树结构：[呈现树](https://www.html5rocks.com/zh/tutorials/internals/howbrowserswork/#Render_tree_construction)。呈现树包含多个带有视觉属性（如颜色和尺寸）的矩形，这些矩形的排列顺序就是它们将在屏幕上显示的顺序。呈现树构建完毕之后，进入“[布局](https://www.html5rocks.com/zh/tutorials/internals/howbrowserswork/#layout)”处理阶段，也就是为每个节点分配一个应出现在屏幕上的确切坐标。下一个阶段是[绘制](https://www.html5rocks.com/zh/tutorials/internals/howbrowserswork/#Painting)，渲染引擎会遍历呈现树，由用户界面后端层将每个节点绘制出来。需要着重指出的是，这是一个渐进的过程（优化上述每一个步骤对实现最佳渲染性能至关重要）。为达到更好的用户体验，渲染引擎会力求尽快将内容显示在屏幕上，它不必等到整个 HTML 文档解析完毕之后，就会开始构建呈现树和设置布局，在不断接收和处理来自网络的其余内容的同时，渲染引擎会将部分内容解析并显示出来。具体流程：

①DOM 树（js加载会阻塞DOM树解析）与 CSSOM 树（js加载不会阻塞CSSOM 树解析？。而**css加载不会阻塞DOM树解析，异步加载时DOM照常构建，但会阻塞render树渲染，因为render树需要css信息，所以渲染时需等css加载完毕**）合并后形成渲染树（RenderObject树构建。渲染树只包含渲染网页所需的节点。用于计算每个可见元素的布局，并输出给绘制流程，将像素渲染到屏幕上）。
②布局，计算每个对象的精确位置和大小。
③绘制，使用最终渲染树将像素渲染到屏幕上（注意：`visibility: hidden` 与 `display: none` 是不一样的，前者隐藏元素，但元素仍占据着布局空间，即会将其渲染成一个空框，而后者是将元素从渲染树中完全移除，元素既不可见，也不是布局的组成部分）。

<img src="README.assets/render-tree-construction.png" alt="DOM CSSOM RenderTree" style="zoom:80%;" />

<img src="README.assets/flow.png" alt="img"  />

以webkit的渲染作为示例（可以使用调试工具来看）：

![img](README.assets/webkitflow.png)

<img src="README.assets/image-20190618182337662.png" alt="image-20190618182337662" style="zoom: 50%;" />

**关键渲染路径：**浏览器接收到服务器返回的HTML、CSS和JavaScript字节数据并对其进行解析和转变成像素的渲染过程被称为''关键渲染路径''，通过优化关键渲染路径即可以缩短浏览器渲染页面的时间。**优化关键渲染路径就是在对关键资源、关键路径长度和关键字节进行优化**；关键资源越少，浏览器在渲染前的准备工作就越少；而关键路径长度和关键字节关系到浏览器下载资源的效率，其越少则浏览器下载资源的速度就越快。

①假设有一个`HTML`页面，它只引入了一个`CSS`外部文件（如上面的例子2），则它的关键渲染路径如下：首先浏览器要先对服务器发送请求获得`HTML`文件，得到`HTML`文件后开始构建`DOM`树，在遇见`<link>`标签时浏览器需要向服务器再次发出请求来获得`CSS`文件，然后则是继续构建`DOM`树和`CSSOM`树，浏览器合并出渲染树，根据渲染树进行布局计算，执行绘制操作，页面渲染完成。

关键资源：可能阻塞网页首次渲染的资源（下图中为2个，`HTML`文件与外部`CSS`文件`style.css`）。
关键路径长度： 获取关键资源所需的往返次数或总时间（下图为2次或以上，一次获取`HTML`文件，一次获取`CSS`文件，这个次数基于`TCP`协议的最大拥塞窗口，一个文件不一定能在一次连接内传输完毕）。
关键字节：所有关键资源文件大小的总和（下图为`9KB`）。

```html
<html>
  <head>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link href="style.css" rel="stylesheet">
    <title>Critical Path</title>
  </head>
  <body>
    <p>Hello <span>web performance</span> students!</p>
    <div><img src="awesome-photo.jpg"></div>
  </body>
</html>
```

![img](README.assets/63503acbly1fk56dzdbn9j20nr068dga.jpg)

②在①基础上新增一个`JavaScript`文件，`JavaScript`文件阻塞了`DOM`树的构建，并且在执行`JavaScript`脚本时还需要先等待构建`CSSOM`树，所以将`<script>`标签添加异步属性`async`，这样浏览器的`HTML`解析器就不会阻塞这个`JavaScript`文件了，关键渲染路径特性如下：

关键资源：2（加上`async`之后，`app.js`为异步加载，不会成为阻塞渲染的资源）。
关键路径长度： 2或以上（浏览器会在一次连接中一起下载`style.css`和`app.js`）。
关键字节： 9KB（加上`async`之后，`app.js`不再是关键资源，所以没有算上它的大小）

```html
<html>
  <head>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link href="style.css" rel="stylesheet">
  </head>
  <body>
    <p>Hello <span>web performance</span> students!</p>
    <div><img src="awesome-photo.jpg"></div>
    <script src="app.js" async></script>
  </body>
</html>
```

![img](README.assets/63503acbly1fk56e0sokqj20oj074ab1.jpg)

③在2基础上对`CSS`进行优化（如添加上媒体查询）：

关键资源：1（`app.js`为异步加载，`style.css`只有在打印时才会使用，所以只剩下`HTML`一个关键资源，即当`DOM`树构建完毕，浏览器就会开始进行渲染），虽然如果`app.js`在`Dom`树构建完成之前请求完成的的话，还是要先等待js执行完毕，进而阻塞，但这里不考虑这情况？。
关键路径长度：1或以上。
关键字节：5KB。

```html
<html>
  <head>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link href="style.css" rel="stylesheet" media="print">
  </head>
  <body>
    <p>Hello <span>web performance</span> students!</p>
    <div><img src="awesome-photo.jpg"></div>
    <script src="app.js" async></script>
  </body>
</html>
```

![img](README.assets/63503acbly1fk56e15x4jj20ny082mxu.jpg)

#### 重排reflow与重绘repaint

**如何理解渲染机制相关的重排和重绘：**

**重排（回流）**（元素的尺寸变了、位置变了）：DOM结构中的各个元素都有自己的盒子（模型），这些都需要浏览器根据各种样式来计算并根据计算结果将元素放到它该出现的位置，这个过程称之为reflow。重排指的是重新计算页面布局，某个节点reflow时会重新计算节点的尺寸和位置，还有可能触发其子节点、祖先节点和页面上的其它节点reflow，在这之后再触发一次repaint（重排一定会触发重绘）。当render tree中的一部分（或全部）因为元素的规模尺寸、布局、隐藏等改变而需要重新构建，这就称为回流，每个页面至少需要一次回流（页面第一次加载的时候）。

**触发Reflow：**
①当增加、删除、修改DOM结点时（脚本操作 DOM），会导致Reflow或Repaint；
②当移动DOM的位置（如计算 offsetWidth 和 offsetHeight 属性），或是搞个动画的时候；
③当修改CSS（排版？）样式的时候，如改变字体、增加或移除样式表、内容变化（如用户在input框中输入文字）、激活 CSS 伪类（如:hover，IE中为兄弟结点伪类的激活）、操作 class 属性、设置 style 属性的值；
④当调整窗口大小（Resize窗口）的时候（移动端没有这个问题），或滚动的时候等。

**触发页面重布局的一些css属性：**
①盒子模型相关属性会触发重布局：`width`、`height`、`padding`、`margin`、`display`、`border-width`、`border`、`min-height`。
②定位属性及浮动会触发重布局：`top`、`bottom`、`left`、`right`、`position`、`float`、`clear`。
③改变节点内部文字结构会触发重布局：`text-align`、`overflow-y`、`font-weight`、`overflow`、`font-family`、`line-height`、`vertical-align`、`white-space`、`font-size`。

**重绘**（元素的颜色、背景、边框、轮廓变了，但是元素的几何尺寸没有变？）：当各种盒子的位置、大小以及其它属性（如颜色、字体大小等）都确定下来后，浏览器于是便把这些元素都按照各自的特性绘制了一遍，于是页面的内容出现了（页面要呈现的内容，通通都绘制到页面上），这个过程称之为repaint。repiant会遍历所有的节点，检测各节点的可见性、颜色、轮廓等可见的样式属性，然后根据检测的结果更新页面的响应部分。当render tree中的一些元素需要更新属性，而这些属性只是影响元素的外观或风格（而不会影响布局的？），则称为重绘。

**触发重绘而不触发重排的一些css属性：**`color`；`border-style`、`border-radius`；`visibility`；`text-decoration`；`background`、`background-image`、`background-position`、`background-repeat`、`background-size`；`outline`、`outline-color`、`outline-style`、`outline-width`；`box-shadow`；

**触发Repaint（redraw）：**DOM改动、CSS改动。

```javascript
// 例子：
var bstyle = document.body.style; // cache
bstyle.padding = "20px"; // reflow, repaint
bstyle.border = "10px solid red"; //  再一次的 reflow 和 repaint
bstyle.color = "blue"; // repaint
bstyle.backgroundColor = "#fad"; // repaint
bstyle.fontSize = "2em"; // reflow, repaint
// new DOM element - reflow, repaint
document.body.appendChild(document.createTextNode('dude!'));
```

当然，浏览器不会像上面那样，每改一次样式就reflow或repaint一次。一般来说，浏览器会把这样的操作积攒一批，然后做一次reflow，这又叫异步reflow或增量异步reflow。但是有些情况浏览器是不会这么做的（如resize窗口、改变了页面默认的字体等，对于这些操作，浏览器会马上进行reflow），此时可以通过一些方法**减少重排与重绘**（重排和重绘在实际开发中是很难避免的，能做的就是尽量减少这种行为的发生，注意Reflow的成本比Repaint的成本高得多的多）：

①js尽量少访问dom节点和css属性，尽量不要过多地频繁地去增加、修改、删除元素，因为这可能会频繁地导致页面reflow，可以先把该dom节点抽离到内存中（虚拟DOM）进行复杂的操作然后再display到页面上。

②减少不必要的 DOM 层级（DOM depth）。改变 DOM 树中的一级会导致所有层级的改变（DOM Tree里的每个结点都会有reflow方法，一个节点的reflow很有可能导致子节点，甚至父节点以及同级节点的reflow），上至根部，下至被改变节点的子节点，这导致大量时间耗费在执行 reflow 上面。另外，不要通过父级来改变子元素样式，最好直接改变子元素样式，改变子元素样式尽可能不要影响父元素和兄弟元素的大小和尺寸

③尽量用 `transform` 来做形变和位移，不会造成回流。

④权衡速度的平滑。如实现一个动画，以1个像素为单位移动这样最平滑，但reflow会过于频繁，CPU很快会被完全占用，但以3个像素为单位移动就好很多。

⑤尽可能的为产生动画的 HTML 元素使用 `fixed` 或 `absolute` 的 `position` ，则修改它们的 CSS 是不会导致 Reflow 的。

⑥不要用tables布局的另一个原因就是tables中某个元素一旦触发reflow就会导致table里所有的其它元素reflow。在适合用table的场合，可以设置table-layout为auto或fixed。

⑦img标签要设置高宽，以减少重绘重排。

⑧把DOM离线后再进行修改，如将一个dom脱离文档流（如`display：none`），再修改属性，这里只发生一次回流。注意：`display:none`会触发reflow，而`visibility:hidden`只会触发repaint，因为没有发现位置变化。

⑨避免不必要的复杂的 CSS 选择器，尤其是后代选择器（descendant selectors），否则匹配选择器将耗费更多的 CPU。

⑩尽量通过class来设计元素样式，切忌用style多次操作单个属性。

```javascript
// 例子：
var left = 10, top = 10; el.style.left = left + "px"; el.style.top  = top  + "px"; // bad
el.className += " theclassname"; // Good
el.style.cssText += "; left: " + left + "px; top: " + top + "px;"; // Good
```



### 页面加载缓慢的原因

<img src="README.assets/browser-rendering.gif" alt="browser-rendering" style="zoom:67%;" />

<img src="README.assets/backend-generation.gif" alt="backend-generation" style="zoom:67%;" />



<img src="README.assets/wpo-front-backend.png" alt="wpo-front-backend" style="zoom: 80%;" />

#### 浏览器部分

①网络层面：

- 过多的HTTP请求：打开一个网页的时候，后台程序的响应并不所需太多时间，等待的时间主要花费在下载网页元素上了，即HTML、CSS、JavaScript、Flash、图片等，据统计，每增加一个元素，网页载入的时间就会增加25-40毫秒（具体取决于用户的带宽情况）。

- 资源访问带宽小：有两方面，一方面是客户端的带宽，一方面是服务器端的带宽。

- 网页元素（图片、视频、样式）太大。

②浏览器渲染层面：

- 渲染阻塞：浏览器想要渲染一个页面就必须先构建出`DOM`树与`CSSOM`树，如果`HTML`与`CSS`文件结构非常庞大与复杂，这显然会给页面加载速度带来严重影响；所谓渲染阻塞资源，即是对该资源发送请求后还需要先构建对应的`DOM`树或`CSSOM`树，这种行为显然会延迟渲染操作的开始时间；**HTML、CSS、JavaScript都是会对渲染产生阻塞的资源，HTML是必需的，但还可以从CSS与JavaScript着手优化，尽可能地减少阻塞的产生。**

- 重复渲染。

- DNS解析（域名）。

③服务端层面：

- 硬件配置低：这个是双向的。

- 服务器软件（如防火墙、内网策略等）。

- 未对Nginx这类web服务器进行配置优化。

- CPU占满、数据库未优化。

- 代码问题：代码效率，代码性能。

- 包含了过多的分析类工具。

#### 代码部分

代码优化，先要写出优质的代码，有几点原则：①使用辅助应用对代码进行检查（如Eslint等）；②使用预编译工具（如less，sass，stylus）；③使用官方的开发规范（命名规范、注释、使用规范、文档规范）；④写出逻辑上易于阅读的代码（文档编排或目录结构、设计模式、代码结构）；⑤代码审查；⑥单元测试；⑦异常与错误机制。

①构建层面：未对代码进行打包、压缩、兼容性优化；未合并重复的请求、代码。

②编码层面：没有良好的编码习惯，错误地编排JS与CSS；for循环、迭代、同步、重定向、阻塞请求；未删除重复、无用的代码；未对逻辑业务复杂的代码进行重构（了解设计模式，对业务进行疏理）。

③机制：如SSR（Server Side Render）服务器端渲染；未加入Async异步机制；未思考页面加载、用户体验。

④规范：CSS规范；HTML规范/HTML5规范；Airbnb代码规范等。



### 优化原则

#### 尽量减少HTTP请求

在浏览器（客户端）和服务器发生通信时，就已经消耗了大量的时间，尤其是在网络情况比较糟糕的时候，这个问题尤其突出。当请求的网页文件中有很多图片、CSS、JS、甚至音乐等信息时，将会频繁地与服务器建立连接与释放连接，这必定会造成资源的浪费（在网速相同的条件下，下载一个100KB的图片比下载两个50KB的图片要耗费的网络资源更多），且每个HTTP请求都会对服务器和浏览器产生性能负担。**具体方法：**

①组合文件，优化图片，使用sprites设计风格（将背景图片合并成一个文件，通过`background-image` 和 `background-position` 控制显示，意味着更少的HTTP请求，通过不让用户等待加载多个图像来节省加载时间）；确保图像不大于它们所需的图像，采用正确的文件格式（PNG通常更适用于少于16种颜色的图形，而JPEG通常更适合照片）并且它们是针对Web压缩的；一些在线工具：[Sprite Cow](http://www.spritecow.com/)、[Spritebox](https://www.spritebox.net/)。

②肉联图片：使用`data:URL`方案将图像数据嵌入实际页面中，虽然可能会增加HTML文档的大小而导致请求的速度会减慢（需要平衡，建议小图片采用base64的格式，直接嵌入代码中），但将内嵌图像组合到（缓存的）样式表中是一种减少HTTP请求并避免增加页面大小的方法。

③简化页面的设计。

#### 使用内容传送网络CDN

建议最终用户响应时间的80-90％用于下载页面中的所有组件（图像，样式表，脚本，Flash等），这是*Performance Golden Rule*，而不是从重新设计应用程序架构的艰巨任务开始，最好首先分散静态内容，这不仅可以大大缩短响应时间，而且用CDN，它更容易实现。

内容分发网络（CDN），也称为内容传送网络，是分布在多个位置的Web服务器的集合（用于分发传送内容的负载的服务器网络）。从本质上讲，网站的副本存储在多个地理位置不同的数据中心，选择用于向特定用户传送内容的服务器通常基于网络接近度的度量（如选择具有最少网络跳数的服务器或具有最快响应时间的服务器），以便用户可以更快、更可靠地访问您的网站，并更有效地向用户传送内容。对于初创公司和私人网站来说，CDN服务的成本可能过高，但随着目标受众变得越来越大并变得更加全球化，CDN对于实现快速响应时间是必要的。

CDN服务商有很多，有专门做CDN服务器的蓝讯、网宿、帝联、快网，还有阿里云、腾讯云、华为云等，国外如[Akamai Technologies](http://www.akamai.com/)，[EdgeCast](http://www.edgecast.com/)或[level3](http://www.level3.com/index.cfm?pageID=36)。除了去购买一些CDN服务商的服务以外，对于大多数开发者，可以使用公共CDN网络上的资源。

#### 避免空src或href值

src或href为空的两种形式：HTML形式，`<img src="">` 或 `<a href=""></a>`；JavaScript形式，`var img = new Image(); img.src = "";`。

空的src和href都会导致多余的HTTP请求，虽然不影响加载时间，但是会对服务器产生不必要的流量和压力，浏览器仍然会向服务器发起一个 HTTP 请求（IE 向页面所在的目录发送请求，Safari、Chrome、Firefox 向页面本身发送请求（网站根路径？），Opera 不执行任何操作）。另外，空的src的image甚至会影响整个网站的用户体验，给服务器造成意外的流量负担（尤其时日 PV 较大时），浪费服务器计算资源，且可能产生报错。解决办法：

①删除空的`src`和`href`标签；

②给`a`标签的`href`属性，连接到实际的页面：`<a href="#"></a>`；`<a href="#nogo"></a>`；`<a href="##"></a>`；`<a href="###"></a>`；`<a href="void(0);"></a>`；`<a href="void(0)"></a>`；`<a href=";"></a>`；`<a href=""></a>`。

③禁止跳转：如添加`cursor:pointer`样式处理。

```html
<style>
    a{cursor: pointer}
</style>
<a>点击一</a>
<a onclick="doSomething()">点击二</a>
```

④给`a`标签创建一个带有描述信息的`href` 属性，并监控`click`事件调用`preventDefault()`函数。优点：让`<a>`够响应键盘事件并获得焦点（从而屏幕阅读器能够读出背后的内容，增强可访问性）；优雅降级，在网络连接很差，还没有加载到CSS的时候，`<a>`依然有手型与正常的link样式。

```html
<a href="#Something_De scriptive" id="my_id">Trigger</a>
<script>
    $("#my_id").click(function(e){
        e.preventDefault(); //取消单击事件的默认动作以阻止链接的跳转。
    })
</script>
```

#### gzip的组件

所有现代浏览器都支持 `gzip` 压缩并会为所有 HTTP 请求自动协商此类压缩，启用 `gzip` 压缩可大幅缩减所传输的响应的大小（最多可缩减 90%），从而显著缩短下载相应资源所需的时间、减少客户端的流量消耗并加快网页的首次呈现速度。从HTTP / 1.1开始，Web客户端表示支持使用HTTP请求中的Accept-Encoding标头进行压缩：`Accept-Encoding：gzip，deflate`。压缩包括XML和JSON在内的任何文本响应都是值得的，但不应对图像和PDF文件进行gzip压缩，因为它们已经过压缩，如果试图对它们进行gzip不仅会浪费CPU，还可能会增加文件大小。如在nginx中开启gzip压缩（其它web容器启动gzip的方法：Nginx，使用 [ngx_http_gzip_module](http://nginx.org/en/docs/http/ngx_http_gzip_module.html)；Apache，使用 [mod_deflate](http://httpd.apache.org/docs/current/mod/mod_deflate.html)；IIS，[配置 HTTP 压缩功能](http://technet.microsoft.com/en-us/library/cc771003(v=WS.10).aspx)）：

```bash
# 开启gzip
gzip on;
# 启用gzip压缩的最小文件，小于设置值的文件将不会压缩
gzip_min_length 1k;
# gzip 压缩级别，1-10，数字越大压缩的越好，也越占用CPU时间
gzip_comp_level 2;
# 进行压缩的文件类型。javascript有多种形式，其中的值可以在 mime.types 文件中找到。
gzip_types text/plain application/javascript application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png font/ttf font/otf image/svg+xml;
# 是否在http header中添加Vary: Accept-Encoding，建议开启
gzip_vary on;
# 禁用IE 6 gzip
gzip_disable "MSIE [1-6]\.";
```

#### CSS放顶部和JS放底部

在HTML文件`<body>`中指定外部样式表和内联样式块可能对浏览器的渲染性能产生不利影响，因为：浏览器会阻塞渲染网页，直到所有外部的样式表都已被下载；而（用`<style>`标记指定的）内联样式块可能会导致reflows和页面跳动。所以把外部样式表和内联样式块放在页面的`<head>`中是很重要的，通过确保样式表首先被下载和解析，可以让浏览器逐步渲染页面。

具体做法：①将内联样式块和`<link>`元素从页面`<body>`内移动到页面`<head>`中（HTML 4.01规范规定，始终把使用`<link>`标签的外部样式表放在`<head>`部分里，还要确保指定的样式有正确的顺序）；②把`<style>`区块放在`<head>`部分里；③使用css媒体类型：可以让`CSS`资源只在特定条件下使用，这样这些资源就可以在首次加载时先不进行构建`CSSOM`树（让CSS资源不在首次加载中阻塞渲染，但不管是哪种CSS资源它们的下载请求都不会被忽略，浏览器仍然会先下载CSS文件），只有在符合特定条件时，才会让浏览器进行阻塞渲染然后构建`CSSOM`树，`CSS`的媒体查询正是用来实现这个功能的，它由媒体类型以及零个或多个检查特定媒体特征状况的表达式组成。

```html
<!-- 没有使用媒体查询，这个css资源会阻塞渲染 -->
<link href="style.css"    rel="stylesheet">
<!-- all是默认类型，它和不设置媒体查询的效果是一样的 -->
<link href="style.css"    rel="stylesheet" media="all">
<!-- 动态媒体查询，将在网页加载时计算。根据网页加载时设备的方向，portrait.css 可能阻塞渲染，也可能不阻塞渲染。-->
<link href="portrait.css" rel="stylesheet" media="orientation:portrait">
<!-- 只在打印网页时应用，因此网页首次在浏览器中加载时，它不会阻塞渲染。 -->
<link href="print.css"    rel="stylesheet" media="print">
```

**把Javascript脚本放在底部，删除阻止渲染的JavaScript**，具体做法：将脚本定义或引用放置到`<body>`底部，`<script defer="defer">`，defer 属性规定是否对脚本执行进行延迟， 脚本将在页面完成解析时执行。蓝色线代表网络读取，红色线代表执行时间，这俩都是针对脚本的，绿色线代表 HTML 解析：

![请输入图片描述](README.assets/bVcQV0.jpeg)

`defer`和`async`在网络读取（下载）是一样的，都是异步的（相较于 HTML 解析），差别在于脚本下载完之后何时执行；`defer`*是最接近对于应用脚本加载和执行的要求的（按照加载顺序执行脚本的）；`async`则是一个乱序执行的主，反正对它来说脚本的加载和执行是紧挨着的，所以不管声明的顺序如何，只要它加载完了就会立刻执行；`async`对于应用脚本的用处不大，因为它完全不考虑依赖（哪怕是最低级的顺序执行），不过它对于那些可以不依赖任何脚本或不被任何脚本依赖的脚本来说却是非常合适的，最典型的例子是Google Analytics。

#### 减少DNS查找

用户访问网站的过程如下：
①在地址栏输入网站地址（如www.example.com）；
②本地DNS得到这个请求，查询本地DNS缓存，如果有这条记录则直接返回对应的IP，否则会请求网络上的DNS服务器，得到相应的IP，再返回给客户机，并缓存这条记录；
③浏览器向得到的IP发起建立连接请求，得到响应后建立连接，请求数据；
④Server端计算所需数据，并返回给client端；
⑤client端（即浏览器），解析数据并显示在浏览器窗口中。

在 一次请求中，DNS解析可以占到请求时间的三分之一左右，所以如果可以缩短DNS解析时间，就可以加快页面的打开速度。缩短DNS解析时间的方法可以**通过延长DNS缓存的时间**、**选用更快的DNS Server**、**减少域名总数**（但是减少域名个数又会降低资源并行下载的数量， 因为同一域名最多可以并行下载两个资源，所以这里需要一个折衷方案，建议是将资源分布在大于等于2但小于等于4个域名上？）、**使用DNS预解析**（因为DNS解析速度很可能是造成资源严重延时的最大原因）等。

**DNS预解析使用场景：**
①新用户访问，后端可以通过 Cookie 判断是否为首次进入站点，对于这类用户，DNS Prefetch 可以比较明显地提升访问速度；
②登录页，提前在页面上进行下一跳页用到资源的 DNS Prefetch；
③页面中的静态资源在不同的domain下，如CSS、JS、图片等文件；
④电商网站的商品页（大量载入不同domain下的商品图）；
⑤大型网站；
⑥js或服务端重定向；
⑦手机网页。

```html
<!-- 在页面header中添加以下代码用以DNS预解析 -->
<meta http-equiv="x-dns-prefetch-control" content="on" />
<link rel="dns-prefetch" href="http://bdimg.share.baidu.com" />
<link rel="dns-prefetch" href="http://nsclick.baidu.com" />
<link rel="dns-prefetch" href="http://hm.baidu.com" />
<link rel="dns-prefetch" href="http://eiv.baidu.com" />
<!-- 注意dns-prefetch需慎用，多页面重复DNS预解析会增加重复DNS查询次数 -->
```

注意DNS预解析的一些兼容性问题，可参见：[http://caniuse.com/#feat=link-rel-dns-prefetch](http://caniuse.com/#feat=link-rel-dns-prefetch)

<img src="README.assets/sdfdsf.png" alt="sdfdsf" style="zoom:80%;" />

Chrome中的一些指令：`chrome://histograms/DNS.PrefetchQueue`，查看队列状态；`chrome://histograms/DNS`，查看从浏览器启动到上一页的DNS记录；`chrome://dns`，查看各域名DNS统计；`chrome://net-internals/#dns`，清除host缓存。

#### 压缩资源

①压缩js、css、image：**对数据进行压缩其实就是使用更少的位数来对数据进行重编码**，如今有非常多的压缩算法，且每一个的作用领域也各不相同，它们的复杂度也不相同。在对`HTML`、`CSS`和`JavaScript`这些文件进行压缩之前，还需要先进行一次冗余压缩（就是去除多余的字符，如注释、空格符和换行符，这些字符对于程序员是有用的，但它们对于浏览器是没有任何意义的）。**通过对外部资源进行压缩可以大幅度地减少浏览器需要下载的资源量，它会减少关键路径长度与关键字节，使页面的加载速度变得更快。**常用工具有webpack和gulp。

②删除重复的脚本（类似`tree-shaking`）：在一个页面中重复引用一个脚本可能存在的问题是浏览器会重复下载并执行脚本文件。

③使用合适大小的图片：用以避免消耗不必要的带宽和系统资源。

④减少DOM元素的数量

⑤使用异步加载：如async、defer，而服务端渲染也是一种减少浏览器资源消耗、减少页面重排重绘、一种现行MVVM框架单页应用最主要的SEO优化手段。

#### 避免3xx/4xx

①**避免重定向**：3xx是重定向相关的HTTP响应代码。

重定向是指用户的原始请求（如请求A）被重定向到其它的请求（如请求B）。HTTP 重定向通过 `301`/`302` 状态码实现（`301 Moved Permanently`，这个状态码标识用户所请求的资源被移动到了另外的位置，客户端接收到此响应后，需要发起另外一个请求去下载所需的资源；`302 Found`，这个状态码标识用户所请求的资源被找到了，但不在原始位置，服务器会回复其它的一个位置，客户端收到此响应后，也需要发起另外一个请求去下载所需的资源）：

```
HTTP/1.1 301 Moved Permanently  
Location: http://example.com/newuri  
Content-Type: text/html  
```

客户端收到服务器的重定向响应后，会根据响应头中 `Location` 的地址再次发送请求。重定向会影响用户体验，尤其是多次重定向时，每次页面重定向到另一个页面时，访问者都会面临等待HTTP请求直到响应周期完成的额外时间，用户在一段时间内看不到任何内容，只看到浏览器进度条一直在刷新。有时重定向无法避免（但再糟糕也比抛出 `404` 好），虽然通过 [HTML meta refresh](https://link.juejin.im/?target=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FMeta_refresh) 和 JavaScript 也能实现，但首选 HTTP `3xx` 跳转，以保证浏览器‘后退’功能正常工作（也利于 SEO）。

常见的优化办法：

- URL 末尾应该添加 `/`。比如，访问 `http://astrology.yahoo.com/astrology` 将被 301 重定向到 `http://astrology.yahoo.com/astrology/`，如果使用 Apache，可以通过 `Alias` 或 `mod_rewrite` 或 `DirectorySlash` 解决这个问题。
- 网站域名变更：CNAME 结合 `Alias` 或 `mod_rewrite` 或其它服务器类似功能实现跳转。

- 在定义链接地址的href属性的时候，尽量使用最完整的、直接的地址（如使用 `www.cnblogs.com` 而不是`cnblogs.com`、使用`cn.bing.com`而不是`bing.com`、使用`www.google.com.hk`而不是`google.com`、使用`www.mysite.com/products/`而不是`www.mysite.com/products`）。

②**避免404浏览器找不到资源的情况**

发出HTTP请求并获得无用的响应（即404 Not Found，未找到资源）是完全没必要的（特别是当外部JavaScript的链接错误并且结果是404时），因为，此下载将阻止并行下载，且浏览器可能会尝试解析404响应主体而带来的性能的浪费。

**404的影响：**

用户可能看不到：如请求favicon.ico文件或请求了某个不存在的脚本文件、样式表、图片文件，页面还是会按照正常的方式进行呈现；丢失的脚本文件、样式表、图片文件，会导致页面的某些行为、界面效果出现异常，但也可能不是很明显；最大的问题可能是性能方面的影响，尤其是请求一个不存在的脚本文件，即便是返回404，浏览器也会尝试去按照Javascript的方式解析响应中的内容，这会增加很多处理的时间。
看得到的影响：如果用户请求的某个页面不存在，那么将收到明确的回应，而默认情况下，应收到一个标准的错误页面。

**常见的优化办法：**至少会有两种原因导致404错误：

- 该资源按理说是要有，但没有提供，而用户按照正常的方式来请求，所以资源找不到：为网站提供favicon.ico这种经常可能会被忽略的资源；使用一些检查工具（如Link checker）。
- 该资源本来就不存在，用户按照不正常的方式来请求，当然还是找不到：避免用户收藏绝对地址而给后期更新带来隐患，可以使用地址Rewrite来重写，或者在设计阶段定义一些灵活友好的地址；使用Routing技术，配置路由规则。

#### 利用缓存

①使用本地缓存，缓存部分常用用户数据和公开数据（缓存机制设计：缓存+过期时间）

②**利用浏览器缓存 ，为链接或者资源添加Expires或Cache-Control头**。浏览器会缓存大量信息（样式表、图像、JavaScript文件等），以便当访问者返回站点时，浏览器不必重新加载整个页面。对于静态组件：通过设置远期未来`Expires`标头实现“永不过期”策略，表示缓存该信息的时间（在许多情况下，一年是合理的时间段，除非网站设计经常更改），格式是`Expires = "Expires" ":" HTTP-date`，如`Expires: Thu, 01 Dec 1994 16:00:00 GMT`（必须是GMT格式）。对于动态组件：使用适当的`Cache-Control`标头来帮助浏览器处理条件请求。

通过HTTP的META设置expires和cache-control（实际使用其一即可，且这样写仅对该网页有效，对网页中的图片或其它请求无效，并不会做任何`cache`）：

```html
<meta http-equiv="Cache-Control" content="max-age=7200" />
<meta http-equiv="Expires" content="Mon, 01 Aug 2019 00:00:00 GMT" />
```

`Cache-Control` 的参数包括：

- **max-age=**[单位：秒 seconds]：设置缓存最大的有效时间，定义的是时间大小，而不是确定的时间点。

- **s-maxage=**[单位：秒 seconds]：类似于 `max-age`，但是它只用于共享缓存（如proxy）。

- **public**：响应会被缓存，并且在多用户间共享，正常情况，如果要求 [HTTP 认证](http://baike.baidu.com/view/2076408.htm)，响应会自动设置为 private。

- **private**：响应只能够作为私有的缓存（如在一个浏览器中），不能在用户间共享。

- **no-cache**：响应不会被缓存，而是实时向服务器端请求资源，这对保证[HTTP 认证](http://baike.baidu.com/view/2076408.htm)能够严格地禁止缓存以保证安全性很有用（这是指页面与public结合使用的情况下），既没有牺牲缓存的效率，又能保证安全。

- **no-store**：在任何条件下，响应都不会被缓存，并且不会被写入到客户端的磁盘里，这也是基于安全考虑的某些敏感的响应才使用。

- **must-revalidate**：响应在特定条件下会被重用，以满足接下来的请求，但是它必须到服务器端去验证它是不是仍然是最新的。

- **proxy-revalidate**：类似于 `must-revalidate`，但不适用于代理缓存。

③**缓存favicon.ico，并设置最好小于1k**：favicon.ico是一个保留在服务器根目录中的图片，为了减轻拥有favicon.ico的带来的性能问题，请确保优化它的大小，最好不到1K，并设置Expires标头使其缓存。

④**把css与js使用外联的方式进行使用**：建议将css和js以外联方式引用以充分利用`cache`，只有一个例外就是针对首页，首页可以采用内联来减少http请求数，加快页面显示速度。首页内联的原因是首页被人们访问的次数不会太多，而且样式一般比较特殊，不像其它页面一样有相同的页面模板（因为就有相同的样式部分），所以首页的样式可以内联，并且应该在首页加载完成之后，再在后台动态加载后续页面的css和js，以提高后续页面的访问速度。如果站点上的用户每个会话有多个页面查看，并且许多页面重复使用相同的脚本和样式表，则缓存的外部文件可能会带来更大的潜在好处。（对于现在的单页面的应用，更适合于动态加载的方案）

⑤**配置的ETag**：ETag（`Entity Tag`，实体标签），属于HTTP协议的一部分，即所有的Web服务器都应该支持这个特性，它的作用是用一个特殊的字符串来标识某个资源的“版本”，客户端（浏览器）请求的时候，比较ETag如果一致，则表示该资源并没有被修改过，客户端（浏览器）可以使用自己缓存的版本，避免重复下载。它比last-modified date更具有弹性，如某个文件在1秒内修改了10次，Etag可以综合Inode（文件的索引节点数），MTime（修改时间）和Size来精准的进行判断，避开UNIX记录MTime只能精确到秒的问题。在服务器集群使用，可取后两个参数，使用ETags减少Web应用带宽和负载。

| 响应标        | 优势 和特点                                                  | 劣势 和可能的问题                                            |
| :------------ | :----------------------------------------------------------- | :----------------------------------------------------------- |
| Expires       | HTTP 1.0就有，简单易用。服务器通过该Header告诉浏览器，某资源直到某个时间才会过期，所以在没有过期之前，浏览器就直接使用本地的缓存了。 | 因为这是由服务器发送的（UTC），但如果服务器时间和客户端时间存在不一致，可能会有些问题。可能存在版本的问题，因为如果在到期之前修改过了，客户端是不会知道的。 另外，Cache-Control中的max-age可以实现类似的效果，且更加好，因为max-age是一个以秒为单位的时间数，而不是具体的时间，所以不存在第一个问题。 |
| Last-Modified | 服务器通过一个Header（Last-Modified）告诉浏览器，某资源最后修改的时间。浏览器在请求的时候，包含一个Header（If-Modified-Since），然后服务器可以进行比较，如果在该时间后没有修改过，则返回304。 | Last-Modified 也是一个时间，但该时间只能精确到秒，如果在同一个秒中有多次修改，则可能会发生问题。 |
| ETag          | 可以更加精确地判断资源是否被修改，因为它不是一个时间值，而是对时间经过处理的一个长整型数值（通过特定的算法）。浏览器发起新请求时需要包含 If-None-Match。 | 如果部署在服务器场环境中，配置不当的话，可能每个服务器会对相同的资源生成不一样的ETag，这样就增加了重复下载的可能性。 |

例子：

<img src="README.assets/image-20190619145105413.png" alt="image-20190619145105413" style="zoom: 50%;" />

#### AJAX优化

AJAX=Asynchronous JavaScript And XML，是一种使用现有标准的新方法。AJAX是在不重新加载整个页面的情况下，与服务器交换数据并更新部分网页的艺术。

由于AJAX是需要发起请求，然后服务器执行，并将结果（通常是JSON格式的）发送给浏览器进行最后的呈现或处理，所以对于网站设计优化的角度而言，同样需要考虑对这些请求，要尽可能的利用到缓存的功能来提高性能，即**使Ajax可缓存**。但对于AJAX而言，有一些特殊性，并不是所有的AJAX请求都是可以缓存的：①`POST`的请求，是不可以在客户端缓存的（但是服务器端可以对数据进行缓存，以便提高处理速度），每次请求都需要发送给服务器进行处理。
②`GET`的请求，是可以（并且默认）在客户端进行缓存的，除非指定了不同的地址，否则同一地址的AJAX请求，不会重复再服务器执行，而是返回304。

但有的时候，希望`GET`请求不被缓存，做法：
①每次调用的时候，请求不同的地址（可以在原始地址后面添加一个随机的号码）。
②如果使用jquery，则可以考虑禁用AJAX的缓存，`$.ajaxSetup({ cache: false });`。
③如果使用axios，则可以`var config = {	headers: {'Content-Type': 'application/json','Cache-Control' : 'no-cache'}}; axios.get('/post',config)`。

另外，建议**使用GET的Ajax请求**：在使用XMLHttpRequest（AJAX的基础）的时候，浏览器中的POST实现为两步走的过程，首先发送头部信息，然后再发送数据。但如果是使用GET的话，就只有一个TCP的包发送出去（除非有大量的Cookie），这样无疑可以提高性能。但是get有容量限制，大于2K（对get的限制：IE是2K，firefox、chrome是4K）的内容只能用post。

#### Cookie优化

①**减小cookie大小**：因为在发请求时浏览器会将cookie信息发送到server端，所以应该只在cookie中存必要的信息且长度越小越好。另外，在写cookie的时候要**给cookie设置一个合理的过期时间**及域。

②对一些静态资源不需要使用cookie的单独设置域（**去除不必要的 Cookie**）：当浏览器发出静态图像请求并将cookie与请求一起发送时，服务器对这些cookie没有任何用处，而且会毫无理由地创建网络流量，所以要确保使用无cookie请求请求静态组件，创建一个子域并在那里托管所有静态组件。

如果域名是`www.example.org`，则可以托管静态组件`static.example.org`，但是，如果已经在顶级域上设置了cookie（即`example.org`而不是`www.example.org`），则所有请求（包括`static.example.org`的）都将包含这些cookie，所以要**注意设置 Cookie 的 domain 级别，如无必要，不要影响到 sub-domain**（在这种情况下，可以购买一个全新的域，在那里托管静态组件，并保持此域无cookie）。在无cookie域上托管静态组件的另一个好处是，某些代理可能拒绝缓存使用cookie请求的组件，而无cookie域的静态资源请求则不拒绝。注意：省略www会别无选择，任何`*.example.org`路径都只能写入cookie，所以出于性能原因，最好使用www子域并将cookie写入该子域。

#### 缩短服务器响应时间

服务器响应时间受到访问流量、每个页面使用的资源、服务器使用的软件以及硬件本身的影响（通常来说，服务器的响应时间由数据库的问题居多，还有错误的程序设计）。要改善服务器响应时间，请查找性能瓶颈，如慢速数据库查询、慢速路由或缺少足够的内存，并修复它们和设法应对任何会在将来出现的性能瓶颈问题，最佳服务器响应时间要低于200毫秒。

①**收集并检查**现有性能和数据。若无可用内容，则可以使用自动化的网络应用监测解决方案（市面上有托管的开源版本，适用于大多数平台）进行评估，或添加自定义的方法。
②**找出并修复**首要的性能瓶颈问题。若使用的是热门网页框架或内容管理平台，请参阅性能优化最佳做法相关的文档。
③**监测并提醒**任何会在将来出现的性能衰退问题。



### 优化工作清单

当出现了页面性能问题时，或在设计应用之前，可以参考如下的条目进行快速检查：

- 页面内容：①减少 HTTP 请求数；②减少 DNS 查询；③避免重定向；④缓存 Ajax 请求；⑤延迟加载；⑥预先加载；⑦减少 DOM 元素数量；⑧划分内容到不同域名；⑨尽量减少 iframe 使用；⑩避免 404 错误。
- 服务器：①使用 CDN；②添加 Expires 或 Cache-Control 响应头；②启用 Gzip；③配置 Etag；④尽早输出缓冲；⑤Ajax 请求使用 GET 方法；⑥避免图片 src 为空。
- Cookie：①减少 Cookie 大小；②静态资源使用无 Cookie 域名。
- CSS：①把样式表放在 `<head>` 中；②不要使用 CSS 表达式；③使用 `link` 替代 `@import`；④不要使用 filter。
- JavaScript：①把脚本放页面底部；②使用外部 JavaScript 和 CSS；③压缩 JavaScript 和 CSS；④移除重复脚本；⑤减少DOM操作；⑥使用高效的事件处理。
- 图片：①优化图片；②优化 CSS Sprite；③不要在 HTML 中缩放图片；④使用体积小、可缓存的 favicon.ico。
- 移动端：①保持单个文件小于 25 KB；②打包内容为分段（multipart）文档。



## 优化工具

### Google Page Speed

Google Page Speed以帮助开发人员和网站所有者确保网页尽可能顺畅、快速地运行，其会对页面进行访问，并提出一些优化建议，可以使用在线inset的方式或插件的方式（但只能看到页面加载的情况，不能看到提出来的具体的建议）。Google Page Speed可以与其它维护网站性能的Google工具一起使用（如Google Analytics）。**特点：**
①在CSS方面更加注重细节，对于CSS选择器，Google Page Speed提供了大量有用的建议。
②页面速度活动功能类似于加载计时器评估，但它实时提供图表，因此可以在任何给定时间准确查看网站上发生的情况。
③自动优化：使用PageSpeed模块，可以将Google跟Nginx或Apache网站服务器集成，以自动优化网站。
④优化库集成：可以找到PageSpeed模块背后优化建议，允许设计和构建自己的工具。

**PageSpeed**：PageSpeed Insights 的Chrome扩展是由谷歌官方开发的一款可以分析页面载入的各个方面，包括资源、网络、DOM以及时间线等信息的插件，也提供在线访问方式。**使用Google PageSpeed Insights**，打开`https://developers.google.com/speed/pagespeed/insights/`，输入需要分析的网址即可，这里面需要注意必须在公网可以访问到网址。

<img src="README.assets/image-20190619212956061.png" alt="image-20190619212956061" style="zoom: 50%;" />

**使用Chrome插件/Mozila插件：**下载安装办法：①使用插件ID:`djfpadpbeemogokhllpiakdeadpoclan`到https://chrome-extension-downloader.com/来下载，然后打开[chrome://extensions/](chrome://extensions/)，再把`ctx`文件拖进去安装；②直接在商店里面搜索（要翻墙）。

<img src="README.assets/image-20190619203556941.png" alt="image-20190619203556941" style="zoom:50%;" />

![image-20230809221156239](README.assets/image-20230809221156239.png)

### JsPerf和Benchmark.js

JsPerf和Benchmark.js是能在js的执行过程提出优化建议或对比。其它更深层次的一些优化工具，则可以使用Chrome的performance选项卡去看哪个环节加载比较耗时。其他JS在线测试网站，还有[jsbench.me](https://jsbench.me/)、[jsben.ch](http://jsben.ch/)、[measurethat.net](https://measurethat.net/)、[webpagetest.org](https://webpagetest.org/)等。

#### JsPerf.js

JsPerf.js是线上使用的（JsPerf在线：https://jsperf.com/；JsPerf Github地址：https://github.com/jsperf/jsperf.com）。

**线上使用方案：**

需要使用Github进行登录，点击`Login with Github to Create Test Cases`：

![image-20190618210408261](README.assets/image-20190618210408261.png)

![image-20190619103010414](README.assets/image-20190619103010414.png)

登录之后，进入授权页面：

![image-20190619103140822](README.assets/image-20190619103140822.png)

创建自己的测试用例（如for和foreach的对比）：

<img src="README.assets/screencapture-jsperf-2019-06-18-21_15_29.png" alt="screencapture-jsperf-2019-06-18-21_15_29" style="zoom:80%;" />

测试过程：

<img src="README.assets/image-20190618211820471.png" alt="image-20190618211820471"  />

测试结果：（注意下图是在window系统的Chrome浏览器里执行的，而在macOS系统的Chrome浏览器里执行则相差不大）

<img src="README.assets/image-20190618211915799.png" alt="image-20190618211915799"  />

更全面的对比结果：

![image-20190618213130251](README.assets/image-20190618213130251.png)

![image-20190618213201840](README.assets/image-20190618213201840.png)

其它的一些测试例子（[https://jsperf.com/popular](https://jsperf.com/popular)）：

<img src="README.assets/image-20190619143653346.png" alt="image-20190619143653346" style="zoom:80%;" />

**线下使用方案：**

环境准备：Mysql、Nodejs。创建过程（安装JsPerf到服务器上）：
①安装Mysql：`mysql -uroot -e "CREATE DATABASE jsperf; GRANT ALL ON jsperf.* TO 'jsuser'@'localhost' IDENTIFIED BY 'jspass'; FLUSH PRIVILEGES;"`；
②在 [Browserscope.org](https://www.browserscope.org/) 注册一个API key ，在 [the settings page](https://www.browserscope.org/user/settings)页面中；
③注册一个 [new OAuth GitHub application](https://github.com/settings/applications/new). 使用callback URL 留空. 复制 "Client ID" 和 "Client Secret"到github的页面上；
④使用`npm install`安装；
⑤配置`.env`的文件，再运行`npm start`。

```bash
NODE_ENV=development
# from Prerequisites step 1
MYSQL_USER=jsuser
MYSQL_PASSWORD=jspass
MYSQL_DATABASE=jsperf
# from Prerequisites step 2
BROWSERSCOPE=
# from Prerequisites step 3
GITHUB_CLIENT_ID=
GITHUB_CLIENT_SECRET=
GITHUB_CALLBACK=http://localhost:3000

BELL_COOKIE_PASS=password-should-be-32-characters
COOKIE_PASS=password-should-be-32-characters

# customizable but not recommended for local development
# SCHEME=http
# DOMAIN=localhost
# PORT=3000
# MYSQL_HOST=localhost
# MYSQL_PORT=3306
# LOGGLY_TOKEN=
# LOGGLY_SUBDOMAIN=
# REDIS_HOST=
# REDIS_PORT=
# REDIS_PASSWORD=
```

#### BenchMark.js

BenchMark.js可以本地安装，经常看到项目中有一个benchmark的文件夹（Benchmark.js网址：https://github.com/bestiejs/benchmark.js）。benckmark是对js运行能效的一个对比测试，能够知道JS代码中与其它方案对比的时候，是否有优化的空间，当然这些新的方案要自己去编写去测试（同样，也可以在JsPerf的官网上去看其它的测试结果）。

```bash
<!-- HTML中引入： -->
<script src="lodash.js"></script>
<script src="platform.js"></script>
<script src="benchmark.js"></script>
# 或者使用`npm`:
$ {sudo -H} npm i -g npm
npm init -y
$ npm i --save benchmark // 或npm install -S benchmark
touch test.js // Linux操作系统下创建文件
node test.js
```

```javascript
// 例子：Reg和IndexOf的对比
var Benchmark = require('benchmark');
var suite = new Benchmark.Suite;
// 添加测试：add tests
suite.add('RegExp#test', function() {
  /o/.test('Hello World!');
})
.add('String#indexOf', function() {
  'Hello World!'.indexOf('o') > -1;
})
// add listeners
.on('cycle', function(event) {
  console.log(String(event.target));
})
.on('complete', function() {
  console.log('Fastest is ' + this.filter('fastest').map('name'));
})
.run({ 'async': true }); // run async
// 打印：logs:
// => RegExp#test x 4,161,532 +-0.99% (59 cycles)
// => String#indexOf x 6,139,623 +-1.00% (131 cycles) // 可见131>59，即indexOf比RegExp快
// => Fastest is String#indexOf

// 例子：call与apply的对比
var Benchmark = require('benchmark');
var suite = new Benchmark.Suite;
var arr1 = function (str) {
    return [].slice.apply(str);
};
var str2 = function (str) {
    return [].slice.call(str);
};
suite.add('arr1', function() {
    arr1('test');
})
    .add('str2', function() {
        str2('test');
    })
    .on('cycle', function(event) {
        console.log(String(event.target));
    })
    .on('complete', function() {
        console.log('Fastest is ' + this.filter('fastest').pluck('name'));
    })
    .run({ 'async': true });

// 例子：Date()与Moment()中的format的对比
const Benchmark = require('benchmark');
var suite = new Benchmark.Suite;
const moment = require('moment')
Date.prototype.Format = function (fmt) {
  var o = {
    "M+": this.getMonth() + 1, //月份
    "d+": this.getDate(), //日
    "h+": this.getHours(), //时
    "m+": this.getMinutes(), //分
    "s+": this.getSeconds(), //秒
    "q+": Math.floor((this.getMonth() + 3) / 3), //季度
    "S": this.getMilliseconds() //毫秒
  };
  if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
  for (var k in o) {
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
  }
  return fmt;
}
suite.add('Date format', function () {
  console.log(new Date().Format('yyyy-MM-dd hh:mm:ss'))
})
  .add('Moment format', function () {
    console.log(moment().format('YYYY-MM-DD HH:mm:ss'))
  })
  .on('cycle', function (event) {
    console.log(String(event.target));
  })
  .on('complete', function () {
    console.log('Fastest is ' + this.filter('fastest').map('name'));
  })
  .run({ 'async': true });
// 输出结果：
// Moment format x 73,570 ops/sec ±4.93% (82 runs sampled)
// Fastest is Moment format
```



## 参考资料

1. [浏览器的工作原理：新式网络浏览器幕后揭秘](https://www.html5rocks.com/zh/tutorials/internals/howbrowserswork/) **强烈推荐**
2. [渲染树构建、布局及绘制](https://developers.google.com/web/fundamentals/performance/critical-rendering-path/render-tree-construction)
3. [优化第一个字节的时间](https://moz.com/blog/improving-search-rank-by-optimizing-your-time-to-first-byte)
4. [TCP的三次握手与四次挥手（详解+动图）](https://blog.csdn.net/qzcsu/article/details/72861891)推荐
5. [常见性能优化策略的总结](https://tech.meituan.com/2016/12/02/performance-tunning.html)
6. [Page Speed](https://moz.com/learn/seo/page-speed)
7. [web性能优化篇](https://juejin.im/post/5c011e0c5188252ea66afdfa#heading-68)
8. [2018 前端性能优化清单](https://juejin.im/post/5a966bd16fb9a0635172a50a)
9. [（译）2019年前端性能优化清单 — 上篇](https://juejin.im/post/5c46cbaee51d453f45612a2c)
10. [（译）2019年前端性能优化清单 — 中篇](https://juejin.im/post/5c471eaff265da616d547c8c)
11. [（译）2019年前端性能优化清单 — 下篇](https://juejin.im/post/5c473cdae51d45518d4701ff)
12. [PageSpeed Insights 规则](https://developers.google.com/speed/docs/insights/rules)
13. [浏览器渲染过程与性能优化](https://sylvanassun.github.io/2017/10/03/2017-10-03-BrowserCriticalRenderingPath/)
14. [如何提升 CSS 选择器性能](https://www.jianshu.com/p/268c7f3dd7a6)
15. [前端性能优化：2018年JavaScript开销及优化工具和方法](https://www.html.cn/archives/9517)
16. [从浏览器多进程到JS单线程，JS运行机制最全面的一次梳理](https://juejin.im/post/5a6547d0f265da3e283a1df7)推荐
17. [彻底理解浏览器的缓存机制](https://juejin.im/entry/5ad86c16f265da505a77dca4) 推荐2