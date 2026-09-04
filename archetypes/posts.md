---
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
date: {{ .Date }}
draft: false
tags: []
categories: []
# image: "cover.jpg"  # uncomment once you add a cover.jpg in this folder
lat: 0.0
lon: 0.0
location: ""
---

Write here. Drop photos into this same folder as page resources
(any .jpg/.png files sitting next to this index.md), then show them all as a gallery with:

{{</* gallery */>}}

Or reference a single photo inline:

![alt text](photo1.jpg)
