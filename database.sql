create database pythondb;
use pythondb;

-- 超级用户用户表 
drop table if exists `adminuser`;
CREATE TABLE adminuser (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL, -- 用户名
    useremail VARCHAR(100) NOT NULL, -- 用户邮箱
    userpassword VARCHAR(100) NOT NULL -- 用户密码
);
select * from adminuser;

-- 用户表 
drop table if exists `user`;
CREATE TABLE user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL, -- 用户名
    useremail VARCHAR(100) NOT NULL, -- 用户邮箱
    userpassword VARCHAR(100) NOT NULL, -- 用户密码
    usertoken varchar(100) not null,
    useravater text, -- 用户头像
    useraddress varchar(20) -- 用户ip地址
);
select * from user;