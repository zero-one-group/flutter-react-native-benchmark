// Learn more https://docs.expo.io/guides/customizing-metro
const { getDefaultConfig } = require('expo/metro-config');
const { mergeConfig } = require('@react-native/metro-config');

/**
 * Metro configuration
 * https://reactnative.dev/docs/metro
 */
const config = getDefaultConfig(__dirname);

// Add any custom config here
const customConfig = {
  resolver: {
    sourceExts: ['js', 'jsx', 'json', 'ts', 'tsx', 'cjs'],
    assetExts: ['bin', 'txt', 'jpg', 'png', 'ttf'],
  },
};

module.exports = mergeConfig(config, customConfig);
