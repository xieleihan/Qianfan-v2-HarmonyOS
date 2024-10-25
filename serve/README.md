# FastAPI

## 运行前须知
> 请根据你的实际数据库的名称配置
> ```python
> conn = pymysql.connect(
>       host='157.122.209.70',
>       user='root',
>       passwd='123456',
>       port=51337,
>       db='pythondb',  # 数据库名称
>       charset='utf8',
>   )
> ```

**并且,请自己在`main.py`的同级目录下,新建一个`.env`文件,配置服务运行所需的环境变量**

## 接口文档

### 用户登录与注册

> #### 注册
>
> > 接口地址:`http://localhost:9001/register`
> >
> > 方法:`POST`
> >
> > 参数:`username`,`useremail`,`userpassword`
>
> #### 登录
>
> > 接口地址: `http://localhost:9001/login`
> >
> > 方法:`POST`
> >
> > 参数:`useremail`,`userpassword`
> >
> > 返回: 一个`token`

### 百度AI模型

> 接口地址:`http://localhost:9001/baiduai`
>
> 方法:`GET`
>
> 参数:`userMessage`

### 深度求索

> 接口地址:`http://localhost:9001/deepseek`
>
> 方法:`GET`
>
> 传递参数:`userMessage`

### 获取客户端的ip信息

> 接口地址:`http://localhost:9001/proxyip`
>
> 方法:`GET`

### 英汉词典

> 接口地址:`http://localhost:9001/proxy/textandtext`
>
> 方法:`GET`
>
> 参数:`query:string`

### 通用翻译

> 接口地址:`http://localhost:9001/proxy/translate`
>
> 方法:`GET`
>
> 参数:`q:string(待翻译的文本)`,`fromstr:string(从什么语言)`,`to:string(翻译到什么语言)`

### 代理请求

> 接口地址:`http://localhost:9001/proxy`
>
> 方法:`GET`
>
> 参数:`url`

