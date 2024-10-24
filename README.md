# Qianfan-v2-HarmonyOS

> 本项目
>
> 授权任何人,无论任何理由为目的的使用,授权长期有效

![Qianfan-v2-HarmonyOS](https://socialify.git.ci/xieleihan/Qianfan-v2-HarmonyOS/image?description=1&descriptionEditable=%E7%BA%AF%E8%A1%80HarmonyOS%E5%BC%80%E5%8F%91HAP%2CPython%E5%90%8E%E7%AB%AF%2CMySQL%E6%95%B0%E6%8D%AE%E6%8C%81%E4%B9%85%E5%8C%96&font=Source%20Code%20Pro&forks=1&issues=1&language=1&logo=https%3A%2F%2Favatars.githubusercontent.com%2Fu%2F57227318%3Fv%3D4&name=1&owner=1&pattern=Floating%20Cogs&pulls=1&stargazers=1&theme=Auto)

## 项目介绍

> 想做一个聚合的工具类应用,将基本常用的工具类封包进一个程式里,并且引入`deepseek`深度求索的API,做AI聊天机器人,后续可能基于深度求索的模型和`langchain`,去扩展一下这个大模型的潜力.
>
> 可以关注下深度求索`deepseek`哦🤗

## 项目技术栈

- 前端

	<div align="left">
		  <img src="https://fastly.jsdelivr.net/gh/devicons/devicon/icons/typescript/typescript-original.svg" height="45" alt="TypeScript logo"  />
		  <img width="6" />
		</div>

- 后端

	<div align="left">
		  <img src="https://fastly.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg" height="45" alt="Python logo"  />
		</div>

- 数据库

	<div align="left">
		  <img src="https://fastly.jsdelivr.net/gh/devicons/devicon/icons/mysql/mysql-original.svg" height="45" alt="MySQL logo"  />
		</div>

> 鸣谢开源项目`FastAPI`等一系列在本项目中运用到的开源技术的支持者

## 项目架构

```text
-Qianfan_v2
│─ app // 鸿蒙app项目源码
│──└ entry 
│─────└ src
│────────├ main // 主程序入口
│────────└ resources // 资源入口
│
├ serve // Python后端 
│
│─ MySQL.sql // 数据库表
│
└ README.md // 阅读文档
```

## 项目运行须知

- 鸿蒙项目:

	> 需要到华为官网下载最新的`DevEco Studio`,并且下载安装`SDK`,然后开始调试

- Python的`FastAPI`

	> 请到`serve`文件下,使用`Pycharm`,`pip`安装所有必须的包
	>
	> 然后运行
	>
	> ```sh
	> fastapi dev main.py --port 9001
	> ```
	>
	> 或者使用
	>
	> ```sh
	> uvicorn --reload --port 9001
	> ```

- 数据库

	> 请根据自己的实际情况,就行

## 项目上线

> 地址:**待上架,正在申请软著**



## 项目构建

> 时间: 2024.10.23 ~ 预计10.25停止维护
>
> 具体时间按照GitHub最后更新截止



> Copyleft © 2024
