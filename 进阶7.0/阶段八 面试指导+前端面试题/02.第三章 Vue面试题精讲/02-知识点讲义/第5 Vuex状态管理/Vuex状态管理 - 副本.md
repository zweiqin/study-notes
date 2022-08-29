### Vuex状态管理

#### Vuex

当项目比较复杂，多个组件共享状态的时候，使用组件间通信的方式比较麻烦，而且需要维护。此时可以使用集中式的状态（管理）解决方案，即Vuex。状态管理：。

①Vuex 是专门为 Vue.js 设计的状态管理库，从使用的角度来讲其实就是一个JavaScript库；它的作用是进行状态管理，即通过对状态的集中管理和分发，来解决多个组件共享状态（复杂组件通信和数据共享）的问题；它采用集中式的方式存储需要共享的数据，但是若状态特别多则不易管理，所以Vuex还提供了一种模块的机制，可以按照模块管理不同的状态；Vuex 也集成到 Vue 的官方调试工具 devtools extension，提供了time-travel时光旅行、历史回滚、状态快照、导入导出等高级调试功能。

补充知识：
Vue中有两个最核心的内容（功能）：①数据驱动；②组件化（使用基于组件化的开发，可以提高开发效率，带来更好的可维护性）；
单向的数据流程很简单清晰，即`状态`绑定到视图上呈现给`用户`，用户通过与`视图`交互改变状态，之后改变了的状态再次绑定到视图后会再次呈现给用户。（state：状态，数据源。view：视图，通过把状态绑定到视图呈现给用户。actions：用户和视图交互改变状态的方式。）但是多个组件共享数据会破坏这种简单的结构。

为了解决这些问题，可以把不同组件的共享状态抽取出来，存储到一个全局对象中并且将来使用的时候保证其是响应式的。这个对象创建好之后里面有全局的状态和修改状态的方法，任何组件都可以获取和通过调用对象中的方法修改全局对象中的状态 （但是组件中不允许直接修改对象的state状态属性，不在组件中直接修改状态的值而是通过调用store的actions来修改值，这样做的好处是，能够记录store中里的state对象的变更，当state里有数据变更的时候，就可以实现高级的调试功能。例如：timeTravel(时光旅行)和历史回滚功能）。

Vuex 可以管理组件间共享的状态，但是若在项目中使用Vuex，则需要了解Vuex中带来的新的概念和一些API，如果项目不大，并且组件间共享状态不多的情况下，这个时候使用Vuex带来的益处并没有付出的时间多。此时使用简单的[store 模式](https://link.zhihu.com/?target=https%3A//cn.vuejs.org/v2/guide/state-management.html%23%E7%AE%80%E5%8D%95%E7%8A%B6%E6%80%81%E7%AE%A1%E7%90%86%E8%B5%B7%E6%AD%A5%E4%BD%BF%E7%94%A8)或者其他方式就能满足我们的需求。而如果项目是中大型单页应用程序，且需要解决多个视图依赖同一状态**、**来自不同视图的行为需要变更同一状态的问题，则建议使用Vuex进行状态管理、

Vuex的核心概念：
①**Store**：仓库，Store是使用Vuex应用程序的核心，每个应用仅有一个Store，它是一个容器，包含着应用中的大部分状态，但是不能直接改变Store中的状态，要通过提交Mutations的方式改变状态。
②**State**：状态，保存在Store中，因为Store是唯一的，所以State也是唯一的，称为单一状态树，这里的状态是响应式的。
③**Getters**：相当于Vuex中的计算属性，方便从一个属性派生出其他的值，它内部可以对计算的结果进行缓存，只有当依赖的状态发生改变的时候，才会重新计算。
④**Mutations**：状态的变化必须要通过提交Mutation来完成。
⑤**Actions**：与Mutation类似，不同的是可以进行异步的操作，内部改变状态的时候都需要先改变Mutation。
⑥**Modules**：模块，由于使用的单一状态树让所有的状态都会集中到一个比较大的对象中，应用变得很复杂的时候，Store对象就会变得相当臃肿，为了解决这些问题，Vuex允许我们将Store分割成模块，每个模块拥有自己的State，Mutation，Actions，Getter，甚至是嵌套的子模块。

#### Vuex的使用

```js
//使用vue-cli创建项目的时候，如果选择了Vuex，会自动生成Vuex的基本结构。
// store/index.js
import Vue from 'vue'
import Vuex from 'vuex'  // 导入Vuex插件
Vue.use(Vuex)  // 通过use方法注册插件,插件内部在第一次new Vue的时候,把Vuex的 Store类的实例 注入到了Vue实例的原型链上
export default new Vuex.Store({  // 创建了Vuex的 Store类的实例 并且导出
    state: {
        ...
    },    // 如果有需要还可以有getters
    mutations: {
        ...
    },
    actions: {
        ...
    },
    modules: {
        ...
    }
})
//main.js
import store from './store'  // 导入store对象
new Vue({
    router,
    store,  // 在初始化Vue的时候传入store选项，这个选项会被注入到Vue实例的原型链上，在组件中可使用this.$store
    render: h => h(App)
}).$mount('#app')
```

具体使用示例：

```js
// main.js
import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
Vue.config.productionTip = false
new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
```

```js
// store/index.js
import Vue from 'vue'
import Vuex from 'vuex'
import products from './modules/products'
import cart from './modules/cart'
Vue.use(Vuex)
export default new Vuex.Store({
  //所有的状态变更必须提交mutation，但是如果在组件中获取到$store.state.msg之后直接进行修改，虽然在语法层面上没有问题，但破坏了Vuex的约定，且devTools也无法跟踪到状态的修改。开启严格模式之后，如果在组件中直接修改state则会报错。
  //不要在生产环境开启严格模式，因为严格模式会深度检测状态树，会影响性能。建议在开发模式中开启严格模式，在生产环境中关闭严格模式
  // strict: process.env.NODE_ENV !== 'production', // 非生产(开发)环境开启严格模式后，不允许在mutation外修改state
  state: {
    count: 0,
    msg: 'Hello Vuex'
  },
  getters: {
    reverseMsg (state) {
      return state.msg.split('').reverse().join('')
    }
  },
  mutations: {
    increate (state, payload) { //第一个是state状态，第二个是payload载荷（提交的额外参数）
      state.count += payload
    }
  },
  actions: { //若有异步的修改，要使用actions，在actions中可执行异步操作，当异步操作结束后,若要更改状态,要提交Mutations
    increateAsync (context, payload) { //第一个参数是context上下文，这个对象中有state，commit，getters等成员
      setTimeout(() => {
        context.commit('increate', payload)
      }, 2000)
    }
  },
  modules: {
    products,
    cart
  }
})
```

```js
// store/modules/products.js
const state = {
  products: [
    { id: 1, title: 'iPhone 11', price: 8000 },
    { id: 2, title: 'iPhone 12', price: 10000 }
  ]
}
const getters = {}
const mutations = {
  setProducts (state, payload) {
    state.products = payload
  }
}
const actions = {}
export default {
  namespaced: true, //因为每个模块中的mutation是可以重名的，所以推荐使用命名空间的用法，方便管理
  state,
  getters,
  mutations,
  actions
}
```

```javascript
// store/modules/cart.js
const state = {}
const getters = {}
const mutations = {}
const actions = {}
export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
}
```

```vue
<!-- // App.vue -->
<template>
  <div id="app">
    <h1>Vuex - Demo</h1>
    <!-- count：{{ $store.state.count }} <br> msg: {{ $store.state.msg }} -->
    <!-- count：{{ count }} <br> msg: {{ msg }} -->
    count：{{ num }} <br> msg: {{ message }}
    <h2>Getters</h2>
    <!-- reverseMsg: {{ $store.getters.reverseMsg }} -->
    reverseMsg: {{ reverseMsg }}
    <h2>Mutations</h2>
    <!-- 如果调用commit提交Mutation，第一个参数是调用的方法名，第二个参数是payload，传递的数据 -->
    <!-- <button @click="$store.commit('increate', 2)">Mutations</button> -->
    <button @click="increate(3)">Mutations</button>
    <h2>Actions</h2>
    <!-- <button @click="$store.dispatch('increateAsync', 5)">Actions</button> -->
    <button @click="increateAsync(6)">Actions</button>
    <h2>Modules</h2>
    <!-- 第一个products是products模块，第二个products是模块的state的products属性 -->
    <!-- products: {{ $store.state.products.products }} <br>
    <button @click="$store.commit('setProducts', [])">Mutations</button> -->
    products: {{ products }} <br>
    <button @click="setProducts([])">Mutations</button>
    <h2>strict</h2>
    <!-- 开启严格模式之后，点击按钮内容改变，但是控制台会抛出错误 -->
    <button @click="$store.state.msg = 'Lagou'">strict</button>
  </div>
</template>
<script>
import { mapState, mapGetters, mapMutations, mapActions } from 'vuex' //引入vuex的这些模块
export default {
  computed: {
    //mapState可以接收数组作为参数，数组的元素是需要映射的状态属性。会返回一个对象，包含两个对应属性计算的方法
    // ...mapState(['count', 'msg'])  //在计算属性中调用mapState函数，再使用扩展运算符展开返回的对象
    ...mapState({ num: 'count', message: 'msg' }), //mapState也可以传对象，键是别名，值是映射的状态属性
    ...mapGetters(['reverseMsg']), //也可以使用对象设置别名
    ...mapState('products', ['products']) //模块中的state，第一个参数是模块名称，第二个参数是数组或对象
  },
  methods: {
    ...mapMutations(['increate']), //返回一个对象，这个对象中存储的是mutations中映射的方法
    ...mapActions(['increateAsync']), //对Actions的方法的映射
    ...mapMutations('products', ['setProducts']) //模块中的mutations，第一个是模块名称，第二个是数组或对象
  }
}
</script>
<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
#nav {
  padding: 30px;
}
#nav a {
  font-weight: bold;
  color: #2c3e50;
}
#nav a.router-link-exact-active {
  color: #42b983;
}
</style>
```

#### Vuex插件

Vuex插件就是一个函数，其接收一个store的参数，在这个函数里面可以注册一个函数让Vuex在所有的mutations结束之后再执行

插件的使用：插件应该在 创建Store类的实例 的时候去注册。

subscribe函数的作用：订阅store（实例）中的mutation，subscribe函数里的回调函数会在每个mutation之后调用，subscribe函数会接收两个参数，第一个是mutation（可以用来区分模块的命名空间），第二个参数是state（里面是存储的状态）

```js
const myPlugin = store => {  // 当store初始化后调用
    store.subscribe((mutation, state) => {  // 在每次mutation后调用：mutation的格式为{ type, payload }，type里面的格式是"模块名/state属性"；state的格式为{ 模块一, 模块二 }
    })
}......
const store = new Vuex.Store({......
    plugins: [myPlugin]
})
```

#### 购物车案例

![image-20220807134221592](.\image-20220807134221592.png)

具体代码见购物车案例文件夹

#### 模拟一个简单的Vuex

```js
let _Vue = null
class Store {
  constructor (options) {
    const {
      state = {},
      getters = {},
      mutations = {},
      actions = {}
    } = options
    this.state = _Vue.observable(state)
    this.getters = Object.create(null)
    Object.keys(getters).forEach(key => {
      Object.defineProperty(this.getters, key, {
        get: () => getters[key](state)
      })
    })
    this._mutations = mutations
    this._actions = actions
  }
  commit (type, payload) {
    this._mutations[type](this.state, payload)
  }
  dispatch (type, payload) {
    this._actions[type](this, payload)
  }
}
function install (Vue) {
  _Vue = Vue
  _Vue.mixin({
    beforeCreate () {
      if (this.$options.store) {
        _Vue.prototype.$store = this.$options.store
      }
    }
  })
}
export default {
  Store,
  install
}
```

