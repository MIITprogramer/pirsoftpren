# PIR SOFTPREN - TECHNICAL DOCUMENTATION

## 1. OVERVIEW
PIR SOFTPREN adalah aplikasi yang dikembangkan dengan backend **Node.js**, database **MySQL**, dan frontend menggunakan **Vuetify**. Aplikasi ini dirancang untuk pengisian **Part Inspection Report (PIR)** pada perusahaan manufaktur.

---

## 2. DEPLOYMENT & SETUP

### 2.1. PREREQUISITES
Sebelum melakukan instalasi, pastikan telah menginstal software berikut:
- **Node.js** (^v22.14.0)
- **MySQL Server**
- **NPM**
- **PM2**

Pastikan semua software di atas telah terinstal sebelum melanjutkan proses instalasi.

---

### 2.2. BACKEND INSTALLATION
```sh
# Clone repository
git clone https://github.com/MIITprogramer/pirsoftpren.git
cd pirsoftpren

# Install dependencies
npm install

# Build project
npm run build

# Server berjalan di local_ip:port yang telah didaftarkan
# Pastikan database pirsoftpren sudah diimport ke dalam server MySQL (file SQL ada di root project)
```

---

### 2.3. FRONTEND EDITING
```sh
# Masuk ke folder frontend
cd frontend

# Install dependencies
npm install

# Jalankan aplikasi
npm run dev
```
Lakukan editing script dalam root folder **frontend** untuk menyesuaikan tampilan atau fungsionalitas aplikasi.
