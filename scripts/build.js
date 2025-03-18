const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');

try {
    console.log('🛠  Running npm install in root...');
    execSync('npm install', { stdio: 'inherit' });

    console.log('📂 Running create-env script...');
    execSync('npm run create-env', { stdio: 'inherit' });

    console.log('📂 Moving into frontend folder...');
    process.chdir(path.join(__dirname, '../frontend'));

    console.log('🛠  Running npm install in frontend...');
    execSync('npm install', { stdio: 'inherit' });

    console.log('🚀 Building frontend...');
    execSync('npm run build', { stdio: 'inherit' });

    console.log('📂 Moving back to root folder...');
    process.chdir(path.join(__dirname, '..'));

    console.log('🧹 Cleaning root dist folder...');
    const distPath = path.join(__dirname, '../dist');
    if (fs.existsSync(distPath)) {
        fs.rmSync(distPath, { recursive: true, force: true });
    }
    fs.mkdirSync(distPath);

    console.log('📁 Copying frontend build files to root dist...');

    if (os.platform() === 'win32') {
        // Gunakan xcopy untuk Windows
        execSync('xcopy frontend\\dist\\* dist\\ /E /Y /I', { stdio: 'inherit' });
    } else {
        // Gunakan cp untuk macOS/Linux
        execSync('cp -r frontend/dist/* dist/', { stdio: 'inherit' });
    }

    console.log('📌 Starting index.js with PM2...');
    execSync('pm2 start index.js --name pirsoftpren', { stdio: 'inherit' });

    console.log('💾 Saving PM2 process list...');
    execSync('pm2 save', { stdio: 'inherit' });

    console.log('📄 Creating PM2 resurrect batch file...');
    const batchFilePath = path.join(__dirname, '../resurrect_pm2.bat');
    const batchContent = `@echo off
pm2 resurrect
echo PM2 resurrected!
pause`;
    fs.writeFileSync(batchFilePath, batchContent, 'utf8');

    console.log('✅ Build and deployment completed successfully!');
} catch (error) {
    console.error('❌ Error during build process:', error);
    process.exit(1);
}
