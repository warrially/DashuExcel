# Excel版LUA说明文档

## 一、 如何使用

### 1. 复制`对应演示`目录下的所有文件到`bin`目录下
### 2. 直接打开`Excel.exe`查看运行效果
### 3. 如果需要长期查看，可以按住`shift`点击`鼠标右键`选择`在此处打开命令窗口`
#### 或者按住键盘上的组合键 `win+r` 输入`CMD`再回车，然后通过`cd`命令进入bin目录
#### 例如 `cd e:\DashuExcel\bin\`
### 4. 输入`Excel.exe` 启动程序


## 二、初始语法

### 1. 程序的入口脚本文件是 `main.lua` 文件
### 2. 打开 `main.lua` 文件(这里推荐Notepad++, sublime等文本编辑软件)
#### [sublime下载地址](http://rj.baidu.com/soft/detail/15554.html)
#### [notepad下载地址](http://rj.baidu.com/soft/detail/13478.html)
### 3. 在文件的开头部分写上代码
```
local TExcel = require "TExcel" -- 开头引用
```
