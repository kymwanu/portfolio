#!/bin/bash

# Build do Flutter Web
flutter build web

# Deploy para GitHub Pages
git add build/web
git commit -m "Deploy Flutter Web"
git subtree push --prefix build/web origin gh-pages
