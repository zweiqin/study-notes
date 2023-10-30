#### 常见的Js检验工具

常见的有三个可以使用的js校验器：[JSLint](http://www.jslint.com/)、[JSHint](http://jshint.com/)、[ESLint](http://eslint.org/)。JSLint是其中最老的工具。ESLint是比较新的工具，它被设计得更容易拓展（需要可用的插件）、拥有大量的自定义规则，也就是高度可定制性。用户可以通过定义原始[规则](https://eslint.org/docs/rules/)来灵活地设置编码标准，这些规则是ESLint中默认可用的编码规则。

#### 安装与起步（基本使用）

一、在项目里面去使用（本地安装）：使用本地安装的 ESLint 时，使用的任何插件或可分享的配置也都必须在本地安装。

```json
npm init  // npm init 指令会在项目根目录下生成 package.json 文件
npm install eslint --save-dev  // --save-dev或-D会把eslint安装到package.json文件中的devDependencies属性中
```

- 方式1：新增并使用package.json 脚本（npm run）

```
//第一个是检测src目录下的所有文件，第二个是创建ESLint的配置文件（初始化）
"scripts": {
    "lint": "eslint src",
    "lint:create": "eslint --init"
}
①使用run命令：npm run lint
```

- 方式2：使用npx命令 或 执行.bin文件夹下eslint：

  运行npx时，会到node_modules/.bin路径和环境变量$PATH里，找这个命令。npx除了调用项目内部模块，还能避免进行全局模块的安装。

```bash
①npx eslint --init 或(等同于) ./node_modules/.bin/eslint --init //执行.bin文件夹下对应的二进制指令
②./node_modules/.bin/eslint yourfile.js
```

二、在全局使用（如果让 ESLint 适用于所有的项目，则建议全局安装 ESLint。但是ESLint的全局包的更新相对更麻烦）

```bash
npm install -g eslint
①eslint --init 或 npx eslint --init
②eslint yourfile.js  //全局安装可以在任何文件或目录运行 ESLint
```

#### ESLint初始化(使用命令生成.eslintrc.js文件)

```bash
➜ npx eslint --init
? How would you like to use ESLint? (Use arrow keys)
  To check syntax only 
❯ To check syntax and find problems 
  To check syntax, find problems, and enforce code style 
? What type of modules does your project use? (Use arrow keys)
❯ JavaScript modules (import/export) 
  CommonJS (require/exports) 
  None of these 
? Which framework does your project use? // 这里可以针对你的开发项目进行配置
  React 
  Vue.js 
❯ None of these 
? Where does your code run? // 可以配置代码运行的地方，是浏览器还是Node环境还是都有
❯◉ Browser
 ◉ Node
? What format do you want your config file to be in? (Use arrow keys)
❯ JavaScript 
  YAML 
  JSON 
Successfully created .eslintrc.js file in /Users/itheima/Downloads/Demo  // 成功创建了配置文件
```

配置文件`.eslintrc.js`：eslint使用配置的顺序：`.eslintrc.js` > `.eslintrc.yaml` > `.eslintrc.yml` > `.eslintrc.json` > `.eslintrc` > `package.json`

该js文件导出一个对象，对象包含属性` root`、`env`、`extends`、`globals`、`parserOptions`、`plugins`、`rules` 七个属性：

1.`root`：根。

2.`env`：指定脚本的运行环境。每种环境都有一组特定的预定义全局变量（如：nodejs，browser，commonjs等）。

3.`extends`: 对默认规则进行扩展，可以使用`Airbnb`或`Standard`规则，即使用别人提供的包， 如google，通过使用这个现成的配置，则可以轻松使用Google JavaScript样式指南中的编码约定，而无需从头开始编写设置。

4.`globals`：执行代码时脚本需要访问的额外全局变量。

5.`parserOptions`：用于指定想要支持的JavaScript语言选项，里面的属性有：

- `ecmaVersion`：默认设置为3，5， 可以使用 6、7、8 或 9 来指定要使用的 ECMAScript 版本。也可以使用年份命名的版本号进行指定，如2015（同 6），2016（同 7）， 2017（同 8）， 2018（同 9）

- `sourceType`：设置为 `"script"` (默认) 或 `"module"`（如果代码是 ECMAScript 模块)。
- `ecmaFeatures`：这是个对象，表示要使用的额外的语言特性：可选值有：`globalReturn`允许在全局作用域下使用return语句，`impliedStrict`启用全局 [strict mode](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode) (如果 `ecmaVersion` 是 5 或更高)，`jsx`启用 [JSX](http://facebook.github.io/jsx/)

6.`plugins`：ESLint提供的默认规则涵盖了基本规则，但JavaScript可以使用的范围非常广泛，如果ESLint的默认规则未提供希望要使用的规则，则可以在ESLint中（通过插件plugins）开发自己的独立规则。为了让第三方开发独立规则，ESLint允许使用[插件](https://eslint.org/docs/developer-guide/working-with-plugins)。如果你在npm中搜索eslint-plugin- *，则可以找到第三方提供的大量自定义插件。

```js
//例如，如果要对React代码执行静态分析，可以安装名为[eslint-plugin-react](https://www.npmjs.com/package/eslint-plugin-react)的插件，并使用以下设置来执行React语法特有的静态分析。
{......
    "extends": "google",
    "plugins": [ 
        "react" 
    ],
    "rules": {
        //关闭 不许存在冗余的未使用的变量
        "no-used-vars": "off", //等同于"no-used-vars": 0,
        //末尾逗号
        "comma-dangle": ["error", "never"],
        //分号
        "semi": ["error", "never"], //等同于"semi": [2, "never"],
        //引号
        "quotes": ["error", "single"],
        //不许出现多余的空行，下面配置最大间距空行是1，文件结尾不许有空行
        "no-multiple-empty-lines": ["error", { "max": 1, "maxEOF": 0 }],
        //驼峰命名
        "camelcase": "error",
        //日志输出，在生产环境下不可以有console，在非生产环境(开发环境)则可以使用
        "no-console": process.env.NOED_ENV === 'production' ? "error" : "off",
        "no-debugger": process.env.NOED_ENV === 'production' ? "error" : "off",
        //强等判断
        "eqeqeq": "error",
        //语句块之间的空格(关键字后的空格,函数名后的空格,小括号前后的空格)
        "space-before-blocks": "error",
        //缩进
        "indent": ["error", 2]
    } 
}
```

7.`rules`：开启某些规则，也可以设置规则的等级。里面的规则（属性）的值的含义：

- “off” 或 `0` - 关闭规则
- “warn” 或 `1` - 开启规则，使用警告级别的错误：warn (不会导致程序退出)
- “error” 或 `2` - 开启规则，使用错误级别的错误：error (当被触发的时候，程序会退出)

#### .eslintignore文件

可在项目根目录创建`.eslintignore`文件（纯文本文件），让ESLint忽略某些文件或者目录。常见内容：

```
node_modules/*
**/node_modules/*
dist/*
/build/**
/coverage/**
/docs/**
/jsdoc/**
/templates/**
/tests/bench/**
/tests/fixtures/**
/tests/performance/**
/tmp/**
/lib/rules/utils/unicode/is-combining-character.js
test.js
!.eslintrc.js

或在react项目中配置：
node_modules/
build
my-app*
packages/react-scripts/template
packages/react-scripts/fixtures
fixtures/
```

#### 常用ESlint配置

另外，第三方共享的著名的编码约定，例如“Google JavaScript Style Guide”或“Airbnb JavaScript Style Guide”也可以重复使用。如："extends": "google",

甚至可以在遵循这些编码约定的同时启用或禁用特定文件的特定规则。

ESLint的规范：①Standard: https://github.com/standard/eslint-config-standard（具体地址:[eslintrc.json](https://github.com/standard/eslint-config-standard/blob/master/eslintrc.json)）；②Airbnb: https://github.com/airbnb/javascript

ESLint中文网里的（所有）配置选项：https://cn.eslint.org/docs/rules/

#### 在IDE中的配置

在Webstorm中，ESLint的ide插件配置：（相比于vscode就更智能）

![image-20190626120415006](项目质量检测.assets/image-20190626120415006.png)

#### 实战vue项目配置

ESlint配置文件：

```js
module.exports = {
  //对于vue项目，vue的脚手架内部会自动执行 读取配置文件并执行eslint命令 来检查代码规范
  root: true,
  env: {
    node: true,
  },
  extends: [
    'plugin:vue/essential',
    '@vue/standard',
  ],
  rules: {
    'no-console': process.env.NODE_ENV === 'production' ? 'error' : 'off',
    'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'off',
    semi: ['error', 'never'],
  },
  parserOptions: {
    parser: 'babel-eslint',
  },
}
```

使用prettier-eslint插件：

```json
//prettier-eslint插件能让代码在格式化时，使用prettier-eslint插件进行格式化，而这个插件的格式化规则是按照ESLint的配置规则来进行格式化的
安装：yarn add prettier-eslint -D
```

Prettier(格式化插件)：

```json
//Prettier插件用来替代lint中的一些场景，如分号、tab缩进、空格、引号等（这些问题lint工具不能自动修复）
//Prettier
"prettier.trailingComma": "es5",
"prettier.semi": false,
"prettier.jsxSingleQuote": true,
"prettier.singleQuote": true,
"prettier.eslintIntegration": true,
```

在文件修改并进行保存之后的执行顺序：

①ide的ESLint插件对不符合配置规则的地方进行实时标红（保存之前）

②读取配置文件.eslintrc.js，ide的ESLint插件进行修改。（相当于编辑器帮你执行了eslint --fix）

③读取配置文件.prettier，ide的Prettier插件进行修改。（相当于编辑器帮你执行了prettier --write .文件）

④用prettier-eslint进行更符合ESLint规则的更细致的格式化

⑤（重新运行项目）对于vue项目，脚手架内部会使用eslint进行代码规范检查（不符合规范则在终端里报错）（相当于vue项目帮执行了eslint的检查文件命令）

