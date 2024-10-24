from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import pymysql
import bcrypt
from typing import Optional
import logging

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
    userpassword: str
    useravater: str = None  # 可选字段，默认值为 None
    useraddress: str = None  # 可选字段，默认值为 None

class LoginRequest(BaseModel):
    username: str
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
            "INSERT INTO user (username,  userpassword, usertoken, useravater, useraddress) "
            "VALUES (%s, %s, %s, %s, %s)",
            (request.username,  hashed_password, usertoken, default_avater, default_address)
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
    cursor.execute("SELECT id, userpassword, usertoken FROM user WHERE username = %s", (request.username,))
    user = cursor.fetchone()
    if not user:
        raise HTTPException(status_code=400, detail="用户不存在")

    user_id, hashed_password, user_token = user

    # 验证密码
    if not bcrypt.checkpw(request.userpassword.encode('utf-8'), hashed_password.encode('utf-8')):
        raise HTTPException(status_code=400, detail="密码错误")

    cursor.close()

    return {"message": "登录成功", "user_id": user_id, "token": user_token,"code":200}