#!/bin/bash

# dependencias.sh
# Script para instalar las dependencias de Infofetch
# Uso: sudo ./dependencias.sh

set -e

echo "==> Detectando sistema operativo..."

# Detectar gestor de paquetes
if command -v dnf >/dev/null 2>&1; then
    PKG_MANAGER="dnf"
    INSTALL_CMD="dnf install -y"
    DISTRO="Fedora/RHEL"
elif command -v apt >/dev/null 2>&1; then
    PKG_MANAGER="apt"
    INSTALL_CMD="apt install -y"
    DISTRO="Debian/Ubuntu"
else
    echo "❌ No se detectó ni dnf ni apt. Instala manualmente las dependencias."
    exit 1
fi

echo "==> Sistema detectado: $DISTRO"
echo "==> Gestor de paquetes: $PKG_MANAGER"

# Dependencias principales
DEPENDENCIAS=(chafa playerctl)

# Solo en Debian/Ubuntu se necesita lsb-release
if [ "$DISTRO" = "Debian/Ubuntu" ]; then
    DEPENDENCIAS+=(lsb-release)
fi

echo "==> Instalando dependencias: ${DEPENDENCIAS[*]}"

$INSTALL_CMD "${DEPENDENCIAS[@]}"

echo "✅ Instalación completada."
echo "Ahora ya puedes usar Infofetch sin problemas."

