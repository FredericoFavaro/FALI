#!/bin/bash

#-----------------------------------------------#
#                   VARIAVEIS                   #
#-----------------------------------------------#
editor=nano
#timezone=$(curl -s https://ipapi.co/timezone)
idioma="en_US.UTF-8 UTF-8"
teclado=us
if [ -e /sys/firmware/efi ]; then
    bootefi=/efi
else
    bootefi=/boot
fi
root=false
root_partition=none
root_filesys=none
swap=false
swap_partition=none
home=false
home_partition=none
home_filesys=none
boot=false
boot_partition=none
boot_filesys=none


#-----------------------------------------------#
#                    FUNCOES                    #
#-----------------------------------------------#

### Titulo
title () {
            clear
        echo ""
        echo -e "                 ███████  █████  ██      ██"
        echo -e "                 ██      ██   ██ ██      ██"
        echo -e "                 █████   ███████ ██      ██"
        echo -e "                 ██      ██   ██ ██      ██"
        echo -e "                 ██      ██   ██ ███████ ██" 
        echo -e "                 \e[1mFred's Arch Linux Instaler\e[0m"
        echo ""
        # 60 caracteres maximo
        echo -e "\e[1;7m$1\e[0m"
        echo ""
}

### Mensagem de erro
errormsg () {
    echo ""
    echo -e "\e[31;1mERRO: '$1' é uma opção inválida! \e[0m"
    echo -e "\e[1mTente novamente\e[0m"
    sleep 2
}


### Menu principal
menu () {
    while true; do
        title "                            Menu                            "
        echo -e "      \e[1m1\e[0m - Editor de Texto     [\e[1;32m $editor \e[0m]"
        echo -e "      \e[1m2\e[0m - Localização         [\e[1;32m $timezone \e[0m]"
        echo -e "      \e[1m3\e[0m - Idioma do sistema   [\e[1;32m $idioma \e[0m]"
        echo -e "      \e[1m4\e[0m - Teclado             [\e[1;32m $teclado \e[0m]"
        echo -e "      \e[1m5\e[0m - Mirrorlist"
        echo -e "      \e[1m6\e[0m - Particionamento"
        echo -e "      \e[1m7\e[0m - Instalação"
        echo -e "      \e[1m8\e[0m - Configurar sistema"
        echo -e ""        
        echo -e "      \e[1m0\e[0m - Sair"
        echo -e ""
        echo -e "      \e[1mInforme uma opção:\e[0m"
        read -s -n 1 op_menu
        case "$op_menu" in
            1)
                editor_texto
                ;;
            2)
                localizacao
                ;;
            3)
                idioma_sys
                ;;
            4)
                keyboard
                ;;
            5)
                mirrorlist
                ;;
            6)
                particionamento
                ;;                
            7)
                instalacao
                ;;
            8)
                config
                ;;                            
            0)
                echo ""
                echo "Saindo..."
                sleep 2
                clear
                break
                ;;
            *)
                echo ""
                errormsg "'$op_menu' é uma opção inválida!"
        esac
    done
}

### Selecao do editor de texto (padrao: nano)
editor_texto () {
    while true; do
        title "                       Editor de texto                      "
        echo -e "      \e[1m1\e[0m - Nano"
        echo -e "      \e[1m2\e[0m - VIM"
        echo ""
        echo -e "      \e[1m0\e[0m - Voltar"
        echo ""
        echo -e "      \e[1mInforme uma opção:\e[0m"
        read -s -n1 op_editor
        case "$op_editor" in
            1)
                editor=nano
                echo ""
                echo -e "      Definindo \e[1mNano\e[0m como editor de texto padrão!"
                sleep 2
                break
                 ;;
            2)
                editor=vim
                echo ""
                echo -e "      Definindo \e[1mVIM\e[0m como editor de texto padrão!"
                sleep 2
                break
                ;;
            0)
                break
                ;;
            *)
                echo""
                errormsg "'$op_editor' é uma opção inválida!"
            esac
    done
}

### Selecao da timezone (padrao: localizado pelo IP)
localizacao () {
    while true; do
        clear
        title "                         Localização                        "

        echo -e "      \e[1m1\e[0m - Automático (Baseado IP)"
        echo -e "      \e[1m2\e[0m - Manual"
        echo ""
        echo -e "      \e[1m0\e[0m - Voltar"
        echo ""
        echo -e "      \e[1mInforme uma opção:\e[0m"
        read -s -n1 op_timezone
        case "$op_timezone" in
            1)
                timezone=$(curl -s https://ipapi.co/timezone)
                echo ""
                echo -e "Definindo \e[1m$timezone\e[0m como sua localização atual!"
                sleep 2
                break
                ;;
            2)
                timezone_manual
                ;;
            0)
                clear
                break
                ;;
            *)
                errormsg "'$op_timezone' é uma opção inválida!"
        esac
    done
}

### Selecao da timezone manual
timezone_manual () {
    while true; do 
        clear
        title "                    Localização / Manual                    "
        echo -e "Digite uma localização (\e[1mZona/Subzona\e[0m) ou 0 para sair: "
        echo "ex: America/Sao_Paulo"
        echo ""
        read fuso
        if [[ $fuso == 0 ]]; then
            break
        else
            if ! timedatectl list-timezones | grep -ix > /dev/null 2>&1 $fuso; then
                errormsg "'$fuso' é uma opção inválida!"
            else
                timezone=$fuso
                echo ""
                echo -e "Definindo \e[1m$timezone\e[0m como sua localização atual!"
                sleep 2
                break
            fi
        fi
    done
}

### Selecao do idioma do sistema (padrao: us)
idioma_sys () {
    while true; do
        clear
        title "                     Idioma do Sistema                      "
        echo -e "      \e[1m1\e[0m - Inglês (en_US.UTF-8)"
        echo -e "      \e[1m2\e[0m - Português (pt_BR.UTF-8)"
        echo ""
        echo -e "      \e[1m0\e[0m - Voltar"
        read -s -n1 op_idioma
        case "$op_idioma" in
            1)
                locale-gen > /dev/null 2>&1
                export LANG=en_US.UTF-8 > /dev/null 2>&1
                idioma="en_US.UTF-8 UTF-8"
                echo ""
                echo -e "Definindo \e[1m$idioma\e[0m como idoma do sistema!"
                sleep 2
                break
                ;;
            2)
                sed -i "s/#pt_BR.UTF-8/pt_BR.UTF-8/" /etc/locale.gen
                locale-gen > /dev/null 2>&1
                export LANG=pt_BR.UTF-8 > /dev/null 2>&1
                idioma="pt_BR.UTF-8 UTF-8"
                echo ""
                echo -e "Definindo \e[1m$idioma\e[0m como idoma do sistema!"
                sleep 2
                break
                ;;
            0)
                clear
                break
                ;; 
            *)
                errormsg $op_idioma
        esac
    done
}

### Selecao do layout do teclado (padrao: us)
keyboard () {
    while true; do
        clear
        title "                          Teclado                           "
        echo -e "      \e[1m1\e[0m - us"
        echo -e "      \e[1m2\e[0m - br-abnt"
        echo -e "      \e[1m3\e[0m - br-abnt2"
        echo -e "      \e[1m4\e[0m - outro"
        echo ""
        echo -e "      \e[1m0\e[0m - Voltar"
        read -s -n1 op_keyboard
        case "$op_keyboard" in
            1)
                loadkeys us
                teclado=us
                echo ""
                echo -e "Definindo \e[1m$teclado\e[0m como layout de teclado!"
                sleep 2
                break
                ;;
            2)
                loadkeys br-abnt
                teclado=br-abnt
                echo ""
                echo -e "Definindo \e[1m$teclado\e[0m como layout de teclado!"
                sleep 2
                break
                ;; 
            3)
                loadkeys br-abnt2
                teclado=br-abnt2
                echo ""
                echo -e "Definindo \e[1m$teclado\e[0m como layout de teclado!"
                sleep 2
                break
                ;;
            4) 
                keyboard_outro
                ;; 
            0)
                clear
                break
                ;; 
            *)
                errormsg $op_keyboard
        esac
    done
}

keyboard_outro () {
    while true; do
    clear
    title "                      Teclado / Outro                       "
    echo "Digite o layout de teclado ou 0 para sair: "
    read x
        if [[ $x == 0 ]]; then
            break
        elif ! localectl list-keymaps | grep -ix > /dev/null 2>&1 $x; then
            errormsg $x
        else
            loadkeys $x
            teclado=$x
            echo ""
            echo -e "Definindo \e[1m$teclado\e[0m como layout de teclado!"
            sleep 2
            break
        fi
    done
}

### Configuracao do mirrorlist (padrao: original do sistema)
mirrorlist () {
    while true; do
        clear
        title "                         Mirrorlist                         "
        echo -e "      \e[1m1\e[0m - Original"
        echo -e "      \e[1m2\e[0m - Ranquear os mais rápidos"
        echo -e "      \e[1m3\e[0m - Manual"
        echo ""
        echo -e "      \e[1m0\e[0m - voltar"
        read -s -n1 op_mirror
        case "$op_mirror" in
            1)
                cp /etc/pacman.d/mirrorlist.original /etc/pacman.d/mirrorlist
                echo ""
                echo -e "\e[1m$Mirrorlist gerada com sucesso!\e[0m$"
                sleep 2
                break
                ;;
            2)
                pacman -Sy --needed --noconfirm pacman-contrib  > /dev/null 2>&1
                echo ""
                echo "Testando a velocidade dos mirrors..."
                echo "Esse processo pode levar alguns minutos!"
                rankmirrors -n 10 /etc/pacman.d/mirrorlist.original > /etc/pacman.d/mirrorlist
                echo -e "\e[1m$Mirrorlist gerada com sucesso!\e[0m$"
                sleep 2
                break
                ;;
            3)
                cp /etc/pacman.d/mirrorlist.original /etc/pacman.d/mirrorlist
                $editor /etc/pacman.d/mirrorlist
                echo ""
                echo -e "\e[1m$Mirrorlist gerada com sucesso!\e[0m$"
                sleep 2
                break
                ;;
            0)
                clear
                break
                ;; 
            *)
                errormsg $op_mirror
        esac
    done
}

### Criação e montagem das partições

particionamento () {
    while true; do
        clear
        title "                       Particionamento                      "
        echo -e "      \e[1m1\e[0m - Visualizar tabela de partição"
        echo -e "      \e[1m2\e[0m - Modificar tabela de partição"
        echo -e "      \e[1m3\e[0m - Montar/formatar partições"
        echo ""
        echo -e "      \e[1m0\e[0m - Voltar"
        read -s -n1 op_particao
        case "$op_particao" in
            1)
                tabela_particao
                ;;
            2)
                modificar_tabela_particao
                ;;
            3)
                ponto_montagem
                ;;
            0)
                break
                ;;
            *)
                errormsg $op_particao
        esac
    done
}

tabela_particao () {
    clear
    title "                     Tabela de Partição                     "
    echo -e "\e[1mNOME  TAMANHO TIPO PONTO DE MONTAGEM\e[0m"
    lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | grep sd
    echo ""
    read -n1 -s -r -p "Aperte qualquer tecla para voltar."
}

modificar_tabela_particao () {
    while true; do
        clear
        title "       Particionamento / Modificar tabela de partição       "
        declare -a dispositivos=();
        mapfile -t dispositivos < <(lsblk -d -n -l -o NAME | grep "sd.");
        option=0
        cont=0
        for dispositivo in ${dispositivos[@]}; do # Cria uma string com os valores do case baseado no range de $dispositivos
            cont=$(($cont + 1))
            echo -e "      \e[1m$cont\e[0m - $dispositivo"
            option+="|$cont"
        done
        echo ""
        echo -e "      \e[1m0\e[0m - Voltar"
        read -s -n1 op_dispositivo
        eval "case \"$op_dispositivo\" in
            $option)
                op_modificar_dispositivo
                break
                ;;
            *)
                errormsg $op_dispositivo
                ;;
        esac"
    done
}

op_modificar_dispositivo () {
    if [ $op_dispositivo != 0 ]; then
        echo ""
        echo -e "Disco selecionado: \e[1m${dispositivos[$op_dispositivo-1]}\e[0m";
        echo -e "Executando \e[1mcfdisk /dev/${dispositivos[$op_dispositivo-1]}\e[0m"
        sleep 2
        cfdisk /dev/${dispositivos[$op_dispositivo-1]}
    fi
}

ponto_montagem () {
    while true; do
    clear
    title "         Particionamento / Montar/formatar partições        "
    pontos=(/ $bootefi /home swap)
    echo -e "      \e[1mSelecione um ponto de montagem: \e[0m"
    echo ""
    cont=0
    for ponto in ${pontos[@]}; do
        cont=$(($cont + 1))
        echo -e "      \e[1m$cont\e[0m - $ponto"
    done
    echo ""
    echo -e "      \e[1m0\e[0m - Voltar"
    read -s -n1 op_ponto
    case $op_ponto in
        1|2|3|4)
            partition ${pontos[$op_ponto-1]}
            ;;
        0)
            break
            ;;
        *)
            errormsg $op_ponto
        esac
    done
}

partition () {
    while true; do
        clear
        title "         Particionamento / Montar/formatar partições        "
        echo -e "      \e[1mSelecione uma partição para montar o $1\e[0m:"
        echo ""
        declare -a particoes=();
        mapfile -t particoes < <(lsblk -n -l -o NAME | grep "sd..");
        option=0
        cont=0
        for particao in ${particoes[@]}; do
            cont=$(($cont + 1))
            echo -e "      \e[1m$cont\e[0m - $particao"
            option+="|$cont"
        done
        echo "$option"
        echo ""
        echo -e "      \e[1m0\e[0m - Voltar"
        read -s -n1 op_particao
        eval "case \"$op_particao\" in
            $option)
                    if [[ $op_ponto == 4 ]]; then
                        echo ""
                        echo -e "Swap sera montado em ${particoes[op_particao-1]}"
                        swap=true
                        swap_partition=${particoes[op_particao-1]}
                        sleep 2
                        break
                    elif [ $op_particao != 0 ]; then
                        filesystem
                    fi
                break
                ;;
            *)
                errormsg $op_particao
                ;;
        esac"
    done
}

filesystem () {
    while true; do
    clear
    title "         Particionamento / Montar/formatar partições        "
    filesys_types=(Não_formatar btrfs ext2 ext3 ext4 f2fs jfs nilfs2 ntfs reiserfs vfat xfs)
    echo -e "      \e[1mSelecione um Sistemas de arquivos para formatar\e[0m"
    echo -e "      \e[1ma partição ${particoes[$op_particao-1]}\e[0m"
    echo ""
    cont=0
    for filesys_type in ${filesys_types[@]}; do
        cont=$(($cont + 1))
        echo -e "      \e[1m$cont\e[0m - $filesys_type"
    done
    echo ""
    echo -e "      \e[1m0\e[0m - Voltar"
    read -s -n1 op_filesys_type
    case $op_filesys_type in
        1|2|3|4|5|6|7|8|9|10|11|12)
            if [ "$op_ponto" == 1 ]; then
                root=true
                root_partition=${particoes[$op_particao-1]}
                root_filesys=${filesys_types[op_filesys_type-1]}
            elif [ "$op_ponto" == 2 ]; then
                boot=true
                boot_partition=${particoes[$op_particao-1]}
                boot_filesys=${filesys_types[op_filesys_type-1]}
            elif [ "$op_ponto" == 3 ]; then
                home=true
                home_partition=${particoes[$op_particao-1]}
                home_filesys=${filesys_types[op_filesys_type-1]}  
            fi
            break
            ;;
        0)
            break
            ;;
        *)
            errormsg $op_filesys_type
        esac
    done

}

instalacao () {
    while true; do
        clear
        title "                         Instalação                         "
        echo -e "      \e[1m1\e[0m - Revisar Instalação"
        echo -e "      \e[1m2\e[0m - Instalar Arch Linux"
        echo ""
        echo -e "      \e[1m0\e[0m - Voltar"
        read -s -n1 op_install
        case $op_install in
            1)
                revisao
                ;;
            2)
                if $root; then
                    install
                else
                    alerta_root
                fi
                ;;
            0)
                break
                ;;
            *)
                errormsg $op_install
        esac
    done
}

alerta_root () {
    clear
    title "                    Instalar Arch Linux                     "
    echo -e "\e[31;1mALERTA: O ponto de montagem / é obrigatório!!!\e[0m"
    echo -e "\e[1mVolte ao menu inicial e use a opção 6 (Particionamento)\npara configura-lo.\e[0m"
    echo ""
    echo "Aperte qualquer tecla para voltar"
    read -s -n1
    break
}

revisao () {
    clear
    title "                    Revisão da instalação                   "
    echo -e "\e[1mEditor de texto:\e[0m $editor"
    echo -e "\e[1mLocalização:\e[0m $timezone"
    echo -e "\e[1mIdioma do sistema:\e[0m $idioma"
    echo -e "\e[1mLayout de teclado:\e[0m $teclado"
    echo ""
    echo -e "\e[1mParticionamento:\e[0m"
    echo ""
    echo -e "\e[1;7mPonto de montagem\e[0m   \e[1;7mPartição\e[0m   \e[1;7mSistema de arquivo\e[0m"
    if $root; then
        echo "/                   $root_partition       $root_filesys"
    fi
    if $boot; then
        echo "$bootefi                $boot_partition       $boot_filesys"
    fi
    if $home; then
        echo "/home               $home_partition       $home_filesys"
    fi
    if $swap; then
        echo "swap                $swap_partition"
    fi
    echo ""
    echo "Aperte qualquer tecla para voltar"
    read -s -n1
    break
}
install () {
    
    
        mkfs.$root_filesys -L "arch_linux" /dev/$root_partition
        mount /dev/$root_partition /mnt
        if $home; then
            mkfs.$home_filesys -L "home" /dev/$home_partition
            mkdir /mnt/home && mount /dev/$home_partition /mnt/home
        fi
        if $boot; then
            mkfs.fat -F32 /dev/$boot_partition
            mkdir -p /mnt$bootefi && mount /dev/$boot_partition /mnt$bootefi
        fi
        if $swap; then
            mkswap -L "Swap" /dev/$swap_partition && swapon /dev/$swap_partition
        fi
        # Atualizar os mirrors
        pacman -Syu --noconfirm pacman-mirrorlist
        # Instalando o sistema
        pacstrap /mnt base base-devel
        # Gerarando o arquivo fstab
        genfstab -U -p /mnt >> /mnt/etc/fstab
        # Saindo da iso de instalação e logando no sistema instalado como root
        mkdir /mnt/FALI && cp ./core.sh /mnt/FALI
        arch-chroot /mnt ./mnt/FALI/core.sh
}

#-----------------------------------------------#
#                   APLICACAO                   #
#-----------------------------------------------#

### Idendifica a localizacao com base no IP
#timezone=$(curl -s https://ipapi.co/timezone)

### Faz copia do mirrorlist
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.original
### Inicia o menu principal
menu
