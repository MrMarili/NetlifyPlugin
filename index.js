const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const QRCode = require('qrcode');

module.exports = {
  onBuild: async ({ inputs, utils }) => {
    console.log('🔍 Debug: inputs received:', JSON.stringify(inputs, null, 2));
    const { mode = 'eas' } = inputs;
    
    console.log(`🚀 Starting netlify-plugin-expo-qr in ${mode} mode...`);
    
    // Check required environment variables
    if (!process.env.EXPO_TOKEN) {
      utils.build.failBuild('❌ EXPO_TOKEN environment variable is required');
      return;
    }
    
    try {
      let expoUrl;
      let branchName = 'unknown';
      
      if (mode === 'eas') {
        console.log('📱 Starting Expo with tunnel...');
        
        // Set EXPO_TOKEN for EAS authentication
        console.log('🔐 Setting EXPO_TOKEN for EAS authentication...');
        process.env.EXPO_TOKEN = process.env.EXPO_TOKEN;
        
        // Get branch from environment variable or default to 'preview'
        const branch = process.env.EAS_UPDATE_BRANCH || 'preview';
        branchName = branch;
        
        // Start Expo with tunnel to get the QR code
        console.log('🌐 Starting Expo with tunnel...');
        try {
          const expoCommand = 'npx expo start --tunnel';
          console.log(`🔧 Executing: ${expoCommand}`);
          
          const expoOutput = execSync(expoCommand, { 
            encoding: 'utf8',
            stdio: 'pipe',
            env: { ...process.env, EXPO_TOKEN: process.env.EXPO_TOKEN, CI: '1' },
            timeout: 30000 // 30 seconds timeout
          });
          
          // Extract tunnel URL from output
          const tunnelMatch = expoOutput.match(/exp:\/\/u-[^\s]+/);
          if (tunnelMatch) {
            expoUrl = tunnelMatch[0];
            console.log(`✅ Expo tunnel started: ${expoUrl}`);
          } else {
            throw new Error('Could not extract tunnel URL from Expo output');
          }
        } catch (tunnelError) {
          console.log('❌ Expo tunnel failed:', tunnelError.message);
          throw new Error('Failed to start Expo tunnel');
        }
        
      } else if (mode === 'publish') {
        console.log('📱 Running Expo publish (legacy mode)...');
        
        // Note: expo publish is deprecated, using eas update instead
        console.log('⚠️  expo publish is deprecated, falling back to eas update');
        
        const easCommand = `eas update --branch preview --message "Netlify ${process.env.COMMIT_REF || 'build'}" --non-interactive --json`;
        console.log(`🔧 Executing: ${easCommand}`);
        
        const easOutput = execSync(easCommand, { 
          encoding: 'utf8',
          stdio: 'pipe',
          env: { ...process.env, EXPO_TOKEN: process.env.EXPO_TOKEN }
        });
        
        const easResult = JSON.parse(easOutput);
        console.log('✅ EAS update completed successfully');
        
        // Extract URL from EAS update result
        if (easResult.url) {
          expoUrl = easResult.url;
        } else if (easResult.links && easResult.links.url) {
          expoUrl = easResult.links.url;
        } else {
          throw new Error('Could not extract Expo URL from EAS update result');
        }
        
      } else {
        throw new Error(`Invalid mode: ${mode}. Must be 'eas' or 'publish'`);
      }
      
      console.log(`🔗 Extracted Expo URL: ${expoUrl}`);
      
      // Ensure dist directory exists
      const distDir = path.join(process.cwd(), 'dist');
      if (!fs.existsSync(distDir)) {
        fs.mkdirSync(distDir, { recursive: true });
      }
      
      // Generate QR code as Data URI
      console.log('📱 Generating QR code...');
      const qrCodeDataUri = await QRCode.toDataURL(expoUrl, {
        errorCorrectionLevel: 'M',
        margin: 2,
        width: 300
      });
      
      // Create HTML page
      const htmlContent = `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expo App QR Code</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .container {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 500px;
            width: 100%;
        }
        h1 {
            color: #333;
            margin-bottom: 20px;
            font-size: 24px;
        }
        .qr-code {
            margin: 30px 0;
        }
        .qr-code img {
            max-width: 300px;
            width: 100%;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        .url {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            word-break: break-all;
            font-family: 'Courier New', monospace;
            font-size: 14px;
            color: #495057;
        }
        .branch {
            background: #e3f2fd;
            color: #1976d2;
            padding: 8px 16px;
            border-radius: 20px;
            display: inline-block;
            font-size: 14px;
            font-weight: 500;
            margin: 20px 0;
        }
        .instructions {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 20px;
            margin: 20px 0;
            text-align: left;
        }
        .instructions h3 {
            margin-top: 0;
            color: #856404;
        }
        .instructions ol {
            margin: 10px 0;
            padding-left: 20px;
        }
        .instructions li {
            margin: 8px 0;
            color: #856404;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📱 Expo App QR Code</h1>
        
        <div class="branch">
            Branch: ${branchName}
        </div>
        
        <div class="qr-code">
            <img src="${qrCodeDataUri}" alt="QR Code for Expo App" />
        </div>
        
        <div class="url">
            ${expoUrl}
        </div>
        
        <div class="instructions">
            <h3>📋 How to open in Expo Go:</h3>
            <ol>
                <li>Install <strong>Expo Go</strong> from your device's app store</li>
                <li>Open Expo Go on your device</li>
                <li>Scan this QR code with your device's camera or Expo Go's built-in scanner</li>
                <li>Your app will load automatically in Expo Go</li>
            </ol>
        </div>
        
        <p style="color: #6c757d; font-size: 14px; margin-top: 30px;">
            Generated by netlify-plugin-expo-qr
        </p>
    </div>
</body>
</html>`;
      
      // Write HTML file
      const htmlPath = path.join(distDir, 'expo-qr.html');
      fs.writeFileSync(htmlPath, htmlContent);
      console.log(`✅ QR code page written to: ${htmlPath}`);
      
      // Write URL to text file
      const urlPath = path.join(distDir, '__expo-latest.txt');
      fs.writeFileSync(urlPath, expoUrl);
      console.log(`✅ Latest Expo URL written to: ${urlPath}`);
      
      console.log('🎉 netlify-plugin-expo-qr completed successfully!');
      
    } catch (error) {
      console.error('❌ Error in netlify-plugin-expo-qr:', error.message);
      
      if (error.message.includes('Could not extract Expo URL')) {
        utils.build.failBuild('Failed to extract Expo URL from update result');
      } else {
        utils.build.failBuild(`Plugin execution failed: ${error.message}`);
      }
    }
  }
};
