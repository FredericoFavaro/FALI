#!/bin/bash
func () {
declare -a dispositivos=();
mapfile -t dispositivos < <(lsblk -n -l -o name | grep "sd..");
#dispositivos=("sda1" "sda2" "sda3" "sda4" "sdb1" "sdb2")
option=1
cont=0
for item in ${dispositivos[*]}; do
    cont=$(($cont + 1))
    echo "$cont - $item"
    option+="|$cont"
done

read casa
eval "case \"$casa\" in
    $option)
        echo ok
        echo "${dispositivos[$casa-1]}"
        ;;
    *)
        echo error
        ;;
esac"
}


func2 () {
Menu () {
    select item; do
        if [ 1 -le ("$REPLY"-1) ] && [ ("$REPLY"-1) -le $(($#)) ]; then
            break;
        elif [ "0" == "$REPLY" ]; then
            echo "0"
        else
            echo "Selecione uma opção válida: (1-$#)."
        fi
    done
}

declare -a drives=();
mapfile -t drives < <(lsblk -n -l -o name | grep "sd..");
echo "Minhas Partições (Selecione uma):";
Menu "${drives[@]}"
drive=($(echo "${item}"));
echo "Disco selecionado: ${drive[0]}";
}


func3 () {
declare -a dispositivos=();
mapfile -t dispositivos < <(lsblk -n -l -o name | grep "sd..");
#dispositivos=("sda1" "sda2" "sda3" "sda4" "sdb1" "sdb2")
option=1
cont=0
for item in ${dispositivos[*]}; do
    cont=$(($cont + 1))
    echo "$cont - $item"
    option+="|$cont"
done

read casa
eval "case \"$casa\" in
    $option)
        echo ok
        echo "${dispositivos[$casa-1]}"
        ;;
    *)
        echo error
        ;;
esac"
}





func2

ponto_montagem () {
    select ponto in / /boot /home swap
    do
        if [ 1 -le "$REPLY" ] && [ "$REPLY" -le $# ]; then
            echo $REPLY
        else
            errormsg "Opção inválida!"
            echo "Tente novamente"
    done
}

Ponto de montagem
("/" "/boot" "/home" "swap")
partição

filesystem 
()
