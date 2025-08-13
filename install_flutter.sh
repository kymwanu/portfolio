#!/bin/bash

# Instalar Flutter
echo "🔹 Baixando Flutter SDK..."
git clone -b stable https://github.com/flutter/flutter.git --depth 1
export PATH="$PATH:$(pwd)/flutter/bin"


# Confirmar versão
flutter --version

# Rodar build do Flutter Web
flutter build web --release
