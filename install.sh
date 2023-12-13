#!/bin/bash

# Lista de paquetes a instalar
apt update && apt upgrade -y

packages=(
    "nodejs"
    "golang"
    "ruby"
    "openjdk-17"
    "sqlite"
    "octave"
    "php"
    "python"
    "python2"
    "python3"
    "nano"
    "vim"
    "tmux"
    "micro"
    "perl"
    "git"
    "wget"
    "curl"
    "proot"
    "cmatrix"
    "sl"
    "cowsay"
    "figlet"
    "jp2a"
    "openssl"
    "openssh"
    "util-linux"
    "toilet"
    "fontconfig-utils"
    "x11-repo"
    "aterm"
)

# Agregar las librerías de Python
python_libraries=(
    "setuptools"
    "toilet"
    "cython"
    "tqdm"
    "alive-progress"
    "requests"
    "colorama"
    "pyfiglet"
)

declare -A started_packages  # Array asociativo para mantener un registro de los paquetes iniciados
declare -A completed_packages  # Array asociativo para mantener un registro de los paquetes completados
clear
echo -e "\n *** (Herramientas de desarrollo y librerías de Python) ***\n"

# Iterar sobre la lista de paquetes
for package in "${packages[@]}"
do
    pkg install -y $package > /dev/null 2>&1 &
    started_packages[$package]=$!  # Almacena el ID del proceso en el array asociativo
    echo "[+] $package - Iniciado"
done

# Esperar a que todos los procesos en segundo plano finalicen
for package in "${!started_packages[@]}"
do
    wait ${started_packages[$package]} && completed_packages[$package]=1 || completed_packages[$package]=0
done
clear
# Instalación de librerías de Python
echo -e "\n*** Instalando librerías de Python ***\n"
for lib in "${python_libraries[@]}"
do
    pip install -q $lib > /dev/null 2>&1 &
    started_packages[$lib]=$!  # Almacena el ID del proceso en el array asociativo
    echo "[+] $lib - Iniciado"
done

# Esperar a que todos los procesos en segundo plano finalicen
for lib in "${!started_packages[@]}"
do
    wait ${started_packages[$lib]} && completed_packages[$lib]=1 || completed_packages[$lib]=0
done


echo -e "\n *** (Herramientas de desarrollo y librerías de Python) ***\n"

# Mostrar mensaje [✓] o [!] por paquete
for package in "${!completed_packages[@]}"
do
    if [ ${completed_packages[$package]} -eq 1 ]; then
        echo "[✓] $package - Instalado"
    else
        echo "[!] $package - No se pudo instalar"
    fi
done

# Mostrar mensaje [✓] o [!] por librería de Python
for lib in "${!completed_packages[@]}"
do
    if [ ${completed_packages[$lib]} -eq 1 ]; then
        echo "[✓] $lib - Instalado"
    else
        echo "[!] $lib - No se pudo instalar"
    fi
done
