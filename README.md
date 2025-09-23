# Infofetch by FerociousFuture

## Descripción

`Infofetch` es un script en **Bash** que muestra información del sistema y una imagen en caracteres en la terminal. Está diseñado para ser simple, personalizable y útil, con la opción de mostrar la canción que se está reproduciendo.

---

## Características Principales

* **Información del Sistema:** Muestra tu usuario, nombre de host, sistema operativo, kernel, shell, tiempo de actividad, CPU y memoria RAM.
* **Música en Reproducción:** Si tienes `playerctl` instalado, muestra la canción actual con el título, artista y el ícono de play/pausa.
* **Visualización Atractiva:** Utiliza `chafa` para convertir una imagen personalizada en arte de caracteres, lo que le da un toque único a tu terminal.
* **Fácil de Usar:** La configuración se maneja a través de un simple archivo `config.conf` y utiliza rutas relativas, lo que lo hace muy portátil.

---

## Requisitos

* `bash` (v4 o superior)
* `chafa`
* `playerctl` (opcional, para la funcionalidad de música)
* `lsb_release` o soporte en `/etc/os-release`

### Instalación de dependencias

* Clona este repositorio en una carpeta.
* Utiliza chmod +x Dependencias.sh y luego ejecutalo para instalar todas las dependencias automaticamente.
* Agrega el script a la configuración por defecto de tu terminal para inicarlo cada vez que abras una terminal.

