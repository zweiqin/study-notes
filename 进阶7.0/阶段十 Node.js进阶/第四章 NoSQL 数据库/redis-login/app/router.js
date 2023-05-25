'use strict';

/**
 * @param {Egg.Application} app - egg application
 */
module.exports = app => {
  const { router, controller } = app;
  router.get('/', controller.home.index);
  
  router.get('/login', controller.login.loginHtml);
  router.get('/sign', controller.login.signHtml);
  
  // 注册 的 api接口
  router.post('/api/sign', controller.login.sign);

  // 登录接口
  router.post('/api/login', controller.login.login);

  // 退出登录
  router.get('/logout', controller.login.logout)
};
