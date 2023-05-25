### WebSocket

以前，很多网站为了实现推送技术，所用的技术都是 Ajax 轮询。轮询是在特定的的时间间隔（如每1秒），由浏览器对服务器发出HTTP请求，然后由服务器返回最新的数据给客户端的浏览器。这种传统的模式（单向请求）带来很明显的缺点：①浏览器需要不断的向服务器发出请求，无法监听连续的状态变化 (HTTP无状态），效率低；②HTTP请求可能包含较长的头部，其中真正有效的数据可能只是很小的一部分，所以会浪费很多的带宽等资源。

<img src="README.assets/ws.png" alt="img" style="zoom:80%;" />

![img](README.assets/bg2017051502.png)

而 HTML5 定义的 WebSocket 协议，能更好的节省服务器资源和带宽，并且能够更实时地进行通讯。WebSocket 协议在2008年诞生，2011年成为国际标准。WebSocket 是 HTML5 开始提供的一种在单个 TCP 连接上进行全双工通讯的协议，所有浏览器都已经[支持](https://caniuse.com/#search=websocket)了。WebSocket 使得客户端和服务器之间的数据交换变得更加简单，允许服务端主动向客户端推送数据。在 WebSocket API 中，浏览器和服务器只需要完成一次握手，两者之间就直接可以创建持久性的连接，并进行双向数据传输。在 WebSocket API 中，浏览器和服务器只需要做一个握手的动作，然后浏览器和服务器之间就形成了一条快速通道，两者之间就直接可以数据互相传送。WebSocket的特点：
①建立在 TCP 协议之上，服务器端的实现比较容易；
②与 HTTP 协议有着良好的兼容性，其默认端口也是80和443，并且握手阶段采用 HTTP 协议，因此握手时不容易屏蔽，能通过各种 HTTP 代理服务器；
③数据格式比较轻量，性能开销小，通信高效；
④可以发送文本，也可以发送二进制数据；
⑤没有同源限制，客户端可以与任意服务器通信；
⑥协议标识符是`ws`（如果加密，则为`wss`），服务器网址就是 URL。

它的最大特点就是，服务器可以主动向客户端推送信息，客户端也可以主动向服务器发送信息，是真正的**双向平等**对话，属于（客户端向）服务器推送技术的一种。Websocket的常见应用：聊天室、消息系统（推送消息、实况、股票基金等实时变化的数据）、点赞、直播评论（弹幕）、游戏、协同编辑、基于位置的应用、在线教育（多媒体聊天、文字消息）等等。

<img src="README.assets/image-20191004220021412.png" alt="image-20191004220021412" style="zoom: 80%;" />

学习路径：了解Websocket基本概念（what），了解Websocket工作原理（Why），搭建Websocket服务（how）和学习Websocket的基本使用（how），具体的Websocket应用（消息应用）。

学习准备：①Linux服务器或虚拟机（Centos 7.x）（安装Docker服务参见：https://www.daocloud.io/mirror）；②域名，可方便后面配置WSS，开发一些WSS的应用（如小程序）。

### WebSocket服务端

常用的 Node 实现有这几种：[ws](https://github.com/websockets/ws)，[µWebSockets](https://github.com/uWebSockets/uWebSockets)，[Socket.IO](http://socket.io/)，[WebSocket-Node](https://github.com/theturtle32/WebSocket-Node)。

#### ws配置服务端

```shell
npm install -S ws
```

服务端的例子：

```js
const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 8080 }); // 使用Wesocket.Server方法初始化服务端
// 一个更复杂的配置：
// const wss = new WebSocket.Server({
//   port: 8080,
//   perMessageDeflate: {
//     zlibDeflateOptions: {
//       // See zlib defaults.
//       chunkSize: 1024,
//       memLevel: 7,
//       level: 3
//     },
//     zlibInflateOptions: {
//       chunkSize: 10 * 1024
//     },
//     // Other options settable:
//     clientNoContextTakeover: true, // Defaults to negotiated value.
//     serverNoContextTakeover: true, // Defaults to negotiated value.
//     serverMaxWindowBits: 10, // Defaults to negotiated value.
//     // Below options specified as default values.
//     concurrencyLimit: 10, // Limits zlib concurrency for perf.
//     threshold: 1024 // Size (in bytes) below which messages
//     // should not be compressed.
//   }
// });
wss.on('connection', function connection(ws) {
  ws.on('message', function incoming(message) {
    console.log('received: %s', message);
  });
  ws.send('something');
});
```

客户端的例子：（可直接`node client.js`直接执行）

```js
// 引用weboscket库
const WebSocket = require('ws');
const ws = new WebSocket('ws://127.0.0.1:8080')
ws.on('open', function () {
  for (var i = 0; i < 3; i++) {
    ws.send('Hello from client: ' + i)
  }
  ws.on('message', function (msg) {
    console.log(msg)
  })
})
```

#### socket.io配置服务端

WebSocket是跟随HTML5一同提出的，所以在兼容性上存在问题，而[Socket.io](https://socket.io/)则可以化解这个问题。socket.io是基于 Websocket 的Client-Server 实时通信库。socket.io底层是基于engine.io这个库，engine.io为 socket.io 提供了跨浏览器和跨设备的双向通信的底层库，engine.io使用了 Websocket 和 XHR 方式封装了一套 socket 协议。

socket.io封装了websocket，同时包含了其它的连接方式，所以在任何浏览器里都可用socket.io来建立异步的连接。在低版本的浏览器中，不支持Websocket，为了兼容则使用长轮询(polling)替代。socket.io包含了服务端和客户端的库，如果在客户端（浏览器）中使用了socket.io的js，服务端也必须同样适用。

<img src="README.assets/1460000018944638.png" alt="engine.io" style="zoom:80%;" />

服务端的例子，引入socket.io、http、express库

```js
const app = require('express')()
const http = require('http').createServer(app)
const io = require('socket.io')(http)
app.get('/', function (req, res) {
  res.sendFile(__dirname + '/index.html')
})
// 监听连接
io.on('connection', function (socket) {
  console.log('a socket is connected');
  // 获取客户端的消息
  socket.on('chat msg', function (msg) {
    console.log('msg from client: ' + msg);
    // 发送消息给客户端
    socket.send('server says: ' + msg)
    // socket.broadcast.emit('hi'); // 向除了某个(该)套接字以外的所有人发送消息
  })
})
// io.emit('chat message', msg) // 将消息发送给所有人，包括发送消息的客户端
http.listen(3000, function () {
  console.log('server is running on: 3000')
})
```

客户端的例子，引入socket.io.js，有两种方式去引用：

①支持从socket.io.client中的dist中加载这个js（客户端的仓库地址：https://github.com/socketio/socket.io-client）；②CDN

<img src="README.assets/image-20220830201356713.png" alt="image-20220830201356713" style="zoom:80%;" />

### WebSocket API

浏览器通过 JavaScript 向服务器发出建立 WebSocket 连接的请求，连接建立以后，客户端和服务器端就可以通过 TCP 连接直接交换数据。当获取 Web Socket 连接后，你可以通过 **send()** 方法来向服务器发送数据，并通过 **onmessage** 事件来接收服务器返回的数据。以下 API 用于创建 WebSocket 对象：（代码中的第一个参数 url指定连接的 URL，第二个参数 protocol 是可选的，指定了可接受的子协议）

```js
var Socket = new WebSocket(url, [protocol] );
```

#### WebSocket 属性

以下是 WebSocket 对象的属性（假定使用了以上代码创建了 Socket 对象）

| 属性                  | 描述                                                         |
| :-------------------- | :----------------------------------------------------------- |
| Socket.readyState     | 只读属性 **readyState** 表示连接状态，可以是以下值：0 - 表示连接尚未建立。1 - 表示连接已建立，可以进行通信。2 - 表示连接正在进行关闭。3 - 表示连接已经关闭或者连接不能打开。 |
| Socket.bufferedAmount | 只读属性 **bufferedAmount** 已被 send() 放入正在队列中等待传输，但是还没有发出的 UTF-8 文本字节数。 |

#### WebSocket 事件

以下是 WebSocket 对象的相关事件（假定使用了以上代码创建了 Socket 对象）

| 事件    | 事件处理程序     | 描述                       |
| :------ | :--------------- | :------------------------- |
| open    | Socket.onopen    | 连接建立时触发             |
| message | Socket.onmessage | 客户端接收服务端数据时触发 |
| error   | Socket.onerror   | 通信发生错误时触发         |
| close   | Socket.onclose   | 连接关闭时触发             |

#### WebSocket 方法

以下是 WebSocket 对象的相关方法（假定使用了以上代码创建了 Socket 对象）

| 方法           | 描述             |
| :------------- | :--------------- |
| Socket.send()  | 使用连接发送数据 |
| Socket.close() | 关闭连接         |

#### WebSocket 实例

WebSocket 协议本质上是一个基于 TCP 的协议。为了建立一个 WebSocket 连接，客户端浏览器首先要向服务器发起一个 HTTP 请求，这个请求和通常的 HTTP 请求不同，WebSocket发起的请求包含了一些附加头信息，其中附加头信息"Upgrade: WebSocket"表明这是一个申请协议升级的 HTTP 请求，服务器端解析这些附加的头信息然后产生应答信息返回给客户端，这样客户端和服务器端的 WebSocket 连接就建立起来了，双方就可以通过这个连接通道自由的传递信息，并且这个连接会持续存在直到客户端或者服务器端的某一方主动的关闭连接。目前大部分浏览器都支持 WebSocket() 接口，你可以在以下浏览器中尝试实例： Chrome, Mozilla, Opera 和 Safari。

### Websocket基础应用

#### 案例介绍

实现的功能如下：

①基本的应用：服务端广播消息，客户端结合vue来使用（调试版本&正式版本）；

②欢迎语；

③退出时进行消息通知：服务端广播消息，客户端针对不同的业务进行代码提示；

④统计聊天人数：服务端把在线的clients数量返回给客户端，客户端接收消息（包括自己）；

⑤多个聊天室：存储聊天室（会话）。方式：1.（服务端）内存中进行存储；2.redis；3.redis + mongoDB；4.localstorage + 重连机制；

⑥指定发送消息和统计在线人数：根据上述的⑤选择的1的方式来进行改进

⑦心跳检测：官方案例（注意客户端用的是ws这个库）：

1.服务端：检测客户端的连接：通过定时器（以及中间桥梁变量isAlive） -> 超过（达到）指定时间 -> （isAlive还没变成true则）主动断开客户端的连接

![image-20220831234732343](README.assets/image-20220831234732343.png)

2.客户端：（通过）设置定时器（即定时器的setTimeout和clearTimeout两个API来实现）（分别在首次连接成功open和接收到heartbeat的ping消息时进行调用） -> 如果超时（服务端还没有响应 ping/pong） -> 断开与服务端的连接

![image-20220831234915584](README.assets/image-20220831234915584.png)

⑧ws中的鉴权：官方案例（注意客户端用的是ws这个库）：

![image-20220903024434866](README.assets/image-20220903024434866.png)

鉴权机制设计：使用jsonwebtoken（jwt）方式进行鉴权：

先安装`yarn add jsonwebtoken`或`npm install的方式`

<img src="README.assets/image-20220903024909385.png" alt="image-20220903024909385" style="zoom:80%;" />

<img src="README.assets/image-20220903025111291.png" alt="image-20220903025111291" style="zoom:80%;" />

<img src="README.assets/image-20220903030320876.png" alt="image-20220903030320876" style="zoom:80%;" />

<img src="README.assets/image-20220903025457317.png" alt="image-20220903025457317" style="zoom:80%;" />

下图中的右上是加密的算法，右中是载荷，右下是secret

<img src="README.assets/image-20220903025543813.png" alt="image-20220903025543813" style="zoom:80%;" />

⑨Websocket中的断线重连

方式：

A.通过监听error事件和在heartbeat事件超时触发来实现（重新初始化websocket）（案例中使用该方式实现）

B.使用reconnect-websocket库：

1.es6:https://www.npmjs.com/package/reconnecting-websocket

<img src="README.assets/image-20220903134108051.png" alt="image-20220903134108051" style="zoom:80%;" />

<img src="README.assets/image-20220903134250987.png" alt="image-20220903134250987"  />

![image-20220903134541765](README.assets/image-20220903134541765.png)

![image-20220903134636477](README.assets/image-20220903134636477.png)

![image-20220903134807290](README.assets/image-20220903134807290.png)

2.es5: https://github.com/joewalnes/reconnecting-websocket

<img src="README.assets/image-20220903133515953.png" alt="image-20220903133515953" style="zoom:80%;" />

<img src="README.assets/image-20220903133836894.png" alt="image-20220903133836894" style="zoom:80%;" />

#### 案例完整代码

服务端代码：

```js
const WebSocket = require('ws')
const jwt = require('jsonwebtoken')

// 测试用的token
// const token = jwt.sign({
//   data: 'foobar'
// }, 'secret', { expiresIn: '1d' });

// console.log('token is:' + token);

const wss = new WebSocket.Server({ port: 8000 })

// 多聊天室的功能
// 记录房间ID -> roomid -> 指定对应的roomid进行广播
// 否则就广播到大厅 （default默认ID）

// 存放roomid： 1. ws对象上，存储在内存中 2.借助redis、mongodb这样的数据库进行持久化
// redis -> set -> group[roomid] -> 对应的会话ID
// mongodb -> 用户历史加入的房间/会话 -> 用户历史发消息 -> 收藏 等用户相关的需要持久化的数据
var group = {}
// 定时去检测客户端的时长
var timeInterval = 30000

// 提高服务的稳定性
// 检测客户端的连接 -> 定时器 -> 超过指定时间 -> 主动断开客户端的连接
wss.on('connection', function (ws, req) {
  // 初始化客户端的连接状态量
  ws.isAlive = true

  // console.log('a new client is connected!');
  ws.on('message', function (msg) {
    var msgObj = JSON.parse(msg)
    // 鉴权机制 -> 检验token的有效性
    if (msgObj.event === 'auth') {
      console.log('msg auth is: ' + msgObj.message)
      // 拿到token,并且去校验时效性
      jwt.verify(msgObj.message, 'secret', function (err, decode) {
        if (err) {
          // websocket返回前台一个消息
          console.log('auth error')
          return
        } else {
          // 鉴权通过的逻辑
          // 这里可以拿到decode，即payload里面的内容
          ws.isAuth = true
          return
        }
        console.log(JSON.stringify(decode));
      })
    }
    // 拦截，非鉴权的请求
    if (!ws.isAuth) {
      // ws.terminate()
      // 去给客户端发送重新鉴权的消息
      ws.send(JSON.stringify({
        event: 'noauth',
        message: 'please auth again, your token is expired!'
      }))
      return
    }
    if (msgObj.event === 'heartbeat' && msgObj.message === 'pong') {
      ws.isAlive = true
      return
    }
    if (msgObj.name) {
      ws.name = msgObj.name
    }
    if (typeof ws.roomid === 'undefined' && msgObj.roomid) {
      ws.roomid = msgObj.roomid
      if (typeof group[ws.roomid] === 'undefined') {
        group[ws.roomid] = 1
      } else {
        group[ws.roomid]++
      }
    }
    // 广播到其他的客户端
    wss.clients.forEach(function each(client) {
      msgObj.num = group[ws.roomid]
      if (client.readyState === WebSocket.OPEN && client.roomid === ws.roomid) {
        client.send(JSON.stringify(msgObj));
      }

      // msgObj.num = wss.clients.size
      // // 广播给非自己的其他客户端
      // if (client.readyState === WebSocket.OPEN) {
      //   client.send(JSON.stringify(msgObj));
      // }
    });
  })
  // 客户端断开链接
  ws.on('close', function () {
    // console.log('one client is closed :' + ws);
    if (typeof ws.name !== 'undefined') {
      group[ws.roomid]--
      // 广播到其他的客户端
      wss.clients.forEach(function each(client) {
        // 广播给非自己的其他客户端
        if (client !== ws && ws.roomid === client.roomid && client.readyState === WebSocket.OPEN) {
          client.send(JSON.stringify({
            name: ws.name,
            event: 'logout',
            num: group[ws.roomid]
          }));
        }
      });
    }
  })
})

const interval = setInterval(function () {
  // 遍历所有的客户端，发送一个ping/pong消息
  // 检测是否有返回，如果没有返回或者超时之后，主动断开与客户端的连接
  wss.clients.forEach(function each(ws) {
    if (ws.isAlive === false) {
      console.log('client is disconneted!');
      group[ws.roomid]--
      return ws.terminate()
    }

    ws.isAlive = false
    // 主动发送ping/pong消息
    // 客户端返回了之后，主动设置isAlive的状态
    ws.send(JSON.stringify({
      event: 'heartbeat',
      message: 'ping'
    }))
  })
}, timeInterval)
```

客户端代码：

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>Document</title>
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
  </head>
  <body>
    <div id="app">
      <!-- 确定用户输入的昵称，当用户输入昵称之后，就是欢迎用户加入聊天室-->
      <div v-if="isShow">
        <label>昵称：</label><input type="text" v-model="name" />
        <label>房间号：</label><input type="text" v-model="roomid" />
        <button type="button" @click="into()">进入聊天室</button>
      </div>
      <div v-else>
        <!-- 显示消息 -->
        <ul>
          <li v-for="item in items">
            {{ item.message }}
          </li>
        </ul>
        <!-- 显示在线人数 -->
        <div>在线人数： {{ num }}</div>
        <!-- 发送消息 -->
        <div class="ctrl">
          <input type="text" v-model="inputValue" />
          <button type="button" @click="submit()">发送</button>
        </div>
      </div>
    </div>

    <script>
      // 客户端的代码
      // 1. 发送消息
      // 客户端 取input数据 -> websocket -> 发送到服务端 -> 转发给其他所有的客户端
      // 2. 显示消息
      var app = new Vue({
        el: "#app",
        data: {
          isShow: true,
          inputValue: "",
          items: [],
          wsHandle: "",
          name: "",
          num: 0,
          roomid: "",
          handler: "",
          reconnect: "",
        },
        // 把元素挂载完成之后，自动执行
        mounted() {
          this.init();
        },
        methods: {
          init() {
            this.wsHandle = new WebSocket("ws://localhost:8000");
            this.wsHandle.onopen = this.onOpen;
            // 服务端发送回来的其他消息
            this.wsHandle.onmessage = this.onMessage;
            this.wsHandle.onerror = this.onError;
          },
          submit: function() {
            // 取inputValue
            // 通过websocket发送数据
            console.log(this.inputValue);
            this.wsHandle.send(
              JSON.stringify({
                name: this.name,
                message: this.inputValue,
                event: "message",
              })
            );
            this.items.push({
              message: this.name + ": " + this.inputValue,
            });
            this.inputValue = "";
          },
          into: function() {
            if (this.name.trim() === "") {
              alert("用户名不得为空");
              return;
            }
            this.wsHandle.send(
              JSON.stringify({
                name: this.name,
                roomid: this.roomid,
                event: "login",
              })
            );
            this.isShow = false;
          },
          onOpen: function() {
            // 连接创建之时
            // 设置定时器 -> 如果超时或者服务端没有响应 ping/pong -> 断开与服务端的连接
            console.log("client is connected");
            this.checkServer();
            // 发送鉴权token，token -> expire
            const data = {
              event: "auth",
              message:
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZm9vYmFyIiwiaWF0IjoxNTcxMTQ2NzUxLCJleHAiOjE1NzEyMzMxNTF9.ABDOP82STmjStgdKjG7HNMaY30W25y1_fQy-opl1XFM111", // localstorage, cookie/session -> koa/express
            };
            // 主动鉴权
            this.wsHandle.send(JSON.stringify(data));
          },
          onMessage: function(evt) {
            var msg = JSON.parse(evt.data);
            if (msg.event === "noauth") {
              // 相当于鉴权失败
              // RESTful 去请求token eg: login() -> token -> store
              console.log(msg.message);
              // login(), 模拟测试请求token，并且取到token，发送消息给websocket server
              const token =
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZm9vYmFyIiwiaWF0IjoxNTcxMTQ2NzUxLCJleHAiOjE1NzEyMzMxNTF9.ABDOP82STmjStgdKjG7HNMaY30W25y1_fQy-opl1XFM";
              // 第二次鉴权
              this.wsHandle.send(
                JSON.stringify({
                  event: "auth",
                  message: token,
                })
              );
              return;
            }
            // 心跳检测的逻辑
            if (msg.event === "heartbeat" && msg.message === "ping") {
              this.checkServer();
              this.wsHandle.send(
                JSON.stringify({
                  event: "heartbeat",
                  message: "pong",
                })
              );
              return;
            }
            if (msg.num) {
              this.num = msg.num;
            }
            if (msg.event === "login") {
              this.items.push({
                message: "欢迎" + msg.name + "加入聊天室！",
              });
            } else if (msg.event === "logout") {
              this.items.push({
                message: msg.name + "已经退出了聊天室！",
              });
            } else {
              if (msg.name !== this.name) {
                // 把数据推送到items中
                this.items.push({
                  message: msg.name + ": " + msg.message,
                });
              }
            }
          },
          onError: function() {
            var _this = this;
            clearTimeout(this.reconnect);
            this.reconnect = setTimeout(function() {
              console.log("reconnect websocket!!");
              _this.init();
            }, 5000);
          },
          onClose: function() {
            // 关闭websocket连接
            this.wsHandle.close();
          },
          checkServer: function() {
            console.log("checkServer in");
            // 计时器去定时检测websocket的连接
            var _this = this;
            clearTimeout(this.handler);
            // 超时之后，即会执行
            this.handler = setTimeout(function() {
              console.log("checkServer fail, close websocket");
              // 主动断开服务器端的连接
              _this.onClose();
              // 再次初始化websocket连接
              _this.init();
            }, 30000 + 1000);
          },
        },
      });
    </script>
  </body>
</html>
```

#### Websocket与Redis结合（集成Redis到Websocket中）

官网：Redis是一个开源的库，主要用来存储数据，可当作一个数据库或高速的缓存，其性能非常好。（分为客户端和服务端）

<img src="README.assets/image-20220903140950678.png" alt="image-20220903140950678" style="zoom:80%;" />

mac电脑：下载的tar.gz是一个压缩文件，里面含Redis服务的二进制的执行文件，运行在mac或linux或类linux系统上。

而在windows操作系统上的Redis，其实还是使用了类似linux系统上的环境来运行Redis，如下图的redis-windows和微软打包的Redis库（已归档，停止维护）：

<img src="README.assets/image-20220903141414470.png" alt="image-20220903141414470" style="zoom: 67%;" />

<img src="README.assets/image-20220903144654720.png" alt="image-20220903144654720" style="zoom: 67%;" />

<img src="README.assets/image-20220903144719256.png" alt="image-20220903144719256" style="zoom: 67%;" />



##### 安装Redis的方法：

###### ①可以在Windows上安装一个Linux的虚拟机，然后在里面安装Redis

###### ②在（自己的）一台Linux的测试服务器上安装Redis（需要自行编译，比较麻烦），如：下图的下载、解压、进入目录、运行redis

![image-20220903154632837](README.assets/image-20220903154632837.png)

![image-20220903155039611](README.assets/image-20220903155039611.png)

###### ③（推荐）使用Docker技术，先安装Docker，然后一句命令直接安装Redis

安装Docker的方式：

- 使用官方的镜像进行安装（需要使用到一些命令？）：

  <img src="README.assets/image-20220903155846876.png" alt="image-20220903155846876" style="zoom:80%;" />

  <img src="README.assets/image-20220903155954206.png" alt="image-20220903155954206" style="zoom:67%;" />

  点击Desktop下的Docker for Mac（macOS），下载之后得到一个dmg的安装文件，拖拽到应用程序之后，就可以启动Docker；

  ![image-20220903160214143](README.assets/image-20220903160214143.png)

  而Docker for Windows（Microsoft Windows 10）有版本的要求，要求是win10的企业版或专业版（64位），不推荐（因为很多命令行的使用方式和权限的管理等等都不一样）。

  如果是Windows操作系统，则推荐在Windows上先安装一个Linux虚拟机，然后再在里面安装Docker。注意：虚拟机（Linux操作系统或Linux服务器）是划分了一整块资源去运行服务，而Docker是管理这一系列服务的资源（共享了虚拟机上的资源）并由Docker来进行调配，比如某个服务需要更多的内存和CPU计算资源则由Docker来进行调配。先安装Linux：一般，很多时候都是使用Linux服务器（如CentOS比较普遍，Ubuntu适于入门）去发布服务的：

  <img src="README.assets/image-20220903162353835.png" alt="image-20220903162353835" style="zoom:80%;" />

  点击CentOS后进入：

  <img src="README.assets/image-20220903164222820.png" alt="image-20220903164222820" style="zoom:80%;" />

  这里说明需要的CentOS版本，并需要删除旧的CentOS的版本

  <img src="README.assets/image-20220903164452225.png" alt="image-20220903164452225" style="zoom:80%;" />

  （安装了CentOS版的Linux服务器之后）开始安装（Docker）：

  <img src="README.assets/image-20220903164901565.png" alt="image-20220903164901565" style="zoom:80%;" />

  <img src="README.assets/image-20220903165036440.png" alt="image-20220903165036440" style="zoom:80%;" />

  <img src="README.assets/image-20220903165152246.png" alt="image-20220903165152246" style="zoom:80%;" />

- 使用docker-install进行安装：（使用Docker安装的两句命令即可安装，然后使用service docker start即可把Docker服务启动）

  <img src="README.assets/image-20220903170919836.png" alt="image-20220903170919836" style="zoom:80%;" />

  <img src="README.assets/image-20220903171351371.png" alt="image-20220903171351371" style="zoom:80%;" />

- （国内用户可以）通过daocloud进行安装：下载站》安装`Docker`（建议选择较新的版本）和`Docker Compose`（docker命令的集合命令）

  ![image-20220903171849224](README.assets/image-20220903171849224.png)

  ![image-20220903172000115](README.assets/image-20220903172000115.png)

  <img src="README.assets/image-20220903172307637-16621969905471.png" alt="image-20220903172307637" style="zoom:80%;" />

  <img src="README.assets/image-20220903172656222.png" alt="image-20220903172656222" style="zoom:80%;" />

  <img src="README.assets/image-20220903172813574.png" alt="image-20220903172813574" style="zoom:80%;" />

  <img src="README.assets/image-20220903172913083.png" alt="image-20220903172913083" style="zoom:80%;" />

  购买了一台Linux服务器（云服务器）并进行远程连接，然后在该Linux上通过这种方式（daocloud）安装了Docker之后，可使用命令终端查看docker和docker-compose的版本：（注意：除了使用daocloud安装docker之外，还可以借助一些虚拟专用网络来下载docker的官方镜像，下载之后还可以使用一些国内的加速源进行加速）

  <img src="README.assets/image-20220903173752384.png" alt="image-20220903173752384" style="zoom:80%;" />

  之后即可通过Redis官方的docker的镜像网址，通过一句命令直接安装Redis：

  Redis网址：

  <img src="README.assets/image-20220903175215574.png" alt="image-20220903175215574" style="zoom:80%;" />

  Redis官方的docker的镜像网址：

  <img src="README.assets/image-20220903155236207.png" alt="image-20220903155236207" style="zoom:80%;" />

  <img src="README.assets/image-20220903174757689.png" alt="image-20220903174757689" style="zoom:80%;" />

  （下图是在云服务器）开始安装Redis：

  下图中：

  -p参数用于把端口映射出来，把Redis服务的端口映射到宿主机（运行docker服务的机器）之外。如果docker运行在虚拟机里，则宿主机为该虚拟机，另外可通过桥接网络让本机连接上虚拟机（即本机可通过桥接网络访问到虚拟机对应的端口），只需要把docker的服务映射到虚拟机的某个端口上面，则本机即可访问到虚拟机上的这个端口上的Redis服务了。

  11050是对应的虚拟机上面的端口号。

  6379是Redis服务的端口号（默认是6379）。

  -d是指在后台持续运行。

  回车之后的第一行Unable...是指没有找到这个镜像，这时候，就会去拉取Redis的镜像并运行起来，如果在最后一行出现了一串哈希值则说明Redis服务已经正常地创建并使用了。

  <img src="README.assets/image-20220903180600206.png" alt="image-20220903180600206" style="zoom:80%;" />

  安装完成之后：

  可使用`docker ps`或`docker ps |grep redis`命令来查看端口指向（11050指向容器内部的6379端口）

  <img src="README.assets/image-20220903182944177.png" alt="image-20220903182944177" style="zoom:80%;" />

  <img src="README.assets/image-20220903183125306.png" alt="image-20220903183125306" style="zoom:80%;" />

  可使用`curl cip.cc`来查看公网上的远程服务器的ip：

  注意：如果使用的是虚拟机，则使用`ipconfig`或`ip addr`来查内网ip（局域网ip），通常是172或10开头，则宿主机就应该通过该内网ip来访问虚拟机了。

  <img src="README.assets/image-20220903183838328.png" alt="image-20220903183838328" style="zoom:80%;" />

  <img src="README.assets/image-20220903192410860.png" alt="image-20220903192410860" style="zoom:80%;" />

  <img src="README.assets/image-20220903192553997.png" alt="image-20220903192553997" style="zoom:80%;" />

  访问（连接）到Redis服务的方式：

  ①（在宿主机）使用（docker结合）Redis的cli：-it是指启动一个交互终端，some-redis是指容器的名称。之后即可使用set命令设置键值对和使用get命令获取键值对。

  <img src="README.assets/image-20220903191219410.png" alt="image-20220903191219410" style="zoom:80%;" />

  <img src="README.assets/image-20220903191549187.png" alt="image-20220903191549187" style="zoom:80%;" />

  <img src="README.assets/image-20220903191630985.png" alt="image-20220903191630985" style="zoom:80%;" />

  ②通过`Another Redis DeskTop Manager`来连接到Redis服务之后，即可查看分析的数据和键值对，并可通过图形化的界面来操作Redis server。

  <img src="README.assets/image-20220903193924569.png" alt="image-20220903193924569" style="zoom:80%;" />

  <img src="README.assets/image-20220903193959755.png" alt="image-20220903193959755" style="zoom:80%;" />

  <img src="README.assets/image-20220903194207106.png" alt="image-20220903194207106" style="zoom:80%;" />

  <img src="README.assets/image-20220903194254599.png" alt="image-20220903194254599" style="zoom:80%;" />

  <img src="README.assets/image-20220903194316015-16622053973763.png" alt="image-20220903194316015" style="zoom:80%;" />

##### Redis命令：

①Redis命令参考：

通过下面的文档（命令行）可以了解到Redis server的功能和Redis Clients操作的命令，可以快速上手node_redis这样的clients客户端。

<img src="README.assets/image-20220903211640489.png" alt="image-20220903211640489" style="zoom:80%;" />

<img src="README.assets/image-20220903211720863.png" alt="image-20220903211720863" style="zoom:80%;" />

<img src="README.assets/image-20220903225949714.png" alt="image-20220903225949714" style="zoom:80%;" />

②具体演示：

<img src="README.assets/image-20220903213953805.png" alt="image-20220903213953805" style="zoom:80%;" />

使用宿主机（这里是Linux云服务器的命令终端）：

<img src="README.assets/image-20220903220006623.png" alt="image-20220903220006623" style="zoom:80%;" />

<img src="README.assets/image-20220903214902342.png" alt="image-20220903214902342" style="zoom:80%;" />

使用`Another Redis DeskTop Manager`图像化工具

<img src="README.assets/image-20220903215034176.png" alt="image-20220903215034176" style="zoom:80%;" />

<img src="README.assets/image-20220903215137371.png" alt="image-20220903215137371" style="zoom:80%;" />

<img src="README.assets/image-20220903215444209.png" alt="image-20220903215444209" style="zoom:80%;" />

<img src="README.assets/image-20220903215501861.png" alt="image-20220903215501861" style="zoom:80%;" />

③其它命令的具体内容：

<img src="README.assets/image-20220903215804390.png" alt="image-20220903215804390" style="zoom:80%;" />

<img src="README.assets/image-20220903215830389.png" alt="image-20220903215830389" style="zoom:80%;" />

<img src="README.assets/image-20220903223245132.png" alt="image-20220903223245132" style="zoom:80%;" />

<img src="README.assets/image-20220903223336739.png" alt="image-20220903223336739" style="zoom:80%;" />

下图中的`1`代表设置成功，否则`0`代表设置失败。（在后面使用node_redis来操作Redis server的时候，可以使用`redis.print`来打印默认的Redis server返回的数据到console里，可以方便调试整个应用）

<img src="README.assets/image-20220903222856543.png" alt="image-20220903222856543" style="zoom:80%;" />

<img src="README.assets/image-20220903223446999.png" alt="image-20220903223446999" style="zoom:80%;" />

下图中的奇数行代表field，偶数行代表value。

<img src="README.assets/image-20220903223529988.png" alt="image-20220903223529988" style="zoom:80%;" />

可使用图形化的GUI工具来更方便地查看。下图中的TTL代表过期时间（超期时间，EX seconds）

<img src="README.assets/image-20220903223603973.png" alt="image-20220903223603973" style="zoom:80%;" />

可以设置一个键值对，该键值对有10秒时间，设置之后，则在图形化的GUI工具上的这个键值对只有10秒的存在时间。

<img src="README.assets/image-20220903225553651.png" alt="image-20220903225553651" style="zoom:80%;" />

##### 在（安装）配置好Redis服务之后，可以借助Redis Clients来对Redis server进行操作：

Redis Clients有多种语言的实现：

<img src="README.assets/image-20220903140222989.png" alt="image-20220903140222989" style="zoom:80%;" />

选择Node.js之后，有多种库：

<img src="README.assets/image-20220903210328852.png" alt="image-20220903210328852" style="zoom:80%;" />

这里介绍的Redis的客户端是node_redis这个库：（把node_redis这个Redis Clients集成到Node.js的应用中）

<img src="README.assets/image-20220903140332611.png" alt="image-20220903140332611" style="zoom:80%;" />

先安装redis（npm包）：

```bash
npm install -D redis
```

<img src="README.assets/image-20220903140723081.png" alt="image-20220903140723081" style="zoom:80%;" />

<img src="README.assets/image-20220903232737025.png" alt="image-20220903232737025" style="zoom:80%;" />

除了使用cb方法，还可使用promise或async/await的形式来获取（get）数据：（本案例中使用的是bluebird）

<img src="README.assets/image-20220904033754948.png" alt="image-20220904033754948" style="zoom:80%;" />

<img src="README.assets/image-20220904034038135.png" alt="image-20220904034038135" style="zoom:80%;" />

下面是`redis.createClient()`方法：

<img src="README.assets/image-20220903234507539.png" alt="image-20220903234507539" style="zoom:80%;" />

在`redis.createClient()`时可传入一个对象，对象里的选项如下：

<img src="README.assets/image-20220903233320072.png" alt="image-20220903233320072" style="zoom:80%;" />

<img src="README.assets/image-20220903233410470.png" alt="image-20220903233410470" style="zoom:80%;" />

<img src="README.assets/image-20220903233458249.png" alt="image-20220903233458249" style="zoom:80%;" />

client的（事件）方法

<img src="README.assets/image-20220904015134846.png" alt="image-20220904015134846" style="zoom:80%;" />

对操作Redis server的方法进行封装（封装到RedisConfig.js里）：

```js
const redis = require("redis")
const { promisifyAll } = require("bluebird")

const { redisOptions } = require("../config/index")

const redisClient = redis.createClient(redisOptions)
promisifyAll(redisClient)

// 对连接信息的监听
redisClient.on("connect", function() {
  console.log("redis client is connected to server!")
})

// 对错误日志的打印
redisClient.on("error", function(err) {
  console.log("redis client is error: " + err)
})

/**
 * setValue方法
 * @param {String} key 对象的属性
 * @param {String} value 对象的值 JSON.stringfy -> Object
 * @param {*} time 过期时间
 */
const setValue = function(key, value, time) {
  if (time) {
    redisClient.set(key, value, "EX", time, redis.print)
  } else {
    redisClient.set(key, value, redis.print)
  }
}

/**
 * getValue方法
 * @param {String} key
 * 返回是一个String，需要对对象形式的内容，使用JSON.parse
 */
const getValue = async function(key) {
  const result = await redisClient.getAsync(key)
  return result
}

/**
 * 增加记数
 * @param {String}} key
 */
const increase = async function(key) {
  const result = await redisClient.incrAsync(key)
  return result
}

const decrease = async function(key) {
  const result = await redisClient.decrAsync(key)
  return result
}

/**
 * 返回所有相关reg的keys
 * @param {String} reg 定义一个查询的正则表达式
 */
const getKeys = async function(reg) {
  const result = await redisClient.keysAsync(reg + "*")
  return result
}

const existKey = async function(key) {
  const result = await redisClient.existsAsync(key)
  return result
}

const deleteKey = async function(key) {
  const result = await redisClient.delAsync(key)
  return result
}

module.exports = {
  setValue,
  getValue,
  increase,
  decrease,
  getKeys,
  existKey,
  deleteKey,
}
```

#### 改进案例：离线消息和缓存发送

之前使用的方案是通过group把（人数）内容都放到内存里，现在使用Redis进行改造：

客户端： ①设置uid，确定ws唯一的标识；②断线重连后，发送roomid与uid。

```js
const urlParams = new URLSearchParams(window.location.search)
  const uid = urlParams.get("uid")
  if (this.name.trim() === "") {
  alert("用户名不得为空")
  return
}
this.wsHandle.send(
  JSON.stringify({
    name: this.name,
    roomid: this.roomid,
    uid: uid,
    event: "login",
  })
)
this.isShow = false
```

服务端：①使用redis进行消息的缓存；②对客户端的连接进行唯一性标识（uid，相当于账号）；③对于断开连接的客户端，离线消息进行保存；④再次连接过来的客户端，发送离线消息。

```js
wss.on("connection", function(ws, req) {
  // 初始化客户端的连接状态量
  ws.isAlive = true
  // console.log('a new client is connected!');
  ws.on("message", async function(msg) {
    var msgObj = JSON.parse(msg)
    if (msgObj.event === "heartbeat" && msgObj.message === "pong") {
      ws.isAlive = true
      return
    }
    if (msgObj.name) {
      ws.name = msgObj.name
    }
    if (msgObj.uid) {
      ws.uid = msgObj.uid
    }
    if (typeof ws.roomid === "undefined" && msgObj.roomid) {
      // 还需要一个客户端的标识，可以知道ws给谁去发送消息
      ws.roomid = msgObj.roomid
      const result = await existKey(prefix + msgObj.roomid)
      if (result === 0) {
        // 初始化数据
        setValue(prefix + msgObj.roomid, ws.uid)
      } else {
        let arrStr = await getValue(prefix + msgObj.roomid)
        // String -> Json
        let arr = arrStr.split(",")
        if (arr.indexOf(ws.uid) === -1) {
          arrStr += "," + ws.uid
          setValue(prefix + msgObj.roomid, arrStr)
        }
      }
    }
    // 广播到其他的客户端
    let arrStr1 = await getValue(prefix + ws.roomid)
    let arr1 = arrStr1.split(",")
    // 在线人数，计算uid的个数
    msgObj.total = arr1.length
    msgObj.num = wss.clients.size
    wss.clients.forEach(async function each(client) {
      if (client.readyState === WebSocket.OPEN && client.roomid === ws.roomid) {
        client.send(JSON.stringify(msgObj))
        // 删除已经发送了消息的对应的对象
        if (arr1.indexOf(client.uid) !== -1) {
          arr1.splice(arr1.indexOf(client.uid), 1)
        }
        let result = await existKey(ws.uid)
        if (result !== 0) {
          let tmpArr = await getValue(ws.uid)
          let tmpObj = JSON.parse(tmpArr)
          let uid = ws.uid
          if (tmpObj.length > 0) {
            let i = []
            // 遍历数组，判断是否是同一个roomid，否则的话，就保存数据
            tmpObj.forEach(function(item) {
              if (item.roomid === client.roomid && uid === client.uid) {
                // 如果是同一个roomid，就发送对应的消息数据。
                client.send(JSON.stringify(item.msg))
                i.push(item)
              }
            })
            if (i.length > 0) {
              i.forEach(function(item) {
                tmpObj.splice(item, 1)
              })
            }
            setValue(ws.uid, JSON.stringify(tmpObj))
          }
        }
      }
      // 判断，是否有客户端没有连接。
      // 对于没有连接的客户端的数据，进行分发缓存处理
    })

    // 说明有一些客户端断开了与roomid的连接，并且，其他客户端发送了对应的消息
    if (arr1.length > 0 && msgObj.event === "message") {
      arr1.forEach(async function(item) {
        const result = await existKey(item)
        if (result !== 0) {
          let udata = await getValue(item)
          let uObj = JSON.parse(udata)
          uObj.push({
            roomid: ws.roomid,
            msg: msgObj,
          })
          setValue(item, JSON.stringify(uObj))
        } else {
          // 说明先前，这个数据没有进行缓存 ，没有记录
          setValue(
            item,
            JSON.stringify([
              {
                roomid: ws.roomid,
                msg: msgObj,
              },
            ])
          )
        }
      })
    }
  })
```

### Websocket SSL配置

#### 配置HTTPS/WSS

```js
const fs = require('fs');
const https = require('https');
const WebSocket = require('ws');
const server = https.createServer({
  cert: fs.readFileSync('/path/to/cert.pem'),
  key: fs.readFileSync('/path/to/key.pem')
});
const wss = new WebSocket.Server({ server });
wss.on('connection', function connection(ws) {
  ws.on('message', function incoming(message) {
    console.log('received: %s', message);
  });
  ws.send('something');
});
server.listen(8080);
```

### 其他学习资料（参考资料）

[WebSocket + Node.js + Express — Step by step tutorial using Typescript](https://medium.com/factory-mind/websocket-node-js-express-step-by-step-using-typescript-725114ad5fe4)

