---
layout: post
title: std::pair源码学习
summary: 最近在学习STL，经常会使用到std::pair，于是想看看std::pair到底是个什么样神奇的东西，
categories: [STL]
tags: [STL]
publish: true
---

# {{ page.title }} #
{{ page.summary }}

### std::pair的简单使用 ###
std::pair可以将两个值看做一个单元来处理。C++标准库中多处使用了std::pair，其中map和multimap就是使用std::pair来管理键/值(key/value)对的。任何函数如果返回两个值，都可以使用std::pair。下面的代码简单介绍如何std::pair  

{%highlight c++%}
#include <iostream>

int main(int argc, char *argv[])
{
    typedef std::pair<int, std::string> Student;

    //初始化pair的第一种方式 通过构造函数初始化
    Student stu_first(2011, "hahaya");

    //初始化pair的第二种方式 通过初始化成员变量初始化
    Student stu_second;
    stu_second.first = 2012;
    stu_second.second = "ToSmile";

    //初始化pair的第三种方式 通过辅助函数std::make_pair来初始化
    Student stu_third = std::make_pair(2013, "http://hahaya.github.com");

    //std::pair对象的输出
    std::cout << "number:" << stu_first.first << "\tname:" << stu_first.second << std::endl;
    std::cout << "number:" << stu_second.first << "\tname:" << stu_second.second << std::endl;
    std::cout << "number:" << stu_third.first << "\tname:" << stu_third.second << std::endl;

    return 0;
}
{%endhighlight%}
转自 [hahaya博客]: http://hahaya.github.io

