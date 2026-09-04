---
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
date: {{ .Date }}
draft: false
categories: []
# image: "cover.jpg"  # cover.jpg in diesen Ordner legen, dann Zeile aktivieren
lat: 0.0
lon: 0.0
location: ""
---

Hier schreiben. Fotos einfach in diesen Ordner legen (alle .jpg/.png-Dateien
neben dieser index.md), dann als Galerie anzeigen mit:

{{</* gallery */>}}

Oder ein einzelnes Foto direkt einbinden:

![Alt-Text](photo1.jpg)
