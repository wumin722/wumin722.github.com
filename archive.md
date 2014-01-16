---
layout: default
title : 文章列表
---

<header id="header">
	<div class="header-info fix">
		<h1><a href="/">分类</a></h1>
		<p class="describe">just for fun</p>
				
	</div>
</header>
<div>
	<ul>
	{% for category in site.categories %}
	<li><a href="/category.html#{{category[0]}}">{{category[0]}} ({{category[1] | size}})</a></li>
	{% endfor %}
	</ul>
</div>

