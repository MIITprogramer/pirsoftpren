// index.js

// Import modul yang diperlukan
const express = require("express");
const http = require("http");
const path = require("path");
const morgan = require("morgan");
const cors = require("cors");
const bodyParser = require("body-parser");
const fileUpload = require("express-fileupload");
const frontend = express();

require('dotenv').config();

// Konfigurasi aplikasi
const app = express();
const PORT = process.env.LOCAL_SERVER_PORT;

// Middleware
app.use(cors({ origin: "*", methods: ["POST", "GET"] }));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(morgan("dev"));
app.use(
  fileUpload({
    createParentPath: true,
  })
);

// Endpoint API
const myapi = require("./controlers/index.js");
app.use("/", myapi);

// Sajikan file statis dari folder 'dist' untuk frontend
app.use(express.static(path.join(__dirname, "dist")));

// Tangani semua rute dengan mengembalikan file index.html
app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "index.html"));
});

// Membuat HTTP server
const server = http.createServer(app);

frontend.use(express.static(path.join(__dirname, "dist")));

// Tangani semua rute dengan mengembalikan file index.html
frontend.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "index.html"));
});


// Jalankan server
server.listen(PORT, process.env.LOCAL_SERVER_IP, () => {
  console.log(`Server berjalan di http://${process.env.LOCAL_SERVER_IP}:${PORT}`);
});
