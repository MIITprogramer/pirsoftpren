const mysql = require("mysql");
const database = mysql.createConnection({
  host: "127.0.0.1" || process.env.DB_HOST,
  user: "root" || process.env.DB_USER,
  password: "" || process.env.DB_PASSWORD,
  database: "pirsoftpren",
});

module.exports = database;
