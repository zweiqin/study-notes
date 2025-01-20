# npm、cnpm、yarn、pnpm、npx

相关链接：https://juejin.cn/post/7326268908984352777、https://blog.csdn.net/m0_37577465/article/details/132425067、https://www.jianshu.com/p/0376fc3d9f94。



在 JavaScript 生态系统中，有多种工具可用于管理项目的依赖项。

## npm 

**npm**（Node Package Manager）：npm 是 Node.js 官方提供的包管理器，用于安装、管理和发布 JavaScript 包。它是 Node.js 安装时默认包含的工具。通过 `npm install package-name` 命令可以安装项目依赖。

npm使用**符号链接**（Symbolic Link）来创建**软链接**（Soft Link）。当使用`npm link`命令时，它会创建一个全局软链接，将全局安装的模块链接到当前项目中，从而实现模块的共享和开发环境的快速调试。



## cnpm

**cnpm**：由于 npm 的服务器位于国外，中国用户在使用 npm 时可能会遇到下载速度慢的问题。cnpm 通过将 npm 的包镜像到国内服务器，解决了这个问题。cnpm 是淘宝镜像提供的 npm 的镜像版本，用于加速国内用户对 npm 包的安装和下载速度。它是通过将 npm 的源地址配置为淘宝的源地址来实现的。与 npm 相比，使用 cnpm 可以更快地安装依赖项。



## yarn

比如某个依赖包在某个项目里？

**yarn**：yarn 是由 Facebook 开发的另一个包管理器，旨在提供更快、更可靠的依赖管理。它具有与 npm 类似的功能，但执行速度更快，并且具有一些额外的功能，例如离线模式和锁定文件。与 npm 不同，yarn 使用 `yarn add package-name` 命令来安装依赖。

Yarn也使用**符号链接**来创建**软链接**。类似于`npm link`，Yarn通过`yarn link`命令创建一个全局软链接，将全局安装的模块链接到当前项目中。



## pnpm

所有依赖包在特定的`.pnpm`目录里？

**pnpm**：pnpm 是一个快速、磁盘空间效率高的包管理器。与 npm 不同，pnpm 采用了符号链接的方式共享依赖项，因此在项目之间共享依赖时可以节省磁盘空间。pnpm 的命令与 npm 类似。

pnpm使用**硬链接**（Hard Link）来共享已安装的依赖项。当安装依赖项时，pnpm会在项目之间创建硬链接，这样相同的依赖项可以被多个项目共享，减少了磁盘空间占用和安装时间。

对于pnpm来说，当一个项目使用pnpm安装依赖项时，pnpm会将这些依赖项安装到一个称为`node_modules/.pnpm`的目录中。其他项目可以通过创建硬链接来使用这个已安装的依赖项，而无需在各自项目的`node_modules`目录中重复安装。
这种共享依赖项的机制使得多个项目可以共享相同的依赖项，但每个项目仍然需要维护自己的`package.json`文件和项目特定的配置。这样，每个项目可以独立地管理自己的开发和构建过程，而共享的依赖项保持一致，减少了重复的依赖项下载和存储消耗。这是pnpm的一项优势，可以提高项目的构建速度和整体效率。



## npx

**npx**：npx 是 npm 5.2.0 版本及以上内置的命令行工具，用于执行项目安装的依赖项中的可执行文件，`npx command-name`。它可以临时安装依赖项并运行其中的命令，而无需全局安装。

准确地说，npx 并不是一个专门的依赖管理工具，而是 npm 附带的一个命令行工具，用于临时执行项目依赖中的可执行文件。

特别适用于以下几种场景：

- **临时执行项目依赖的可执行文件：** 有时候可能需要在命令行中临时执行某个项目依赖的可执行文件，而不想全局安装这个工具。npx 可以在不污染全局环境的情况下直接运行这些可执行文件。如：`npx eslint index.js`。

- **执行最新版本的工具：** npx 可以确保运行的是最新版本的工具。当使用全局安装的工具时，可能会受限于旧版本，而 npx 可以自动下载和使用最新版本。如：`npx create-react-app my-app`。

- **尝试新的工具和库**。

- **运行一次性命令**。

### npx的执行机制

当使用 npx 执行可执行文件时，npx 会首先检查本地是否已经存在该可执行文件。如果本地已经安装了这个可执行文件（位于项目的 `node_modules/.bin` 目录中），npx 会直接运行它，而无需下载。

如果本地不存在该可执行文件，npx 会自动下载对应的包，并将其安装在一个临时目录中，然后执行该可执行文件。这意味着 npx 会在需要时临时下载所需的包，而不会将其全局安装或污染项目的依赖。

临时下载的包会被存储在一个缓存目录中，以便下次使用相同的包时可以快速加载。默认情况下，npx 使用 npm 的缓存目录作为临时下载的包的存储位置。

在执行完可执行文件后，npx 会自动删除临时下载的包，以节省磁盘空间。这意味着每次使用 npx 执行可执行文件时，它都会检查本地是否存在该包，如果不存在则临时下载，执行完后再删除。





## 对比

| 优势               | npm                                                     | cnpm                                                      | Yarn                                            | pnpm                                                         |
| ------------------ | ------------------------------------------------------- | --------------------------------------------------------- | :---------------------------------------------- | ------------------------------------------------------------ |
| 性能               | - 单线程安装和构建依赖项                                | - 采用并行安装模式，速度较快                              | - 并行安装和构建依赖项，速度较快                | - 采用硬链接来共享依赖项，减少磁盘空间占用和安装时间；<br />- 并行安装和构建依赖项，提高安装速度；<br />- 增量安装依赖项，只安装更新的部分；- 本地缓存和离线安装支持 |
| 效率               | - 较慢的重复安装速度                                    | - 较快的重复安装速度                                      | - 快速的重复安装速度                            | - 快速的重复安装速度；<br />- 较小的网络传输量               |
| 依赖大小           | - 需要保存每个包的多个实例，占用较大的磁盘空间          | - 仅保存每个包的单个实例，占用较小的磁盘空间              | - 仅保存每个包的单个实例，占用较小的磁盘空间    | - 仅保存每个包的单个实例                                     |
| 锁定文件机制       | 使用 package-lock.json                                  | 使用 package-lock.json                                    | 使用 yarn.lock                                  | 使用 pnpm-lock.yaml                                          |
| 生态系统支持       | - 庞大的生态系统和广泛的社区支持                        | - 生态系统相对较小，可能有一些包不完全支持                | - 庞大的生态系统和广泛的社区支持                | - 生态系统相对较小，但兼容 npm 生态系统                      |
| 社区支持与更新频率 | - 庞大的社区支持和活跃的更新频率                        | - 社区相对较小，更新频率较低                              | - 庞大的社区支持和活跃的更新频率                | - 社区相对较小，更新频率较低                                 |
| 安装包             | `npm install [package-name]`、`npm i [package-name]`    | `cnpm install [package-name]`、`cnpm i [package-name]`    | `yarn add [package-name]`                       | `pnpm add [package-name]`                                    |
| 全局安装包         | npm install -g [package-name]                           | cnpm install -g [package-name]                            | yarn global add [package-name]                  | pnpm add -g [package-name]                                   |
| 安装开发依赖       | npm install [package-name] --save-dev                   | cnpm install [package-name] --save-dev                    | yarn add [package-name] --dev                   | pnpm add [package-name] --save-dev                           |
| 卸载包             | `npm uninstall [package-name]`、`npm rm [package-name]` | `cnpm uninstall [package-name]`、`cnpm rm [package-name]` | `yarn remove [package-name]`                    | `pnpm remove [package-name]`                                 |
| 更新包             | npm update [package-name]                               | cnpm update [package-name]                                | yarn upgrade [package-name]                     | pnpm update [package-name]                                   |
| 查看已安装的包     | npm list                                                | cnpm list                                                 | yarn list                                       | pnpm list                                                    |
| 查看特定包的版本   | npm list [package-name]                                 | cnpm list [package-name]                                  | yarn list [package-name]                        | pnpm list [package-name]                                     |
| 初始化项目         | npm init                                                | cnpm init                                                 | yarn init                                       | pnpm init                                                    |
| 查看缓存路径       | npm config get cache                                    |                                                           | yarn cache dir；<br />缓存列表：yarn cache list | pnpm store path                                              |
| 清除缓存           | npm cache clean --force                                 |                                                           | yarn cache clean                                | pnpm store prune                                             |





## 软链接和硬链接

软链接和硬链接各有其适用的情况，没有绝对的好与坏。它们的选择取决于具体的使用场景和需求。

根据具体的使用情况，可以选择合适的链接类型。一般来说：如果需要跨越文件系统或者需要链接到目录，可以选择软链接；如果注重空间效率和性能，并且在同一文件系统内进行链接，可以选择硬链接。

**软链接的优点：**

- 跨文件系统：软链接可以跨越不同的文件系统，可以指向其它分区或磁盘上的文件或目录。

- 可读性：软链接是可读的，可以通过查看链接文件获取目标文件或目录的路径信息。

- 灵活性：软链接可以指向文件和目录，可以创建循环链接（即链接的链条形成闭环），可以链接到不存在的目标，可以链接到目录的特定子目录。

**硬链接的优点**

- 空间效率：硬链接不会额外占用磁盘空间，多个链接共享相同的数据和索引节点，节省存储空间。

- 性能：由于硬链接直接指向同一索引节点，访问硬链接文件的速度与访问目标文件相同，不需要额外的解析步骤。

- 指向目录：硬链接可以指向目录，而软链接无法直接指向目录。



## 注意事项

- 选择合适可靠的镜像源加速依赖的下载；

- 注意遵循版本号规范，确保依赖版本的稳定性；

- 避免重复安装同一个包的多个不同版本，减少磁盘占用；

- 在进行升级操作时，注意备份本地缓存，并进行测试和验证；

- 避免在过程中突然终止安装或升级操作，可能导致不完整的依赖关系和污染的缓存。





















