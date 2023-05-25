'use strict';

const Controller = require('egg').Controller;

class LoginController extends Controller {
  async loginHtml() {
    const { ctx } = this;
    await ctx.render('login');
  }
  async signHtml() {
    const { ctx } = this;
    await ctx.render('sign');
  }

  async sign() {
      // 1. 获取request 的 body
      // 2. 存储到mongo

      const {ctx} = this;
      // 1. 获取request 的 body
      var requestBody = ctx.request.body;
      // 2. 存储到mongo
      await ctx.model.User.insertMany({
          username: requestBody.username,
          password: requestBody.password
      });

      ctx.body = '<h1>注册成功</h1>'
  }

  async login() {
      // 1. 获取request 的 body
      // 2.校验
      // 3. 将 session和redis进行同步

      const {ctx} = this;
      // 1. 获取request 的 body
      var requestBody = ctx.request.body;
        // 数据库查询
      const findUser = await ctx.model.User.find({
          username: requestBody.username
      });
      // 校验
      if (findUser.length && findUser[0].password === requestBody.password) {
        //  将 session和redis进行同步
        // 只需要一行代码就够了
        ctx.session.login = true;
        ctx.redirect('/');
      } else {
        ctx.redirect('/login');
      }

  }

  async logout(){
    const {ctx} = this;
    ctx.session.login = false;
    ctx.redirect('/login');
  }
}

module.exports = LoginController;
