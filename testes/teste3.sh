editor=nano
timezone=America/Recife
idioma="en_US.UTF-8 UTF-8"
teclado=us
root=true
root_partition=sda2
root_filesys=ext4
swap=false
swap_partition=sda1
home=true
home_partition=sda3
home_filesys=ext4
boot=true
boot_partition=sdb1
boot_filesys="Não formatar"

revisao () {
    clear
    echo ""
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
        echo "/boot               $boot_partition       $boot_filesys"
    fi
    if $home; then
        echo "/home               $home_partition       $home_filesys"
    fi
    if $swap; then
        echo "swap                $swap_partition"
    fi
    echo ""
}


revisao




