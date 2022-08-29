### Vue虚拟DOM（Virtual DOM的实现原理）

快捷键：光标移动到某个变量处，按`F12`快速定位到该变量的定义位置；选中某个变量或方法名，按`F12`显示出该变量或方法的具体代码；`ALT` + 左方向键，回到上次的代码位置；`Ctrl` + 单击，跳转到某个变量的定义处；

浏览器调试工具，在sources里，打断点进行调试，按F11进入方法的源码里查看，F10进入断电下一步进行查看。

虚拟DOM、Virtual DOM、节点、真实DOM

#### 1、Virtual DOM的介绍

Virtual DOM(虚拟DOM)：是由普通的JS对象来描述的DOM对象，不是真实的DOM对象。
为什么使用虚拟DOM(来模拟真实的DOM):
①一个DOM对象中的成员非常多，故创建一个（真实的）DOM对象的成本是非常高的
②手动操作DOM比较麻烦，还需要考虑浏览器兼容性问题，虽然有jQuery等库能简化DOM操作，但是随着项目的复杂度越来越高，DOM操作的复杂度也会提升，既要考虑Dom操作，还要考虑数据的操作。
③为了简化视图的操作可以使用模板引擎，但是模板引擎没有解决跟踪状态变化的问题（数据变化后无法获取上一次的状态，只有将页面上的元素删除，然后再重建，这时页面就会有刷新的问题，频繁操作DOM也会让性能非常低），于是VirtualDOM 出现了。
④为了简化DOM的复杂操作于是出现了各种MVVM框架，MVVM框架解决了视图和状态的同步问题，数据变视图变，视图变数据变。
⑤Virtual DOM的好处是当状态改变时不需要立即更新DOM，只需要创建一个虚拟树来描述DOM，Virtual DOM内部会知道如何有效地（diff）更新DOM。

虚拟DOM的思想是，先控制数据，再到视图（数据对应视图），但是数据的状态是通过diff进行比对，diff会比对新旧的虚拟DOM节点，然后找出其中的不同，最后只需要把不同的节点发生渲染操作即可。
总结：虚拟DOM可以维护程序的状态，跟踪上一次的状态，并通过比较前后两次状态的差异来更新真实的 DOM。

虚拟DOM的作用：
①维护视图和状态的关系（虚拟DOM会记录状态的变化，只需要更新状态变化的内容即可）；
②复杂视图情况下提升渲染性能（并不是所有的情况下使用虚拟DOM都会提升性能的，只有在视图比较复杂的情况下，使用虚拟DOM才会提升渲染的性能）；
③虚拟DOM除了渲染DOM以外，还可以实现渲染到其它的平台，如可以实现服务端渲染（ssr）（Nuxt.js/Next.js)、原生应用（Weex/React Native)、小程序（mpvue/uni-app)等，这些内部都使用了虚拟DOM。
Vue中虚拟DOM生成真实DOM的过程：

<img src="E:\迅雷下载\sec\java全能学习面试手册\08-阶段八 面试指导+前端面试题\02.第三章 Vue面试题精讲\02-Vue核心知识点讲义\4 Vue虚拟DOM\屏幕截图 2022-07-23 190613.png" style="zoom:67%;" />

#### 2、Snabbdom的基本使用

Snabbdom：一个开源的虚拟DOM库，源码约 200行  (SLOC，single line of code)，可通过模块来进行扩展，且源码使用 TypeScript 开发，是最快的 Virtual DOM 之一，也是最早的虚拟DOM开源库。Vue 2.x 内部使用的 Virtual DOM就是改造后的Snabdom。

①创建项目，并安装`parcel`：
创建项目目录： md snabbdom-demo；  进入项目目录： cd snabbdom-demo；
创建package.json： npm init -y；  本地安装parcel： npm install parcel-bundler；

②配置 package.json 的 scripts（新增如下键值对）：

```json
"scripts": {
  "dev": "parcel index.html --open", //--open为打开浏览器
  "build": "parcel build index.html"
}
```

③创建目录结构：

![image-20220723202328695](E:\迅雷下载\sec\java全能学习面试手册\08-阶段八 面试指导+前端面试题\02.第三章 Vue面试题精讲\02-Vue核心知识点讲义\4 Vue虚拟DOM\image-20220723202328695.png)

④安装并导入Snabbdom：
安装：yarn add sanbbdom；若新版本有问题，可安装0.7.4版的 npm install snabbdom@0.7.4
导入：import {h,thunk,init} from 'snabbdom'；h函数的作用是生成一个虚拟dom；thunk()是一种优化策略，主要优化复杂视图；init() 是一个高阶函数，返回一个patch()；

⑤使用示例（index.html和basicuse.js代码如下）：

```html
<body>
	<div id="app"></div>
</body>
<script src="./src/01-basicuse.js"></script>
```

```js
import { h, init } from 'snabbdom'
let patch = init([]) //init接收一个数组作为参数(可为空数组)，主要是指定使用的模块列表，并返回一个使用指定模块集的patch函数
//第一个参数为标签加选择器，第二个参数若是 字符串或数字 或数组 或VNode 的形式则表示标签中的内容，返回值为vnode(一个虚拟dom)
let vnode = h('div#container.cls','hello world')
//let vnode = h('div#container.cls',[
//    h('h1','hello world'),
//    h('p','这是一个p标签')
//])
let appDom = document.querySelector('#app')  // 这个appDom为一个真实dom
// patch()函数，用于进行内容比较与替换，第一个参数可以是真实dom元素(会自动将dom转换成vnode),第二个参数是vnode
let oldVnode = patch(appDom,vnode)  // 此函数的作用主要是对比两个vnode的差异更新到真实DOM，返回值为vnode

//若在某时要重新获取服务端的数据，并将获取到的数据重新渲染到该container中，则要重新创建一个VNode, 然后传递给patch再进行比对
vnode = h("div", "Hello Vue");
let a = patch(oldVnode, vnode);
//若要清空节点内容：patch(a,null) //官网给出的错误清空方法
patch(a,h('!')) //正确清空节点的方法，h('!') 为创建一个注释节点替换之前节点内容
```

⑥模块的使用：snabbdom的核心库不能处理元素的属性、样式、事件等，需要使用模块来处理，官方提供的模块有6个：
attributes：用于设置dom元素的属性，内部使用的是setAttribute()，会对布尔类型的属性进行判断，如checked、selected等；
props：用于设置dom的属性，是以element[attr] = value的形式设置的，不会处理布尔类型的属性；
class：用于切换（设置）类样式；dataset：用于设置以data-*开头的自定义属性；
eventlisteners：用于注册和移除事件；                                       style：用于设置行内样式、支持动画。
使用步骤：导入需要的模块；在init()中注册模块；使用h()函数创建vnode时，可把第二个参数设置为对象，其他参数后移。

```js
import { h, init } from 'snabbdom'
import style from 'snabbdom/modules/style'  // 1、导入模块
import eventlisteners from 'snabbdom/modules/eventlisteners'
var patch = init([style,eventlisteners])  // 2、注册模块
let vnode = h('div',{  // 3、使用h()函数的第二个参数，存放样式、事件等dom元素（节点）的数据，其他参数后移
    style:{
        backgroundColor:'red' // 如果是两个单词则采用驼峰写法
    },
    on:{
        click:addCount // 所有事件都写在on里
    }
},[  // 包含2个孩子节点，一个是p标签，一个是h1标签
    h('h1','h1的内容，增加了背景色和click事件'),
    h('p','这是一个p标签')
])
function addCount(){
    alert('方法增加~')
}
let app = document.querySelector('#app')
let oldvNode = patch(app,vnode)
```

#### 3、Snabbdom源码解读

<img src="E:\迅雷下载\sec\java全能学习面试手册\08-阶段八 面试指导+前端面试题\02.第三章 Vue面试题精讲\02-Vue核心知识点讲义\4 Vue虚拟DOM\image-20220724115351863.png" alt="image-20220724115351863" style="zoom:67%;" />

函数重载：参数个数或类型不同的（在多处定义的同一个名称的）函数，称之为函数重载。（在`JavaScript`中没有重载的概念，在`TypeScript`中是有重载的）

##### ①h函数（h.ts）:

render函数的参数就是`Snabbdom`中的`h`函数（用来创建`VNode`），但在`Vue`中，`h`函数做了一定的修改，可以用来支持组件（原有的`Snabbdom`中的`h`函数不支持组件的内容）。

```typescript
export function h(sel: string): VNode;   // （包括以下多行的）h函数的重载的具体实现
export function h(sel: string, data: VNodeData): VNode;
export function h(sel: string, children: VNodeChildren): VNode;
export function h(sel: string, data: VNodeData, children: VNodeChildren): VNode;
export function h(sel: any, b?: any, c?: any): VNode {  //h函数可以接收三个参数，?表示该参数可以不传递
  var data: VNodeData = {}, children: any, text: any, i: number;    //定义变量
  if (c !== undefined) {    // 处理参数，实现重载的机制。如果c这个参数的值不等于undefined,表示传递了三个参数
    data = b;  //参数b中存储的就是模块处理的时候需要的数据，如样式、事件等dom元素（节点）的数据
    if (is.array(c)) { children = c; } //判断参数c的三种情况：1:数组(赋值给children这个变量,表明c里面有子元素)；
    else if (is.primitive(c)) { text = c; } //2:字符串或数字(赋值给text变量,表明是标签中的文本内容)；
    else if (c && c.sel) { children = [c]; } //3:VNode(若有sel属性，表明c是vnode,要转成数组形式再赋值给children)
  } else if (b !== undefined) { //如果该条件成立，表明处理的是两个参数的情况
    if (is.array(b)) { children = b; }
    else if (is.primitive(b)) { text = b; }
    else if (b && b.sel) { children = [b]; }
    else { data = b; } //若执行此步，表明b是一个 dom元素（节点）的数据，并赋值给data（这个变量）
  }
  if (children !== undefined) {  //判断children是否有值（数组）
    for (i = 0; i < children.length; ++i) {  //对chilren进行遍历
      if (is.primitive(children[i])) children[i] = vnode(undefined, undefined, undefined, children[i], undefined);   //判断从chilren中取出来的某项是否为string/number,若是则创建文本的虚拟节点
    }
  }
  if (
    sel[0] === 's' && sel[1] === 'v' && sel[2] === 'g' &&
    (sel.length === 3 || sel[3] === '.' || sel[3] === '#')
  ) {  //addNs方法里，就是给data添加了命名空间，然后通过递归的方式给chilren中的所有子元素都添加了命名空间
    addNS(data, children, sel);   //若是svg，添加命名空间
  }
  return vnode(sel, data, children, text, undefined); //h函数的核心是调用vnode方法返回一个虚拟节点,返回整个VNode
};
export default h; // 导出h函数
```

```typescript
function addNS(data: any, children: VNodes | undefined, sel: string | undefined): void { //addNs方法的实现
  data.ns = 'http://www.w3.org/2000/svg';
  if (sel !== 'foreignObject' && children !== undefined) {
    for (let i = 0; i < children.length; ++i) {
      let childData = children[i].data;
      if (childData !== undefined) {
        addNS(childData, (children[i] as VNode).children as VNodes, children[i].sel);
      }
    }
  }
}
```

##### ②VNode函数（vnode.ts）:

```typescript
import {Hooks} from './hooks';
import {AttachData} from './helpers/attachto'
import {VNodeStyle} from './modules/style'
import {On} from './modules/eventlisteners'
import {Attrs} from './modules/attributes'
import {Classes} from './modules/class'
import {Props} from './modules/props'
import {Dataset} from './modules/dataset'
import {Hero} from './modules/hero'
export type Key = string | number;
export interface VNode { //该接口VNode中定义了很多的属性，而最终vnode函数返回的VNode对象，都要实现该接口中的这些属性
  sel: string | undefined;   //选择器或选择器组合，即调用h函数时的第一个参数
  data: VNodeData | undefined;    // 节点数据：样式、事件等dom元素（节点）的数据
  children: Array<VNode | string> | undefined; //子节点,和text互斥
  text: string | undefined; // 节点中的内容,和children互斥
  elm: Node | undefined; // 记录vnode对应的真实DOM，将Vnode转换成真实DOM以后(反之也是)，会存储到该elm属性中
  key: Key | undefined;  //用于优化，带key的情况可以减少DOM的操作，如果子项比较多，更能体现出带key的优势
}
export interface VNodeData {
  props?: Props;
  attrs?: Attrs;
  class?: Classes;
  style?: VNodeStyle;
  dataset?: Dataset;
  on?: On;
  hero?: Hero;
  attachData?: AttachData;
  hook?: Hooks;
  key?: Key;
  ns?: string; // for SVGs
  fn?: () => VNode; // for thunks
  args?: Array<any>; // for thunks
  [key: string]: any; // for any other 3rd party module
}
export function vnode(sel: string | undefined,
                      data: any | undefined,
                      children: Array<VNode | string> | undefined,
                      text: string | undefined,
                      elm: Element | Text | undefined): VNode {
  let key = data === undefined ? undefined : data.key;
  return {sel, data, children, text, elm, key}; //vnode函数返回一个js对象(虚拟节点),包含了VNode这个接口中的属性
}
export default vnode;
```

##### ③h函数与Vnode函数的应用

```js
var vnode = h('div#app',   // 构造一个虚拟dom
  {style: {color: '#000'}},
  [  //注意：先执行的是内部的调用（内部h函数），然后再依次往外执行调用
    h('span', {style: {fontWeight: 'bold'}}, "my name is zhangsan"),
    ' and xxxx',
    h('a', {props: {href: '/foo'}}, '我是张三')
  ]
);
//此虚拟dom返回的值为如下：
vnode = {
  sel: 'div#app',
  data: {style: {color: '#000'}},
  children: [
    { 
      sel: 'span', 
      data: {style: {fontWeight: 'bold'}},
      children: undefined,
      text: "my name is zhangsan",
      elm: undefined,
      key: undefined
    },
    {
      sel: undefined,
      data: undefined,
      children: undefined,
      text: ' and xxxx',
      elm: undefined,
      key: undefined
    },
    {
      sel: 'a',
      data: {props: {href: '/foo'}},
      children: undefined,
      text: "我是张三",
      elm: undefined,
      key: undefined
    }
  ],
  text: undefined,
  elm: undefined,
  key: undefined
}
```

#### 4、真实DOM的渲染

关键之处是patch(oldVnode, newVnode)：把新节点中变化的内容渲染到真实的DOM，最后返回新节点作为下一次patch处理的旧节点。
patch整体执行过程：
①首先执行模块中的钩子函数pre；
②判断oldVnode是否为DOM元素，若是把oldVnode转成虚拟DOM（节点）
③对比新旧VNode是否是相同节点（实质是对比节点里的key和sel）：
1.如果是相同节点：调用patchVnode()，找出节点的差异并更新DOM。首先判断新的VNode是否有text，如果有并且和oldVNode的text不同，直接更新文本内容；然后如果新的VNode有children，判断子节点是否有变化，判断子节点的过程使用的就是diff算法，diff过程只进行同层级的比较；
2.如果不是相同节点：调用createElm()把vnode转换成真实DOM，并记录到vnode.elm，然后把刚创建的DOM元素插入到parent中，再移除老节点，

##### init函数(snabbdom.ts)

init(modules, domApi)返回patch()函数（高阶函数）。为什么使用高阶函数：因为patch()函数在外部会调用多次，每次调用都会依赖一些参数，如modules/domApi/cbs，而通过高阶函数让init()内部形成闭包，返回的patch()可以访问到modules/domApi/cbs，这样就不需要重新创建这些依赖项。

<img src="E:\迅雷下载\sec\java全能学习面试手册\08-阶段八 面试指导+前端面试题\02.第三章 Vue面试题精讲\02-Vue核心知识点讲义\4 Vue虚拟DOM\image-20220726235417978.png" alt="image-20220726235417978" style="zoom:67%;" />

<img src="E:\迅雷下载\sec\java全能学习面试手册\08-阶段八 面试指导+前端面试题\02.第三章 Vue面试题精讲\02-Vue核心知识点讲义\4 Vue虚拟DOM\image-20220726235641063.png" alt="image-20220726235641063" style="zoom:67%;" />

```typescript
const hooks: (keyof Module)[] = ['create', 'update', 'remove', 'destroy', 'pre', 'post'];
export {h} from './h';
export {thunk} from './thunk';
export function init(modules: Array<Partial<Module>>, domApi?: DOMAPI) { // 第二个参数domApi可不传
  let i: number, j: number, cbs = ({} as ModuleHooks);
  const api: DOMAPI = domApi !== undefined ? domApi : htmlDomApi;  // 初始化 api
  for (i = 0; i < hooks.length; ++i) { //init()在返回patch()之前,收集了所有模块中的钩子函数(方法)存储到cbs对象中
    cbs[hooks[i]] = []; //例如cbs['create'] = [];最终构建的形式为cbs = [ create: [fn1, fn2], update: [], ...]
    for (j = 0; j < modules.length; ++j) {
      const hook = modules[j][hooks[i]];   // 例如const hook = modules[0]['create']
      if (hook !== undefined) {
        (cbs[hooks[i]] as Array<any>).push(hook);
      } 
    }
  }
  function emptyNodeAt(elm: Element) {
      const id = elm.id ? '#' + elm.id : '';
      const c = elm.className ? '.' + elm.className.split(' ').join('.') : '';
      return vnode(api.tagName(elm).toLowerCase() + id + c, {}, [], undefined, elm);
  }
  function createRmCb(childElm: Node, listeners: number) {
      return function rmCb() {
          if (-- listeners === 0) {
              const parent = api.parentNode(childElm);
              api.removeChild(parent, childElm);
          }
      }
  }
......createElm
......addVnodes
......invokeDestroyHook
......removeVnodes
......updateChildren
......patchVnode
  return function patch(oldVnode: VNode | Element, vnode: VNode): VNode { 
      let i: number, elm: Node, parent: Node;
      const insertedVnodeQueue: VNodeQueue = []; // 保存新插入的节点的队列，作用是触发钩子函数
      for (i = 0; i < cbs.pre.length; ++i) cbs.pre[i](); // 执行模块的 pre 钩子函数
      if (!isVnode(oldVnode)) {  // 如果oldVnode不是VNode，则将其创建为VNode并设置elm
        oldVnode = emptyNodeAt(oldVnode);  // 把DOM元素转换成空的VNode
      }
      if (sameVnode(oldVnode, vnode)) {  // 如果新旧节点是相同节点(key和sel都相同) 
        patchVnode(oldVnode, vnode, insertedVnodeQueue);  // 找节点的差异并更新DOM
      } else {  // 新旧节点不同
        elm = oldVnode.elm as Node;  // 获取当前的DOM元素
        parent = api.parentNode(elm);
        createElm(vnode, insertedVnodeQueue); // 创建DOM
        if (parent !== null) {  // 如果父节点不为空，则把vnode对应的DOM插入到文档中，再移除老节点
          api.insertBefore(parent, vnode.elm as Node, api.nextSibling(elm)); 
          removeVnodes(parent, [oldVnode], 0, 0);
        } 
      }
      for (i = 0; i < insertedVnodeQueue.length; ++i) { // 执行用户设置的insert钩子函数
        (((insertedVnodeQueue[i].data as VNodeData).hook as Hooks).insert as any)(insertedVnodeQueue[i]);
      }
      for (i = 0; i < cbs.post.length; ++i) cbs.post[i](); // 执行模块的post钩子函数
      return vnode;  // 返回vnode
    };
}
```

##### createElm函数(snabbdom.ts)

执行过程：①首先触发用户设置的 init 钩子函数；
②判断sel：1.如果选择器是!，则创建注释节点；
2.如果选择器不为空，则解析选择器，取出标签名，生成dom元素并设置elm，再设置标签的 id 和 class 属性，再执行模块的 create 钩子函数，再判断：如果 vnode 有 children，创建子 vnode 对应的 DOM，追加到 DOM 树（进行递归）；如果 vnode 的 text 值是 string/number，创建文本节点并追击到 DOM 树。再执行用户设置的 create 钩子函数，如果有用户设置的 insert 钩子函数，再把 vnode 添加到队列中；
3.如果选择器为空，则创建文本节点；
③返回vnode.elm；（注意此时还没有渲染到页面）

```typescript
  function createElm(vnode: VNode, insertedVnodeQueue: VNodeQueue): Node {
    let i: any, data = vnode.data;
    if (data !== undefined) {
      if (isDef(i = data.hook) && isDef(i = i.init)) {
        i(vnode);   // 执行用户设置的 init 钩子函数
        data = vnode.data;
      }
    }
    let children = vnode.children, sel = vnode.sel;
    if (sel === '!') {  // 如果选择器是!，则创建注释节点
      if (isUndef(vnode.text)) {
        vnode.text = '';
      }
      vnode.elm = api.createComment(vnode.text as string);
    } else if (sel !== undefined) {  // 如果选择器不为空，则解析选择器(Parse selector) //假设为div#app.cls
      const hashIdx = sel.indexOf('#');
      const dotIdx = sel.indexOf('.', hashIdx);
      const hash = hashIdx > 0 ? hashIdx : sel.length;
      const dot = dotIdx > 0 ? dotIdx : sel.length;
      const tag = hashIdx !== -1 || dotIdx !== -1 ? sel.slice(0, Math.min(hash, dot)) : sel; //取出标签名
      const elm = vnode.elm = isDef(data) && isDef(i = (data as VNodeData).ns) ? api.createElementNS(i, tag) : api.createElement(tag);  // 生成dom元素并设置elm
      if (hash < dot) elm.setAttribute('id', sel.slice(hash + 1, dot));
      if (dotIdx > 0) elm.setAttribute('class', sel.slice(dot + 1).replace(/\./g, ' '));
      for (i = 0; i < cbs.create.length; ++i) cbs.create[i](emptyNode, vnode); // 执行模块的create钩子函数
      if (is.array(children)) {  // 如果vnode中有子节点，创建子vnode对应的DOM元素并追加到DOM树上
        for (i = 0; i < children.length; ++i) {
          const ch = children[i];
          if (ch != null) {
            api.appendChild(elm, createElm(ch as VNode, insertedVnodeQueue)); //递归
          }
        }
      } else if (is.primitive(vnode.text)) { // 如果vnode的text值是string/number，创建文本节点并追加到DOM树
        api.appendChild(elm, api.createTextNode(vnode.text));
      }
      i = (vnode.data as VNodeData).hook; // Reuse variable
      if (isDef(i)) {
        if (i.create) i.create(emptyNode, vnode);  // 执行用户传入的钩子 create
        if (i.insert) insertedVnodeQueue.push(vnode);  // 把vnode添加到队列中，为后续执行insert钩子函数做准备
      }
    } else {
      vnode.elm = api.createTextNode(vnode.text as string); // 如果选择器为空，创建文本节点
    }
    return vnode.elm; // 返回新创建的DOM，注意此时还没有渲染到页面
  }
```

##### removeVnodes函数和addVnodes函数

<img src="E:\迅雷下载\sec\java全能学习面试手册\08-阶段八 面试指导+前端面试题\02.第三章 Vue面试题精讲\02-Vue核心知识点讲义\4 Vue虚拟DOM\image-20220727002442615.png" alt="image-20220727002442615" style="zoom: 80%;" />

<img src="E:\迅雷下载\sec\java全能学习面试手册\08-阶段八 面试指导+前端面试题\02.第三章 Vue面试题精讲\02-Vue核心知识点讲义\4 Vue虚拟DOM\image-20220726220708726.png" alt="image-20220726220708726" style="zoom:67%;" />

##### patchVnode函数

patchVnode(oldVnode, vnode, insertedVnodeQueue)的功能为对比oldVnode和vnode的差异,并把差异渲染到DOM上。执行过程:
①触发用户设置的prepatch钩子函数；
②如果新老节点相同，则返回；
③如果新节点的data属性有定义，则执行模块的update钩子函数，再触发用户设置的update钩子函数；
④如果vnode.text未定义：
1.新老节点都有children且不相等，则调用updateChildren()方法（用diff算法对比子节点，并更新子节点的差异）
2.只有新节点有children属性（oldVnode.children无值），（如果老节点有text属性则还要清空对应DOM元素的textContent，）则调用 addVnodes()方法添加所有的子节点
3.只有老节点有children属性（vnode.children无值），则调用 removeVnodes() 方法移除所有的子节点
4.（只有）老节点有text属性，则清空对应DOM元素的textContent
⑤如果（设置了）vnode.text有值且跟oldVnode.text不等（不等于旧节点的text属性），（如果老节点的children属性还有子节点则还要移除所有的子节点，）则设置对应的DOM元素的textContent为vnode.text；
⑥触发用户设置的postpatch钩子函数。

```typescript
function patchVnode(oldVnode: VNode, vnode: VNode, insertedVnodeQueue:VNodeQueue) {
    let i: any, hook: any;
    if (isDef(i = vnode.data) && isDef(hook = i.hook) && isDef(i = hook.prepatch)) {
        i(oldVnode, vnode);    // 首先触发用户设置的 prepatch 钩子函数
    }
    const elm = vnode.elm = (oldVnode.elm as Node); 
    let oldCh = oldVnode.children; 
    let ch = vnode.children;
    if (oldVnode === vnode) return;  // 如果新老 vnode 相同则返回
    if (vnode.data !== undefined) {
        for (let i = 0; i < cbs.update.length; ++i) cbs.update[i](oldVnode,vnode); //执行模块的update钩子函数
        i = vnode.data.hook;
        if (isDef(i) && isDef(i = i.update)) i(oldVnode, vnode)   // 触发用户设置的update钩子函数 
    }
    if (isUndef(vnode.text)) {  // 如果 vnode.text 未定义
        if (isDef(oldCh) && isDef(ch)) {  // 如果新老节点都有 children
            if (oldCh !== ch) updateChildren(elm, oldCh as Array<VNode>, ch as Array<VNode>, insertedVnodeQueue);   // 使用 diff 算法对比子节点，并更新子节点的差异
        } else if (isDef(ch)) {   // 如果只有新节点有children属性，老节点没有children
            if (isDef(oldVnode.text)) api.setTextContent(elm, ''); // 如果老节点有text，清空对应dom元素的内容
            addVnodes(elm, null, ch as Array<VNode>, 0, (ch as Array<VNode>).length - 1, insertedVnodeQueue);    // 批量添加所有的子节点
        } else if (isDef(oldCh)) {   // 如果只有老节点有children属性，新节点没有children
            removeVnodes(elm, oldCh as Array<VNode>, 0, (oldCh as Array<VNode>).length - 1); //批量移除子节点
        } else if (isDef(oldVnode.text)) {  // 如果老节点有 text，清空对应DOM元素的内容
            api.setTextContent(elm, '');
        }
    } else if (oldVnode.text !== vnode.text) {  // 如果vnode.text有值且跟oldVnode.text不等
        if (isDef(oldCh)) { //如果老节点的children属性还有子节点
            removeVnodes(elm, oldCh as Array<VNode>, 0, (oldCh as Array<VNode>).length - 1); //批量移除子节点
        }
        api.setTextContent(elm, vnode.text as string); //设置对应的DOM元素的textContent为vnode.text
    }
    if (isDef(hook) && isDef(i = hook.postpatch)) { // 最后触发用户设置的 postpatch 钩子函数
        i(oldVnode, vnode);
    }
}
```

##### updateChildren函数


补充知识：要对比两棵树的差异，可以取第一棵树的每一个节点依次和第二课树的每一个节点比较，然后对比每一次的差异，这样的时间复杂度为O(n^3)，显然这样很低效。而且在DOM操作时很少会把一个父节点移动或更新到某一个子节点，因此只需要找同级别（同层级）子节点依次比较，然后依次再找下一级别的节点比较，这样算法的时间复杂度为O(n)。所以diff算法的核心是对比新老的节点数组的节点，进而更新DOM。为了保证各个真实DOM的顺序和新的节点数组中的节点保持一致，可以用while循环对首尾节点进行对比，同时对新老的节点数组的开始和结束节点，并设置标记索引，在循环的过程中，向中间移动索引，这样既能实现排序也能减小时间复杂度。

Diff算法执行过程：①如图，对比同级别节点

<img src="E:\迅雷下载\sec\java全能学习面试手册\08-阶段八 面试指导+前端面试题\02.第三章 Vue面试题精讲\02-Vue核心知识点讲义\4 Vue虚拟DOM\image-20220731140125578.png" alt="image-20220731140125578" style="zoom:50%;" />

②当新的开始节点索引<=新的结束节点索引，且当老的开始节点索引<=老的结束节点索引，则进行while循环：

1.先判断这四个节点是否为空，若为空则移动索引，让空节点重新赋值为对应索引的节点

2.两两节点比较，有四种比较方式(必须按顺序)：

<img src="E:\迅雷下载\sec\java全能学习面试手册\08-阶段八 面试指导+前端面试题\02.第三章 Vue面试题精讲\02-Vue核心知识点讲义\4 Vue虚拟DOM\image-20220731140344349.png" alt="image-20220731140344349" style="zoom:50%;" />

a老的开始节点 与 新的开始节点比较，如果匹配上了(key 和 sel 相同)，则进行patchVnode“递归”，(之后再++oldStartIdx,++newStartIdx移动索引)开始下一次while循环。
b老的结束节点 与 新的结束节点比较，如果匹配上了(key 和 sel 相同)，则进行patchVnode“递归”，(之后再--oldEndIdx,--newEndIdx移动索引)开始下一次while循环。

<img src="E:\迅雷下载\sec\java全能学习面试手册\08-阶段八 面试指导+前端面试题\02.第三章 Vue面试题精讲\02-Vue核心知识点讲义\4 Vue虚拟DOM\image-20220731140440290.png" alt="image-20220731140440290" style="zoom:50%;" />

c老的开始节点 与 新的结束节点比较，如果匹配上了(key 和 sel 相同)，则进行patchVnode“递归”，再把老的开始节点(真实dom)移动到老的结束节点的后面，(之后再++oldStartIdx,--newEndIdx移动索引)开始下一次while循环。

<img src="E:\迅雷下载\sec\java全能学习面试手册\08-阶段八 面试指导+前端面试题\02.第三章 Vue面试题精讲\02-Vue核心知识点讲义\4 Vue虚拟DOM\image-20220731140621330.png" alt="image-20220731140621330" style="zoom:50%;" />

d老的结束节点 与 新的开始节点比较，如果匹配上了(key 和 sel 相同)，则进行patchVnode“递归”，再把老的结束节点(真实dom)移动到老的开始节点的前面，(之后再--oldEndIdx,++newStartIdx移动索引)开始下一次while循环。

<img src="E:\迅雷下载\sec\java全能学习面试手册\08-阶段八 面试指导+前端面试题\02.第三章 Vue面试题精讲\02-Vue核心知识点讲义\4 Vue虚拟DOM\image-20220731140739659.png" alt="image-20220731140739659" style="zoom:50%;" />

3.如果不是以上四种情况，则使用新的开始节点的key，在老的节点数组中找出key相同的那个节点对应的索引：

a如果找不到，即新的开始节点是新的节点，则创建该新节点并插入到老的开始节点的前面，(之后再++newStartIdx移动索引)开始下一次while循环。

b如果找到相同key对应的老的节点，则先将这个老的节点记录到elmToMove中。然后判断新老的节点的选择器是否相同：
如果找到了(key相同)但不是相同节点(对应的选择器sel不同)，即新的开始节点是新的节点(或被修改过)，则创建该新节点并插入到老的开始节点的前面，(之后再++newStartIdx移动索引)开始下一次while循环；
如果找到了(key相同)并且是相同节点(对应的选择器sel也相同)，则进行patchVnode“递归”，然后将老的那个节点赋值为空，再把老的节点(elmToMove)对应的DOM元素移动到老的开始节点的前面，(之后再++newStartIdx移动索引)开始下一次while循环。

<img src="E:\迅雷下载\sec\java全能学习面试手册\08-阶段八 面试指导+前端面试题\02.第三章 Vue面试题精讲\02-Vue核心知识点讲义\4 Vue虚拟DOM\image-20220731141427039.png" alt="image-20220731141427039" style="zoom:50%;" />

③执行到这里时，表示上面的（对比新老的节点的）循环结束，此时要么是只有旧的开始节点索引>旧的结束索引，要么是只有新的开始节点索引>新的结束索引，要么是上述两个“只有”同时成立（这种情况就不会执行下面的逻辑,此时整个updateChildren函数执行完成）：
如果是oldStartIdx > oldEndIdx，说明老的节点数组的所有子节点先遍历完，新节点有剩余，则把newStartIdx到newEndIdx之间的剩余的新的节点批量添加到新的结束节点的后面（后面该新的节点数组会自动创建成真实DOM并插入到DOM树中）。
如果是newStartIdx > newEndIdx，说明新的节点数组的所有子节点先遍历完，老节点有剩余，则把oldStartIdx到oldEndIdx之间的剩余的老的节点批量删除。

```typescript
function updateChildren(parentElm: Node, oldCh: VNode[], newCh: VNode[], insertedVnodeQueue: VNodeQueue) {
    let oldStartIdx = 0, newStartIdx = 0;
    let oldEndIdx = oldCh.length - 1;
    let oldStartVnode = oldCh[0];
    let oldEndVnode = oldCh[oldEndIdx];
    let newEndIdx = newCh.length - 1;
    let newStartVnode = newCh[0];
    let newEndVnode = newCh[newEndIdx];
    let oldKeyToIdx: any;
    let idxInOld: number;
    let elmToMove: VNode;
    let before: any;
    while (oldStartIdx <= oldEndIdx && newStartIdx <= newEndIdx) { 
      if (oldStartVnode == null) {  // 索引变化后，可能会把节点设置为空
        oldStartVnode = oldCh[++oldStartIdx]; //Vnode might have been moved left // 节点为空移动索引
      } else if (oldEndVnode == null) {
        oldEndVnode = oldCh[--oldEndIdx];
      } else if (newStartVnode == null) {
        newStartVnode = newCh[++newStartIdx];
      } else if (newEndVnode == null) {
        newEndVnode = newCh[--newEndIdx];  // 以下为比较新老的开始和结束节点的四种情况
      } else if (sameVnode(oldStartVnode, newStartVnode)) {  //1.比较老的开始节点和新的开始节点
        patchVnode(oldStartVnode, newStartVnode, insertedVnodeQueue); 
        oldStartVnode = oldCh[++oldStartIdx];
        newStartVnode = newCh[++newStartIdx];
      } else if (sameVnode(oldEndVnode, newEndVnode)) { //2.比较老的结束节点和新的结束节点
        patchVnode(oldEndVnode, newEndVnode, insertedVnodeQueue); 
        oldEndVnode = oldCh[--oldEndIdx];
        newEndVnode = newCh[--newEndIdx];
      } else if (sameVnode(oldStartVnode, newEndVnode)) { //Vnode moved right 3.比较老的开始节点和新的结束节点
        patchVnode(oldStartVnode, newEndVnode, insertedVnodeQueue); 
        api.insertBefore(parentElm, oldStartVnode.elm as Node, api.nextSibling(oldEndVnode.elm as Node));
        oldStartVnode = oldCh[++oldStartIdx];
        newEndVnode = newCh[--newEndIdx];
      } else if (sameVnode(oldEndVnode, newStartVnode)) { //Vnode moved left 4.比较老的结束节点和新的开始节点
        patchVnode(oldEndVnode, newStartVnode, insertedVnodeQueue); 
        api.insertBefore(parentElm, oldEndVnode.elm as Node, oldStartVnode.elm as Node);
        oldEndVnode = oldCh[--oldEndIdx];
        newStartVnode = newCh[++newStartIdx];
      } else { // 新老的开始节点和结束节点都不相同，则使用新的开始节点(newStartNode)的key在老的节点数组中找相同节点 
        if (oldKeyToIdx === undefined) {  //记录老节点数组中，所有节点的key和index键值对，返回一个对象
          oldKeyToIdx = createKeyToOldIdx(oldCh, oldStartIdx, oldEndIdx);
        } // 从这个对象中找出(跟新的开始节点)相同key，idxInOld为对应的在老的节点数组中对应的老的节点的索引(index)
        idxInOld = oldKeyToIdx[newStartVnode.key as string];
        if (isUndef(idxInOld)) { //如果找不到，即新的开始节点是新的节点,则创建元素并插入DOM树中 //New element
          api.insertBefore(parentElm, createElm(newStartVnode, insertedVnodeQueue), oldStartVnode.elm as Node);
          newStartVnode = newCh[++newStartIdx]; // 重新给新的开始节点赋值，指向下一个新节点，用于下次循环
        } else { // 如果找到相同key对应的老的节点，则先将这个老的节点记录到elmToMove中
          elmToMove = oldCh[idxInOld];
          if (elmToMove.sel !== newStartVnode.sel) { //如果新老的节点的选择器不同,即新的开始节点是新的节点(或被修改过)
            api.insertBefore(parentElm, createElm(newStartVnode, insertedVnodeQueue), oldStartVnode.elm as Node); //创建(新的开始节点对应的DOM)元素并插入到DOM树中
          } else { // 如果新老的节点的选择器相同
            patchVnode(elmToMove, newStartVnode, insertedVnodeQueue);  // 相当于递归
            oldCh[idxInOld] = undefined as any; //先赋值为空，下面再把老的节点(elmToMove)对应的DOM元素移动到左边
            api.insertBefore(parentElm, (elmToMove.elm as Node), oldStartVnode.elm as Node);
          }
          newStartVnode = newCh[++newStartIdx]; // 重新给新的开始节点赋值，指向下一个新节点，用于下次循环
        }
      }
    } // 对比新老的节点的循环结束，以下为判断老的节点数组先遍历完成还是新的节点数组先遍历完成
    if (oldStartIdx <= oldEndIdx || newStartIdx <= newEndIdx) {
      if (oldStartIdx > oldEndIdx) { // 如果老的节点数组先遍历完成，说明新的节点数组有剩余，则把剩余的新的节点插入到右边
        before = newCh[newEndIdx+1] == null ? null : newCh[newEndIdx+1].elm;
        addVnodes(parentElm, before, newCh, newStartIdx, newEndIdx,insertedVnodeQueue);
      } else { // 如果新的节点数组先遍历完成，说明老的节点数组有剩余，则批量删除剩余的老的节点
        removeVnodes(parentElm, oldCh, oldStartIdx, oldEndIdx);
      }
    }
}
```

调试updateChildren：带key的情况：经过调试可以发现，带key属性能更加精确的判断节点是否是sameNode。不带 key 的情况需要进行两次 DOM 操作，带 key 的情况只需要更新一次 DOM 操作(第二个节点与第三个节点换位了)，所以带 key 的情况可以减少 DOM 的操作，如果 li 中的子项 比较多，更能体现出带 key 的优势。如下：

```js
import { h, init } from 'snabbdom'
let patch = init([])
let vnode = h('ul', [ // 首次渲染
  h('li', { key: 'a' }, '首页'),
  h('li', { key: 'b' }, '视频'),
  h('li', { key: 'c' }, '微博')
])
let app = document.querySelector('#app')
let oldVnode = patch(app, vnode)
vnode = h('ul', [
  h('li', { key: 'a' }, '首页'),
  h('li', { key: 'c' }, '微博'),
  h('li', { key: 'b' }, '视频'),
])
patch(oldVnode, vnode) //里面有updateChildren的执行过程
```

##### Modules源码

Snabbdom的核心方法：patch() -> patchVnode() -> updateChildren()。Snabbdom为了保证核心库的精简，把处理元素的属性,事件,样式等这些工作，放置到模块中。模块可按需引入，模块的使用可查[官方文档](https://github.com/snabbdom/snabbdom#modules-documentation)，模块实现的核心是基于Hooks(预定义的钩子函数的名称)。

```typescript
import {VNode} from './vnode';   //源码位置:src/hooks.ts
export type PreHook = () => any;
export type InitHook = (vNode: VNode) => any;
export type CreateHook = (emptyVNode: VNode, vNode: VNode) => any;
export type InsertHook = (vNode: VNode) => any;
export type PrePatchHook = (oldVNode: VNode, vNode: VNode) => any;
export type UpdateHook = (oldVNode: VNode, vNode: VNode) => any;
export type PostPatchHook = (oldVNode: VNode, vNode: VNode) => any;
export type DestroyHook = (vNode: VNode) => any;
export type RemoveHook = (vNode: VNode, removeCallback: () => void) => any;
export type PostHook = () => any;
export interface Hooks {
  pre?: PreHook;  // patch 函数开始执行的时候触发
  init?: InitHook;  // createElm 函数开头(刚开始的时候)触发，在把VNode转换成真实DOM之前触发
  create?: CreateHook;  // 在createElm 函数末尾调用，创建完真实 DOM 后触发
  insert?: InsertHook;  // 在patch 函数末尾执行，真实DOM添加到DOM树后触发
  prepatch?: PrePatchHook;  // 在patchVnode 函数开头调用，开始对比两个VNode的差异之前触发
  update?: UpdateHook;  // 在patchVnode 函数开头调用，两个VNode对比前触发，比prepatch稍晚
  postpatch?: PostPatchHook;  // 在patchVnode 的最末尾调用，两个VNode对比结束后执行
  destroy?: DestroyHook;  // 在removeVnodes里的invokeDestroyHook方法中调用,在删除元素前触发,子节点的destroy也被触发 
  remove?: RemoveHook;   // 在removeVnodes 中调用，元素被删除的时候触发
  post?: PostHook;  // 在patch 函数的最后调用，全部执行完毕触发 
}
```

Modules模块文件：Snabbdom 提供的所有模块在:src/modules 文件夹下

```
│ attributes.ts	       使用 setAttribute/removeAttribute 操作属性,能够处理 boolean 类型的属性
│ class.ts             切换类样式
│ dataset.ts           操作元素的 data-* 属性
│ eventlisteners.ts	   注册和移除事件
│ hero.ts              自定义的模块，examples/hero 示例中使用
│ module.ts            （入口，已经注册了模块。）定义模块遵守的钩子函数
│ props.ts			   和 attributes.ts 类似，但是是使用 elm[attrName] = value的方式操作属性
│ style.ts             操作行内样式,可以使动画更平滑
```

```typescript
import {PreHook, CreateHook, UpdateHook, DestroyHook, RemoveHook, PostHook} from '../hooks'; //位置module.ts
export interface Module {
    pre: PreHook;
    create: CreateHook;
    update: UpdateHook;
    destroy: DestroyHook;
    remove: RemoveHook;
    post: PostHook;
}
```

```typescript
import {VNode, VNodeData} from '../vnode'; // 位置attributes.ts：
import {Module} from './module';
declare global {
    interface Element {
        setAttribute(name: string, value: string | number | boolean): void;
        setAttributeNS(namespaceURL: string, qualifiedName: string, value: string | number | boolean): void;
    }
}
export type Attrs = Record<string, string | number | boolean>
const xlinkNS = 'http://www.w3.org/1999/xlink';
const xmlNS = 'http://www.w3.org/XML/1998/namespace';
const colonChar = 58;
const xChar = 120;   //updateAttrs函数功能:更新节点属性
function updateAttrs(oldVnode: VNode, vnode: VNode): void {
  var key: string, elm: Element = vnode.elm as Element,
    oldAttrs = (oldVnode.data as VNodeData).attrs,
    attrs = (vnode.data as VNodeData).attrs;
    if (!oldAttrs && !attrs) return; // 若新老节点没有 attrs 属性，返回
    if (oldAttrs === attrs) return;  // 若新老节点的 attrs 属性相同，返回
    oldAttrs = oldAttrs || {};
    attrs = attrs || {};
    for (key in attrs) { // update modified attributes, add new attributes // 遍历新节点的属性
      const cur = attrs[key];
      const old = oldAttrs[key];
      if (old !== cur) {  // 如果新老节点的属性值不同
        if (cur === true) {  // 布尔类型值的处理
          elm.setAttribute(key, ""); //如果节点属性值是true则设置空置
        } else if (cur === false) {
          elm.removeAttribute(key); //如果节点属性值是false则移除属性
        } else {  // 非布尔类型值的处理(即正常属性，正常键值对形式)
          if (key.charCodeAt(0) !== xChar) { // ascii 120 -> x
            elm.setAttribute(key, cur);  // 如<svg xmlns="http://www.w3.org/2000/svg">
          } else if (key.charCodeAt(3) === colonChar) {  // ascii 120 -> :  // Assume xml namespace
            elm.setAttributeNS(xmlNS, key, cur);
          } else if (key.charCodeAt(5) === colonChar) { // Assume xlink namespace
            elm.setAttributeNS(xlinkNS, key, cur); // 如<svg xmlns:xlink="http://www.w3.org/1999/xlink">
          } else { //正常设置
            elm.setAttribute(key, cur);
          }
        }
      } 
    }
    for (key in oldAttrs) {
      if (!(key in attrs)) {  // 如果老节点的属性在新节点中不存在，移除 
        elm.removeAttribute(key);  // remove removed attributes
      }
    }
}
export const attributesModule = {create: updateAttrs, update: updateAttrs} as Module; //模块导出成员
export default attributesModule; //模块导出成员
```

