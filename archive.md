---
layout: default
title : 文章分类
summary: 
---

<br/>
<br/>
<div id="category" class="container">
	<ul>
	{% for category in site.categories %}
	<li><a href="/category.html#{{category[0]}}">{{category[0]}} ({{category[1] | size}})</a></li>
	{% endfor %}
	</ul>
</div>

