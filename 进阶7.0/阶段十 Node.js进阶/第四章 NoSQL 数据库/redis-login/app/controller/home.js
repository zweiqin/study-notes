'use strict';

const Controller = require('egg').Controller;

class HomeController extends Controller {
  async index() {
    const { ctx } = this;
    // 需要加上权限判断
    if (ctx.session.login) {
      await ctx.render('home');
    } else {
      ctx.redirect('/login');
    }
  }
}

module.exports = HomeController;
