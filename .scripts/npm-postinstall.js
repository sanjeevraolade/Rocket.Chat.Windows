
const { execSync } = require('child_process');

console.log('Running npm-postinstall.js');

execSync('xcopy /E /Y node_modules\\katex\\dist\\katex.min.css app\\katex\\');

execSync('rmdir /q /s public\\fonts\\ && mkdir public\\fonts\\');
execSync('xcopy /E /Y node_modules\\katex\\dist\\fonts\\* public\\fonts\\');
execSync('xcopy /E /Y node_modules\\\@rocket.chat\\icons\\dist\\font\\* public\\fonts\\');

execSync('xcopy /E /Y node_modules\\pdfjs-dist\\build\\pdf.worker.min.js public\\');
