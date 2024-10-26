from fastapi import FastAPI, HTTPException, Depends,File, Response
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from dotenv import load_dotenv
from httpx_socks import AsyncProxyTransport
from typing import Optional
from openai import OpenAI

import httpx
import pymysql
import bcrypt
import logging
import os
import hashlib
import urllib.parse

def get_md5_hash(input_string: str) -> str:
    # 创建md5对象
    md5 = hashlib.md5()

    # 更新要加密的字符串（需要先编码成字节形式）
    md5.update(input_string.encode('utf-8'))

    # 获取加密后的十六进制表示
    return md5.hexdigest()

# 加载环境变量
load_dotenv(dotenv_path=".env")

# 获取百度 API 的 AK 和 SK
AK = os.getenv("AK")
SK = os.getenv("SK")
translateappid = os.getenv("translateappid")
translatepassword = os.getenv("translatepassword")
deepseek_api_key = os.getenv("deepseek_api_key")
deepseek_base_url = os.getenv("deepseek_base_url")
tianapitranslatekey = os.getenv("tianapitranslatekey")
qweather_api_key = os.getenv("qweather_api_key")

print(AK,SK,translateappid,translatepassword,deepseek_api_key,deepseek_base_url,tianapitranslatekey,qweather_api_key)

# 创建深度求索的配置
client = OpenAI(api_key=deepseek_api_key, base_url=deepseek_base_url)

# 创建 SOCKS 代理传输
proxy_transport = AsyncProxyTransport.from_url("socks4://192.168.1.1:1080")

# 定义数据库连接的依赖项
def get_db_connection():

    # 创建新的数据库连接
    conn = pymysql.connect(
        host='157.122.209.70',
        user='root',
        passwd='123456',
        port=51337,
        db='pythondb',  # 数据库名称
        charset='utf8',
    )
    try:
        # 返回连接对象
        yield conn
    finally:
        # 请求结束时关闭连接
        conn.close()

app = FastAPI()

origins = [
    "*"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": "Hello World"}

# 定义请求体的数据模型
class RegisterRequest(BaseModel):
    username: str
    useremail: str
    userpassword: str
    useravater: str = None  # 可选字段，默认值为 None
    useraddress: str = None  # 可选字段，默认值为 None

class LoginRequest(BaseModel):
    useremail: str
    userpassword: str

# 用户注册
@app.post("/register")
async def register_user(request: RegisterRequest,conn=Depends(get_db_connection)):
    logging.info(f"Received request data: {request}")
    cursor = conn.cursor()

    # 检查用户名是否已存在
    cursor.execute("SELECT COUNT(*) FROM user WHERE username = %s", (request.username,))
    if cursor.fetchone()[0] > 0:
        raise HTTPException(status_code=400, detail="用户名已存在")

    # 检查邮箱是否已存在
    cursor.execute("SELECT COUNT(*) FROM user WHERE useremail = %s", (request.useremail,))
    if cursor.fetchone()[0] > 0:
        raise HTTPException(status_code=400, detail="邮箱已存在")

    # 加密密码
    hashed_password = bcrypt.hashpw(request.userpassword.encode('utf-8'), bcrypt.gensalt())

    # 设置默认的头像和地址
    default_avater = '/public/avater.jpg' if request.useravater is None else request.useravater
    default_address = '0.0.0.0' if request.useraddress is None else request.useraddress

    # 生成用户令牌
    usertoken = bcrypt.gensalt().decode('utf-8')

    # 插入新用户
    try:
        cursor.execute(
            "INSERT INTO user (username, useremail, userpassword, usertoken, useravater, useraddress) "
            "VALUES (%s, %s, %s, %s, %s, %s)",
            (request.username, request.useremail, hashed_password, usertoken, default_avater, default_address)
        )
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail="注册失败")
    finally:
        cursor.close()

    return {"message": "注册成功","code": 200}

# 用户登录
@app.post("/login")
async def login_user(request: LoginRequest,conn=Depends(get_db_connection)):
    cursor = conn.cursor()

    # 检查用户名是否存在
    cursor.execute("SELECT id, userpassword, usertoken FROM user WHERE useremail = %s", (request.useremail,))
    user = cursor.fetchone()
    if not user:
        raise HTTPException(status_code=400, detail="用户不存在")

    user_id, hashed_password, user_token = user

    # 验证密码
    if not bcrypt.checkpw(request.userpassword.encode('utf-8'), hashed_password.encode('utf-8')):
        raise HTTPException(status_code=400, detail="密码错误")

    cursor.close()

    return {"message": "登录成功", "user_id": user_id, "token": user_token,"code":200}

# 代理请求
@app.get("/proxy")
async def proxy(url: str):
    try:
        # 发送请求到目标 URL
        async with httpx.AsyncClient() as client:
            response = await client.get(url)

        return {
            "code": 200,
            "data": response.json()  # 返回响应的JSON
        }
    except Exception as e:
        print(f"Error occurred while fetching data: {str(e)}")
        raise HTTPException(status_code=500, detail="Error occurred while fetching data")

# 翻译
@app.get("/proxy/translate")
async def proxytranslate(q:str,fromstr:str,to:str):
    try:
        print("传递来的参数:",q)
        formatText = q.replace(" ", "\n")
        print("格式化query",formatText)
        url_encoded_text = urllib.parse.quote(formatText)
        print("对query进行处理:",url_encoded_text)
        signstr = f"{translateappid}{formatText}123456{translatepassword}"
        print("签名前文本:",signstr)
        sign = get_md5_hash(signstr)
        print("签名:",sign)

        # 构建目标 URL
        url = f"https://fanyi-api.baidu.com/api/trans/vip/translate?q={url_encoded_text}&from={fromstr}&to={to}&appid={translateappid}&salt=123456&sign={sign}"
        print("发送的翻译url",url)
        # 发送请求到目标 URL
        async with httpx.AsyncClient() as client:
            response = await client.get(url)

        return {
            "code": 200,
            "data": response.json()  # 返回响应的JSON
        }
    except Exception as e:
        print(f"Error occurred while fetching data: {str(e)}")
        raise HTTPException(status_code=500, detail="Error occurred while fetching data")

# 英汉词典
@app.get("/proxy/textandtext")
async def textandtext(query:str):
    try:
        url = f"https://apis.tianapi.com/enwords/index?key={tianapitranslatekey}&word={query}"

        # 发送请求到目标 URL
        async with httpx.AsyncClient() as client:
            response = await client.get(url)

        return {
            "code": 200,
            "data": response.json()  # 返回响应的JSON
        }
    except Exception as e:
        print(f"Error occurred while fetching data: {str(e)}")
        raise HTTPException(status_code=500, detail="Error occurred while fetching data")

# 获取客户端的IP
@app.get("/proxyip")
async def proxy_ip():
    try:
        # 获取 IP 信息
        # 内地：'https://myip.ipip.net/json'
        # 香港：'https://ipapi.co/json/'
        url = 'https://myip.ipip.net/json'

        # 不使用代理发送请求
        async with httpx.AsyncClient(proxies=None) as client:
            response = await client.get(url)

        # 检查请求是否成功
        if response.status_code == 200:
            return {
                "code": 200,
                "data": response.json()  # 返回 JSON 格式的数据
            }
        else:
            return {
                "code": response.status_code,
                "message": "Failed to fetch data"
            }

    except Exception as e:
        print(f"Error occurred while fetching data: {str(e)}")
        return {
            "code": 500,
            "message": "ERROR"
        }

# 来源IP查询https://apis.tianapi.com/ipquery/index
@app.get("/proxy/nginx")
async def proxy_ip():
    try:
        # 获取 IP 信息
        # 内地：'https://myip.ipip.net/json'
        # 香港：'https://ipapi.co/json/'
        url = f'https://apis.tianapi.com/ipquery/index?full=1&key={tianapitranslatekey}'

        # 不使用代理发送请求
        async with httpx.AsyncClient(proxies=None) as client:
            response = await client.get(url)

        # 检查请求是否成功
        if response.status_code == 200:
            return {
                "code": 200,
                "data": response.json()  # 返回 JSON 格式的数据
            }
        else:
            return {
                "code": response.status_code,
                "message": "Failed to fetch data"
            }

    except Exception as e:
        print(f"Error occurred while fetching data: {str(e)}")
        return {
            "code": 500,
            "message": "ERROR"
        }

# 获取图片静态资源
# 天气 https://devapi.qweather.com/v7/weather/24h?{查询参数}  24小时逐小时预报
@app.get("/proxy/weather")
async def proxy_weather(location:str):
    try:
        print(f"{location}")
        url = f'https://devapi.qweather.com/v7/weather/24h?key={qweather_api_key}&location={location}'

        # 不使用代理发送请求
        async with httpx.AsyncClient(proxies=None) as client:
            response = await client.get(url)

        # 检查请求是否成功
        if response.status_code == 200:
            return {
                "code": 200,
                "data": response.json()  # 返回 JSON 格式的数据
            }
        else:
            return {
                "code": response.status_code,
                "message": "Failed to fetch data"
            }

    except Exception as e:
        print(f"Error occurred while fetching data: {str(e)}")
        return {
            "code": 500,
            "message": "ERROR"
        }


# 获取百度 AI 的 Access Token
async def get_access_token():
    url = f"https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id={AK}&client_secret={SK}"
    async with httpx.AsyncClient(proxies=None) as client:
        response = await client.post(url)
        response_data = response.json()
        if response.status_code == 200 and "access_token" in response_data:
            return response_data["access_token"]
        else:
            raise HTTPException(status_code=500, detail="Failed to obtain access token")

# 请求百度 AI 语言模型的接口
@app.get("/baiduai")
async def baidu_ai(userMessage: str):
    try:
        # 获取 Access Token
        access_token = await get_access_token()

        # 构建请求数据
        url = f"https://aip.baidubce.com/rpc/2.0/ai_custom/v1/wenxinworkshop/chat/yi_34b_chat?access_token={access_token}"
        headers = {
            "Content-Type": "application/json"
        }
        data = {
            "messages": [
                {
                    "role": "user",
                    "content": userMessage
                }
            ]
        }

        # 发送请求到百度 AI
        async with httpx.AsyncClient(proxies=None) as client:
            response = await client.post(url, headers=headers, json=data)
            if response.status_code == 200:
                return response.json()
            else:
                raise HTTPException(status_code=response.status_code, detail="Error communicating with the language model")

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error communicating with the language model: {str(e)}")

# 请求深度求索的模型
@app.get("/deepseek")
async def deepseek(userMessage: str):
    try:
        response = client.chat.completions.create(
            model="deepseek-chat",

            messages=[
                {"role": "user", "content": f"{userMessage}"},
            ],
            # 可以调为流式输出
            stream=False
        )
        print(response.choices[0].message.content)
        if(response != ''):
            return {"result":response.choices[0].message.content}
        else:
            return {"code":404,"message":"没有返回信息"}

    except Exception as e:
        print(f"Error occurred while fetching data: {str(e)}")
        return {
            "code": 500,
            "message": "ERROR"
        }