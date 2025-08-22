#!/usr/bin/env node

// Simple test script to verify the plugin's QR code generation
const QRCode = require('qrcode');
const fs = require('fs');
const path = require('path');

async function testQRCodeGeneration() {
  console.log('🧪 Testing QR code generation...');
  
  try {
    // Test URL
    const testUrl = 'exp://exp.host/@username/project?release-channel=preview';
    
    // Generate QR code
    const qrCodeDataUri = await QRCode.toDataURL(testUrl, {
      errorCorrectionLevel: 'M',
      margin: 2,
      width: 300
    });
    
    console.log('✅ QR code generated successfully');
    console.log(`📱 Data URI length: ${qrCodeDataUri.length} characters`);
    
    // Create test HTML
    const testHtml = `<!DOCTYPE html>
<html>
<head>
    <title>Test QR Code</title>
</head>
<body>
    <h1>Test QR Code</h1>
    <img src="${qrCodeDataUri}" alt="Test QR Code" />
    <p>URL: ${testUrl}</p>
</body>
</html>`;
    
    // Write test file
    const testDir = path.join(process.cwd(), 'test-output');
    if (!fs.existsSync(testDir)) {
      fs.mkdirSync(testDir, { recursive: true });
    }
    
    const testPath = path.join(testDir, 'test-qr.html');
    fs.writeFileSync(testPath, testHtml);
    
    console.log(`✅ Test HTML written to: ${testPath}`);
    console.log('🎉 All tests passed!');
    
  } catch (error) {
    console.error('❌ Test failed:', error.message);
    process.exit(1);
  }
}

// Run test
testQRCodeGeneration();
