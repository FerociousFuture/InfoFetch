#!/bin/bash

# Carpeta donde está este script
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Ruta al archivo de configuración
CONFIG_FILE="$SCRIPT_DIR/config.conf"

# Cargar config si existe
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"

# Valores por defecto si no están definidos en config.conf
: "${IMG:=$SCRIPT_DIR/icon.png}"
: "${COLOR_CODE:=34}"
: "${SIZE:=32x32}"

# Si la imagen no existe, crear un placeholder simple
if [ ! -f "$IMG" ]; then
  echo "¡Advertencia! No se encontró la imagen $IMG, usando placeholder."
  PLACEHOLDER="$SCRIPT_DIR/placeholder.png"
  # Creamos un pequeño bloque PNG negro como placeholder
  convert -size 32x32 xc:black "$PLACEHOLDER" 2>/dev/null || echo "No se pudo generar placeholder"
  IMG="$PLACEHOLDER"
fi

# Convierte la imagen en caracteres (bloques)
mapfile -t img_lines < <(chafa "$IMG" --size=$SIZE --fill=block 2>/dev/null || echo "No se pudo generar la imagen")

# Datos del sistema
memoria=$(free -h | awk '/Mem:/ {print $3 " / " $2}')
cpu=$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | sed 's/^ //')
arch=$(uname -m)
runtime=$(echo "$SHELL")
uptime_info=$(uptime -p)

# Detecta nombre del sistema operativo
if command -v lsb_release >/dev/null 2>&1; then
  so=$(lsb_release -d | cut -f2)
elif [ -f /etc/os-release ]; then
  so=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
else
  so=$(uname -o)
fi

# Detecta Musica (requiere playerctl)
musica_line=""
if command -v playerctl >/dev/null 2>&1; then
  status=$(playerctl status 2>/dev/null)
  if [ "$status" = "Playing" ]; then
    cancion=$(playerctl metadata --format "{{title}} - {{artist}}" 2>/dev/null)
    musica_line="Música:    ▶ $cancion"
  elif [ "$status" = "Paused" ]; then
    cancion=$(playerctl metadata --format "{{title}} - {{artist}}" 2>/dev/null)
    musica_line="Música:    ⏸ $cancion"
  fi
fi

# Lineas de info que se muestran a la derecha
info_lines=(
  "Usuario:    $USER"
  "Host:       $(hostname)"
  "SO:         $so ($arch)"
  "Kernel:     $(uname -r)"
  "Shell:      $runtime"
  "Uptime:     $uptime_info"
  "CPU:        $cpu"
  "Memoria:    $memoria"
)

# Agrega música solo si aplica
[ -n "$musica_line" ] && info_lines+=("$musica_line")

# titulo ASCII (Deberia poder cambiarse)
read -r -d '' ascii_title <<'EOF'
▄▖  ▐▘  ▄▖  ▗   ▌ 
▐ ▛▌▜▘▛▌▙▖█▌▜▘▛▘▛▌
▟▖▌▌▐ ▙▌▌ ▙▖▐▖▙▖▌▌                                                                      
EOF

mapfile -t ascii_lines <<< "$ascii_title"

gap="     "

# Calcular espacio necesario (ascii + 2 líneas vacias + specs)
img_height=${#img_lines[@]}
ascii_height=${#ascii_lines[@]}
info_height=${#info_lines[@]}
total_height=$((ascii_height + 2 + info_height))

# Colorea el titulo de cada línea de specs
color_title() {
  local text="$1"
  local title="${text%%:*}:"
  local value="${text#*: }"
  echo -e "\033[1;${COLOR_CODE}m${title}\033[0m ${value}"
}

printf "\n\n"

# Dibuja imagen y datos (specs)
for ((i=0; i<img_height || i<total_height; i++)); do
  img="${img_lines[i]}"
  right=""
  
  if (( i < ascii_height )); then
    right="${ascii_lines[i]}"
  elif (( i == ascii_height || i == ascii_height + 1 )); then
    right=""
  elif (( i - ascii_height - 2 < info_height )); then
    idx=$((i - ascii_height - 2))
    line="${info_lines[idx]}"
    right=$(color_title "$line")
  fi

  printf "%-30s%s%s\n" "$img" "$gap" "$right"
done

printf "\nBy FerociousFuture\n"

