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