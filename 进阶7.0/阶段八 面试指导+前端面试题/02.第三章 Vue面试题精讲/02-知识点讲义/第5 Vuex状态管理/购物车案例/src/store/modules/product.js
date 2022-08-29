import axios from 'axios'

const state = {
  products: [] // 记录所有商品
}
const getters = {}
const mutations = {
  // 修改商品数据状态
  setProducts(state, payload) {
    state.products = payload
  }
}
// 请求接口获取数据
const actions = {
  async getProducts({ commit }) {
    const { data } = await axios({
      method: 'GET',
      url: 'http://127.0.0.1:3000/products'
    })
    // 提交 Mutation
    commit('setProducts', data)
  }
}

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
}