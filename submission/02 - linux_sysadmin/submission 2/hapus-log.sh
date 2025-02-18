#!/bin/bash

lanjut="y"
while [ $lanjut == "y" ] ; do
        clear
        echo
        echo "                 *                "
        echo "                ***               "
        echo "               *****              "
        echo "              *******             "
        echo "             *********            "
        echo "            ***********           "
        echo "                 |                "
        echo "                 |                "; echo
        echo "[*] by github.com/ariafatah0711"; echo

        # menampilkan informasi penggunaan disk dari semua berkas journalctl, baik yang aktif maupun yang diarsipkan.
        echo "[+] show disk usage in journalctl"
        journalctl --disk-usage
        echo; sleep 2

        # menghapus journalctl log hingga ruang disk yang digunakan untuk log berkisar 10 MB.
        echo "[+] menghapus log hingga ukuran 10M"
        journalctl --vacuum-size=10M | head -n 10
        echo; sleep 2

        # menampilkan kembali informasi penggunaan disk dari semua berkas journalctl, baik yang aktif maupun yang diarsipkan.
        echo "[+] menampilkan kembali disk usage"
        journalctl --disk-usage
        echo; sleep 2

        echo "lanjut (y/n)? "
        read lanjut
done