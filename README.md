# React Native 示例项目

本项目是一个简单的词典查询 APP，单词的详细解释页通过 React Native 进行实现。



## 安装步骤

- 在项目根目录中执行以下脚本：

```shell
brew install watchman // 先要安装 homebrew
npm install -g react-native-cli
npm install -g react-devtools // 调试工具
brew install yarn
yarn add react-native
yarn add react@16.8.3 // 上一步安装时会提示需要的 React 版本
yarn add @babel/core
```



- 进入 ios 子目录，执行脚本安装 cocoapods 依赖：`pod install`



## 调试步骤

- 运行命令： `npm start`
- 模拟器调试：打开新的终端窗口，运行命令 `react-native run-ios`.
- 真机调试：在 Xcode 中直接运行即可。



## React Native 加载点

在 `WordSearchViewController` 类的 `tableView:didSelectRowAtIndexPath:` 方法中，通过创建 `RCTRootView` 视图加载 React Native 渲染内容。

