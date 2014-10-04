---
layout: post
title: debian系统配置
summary: ubuntu更新很快，难以跟上节奏。无奈使用更为基础的 debian-7 wheezy
categories: [linux]
tags: [conf]
publish: true
---
$ {{ page.title }} $
{{ page.summary }} 

由于在windows环境下用R画图或者写latex文档经常会有乱码问题，所有很早我就把数据分析之类的事情都放到linux环境下来做了。
之前一直用ubuntu（因为简单易用），倒也挺方便。但本人有个坏毛病，一定要用最新的系统。而恰巧ubuntu更新很快，我就一直不停
的删系统、装系统。所以现在决定用更新慢的debian了（实际上ubuntu就是在debian上做了更多配置）。
用启动盘（我用的是U盘）装好系统后（没有图形界面），先要设置好网络。将之前已经下好的ruijieclient（学校网络用的是锐捷认证）
拷到$PATH中任一路径下，更改其权限后执行。

	$ chmod 775 ruijieclient
	$ ruijieclient

在生成的配置文件/etc/ruijie.conf中根据说明和需要作一些更改。
接着配置源

	$ vi /etc/apt/source.list 加入源地址,推荐163网易的
同时将含有cdrom 的源注释掉 防止安装软件提示要放入cd

	$ apt-get update

将图形界面装上,桌面环境用轻巧的xfce，登录界面用slim

	$aptitude install xorg
	$aptitude install xfce4
	$aptitude install xfce4-goodies
	$aptitude install slim

在slim配置文件/etc/slim.conf中加入下列命令，以便登录是启动X11视窗系统

	login_cmd exec ck-launch-session /bin/bash -login /etc/X11/Xsession %session

配置时间

	$ hwclock -w --localtime

这时adjtime第三行会变成LOCAL，然后再用正确的时间修改系统时间：

	$ date -s 13:20:00
	$ date -s 01/08/2014

配置语言环境和时区

	$ dpkg-reconfigure locales
	$ dpkg-reconfigure tzdata

安装新立得包管理器

	$ apt-get install synaptic

输入法 fcitx   浏览器 google-chromium 用新立得安装

安装字体
将字体放入 ～/.fonts 文件夹下
微软字体在win7  C:\windows\fonts 文件夹下
将字体加入缓存

	$ fc-cache

安装微软核心字体

	$ apt-get install msttcorefonts  
	$ vim /etc/fonts/local.conf

将Arial Georgia Times New Roman Verdana 设置为主字体

系统没声音

	$ alsactl init

消除发生错误是的蜂鸣声

	$ xset b off 

自动挂载硬盘分区

	$ vim /etc/fstab

按照相应的格式填写
