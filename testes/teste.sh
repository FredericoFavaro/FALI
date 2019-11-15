#!/bin/bash
dispositivos=$(lsblk -n -l -o NAME  | grep sd..)
valid=()
cont=1
for item in ${dispositivos[*]}; do
echo $item
valid+=$cont
cont=$(($cont + 1))
done
echo $valid

#valid="red|green|blue"
#read casa
#eval "case \"$casa\" in
#    $valid)
#        echo "do something good here"
#        ;;
#    *)
#        echo invalid colour
#        ;;
#esac"
read casa
case $casa in
    $valid)
        echo "do something good here"
        ;;
    *)
        echo invalid colour
        ;;
esac