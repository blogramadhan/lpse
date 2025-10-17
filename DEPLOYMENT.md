# Panduan Deployment - Portal Layanan Digital Biro PBJ
## Pemerintah Provinsi Kalimantan Barat

---

## Prasyarat

Pastikan server production sudah terinstall:
- Docker (versi 20.10 atau lebih baru)
- Docker Compose (versi 2.0 atau lebih baru)
- Git

---

## File-file Deployment

1. **Dockerfile** - Konfigurasi Docker image
2. **docker-compose.yml** - Orchestration untuk Docker container
3. **deploy.sh** - Script otomatis untuk deployment
4. **.dockerignore** - File yang diabaikan saat build Docker

---

## Langkah Deployment

### 1. Clone Repository

```bash
git clone <repository-url>
cd lpse
```

### 2. Tambahkan Logo

Pastikan file logo Kalimantan Barat sudah ada:

```bash
# Letakkan file logo di:
public/logo-kalbar.png
```

### 3. Jalankan Deployment Script

**Deployment Pertama Kali:**
```bash
bash deploy.sh
# atau
bash deploy.sh deploy
```

Script akan otomatis:
- ✅ Memeriksa instalasi Docker
- ✅ Memeriksa keberadaan logo
- ✅ Membersihkan container lama
- ✅ Build Docker image
- ✅ Menjalankan container
- ✅ Verifikasi status deployment

### 4. Akses Aplikasi

Setelah deployment berhasil, aplikasi dapat diakses di:

```
http://localhost:3060
```

---

## Update Aplikasi dari GitHub

Untuk memperbarui aplikasi dengan code terbaru dari GitHub:

### Menggunakan Update Command (Otomatis):

```bash
bash deploy.sh update
```

Proses update akan:
1. ✅ **Memeriksa Git** - Validasi Git terinstall
2. ✅ **Validasi Repository** - Memastikan folder adalah Git repository
3. ✅ **Backup Perubahan Lokal** - Otomatis backup perubahan lokal dengan Git stash
4. ✅ **Pull dari GitHub** - Mengunduh pembaruan terbaru
5. ✅ **Tampilkan Perubahan** - Menampilkan commit log yang akan diaplikasikan
6. ✅ **Rebuild Docker** - Build ulang Docker image dengan code terbaru
7. ✅ **Cleanup** - Hapus container dan image lama
8. ✅ **Restart Container** - Jalankan container dengan versi baru
9. ✅ **Verifikasi** - Pastikan aplikasi berjalan dengan baik

**Catatan Penting:**
- Perubahan lokal akan di-backup otomatis dengan Git stash
- Untuk restore backup: `git stash apply stash^{/auto-backup-TIMESTAMP}`
- Script akan menampilkan perubahan sebelum mengaplikasikannya

---

## Deployment Manual (Tanpa Script)

Jika ingin deploy manual tanpa menggunakan script:

### Build Image:
```bash
docker compose build
```

### Jalankan Container:
```bash
docker compose up -d
```

### Cek Status:
```bash
docker ps
docker logs lpse-biro-pbj
```

---

## Management Container

Script deployment menyediakan command untuk management container yang mudah:

### Cek Status Container:
```bash
bash deploy.sh status
```
Menampilkan status container (running/stopped/not found) beserta detail lengkapnya.

### Melihat Logs:
```bash
bash deploy.sh logs
```
Menampilkan logs container secara real-time (press Ctrl+C untuk keluar).

**Atau menggunakan Docker langsung:**
```bash
docker logs lpse-biro-pbj
docker logs -f lpse-biro-pbj  # Follow logs
```

### Stop Container:
```bash
bash deploy.sh stop
```
Menghentikan container yang sedang berjalan.

**Atau menggunakan Docker langsung:**
```bash
docker stop lpse-biro-pbj
# atau
docker compose down
```

### Start Container:
```bash
bash deploy.sh start
```
Memulai container yang sudah ada (yang sebelumnya di-stop).

**Atau menggunakan Docker langsung:**
```bash
docker start lpse-biro-pbj
```

### Restart Container:
```bash
bash deploy.sh restart
```
Restart container (stop + start).

**Atau menggunakan Docker langsung:**
```bash
docker restart lpse-biro-pbj
# atau
docker compose restart
```

### Update Aplikasi:
```bash
bash deploy.sh update
```
Otomatis pull dari GitHub dan redeploy dengan code terbaru.

### Remove Container & Images:
```bash
bash deploy.sh remove
```
Menghapus container dan Docker images (dengan konfirmasi).

**Peringatan:** Command ini akan menghapus semua data container dan images!

---

## Konfigurasi Reverse Proxy

Aplikasi berjalan di port **3000**. Untuk production, gunakan reverse proxy (Nginx/Apache) untuk:
- HTTPS/SSL
- Domain mapping
- Load balancing (jika diperlukan)

### Contoh Nginx Configuration:

```nginx
server {
    listen 80;
    server_name pbj.kalbarprov.go.id;

    location / {
        proxy_pass http://localhost:3060;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

## Troubleshooting

### Container Tidak Berjalan:
```bash
docker logs lpse-biro-pbj
docker ps -a
```

### Port Sudah Digunakan:
```bash
# Cek port yang digunakan
sudo lsof -i :3060

# Ubah port di docker-compose.yml
ports:
  - "3061:3060"  # Ganti 3061 dengan port yang tersedia
```

### Logo Tidak Tampil:
- Pastikan file `public/logo-kalbar.png` ada
- Format: PNG dengan background transparan
- Ukuran minimal: 300x300 pixels

### Rebuild Image:
```bash
docker compose build --no-cache
docker compose up -d
```

---

## Spesifikasi Teknis

- **Base Image**: Node.js 20 Alpine
- **Port**: 3060
- **Container Name**: lpse-biro-pbj
- **Network**: lpse-network (bridge)
- **Restart Policy**: unless-stopped

---

## Contact & Support

Untuk dukungan teknis, hubungi:
- **Tim IT Biro PBJ**
- **Setda Provinsi Kalimantan Barat**

---

**Catatan Keamanan:**
- Jangan expose port Docker langsung ke internet
- Gunakan HTTPS untuk production
- Update Docker dan dependencies secara berkala
- Backup data secara rutin
