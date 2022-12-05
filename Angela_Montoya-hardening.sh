#!/bin/bash
#Angela Montoya Aldape

banner()
{
  echo "+------------------------------------------+"
  printf "| %-40s |\n" "`date`"
  echo "|                                          |"
  printf "|`tput bold` %-40s `tput sgr0`|\n" "$@"
  echo "+------------------------------------------+"
}

hola=$(hostnamectl)
banner "Revisando el sistema operativo"
if echo "$hola" | grep "CentOS"; then
        si="CentOS"
        echo $si
        sleep 5
        banner "Instalando el repositorio EPEL"
        sudo yum -y install epel-release
        sleep 5
        banner "ClamAV - Antivirus"
        checar=$(yum list installed)
        if echo "$checar" | grep 'clamav'; then
                banner "Se detectó ClamAV, se removerá"
                banner "Se detendrá el programa"
                sudo systemctl stop clamav-freshclam
                sudo yum -y remove clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd
        fi
        sleep 5
        banner "Instalando ClamAV"
        sudo yum -y install clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd
        sleep 5
        banner "Instalando actualizaciones"
        actualizar=$(sudo yum check-updates)
        long=$(echo -n $actualizar | wc -c)
        if [ "$long" -ge 215 ]; then
                echo "Hay actualizaciones pendientes"
                banner "Se instalarán las actualizaciones"
                sudo yum update
        else
                echo "No hay actualizaciones pendientes"
        fi


elif echo "$hola" | grep "Ubuntu"; then
        si="Ubuntu"
        echo $si
        sleep 5
        banner "ClamAV Antivirus"
        checar=$(apt list --installed)
        if echo $checar | grep "clamav"; then
                banner "Se detectó ClamAV, se removerá"
                banner "Se detendrá el programa"
                sudo systemctl stop clamav-freshclam
                sudo apt-get autoremove clamav clamav-daemon -y
        fi
        sleep 5
        banner "Instalando ClamAV"
        sudo apt-get install clamav clamav-daemon -y
        sleep 5
        banner "Buscando actualizaciones"
        actualizar=$(sudo apt list --upgradable)
        long=$(echo -n $actualizar | wc -c)
        if [ "$long" -ge 11 ]; then
                echo "Hay actualizaciones pendientes"
                banner "Se instalarán las actualizaciones"
                sudo apt upgrade
        else
                echo "No hay actualizaciones pendientes"
        fi
fi
