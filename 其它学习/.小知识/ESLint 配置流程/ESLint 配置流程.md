各版本的eslint：https://github.com/eslint/eslint/releases



## 使用v9.15的ESLint

手动安装和配套安装区别

<img src="ESLint 配置流程.assets/image-20241201231510712.png" alt="image-20241201231510712" style="zoom:80%;" />



### 手动安装

要先安装并构建 Node.js（^18.18.0、^20.9.0 或 >=21.1.0）并支持 SSL（如果使用的是官方 Node.js 发行版，则始终内置 SSL）。

确保已经有`package.json`文件，然后执行安装命令：`npm init @eslint/config@latest` 或 `yarn create @eslint/config` 或 `pnpm create @eslint/config@latest`。

```json
// 在`package.json`文件新增的包：
  "devDependencies": {
    "@eslint/js": "^9.15.0",
    "eslint": "^9.15.0",
    "eslint-plugin-vue": "^9.31.0",
    "globals": "^15.12.0",
    "typescript-eslint": "^8.15.0",
```

安装后，目录中将有一个`eslint.config.js`（或`eslint.config.mjs`）文件。

<img src="ESLint 配置流程.assets/image-20241201233502288.png" alt="image-20241201233502288" style="zoom:80%;" />

然后就可以在任何文件或目录上运行 ESLint：`npx eslint yourfile.js`或`yarn run eslint yourfile.js`。



### 概念

#### 抽象语法树 (AST)

代码语法的结构化表示。AST中源代码的每个部分都称为node。每个节点可以具有任意数量的属性，包括存储子节点的属性。

ESLint 使用的 AST 格式是 ESTree 格式。`ESLint规则`被赋予一个 AST，当它们检测到 violation 时，可能会在 AST 的一部分上生成 violations。

#### 修复（Fix）

rule violation 的可选增强，描述如何自动纠正违规行为。

修复通常是 “safe” 才能自动应用：它们不应导致代码行为发生变化。当使用 --fix 标志运行时，ESLint 尝试在 report 中应用尽可能多的修复，但不能保证所有修复都会被应用。修复也可以通过常见的编辑器扩展来应用。

违反规则还可能包括不安全且不会以 suggestions 的形式自动应用的文件更改。

#### 建议（Suggestion）

rule violation 的可选增强，描述如何手动调整代码以解决违规问题。

自动应用建议通常并不安全，因为它们会导致代码行为发生变化。ESLint 不直接应用建议，但确实为可能选择应用建议的集成提供建议（如编辑器扩展）。

规则违规还可能包括安全的文件更改，并且可以以 fixes 的形式自动应用。

#### ESQuery

ESLint 用于解析`选择器`语法以在 AST 中查询 nodes 的库。ESQuery 解释 AST 节点属性的 CSS 语法。ESQuery 选择器的示例包括：

①BinaryExpression：选择 BinaryExpression 类型的所有节点。

②BinaryExpression[operator='+']：选择所有运算符为 + 的 BinaryExpression 节点。

③BinaryExpression > Literal[value=1]：选择其直接父级为 BinaryExpression 且值为 1 的所有 Literal 节点。

#### 选择器

描述如何在 AST 中搜索 nodes 的语法。

#### ESTree

ESLint 用于如何将 JavaScript 语法表示为 AST 的格式。

如代码`1 + 2;`的 ESTree 表示将是一个大致如下的对象：

```json
{
    "type": "ExpressionStatement",
    "expression": {
        "type": "BinaryExpression",
        "left": {
            "type": "Literal",
            "value": 1,
            "raw": "1"
        },
        "operator": "+",
        "right": {
            "type": "Literal",
            "value": 2,
            "raw": "2"
        }
    }
}
```

#### 静态分析

在不构建或运行源代码的情况下分析源代码的过程。诸如`ESLint`、`formatters`和`类型检查器`之类的`代码检查器`是`静态分析工具`的示例。ESLint等静态分析工具通常通过将语法转换为 ESTree 格式的 AST 来进行操作。

静态分析与动态分析不同，动态分析是在构建和执行源代码后对其进行评估的过程。单元、集成和端到端测试是动态分析的常见示例。

#### Linter

一个静态分析工具，可以对源代码上运行一组规则的结果进行 report 处理，每个规则可以报告源代码中任意数量的 violations。

ESLint 是JavaScript和其他Web技术常用的linter。注意，`linter`与`formatters`和`类型检查器`是分开的。

#### 类型检查器

一款静态分析工具，可帮助全面了解项目的代码结构和数据形状。

类型检查器通常比 linter 更慢且更全面。传统上，linter 一次仅对单个文件或片段的 AST 进行操作，而类型检查器则了解跨文件依赖和类型。

TypeScript 是最常见的 JavaScript 类型检查器。typescript-eslint 项目提供了允许在 lint 规则中使用类型检查器的集成。

#### 格式化器（代码检查）

即**Formatter (Linting)**。

一个包含 ESLint 生成的 report 的包。ESLint 附带了多个内置报告器，包括stylish（默认）、json和html。

**报告**：即**Report**，来自单个 ESLint 运行的 violations 集合。当 ESLint 在源文件上运行时，它将每个源文件的 AST 传递给每个配置的 rule，每个规则的违规行为集合将被打包在一起并传递到formatter（格式化器）以展示给用户。

#### 格式化器（工具）

即**Formatter (Tool)**。

一款静态分析工具，可快速重新格式化代码，而无需更改其逻辑或名称。

格式化程序一般只修改代码的“trivia”（如分号、空格、换行符和一般的空格），琐碎的更改通常不会修改代码的 AST。生态系统中常见的格式化程序包括 Prettier 和 dprint。

ESLint 格式化程序控制CLI（命令行接口）中 linting 结果的外观。注意，虽然 ESLint 是 linter 而不是格式化程序，但 ESLint 规则也可以将格式更改应用于源代码。

**文体（规则）**：强制执行偏好而不是逻辑问题的规则。风格字段包括格式规则、命名约定以及等效语法之间的一致选择。ESLint 的内置风格规则是功能冻结的（除了支持新的 ECMAScript 版本之外，它们不会收到新功能）。

#### 格式（规则）

仅针对`formatting`问题的规则（如分号和空格）。这些规则不会更改应用逻辑，并且是`文体规则`的子集。

ESLint不再推荐格式化规则，并且之前已弃用其内置格式化规则。ESLint 建议使用专用格式化程序（如 [Prettier](https://prettier.nodejs.cn/) 或 [dprint](https://dprint.dev/)）。或`ESLint 风格项目`（https://eslint.style/）提供与格式相关的 lint 规则。







### 配置ESLint

**配置 ESLint 有两种主要方式：**

①配置注释（内联配置）。将规则配置为不同严重性和（或）选项集的源代码注释。使用 JavaScript 注释将配置信息直接嵌入到文件中。内联配置使用与配置文件类似的语法来按名称、新严重性以及可选的规则新选项指定任意数量的规则（通过配置注释配置的规则具有最高优先级，并在所有配置文件设置之后应用）。

```javascript
如同时禁用`eqeqeq`规则并将 curly 规则设置为 "error"的内联配置：
/* eslint eqeqeq: "off", curly: "error" */
或：/* eslint eqeqeq: 0, curly: 2 */
如果规则有其它选项，可以使用数组字面语法指定：
/* eslint quotes: ["error", "double"], curly: 2 */
```

配置注释说明：包括说明为什么需要注释。描述必须出现在配置之后，并且由两个或多个连续的 `-` 字符与配置隔开。

```javascript
/* eslint eqeqeq: "off", curly: "error" -- Here's a description about why this configuration is necessary. */
或：
/* eslint eqeqeq: "off", curly: "error"
    --------
    Here's a description about why this configuration is necessary. */
或：
/* eslint eqeqeq: "off", curly: "error"

 * --------

 * This will not work due to the line above starting with a '*' character.
 */
```

②配置文件。使用 JavaScript 文件指定整个目录及其所有子目录的配置信息，可以是 eslint.config.js 文件的形式，ESLint 将自动查找并读取该文件，也可以在命令行上指定配置文件。

**可以在 ESLint 中配置的一些选项：**

**①全局变量。**脚本在执行期间访问的其它全局变量。

- 使用配置注释，如`/* global var1, var2 */`、`/* global var1:writable, var2:writable */`（选择性地指定这些全局变量可以被写入，而不仅仅是被读取）。
- 使用配置文件：

预定义的全局变量：除了基于配置的 languageOptions.ecmaVersion 自动启用的 ECMAScript 标准内置全局变量外，ESLint 不提供预定义的全局变量集。但可以使用 globals 包为特定环境额外启用所有全局变量（如将console等浏览器全局变量添加到配置中）。

```javascript
import globals from "globals";
export default [
    {
        languageOptions: {
            globals: {
                // 预定义的全局变量：
                // ...globals.jest, // 可以以相同的方式包含多个不同的全局变量集合（如it、expect等）
                // ...globals.node,
                ...globals.browser,
                // 自定义的全局变量：
                var1: "writable", // 允许变量被覆盖
                var2: "readonly", // 不允许覆盖
                Promise: "off" // 禁用全局变量
            }
        }
    }
];
```

**②规则（Rule）。**检查 AST 是否存在预期模式的代码。启用了哪些规则以及处于什么错误级别。当规则的期望未得到满足时，它会创建 violation。ESLint 提供了大量规则来检查常见的 JavaScript 代码问题，且plugins可能会加载更多规则。

严重性：如果有的话，规则配置为运行什么级别的报告。ESLint 支持三个严重级别：
1、"off" (0)：不要运行该规则。
2、"warn" (1)：运行规则，但不要因其违规行为而以非零状态代码退出（不包括 --max-warnings 旗）。
3、"error" (2)：运行规则，如果产生任何违规，则以非零状态代码退出。

**③插件（Plugin）。**哪些第三方插件定义了额外的规则、环境、配置等，供ESLint使用。



#### 配置文件

配置文件：包含 ESLint 如何解析文件和运行规则的首选项的文件。ESLint 配置文件的命名类似于 eslint.config.(c|m)js。每个配置文件导出一个包含`配置对象`的`配置数组`，且应该放在项目的根目录下。

扁平配置：ESLint 当前的配置文件格式。扁平配置文件以`eslint.config.(c|m)?js`格式命名。“扁平”配置文件之所以如此命名，是因为所有嵌套都必须在一个配置文件中完成。相比之下，**“旧版”配置格式**允许在项目内的子目录中嵌套配置文件。旧版 ESLint 配置以 `.eslintrc.*` 格式命名，并允许跨文件嵌套在项目的子目录中。

ESLint 配置文件可以命名为以下任意名称（优先级从高到低）：`eslint.config.js`、`eslint.config.mjs`、`eslint.config.cjs`、`eslint.config.ts`（需要附加设置）、`eslint.config.mts`（需要附加设置）、`eslint.config.cts`（需要附加设置）。

如果项目在其`package.json`文件中没有指定`"type":"module"`，则`eslint.config.js`必须是 CommonJS 格式。如：

```javascript
module.exports = [
    {
        rules: {
            semi: "error",
            "prefer-const": "error"
        }
    }
];
```





#### 配置对象

每个配置对象都包含 ESLint 需要在一组文件上执行的所有信息。每个配置对象都由以下属性组成：



**①name**，配置对象的名称。这在错误消息和配置检查器中使用，以帮助识别正在使用哪个配置对象。

`name` 属性是可选的，但建议为每个配置对象提供一个名称，尤其是在创建共享配置时。该名称应该描述配置对象的用途，并使用`/`作为分隔符以配置名称或插件名称为范围。ESLint 不强制运行时名称唯一，但建议设置唯一名称以避免混淆。

如果要为名为 `eslint-plugin-example` 的插件创建配置对象，则可以将 `name` 添加到带有 `example/` 前缀的配置对象中，如`name: "example/recommended"`。



**②files**，指示配置对象应应用于的文件的通配符模式数组。如果未指定，则配置对象适用于与任何其他配置对象匹配的所有文件。

`files` 和 `ignores` 中指定的模式使用 [`minimatch`](https://www.npmjs.com/package/minimatch) 语法，并相对于 `eslint.config.js` 文件的位置进行评估。

可以使用 files 和 ignores 的组合来确定配置对象应该应用于哪些文件以及不应用于哪些文件。默认情况下，ESLint 会对与模式`**/*.js`、`**/*.cjs`和`**/*.mjs`匹配的文件进行 lint（默认为通配符模式`"**/*.{js,mjs,cjs}"`）。除非使用`全局忽略`明确排除这些文件，否则这些文件始终匹配。

指定具有任意扩展名的文件，格式为`"**/*.extension"`；指定没有扩展名的文件，没有扩展名的文件可以与模式`!(*.*)`匹配，即`"**/!(*.*)"`。
以点开头的文件名（如`.gitignore`）被认为只有扩展名而没有基本名称，对于`.gitignore`，扩展名是`gitignore`，因此文件与模式`"**/.gitignore"`匹配但不与`"**/*.gitignore"`匹配。



**③ignores**，指示配置对象不应应用于的文件的通配符模式数组。如果未指定，则配置对象适用于 files 匹配的所有文件。如果在配置对象中使用 ignores 而没有任何其它键，则模式将充当全局忽略。

ignores配置指定应忽略的所有文件，此模式添加在默认模式之后，即 `["**/node_modules/", ".git/"]`。

可以在 `ignores` 中使用否定模式从忽略模式中排除文件，即加上感叹号`!`。

非全局`ignores`模式只能匹配文件名。像`dir-to-exclude/`这样的模式不会忽略任何东西；要忽略特定目录中的所有内容，应该使用像`dir-to-exclude/**`这样的模式。

如果使用 `ignores` 而不使用 `files`，并且有其它键（如`rules`），则配置对象适用于除`ignores`排除的文件之外的所有linted（JavaScript？）文件。

由于未指定 files 或 ignores 的配置对象适用于已与任何其他配置对象匹配的所有文件，因此它们将适用于所有 JavaScript 文件。



**④languageOptions**，包含与如何为代码检查配置 JavaScript 相关的设置的对象。

- `ecmaVersion`，支持的 ECMAScript 版本，可以是任何年份（即 `2022`）或版本（即 `5`）。对于最新支持的版本，设置为 `"latest"`（默认`"latest"`）。
- `sourceType`，JavaScript 源代码的类型。可能的值有：`"script"`，用于传统脚本文件，非模块；`"module"`，用于 ECMAScript 模块 (ESM)；`"commonjs"`，用于CommonJS文件。默认`"module"`，用于 `.js` 和 `.mjs` 文件，而`"commonjs"`用于 `.cjs` 文件。
- `globals`，指定在代码检查期间应添加到全局作用域的其它对象的对象。
- `parser`，包含 `parse()` 方法或 `parseForESLint()` 方法的对象（默认[`espree`](https://github.com/eslint/js/tree/main/packages/espree)）。
- `parserOptions`，指定直接传递给解析器上的 `parse()` 或 `parseForESLint()` 方法的其它选项的对象。可用选项取决于解析器。

可以通过指定 `languageOptions.parserOptions` 键来更改 ESLint 解释代码的方式。默认情况下，所有选项均为`false`。
选项有：
1、`allowReserved`，允许使用保留字作为标识符（如果`ecmaVersion`是3）。
2、`ecmaFeatures`，一个对象，指示要使用哪些附加语言功能。globalReturn，在全局作用域内允许 return 语句；impliedStrict启用全局严格模式（如果`ecmaVersion`是5或更大）；jsx，启用 JSX（注意，React 将特定语义应用于 ESLint 无法识别的 JSX 语法，如果使用 React，则建议使用[eslint-plugin-react](https://github.com/jsx-eslint/eslint-plugin-react)）。

解析器（Parser）：包含读取字符串并将其转换为标准化格式的方法的对象。

ESLint 解析器将代码转换为 ESLint 可以计算的抽象语法树，即ESLint使用解析器将源代码字符串转换为 AST 形状。默认情况下，ESLint 使用内置的`埃斯普雷`解析器，它与标准 JavaScript 运行时和版本兼容。

已知以下第三方解析器与 ESLint 兼容：
1、Esprima。
2、@babel/eslint-parser，Babel解析器的封装器，使其与 ESLint 兼容。
3、@typescript-eslint/parser，将 TypeScript 转换为 ESTree 兼容形式的解析器，以便它可以在 ESLint 中使用。

自定义解析器让 ESLint 解析非标准 JavaScript 语法。通常，自定义解析器作为可共享配置或插件的一部分包含在内，因此不必直接使用它们。如`@typescript-eslint/parser`是`typescript-eslint`项目中包含的自定义解析器，可让 ESLint 解析 TypeScript 代码；也可以使用`@babel/eslint-parser`包来允许 ESLint 解析实验性语法：

```javascript
import babelParser from "@babel/eslint-parser";
export default [
    {
        files: ["**/*.js", "**/*.mjs"],
        languageOptions: {
            parser: babelParser, // 使用 Babel 解析器而不是默认的 Espree 解析器来解析所有有 .js 和 .mjs 结尾的文件
            // 需要检查正在使用的解析器的文档以获取可用选项。另外，ESLint还将ecmaVersion和sourceType传递给所有解析器。
            // parserOptions: {
            //     requireConfigFile: false,
            //     babelOptions: {
            //       babelrc: false,
            //       configFile: false,
            //       presets: ["@babel/preset-env"]
            //     }
            // }
        }
    }
];
```



**⑤linterOptions**，包含与代码检查过程相关的设置的对象。

- noInlineConfig，一个布尔值，指示是否允许内联配置。

- reportUnusedDisableDirectives，一个严重性字符串，指示是否以及如何应跟踪和报告未使用的禁用和启用指令，用于报告未使用的 `eslint-disable` 注释（默认值："warn"）。对于旧版兼容性，true 相当于 "warn"，false 相当于 "off"。

可以使用 `linterOptions` 对象配置特定于代码检查过程的选项。这些影响 linting 如何进行，而不影响文件源代码的解释方式。



**⑥processor**，包含`preprocess()`和`postprocess()`方法的对象或指示插件内处理器名称的字符串（即"pluginName/processorName"）。

处理器（Processor）：插件的一部分。ESLint 处理器从其它类型的文件中提取 JavaScript 代码，然后让ESLint检测（lint）JavaScript代码；或可以在使用 ESLint 解析 JavaScript 代码之前使用处理器来操作 JavaScript 代码。

如`@eslint/markdown`包含一个自定义处理器，可在 Markdown 代码块内检查 JavaScript 代码：

```javascript
import markdown from "@eslint/markdown";
export default [
    {
        files: ["**/*.md"],
        plugins: {
            markdown
        },
        // ``"somePlugin/someProcessor"`相当于`somePlugin.processors.someProcessor`（可以不进行`plugins: { somePlugin }`的声明也行）
        processor: "markdown/markdown"
    }
];
```



**⑦plugins**，包含插件名称到插件对象的名称-值映射的对象。指定 files 时，这些插件仅对匹配的文件可用。

可以包含一组`configurations`（可共享配置）、`processors`（处理器）和（或）`规则`的包。

ESLint 插件是一个 npm 模块，可以包含一组 ESLint 规则、配置、处理器和环境；
插件通常包含自定义规则；
插件可用于强制执行样式指南并支持 JavaScript 扩展（如 TypeScript）、库（如 React）和框架（Angular）。
插件的一个流行用例是强制框架的最佳实践，如`@angular-eslint/eslint-plugin`包含使用 Angular 框架的最佳实践。

要配置在插件中定义的规则，请在规则 ID 前添加插件命名空间和 `/`。

```javascript
import example from "eslint-plugin-example";
export default [
    {
        plugins: {
            example
        },
        rules: {
            "example/rule1": "warn"
        }
    }
];

在配置注释中使用（注意：配置文件必须加载插件，并在配置的 plugins 对象中指定它。配置注释不能自行加载插件）：
/* eslint "example/rule1": "error" */
```

插件可能提供语言，语言允许 ESLint 对 JavaScript 以外的编程语言进行 lint。要在配置文件中指定语言，请使用 language 键并以`namespace/language-name`格式分配语言名称（当在配置对象中指定 `language` 时，`languageOptions` 将特定于该语言。每种语言都定义了自己的 `languageOptions`，因此请检查插件的文档以确定哪些选项可用）。如以使用`@eslint/json`中的`json/jsonc`语言来处理`*.json`文件：

```javascript
import json from "@eslint/json";
export default [
    {
        files: ["**/*.json"],
        plugins: {
            json
        },
        language: "json/jsonc"
    }
];
```



**⑧rules**，包含配置规则的对象。当指定 files 或 ignores 时，这些规则配置只对匹配的文件可用。



**⑨settings**，一个包含`名称-值对`信息的对象，所有规则都应使用这些信息。

配置共享设置：ESLint 支持将共享设置添加到配置文件中。当将 `settings` 对象添加到配置对象时，它会提供给每个规则。插件可以使用 `settings` 来指定应该在所有规则中共享的信息，特别是当添加自定义规则并希望它们能够访问相同的信息。如：

```javascript
export default [
    {
        settings: {
            sharedData: "Hello"
        },
        plugins: {
            customPlugin: { // 配置局部插件（自定义）、配置虚拟插件
                rules: {
                    "my-rule": {
                        meta: {
                            // custom rule's meta information
                        },
                        create(context) {
                            const sharedData = context.settings.sharedData;
                            return {
                                // code
                            };
                        }
                    }
                }
            }
        },
        rules: {
            "customPlugin/my-rule": "error"
        }
    }
];
```







### 可共享配置（配置）

提供**预定义**配置文件配置的模块。可共享配置可以配置配置文件中的所有相同信息，包括 plugins 和 规则。

可共享的配置通常与 plugins 一起提供；许多插件提供名称如 “recommended” 的配置，以启用其建议的起始规则集。

ESLint 有两个**预定义**的 JavaScript 配置（要安装 `@eslint/js` 包）：
①`js.configs.recommended`，启用 ESLint 建议每个人使用的规则，以避免潜在的错误。
②`js.configs.all`，启用 ESLint 附带的所有规则。

### 使用可共享的配置包

可共享配置是导出配置对象或数组的 npm 包，该包应作为项目中的依赖安装，然后从 `eslint.config.js` 文件内部引用。如：

```javascript
import exampleConfig from "eslint-config-example";
export default [
    // exampleConfig, // 在此示例中，exampleConfig 是一个对象，因此将其直接插入到配置数组中
    // ...exampleConfigs, // 在此示例中，该可共享配置将导出一个数组
    {
        rules: {
            // 。。。
        }
    }
];
```

### 级联配置对象

当多个配置对象与给定文件名匹配时，配置对象将与在发生冲突时覆盖先前对象的后续对象合并。如使用以下配置，所有 JavaScript 文件都定义了一个名为`MY_CUSTOM_GLOBAL`的自定义全局对象，而 `tests` 目录中的那些 JavaScript 文件将 `it` 和 `describe` 定义为除 `MY_CUSTOM_GLOBAL` 之外的全局对象；对于测试目录中的任何 JavaScript 文件，都会应用两个配置对象，因此将 `languageOptions.globals` 合并以创建最终结果。

```javascript
export default [
    {
        files: ["**/*.js"],
        languageOptions: {
            globals: {
                MY_CUSTOM_GLOBAL: "readonly"
            }
        }
    },
    {
        files: ["tests/**/*.js"],
        languageOptions: {
            globals: {
                it: "readonly",
                describe: "readonly"
            }
        }
    }
];
```

另外，当多个配置对象指定相同的规则时，规则配置将与后面的对象**合并**（注意，不是覆盖），优先于任何先前的对象。如：

```javascript
export default [
    {
        rules: {
            semi: ["error", "never"]
        }
    },
    {
        rules: {
            semi: "warn" // semi 的最终配置是 ["warn", "never"]
        }
    }
];
```

覆盖：当配置对象或内联配置设置新的严重性和（或）规则选项来取代先前设置的严重性和（或）选项时。如以下配置文件在`*.test.js`文件中将`no-unused-expressions`从"error"覆盖到"off"：

```json
export default [
  {
    rules: {
      "no-unused-expressions": "error"
    }
  },
  {
    files: ["*.test.js"],
    rules: {
        "no-unused-expressions": "off"
    }
  }
];
```



### 配置文件解析

当 ESLint 在命令行上运行时，它首先检查 `eslint.config.js` 的当前工作目录。如果找到该文件，则搜索停止，否则检查 `eslint.config.mjs`。如果找到该文件，则搜索停止，否则检查 `eslint.config.cjs`。
如果未找到任何文件，它将检查每个文件的父目录，直到找到配置文件或到达根目录。

可以通过在命令行上使用 `-c` 或 `--config` 选项指定备用配置文件来阻止搜索 `eslint.config.js`。



### 禁用规则（用配置注释）

要在文件的一部分（对整个文件则在文件顶部添加）中禁用规则警告，可使用以下格式的块注释：

```javascript
/* eslint-disable */
alert('foo');
/* eslint-enable */

还可以禁用或启用特定规则的警告：
/* eslint-disable no-alert, no-console */
alert('foo');
console.log('bar');
/* eslint-enable no-alert, no-console */
```

不应用规则（无论将来有任何启用/禁用行）：

```javascript
/* eslint no-alert: "off" */
alert('foo');
```

要禁用特定行上的特定规则（多个规则则用空格隔开；所有规则则直接`eslint-disable-line`），可使用以下格式之一的行或块注释：

```javascript
alert('foo'); // eslint-disable-line no-alert
或：
// eslint-disable-next-line no-alert
alert('foo');
或：
alert('foo'); /* eslint-disable-line no-alert */
或：
/* eslint-disable-next-line no-alert */
alert('foo');
```



### 调试你的配置

命令行接口参考：大多数用户使用 npx 在命令行上运行 ESLint，如`npx eslint [options] [file|dir|glob]*`。

https://eslint.nodejs.cn/docs/latest/use/command-line-interface

#### 在调试模式下运行CLI

当不确定是否读取了正确的配置文件（如同一个项目中有多个配置文件）。

操作方法：使用 `--debug` 命令行标志运行 ESLint 并传递要检查的文件，如`npx eslint --debug file.js`。
这将 ESLint 的所有调试信息输出到控制台，可以查看加载了哪个文件（搜`eslint.config.js`），如：

```bash
eslint:eslint Using file patterns: bin/eslint.js +0ms
eslint:eslint Searching for eslint.config.js +0ms
eslint:eslint Loading config from C:\Users\nzakas\projects\eslint\eslint\eslint.config.js +5ms
eslint:eslint Config file URL is file:///C:/Users/nzakas/projects/eslint/eslint/eslint.config.js +0ms
```

#### 打印文件的计算配置

当不确定为什么 linting 没有产生预期的结果，因为似乎规则配置没有被遵守，或使用了错误的语言选项。

操作方法：使用 `--print-config` 命令行标志运行 ESLint 并传递要检查的文件，如`npx eslint --print-config file.js`。
这会输出文件计算配置的JSON表示形式（注意，不会看到 `files`、`ignores` 或 `name` 的任何条目，因为它们仅用于计算最终配置，因此不会出现在结果中。而看到的是 ESLint 本身应用的任何默认配置），如：

```json
{
    "linterOptions": {
        "reportUnusedDisableDirectives": 1
    },
    "language": "@/js",
    "languageOptions": {
        "sourceType": "module",
        "ecmaVersion": "latest"
    },
    "plugins": [
        "@"
    ],
    "rules": {
        "prefer-const": 2
    }
}
```

#### 使用配置检查器

当不确定配置文件中的某些配置对象是否与给定的文件名匹配。

操作方法：使用 `--inspect-config` 命令行标志运行 ESLint 并传递要检查的文件，如`npx eslint --inspect-config`。
这将通过安装和启动 [`@eslint/config-inspector`](https://github.com/eslint/config-inspector) 来启动配置检查器，然后可以输入相关文件名来查看应用哪些配置对象。



### 配置迁移

https://eslint.nodejs.cn/docs/latest/use/configure/migration-guide

ESLint 配置文件从 eslintrc 格式（通常在 `.eslintrc.js` 或 `.eslintrc.json` 文件中配置）迁移到新的扁平配置格式（通常在 `eslint.config.js` 文件中配置）。自 ESLint v9.0.0 以来，扁平配置文件格式一直是默认配置文件格式。



### 待记笔记

https://eslint.nodejs.cn/docs/latest/rules/

https://eslint.nodejs.cn/docs/latest/flags/

https://juejin.cn/post/7402572475719827475#heading-2













