# submission 2
## Membuat User Baru
```bash
useradd -m dicoding -d /home/dicoding -c "Dicoding Indonesia" -s /bin/bash
# -m → Membuat home directory otomatis (/home/dicoding).
# -d /home/dicoding → Menentukan home directory secara eksplisit.
# -c "Dicoding Indonesia" → Menambahkan komentar sebagai informasi nama lengkap.
# -s /bin/bash → Menentukan default shell (/bin/bash).

passwd dicoding
```

## Mengonfigurasi SSH
```bash
vi /etc/ssh/sshd_config
# Port 2000
# PermitRootLogin no
# PubkeyAuthentication yes

semanage port -a -t ssh_port_t -p tcp 2000
# if alredy define use this
semanage port -m -t ssh_port_t -p tcp 2000

systemctl restart sshd
```

## Membuat Berkas Daftar User dan Log SSH 
```bash
cat /etc/passwd > daftar-user.txt
journalctl -b -u sshd -n 50 > log-ssh.txt
```

## Membuat berkas log-ssh.json yang berisi entri log terkait SSH dalam bentuk JSON.
```bash
journalctl -b -u sshd -n 50 -o json-pretty > log-ssh.json
```

## Membuat berkas daftar-user.txt.gpg (hasil enkripsi dari berkas daftar-user.txt).
```bash
gpg -c daftar-user.txt
```

## Membuat berkas shell script bernama hapus-log.sh dengan ketentuan berikut.
```bash
cat > hapus-log.sh << EOF
#!/bin/bash

lanjut="y"
while [ \$lanjut == "y" ] ; do
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
EOF

chmod +x hapus-log.sh
./hapus-log.sh
```