#!/bin/bash

main () {
        clear
        name='ariafatah'
        echo; echo Hello, my name is $name

        echo; echo '[+] memory size: '
        free --mega
        sleep 1
        # free --mega => show memory like ram, swap, dll

        echo; echo '[+] disk size gigabyte: '
        df -BG
        sleep 1
        # df -BG => show disk file system with (-BG=BlockSize Gigabytes)

        echo; echo '[+] disk size filesystem & use% without tmpfs'
        echo '|       Filesystem          |    Use%    |'
        echo '| ------------------------- | ---------- |'
        df -h | grep -v tmpfs | tail -n +2 | awk '{ printf "| %-25s | %-10s | \n", $1, $5  }'
        sleep 1
        # df -h => show disk file system with (-h=human_readable)
        # grep -v <pattern> => print line wihtout(-v) tmpfs
        # tail -n +2 => menampilkan baris dari baris ke (+2)
        # awk =>
        # - %-25s => kolam pertama rata kiri dengan lebar 25 karakter
        # - %-10s => kolam kedua rata kiri dengan lebar 10 karakter
        # - \n    => menambahkan newline
}

i=1
while [ $i -le 3 ]
do
        main
        i=$((i+=1))
done