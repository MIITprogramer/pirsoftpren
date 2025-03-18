const express = require("express");
const path = require("path");
const app = express();
const PORT = process.env.PORT || 8080;

// Sajikan file statis dari folder 'dist'
app.use(express.static(path.join(__dirname, "dist")));

// Tangani semua rute dengan mengembalikan file index.html
app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "index.html"));
});

// Jalankan server
app.listen(PORT, () => {
  console.log(`Server is running at http://localhost:${PORT}`);
});
