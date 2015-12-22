#!/bin/bash

DIR=`readlink -e $1 |sed s/"\/$"//`

echo "# generated by ./config_mirage.bash"
echo "# used in kernel/Makefile.app for unikernel build dependencies"
echo
echo "CFG_MIRAGE_APP_DIR=$DIR"
echo "CFG_MIRAGE_APP_FILES=\\"

for f in $DIR/*.ml; do
    echo "$f \\"
done
echo

# specifics for mirage-www app
if [[ "`echo $DIR|grep -o mirage-www` " == "mirage-www " ]]; then
    echo "export MODE=solo5"
    echo "export FS=crunch"
    echo "export NET=direct"
    echo "export DHCP="
fi

# specifics for kv_ro app
if [[ "`basename $DIR`" == "kv_ro" ]]; then
    echo "CFG_MIRAGE_APP_DEPS=kv_ro_prepare_disk"
    echo "export FS=fat"
    echo
    
    # rules specific to set up fat-based kv_ro (run always)
    echo ".PHONY: kv_ro_prepare_disk "
    echo "kv_ro_prepare_disk:"
    echo "	(cd $DIR && ./make-fat1-image.sh)"
    echo "	cp $DIR/fat1.img ../disk.img"
    echo
fi

# specifics for stackv4 app
if [[ "`basename $DIR`" == "stackv4" ]]; then
    echo "export NET=direct"
    echo "export DHCP="
fi

