#!/bin/bash
echo "========================================"
echo "🚀 INSTALASI KEIBOT AUTOMATION STUDIO 🚀"
echo "========================================"

# 1. INSTALL FFMPEG DI SISTEM LINUX (WAJIB UNTUK VISUALIZER)
echo "⚙️ Menginstal FFMPEG dan Dependensi Sistem..."
sudo apt-get update -y
sudo apt-get install -y ffmpeg python3-pip python3-venv

# Pindah ke direktori root VPS
cd /root

# Hapus folder lama jika user melakukan install ulang
rm -rf keibot-factory

# Mengunduh file dari GitHub Kamu
echo "📥 Mengunduh sistem dari GitHub..."
# ⚠️ GANTI URL DI BAWAH INI DENGAN URL REPOSITORY GITHUB KAMU YANG BARU!
git clone https://github.com/keibotofficial/keibot-factory.git

# Masuk ke folder hasil download
# ⚠️ JIKA NAMA REPOSITORY KAMU BUKAN "keibot-factory", GANTI KATA DI BAWAH INI
cd keibot-factory

# Buat Virtual Environment & Install Library
echo "📦 Menginstall Library Python..."
python3 -m venv venv
source venv/bin/activate

# Install dari requirements dan tambahkan modul baru untuk v2.4
pip install -r requirements.txt
pip install imageio-ffmpeg psutil

# Buat Systemd Service agar jalan 24 jam nonstop
echo "⚙️ Menyiapkan Mesin 24/7..."
# ⚠️ PASTIKAN NAMA FOLDER "keibot-factory" DI BAWAH INI SESUAI DENGAN REPOSITORY KAMU
cat <<EOF > /etc/systemd/system/keibot.service
[Unit]
Description=KeiBot Factory Web Panel
After=network.target

[Service]
User=root
WorkingDirectory=/root/keibot-factory
ExecStart=/root/keibot-factory/venv/bin/python /root/keibot-factory/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Nyalakan Mesin
systemctl daemon-reload
systemctl enable keibot
systemctl restart keibot

# Ambil IP VPS otomatis untuk ditampilkan ke layar
IP_ADDRESS=$(curl -s ifconfig.me)

echo "========================================"
echo "🎉 INSTALASI SELESAI! 🎉"
echo "Mesin Pabrik Anda sudah menyala 24/7."
echo "Silakan buka browser di laptop/HP dan akses:"
echo "👉 http://$IP_ADDRESS:5000"
echo "⚠️ Anda akan diminta membuat PIN Keamanan saat pertama kali buka."
echo "========================================"
