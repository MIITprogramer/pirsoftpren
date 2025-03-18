const fs = require("fs");
const readline = require("readline");
const path = require("path");

const projectRoot = path.join(__dirname, ".."); // Pastikan ini mengarah ke root proyek

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
});

rl.question("Enter DB Host: ", (dbHost) => {
    rl.question("Enter DB User: ", (dbUser) => {
        rl.question("Enter DB Password: ", (dbPassword) => {
            rl.question("Enter Local Server IP: ", (localIp) => {
                rl.question("Enter Server Port: ", (serverPort) => {
                    // Isi untuk .env di root folder
                    const rootEnvContent = `DB_HOST=${dbHost}
DB_USER=${dbUser}
DB_PASSWORD=${dbPassword}
LOCAL_SERVER_IP=${localIp}
LOCAL_SERVER_PORT=${serverPort}
`;

                    // Isi untuk .env di dalam folder frontend
                    const frontendEnvContent = `VITE_API_SERVER=http://${localIp}
VITE_API_SERVER_PORT=${serverPort}
`;

                    // Menulis .env di root folder
                    fs.writeFileSync(path.join(projectRoot, ".env"), rootEnvContent, {
                        encoding: "utf8",
                    });
                    console.log(".env file has been created successfully in root directory.");

                    // Path folder frontend
                    const frontendEnvPath = path.join(projectRoot, "frontend", ".env");

                    // Pastikan folder frontend ada sebelum menulis file
                    if (!fs.existsSync(path.join(projectRoot, "frontend"))) {
                        console.error("Error: Folder frontend tidak ditemukan!");
                    } else {
                        fs.writeFileSync(frontendEnvPath, frontendEnvContent, {
                            encoding: "utf8",
                        });
                        console.log(".env file has been created successfully in frontend directory.");
                    }

                    rl.close();
                });
            });
        });
    });
});
