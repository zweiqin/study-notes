/* eslint valid-jsdoc: "off" */

'use strict';

/**
 * @param {Egg.EggAppInfo} appInfo app info
 */
module.exports = appInfo => {
  /**
   * built-in config
   * @type {Egg.EggAppConfig}
   **/
  const config = exports = {};

  // use for cookie sign key, should change to your own and keep security
  config.keys = appInfo.name + '_1565698426145_5854';

  // add your middleware config here
  config.middleware = [];

  // 模板配置
  config.view = {
    mapping: {
      '.html': 'nunjucks',
    },
  }

  // session 
  config.session = {
    encrypt: false,  // 加密
    signed: false,  // 签名
    // maxAge: 10000
  }

  // redis
  config.redis = {
    client: {
      port: 6379,          // Redis port
      host: '127.0.0.1',   // Redis host
      password: 'auth',
      db: 0,
    }
  }

  config.mongoose = {
    url: 'mongodb://127.0.0.1/redis-mongoose',
    options: {},
    // mongoose global plugins, expected a function or an array of function and options
  }

  // add your user config here
  const userConfig = {
    // myAppName: 'egg',
  };

  return {
    ...config,
    ...userConfig,
  };
};
