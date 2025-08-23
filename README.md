# netlify-plugin-expo-qr

A Netlify Build Plugin that automates publishing Expo (React Native) app updates and generates QR code pages for Expo Go.

## Features

- 🚀 **Automated Expo Updates**: Runs `eas update` or `expo publish` during Netlify builds
- 📱 **QR Code Generation**: Creates scannable QR codes for easy app access
- 🌐 **Static HTML Pages**: Generates beautiful, responsive QR code pages
- ⚙️ **Flexible Configuration**: Supports both EAS and legacy publish modes
- 🔧 **Environment Integration**: Uses Netlify environment variables for configuration

## How It Works

During a Netlify build, the plugin:

1. **Publishes Updates**: Runs either `eas update` or `expo publish` based on configuration
2. **Extracts URLs**: Parses the JSON output to get the public Expo project URL
3. **Generates QR Codes**: Creates a scannable QR code using the `qrcode` package
4. **Creates Static Files**: 
   - `dist/expo-qr.html` - Beautiful QR code page with instructions
   - `dist/__expo-latest.txt` - Latest Expo URL for programmatic access

## Installation

### Option 1: Install from npm (Recommended)

```bash
npm install netlify-plugin-expo-qr
```

### Option 2: Add to netlify.toml

```toml
[[plugins]]
package = "netlify-plugin-expo-qr"
[plugins.inputs]
mode = "eas"
```

## Configuration

### Input Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `mode` | string | `"eas"` | Update mode: `"eas"` or `"publish"` |

### Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `EXPO_TOKEN` | ✅ Yes | - | Your Expo access token |
| `EAS_UPDATE_BRANCH` | ❌ No | `"preview"` | Branch name for EAS updates |

## Usage Examples

### Basic EAS Mode (Recommended)

```toml
# netlify.toml
[[plugins]]
package = "netlify-plugin-expo-qr"

[plugins.inputs]
mode = "eas"

[build.environment]
EXPO_TOKEN = "your-expo-token-here"
EAS_UPDATE_BRANCH = "preview"
```

### Legacy Publish Mode

```toml
# netlify.toml
[[plugins]]
package = "netlify-plugin-expo-qr"

[plugins.inputs]
mode = "publish"

[build.environment]
EXPO_TOKEN = "your-expo-token-here"
```

### Custom Branch Configuration

```toml
# netlify.toml
[[plugins]]
package = "netlify-plugin-expo-qr"

[plugins.inputs]
mode = "eas"

[build.environment]
EXPO_TOKEN = "your-expo-token-here"
EAS_UPDATE_BRANCH = "production"
```

## 🤖 Automation Scripts

This project includes powerful automation scripts to streamline development workflow:

### Available Scripts

- **`scripts/update-both-projects.sh`** - Main script to update both NetlifyPlugin and pluginTest projects
- **`scripts/quick-update.sh`** - Quick update with automatic GitHub push
- **`scripts/setup-aliases.sh`** - Set up convenient shell aliases

### Quick Start

```bash
# Set up aliases (run once)
./scripts/setup-aliases.sh

# Quick update with push
quick-update "Add new feature" "1.0.12"

# Manual update without push
update-projects "Fix bug" "1.0.11"

# Update scripts only
update-scripts
```

### What the Scripts Do

1. **Automatically navigate** between both project directories
2. **Install plugin updates** in pluginTest
3. **Commit changes** with your custom message
4. **Push to GitHub** (optional)
5. **Handle all git operations** seamlessly

For detailed usage, see [scripts/README.md](scripts/README.md).

## Prerequisites

### 1. Expo CLI and EAS CLI

Ensure you have the necessary CLI tools installed:

```bash
npm install -g @expo/cli eas-cli
```

### 2. Authentication

Set up your Expo token:

1. Go to [Expo's website](https://expo.dev)
2. Sign in to your account
3. Go to Settings → Access Tokens
4. Create a new token
5. Add it to your Netlify environment variables

### 3. Project Configuration

Make sure your project has the necessary configuration files:

- `app.json` or `app.config.js` for Expo configuration
- `eas.json` for EAS configuration (if using EAS mode)

## Output Files

### `dist/expo-qr.html`

A beautiful, responsive HTML page containing:
- 📱 Scannable QR code
- 🔗 Direct project URL
- 📋 Step-by-step instructions for Expo Go
- 🎨 Modern, clean design with system fonts

### `dist/__expo-latest.txt`

A simple text file containing the latest Expo URL for programmatic access.

## Build Process

The plugin runs during the `onBuild` lifecycle hook:

1. **Validation**: Checks for required environment variables
2. **Execution**: Runs the appropriate Expo command
3. **Parsing**: Extracts the project URL from JSON output
4. **Generation**: Creates QR code and HTML page
5. **Output**: Writes files to the `dist` directory

## Error Handling

The plugin includes comprehensive error handling:

- ✅ Validates required environment variables
- ✅ Gracefully handles command execution failures
- ✅ Provides clear error messages in build logs
- ✅ Fails builds appropriately when critical errors occur

## Troubleshooting

### Common Issues

1. **Missing EXPO_TOKEN**
   - Ensure `EXPO_TOKEN` is set in Netlify environment variables
   - Verify the token is valid and has appropriate permissions

2. **EAS Command Not Found**
   - Install EAS CLI: `npm install -g eas-cli`
   - Ensure EAS CLI is available in the build environment

3. **Expo Publish Command Not Found**
   - Install Expo CLI: `npm install -g @expo/cli`
   - Ensure Expo CLI is available in the build environment

4. **URL Extraction Failed**
   - Check that the Expo command completed successfully
   - Verify the JSON output structure matches expected format

### Debug Mode

Enable verbose logging by checking the Netlify build logs. The plugin provides detailed information about each step of the process.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Support

- 📖 [Documentation](https://github.com/yourusername/netlify-plugin-expo-qr)
- 🐛 [Issue Tracker](https://github.com/yourusername/netlify-plugin-expo-qr/issues)
- 💬 [Discussions](https://github.com/yourusername/netlify-plugin-expo-qr/discussions)

## Changelog

### v1.0.0
- Initial release
- Support for EAS and legacy publish modes
- QR code generation with embedded HTML
- Comprehensive error handling
- Modern, responsive UI design
