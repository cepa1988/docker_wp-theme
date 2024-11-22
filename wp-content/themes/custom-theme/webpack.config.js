const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const BrowserSyncPlugin = require('browser-sync-webpack-plugin');
module.exports = {
  entry: './src/scss/style.scss',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'style.js',
  },
  module: {
    rules: [
      {
        test: /\.scss$/,
        use: [
          MiniCssExtractPlugin.loader, // Extract CSS into separate file
          'css-loader', // Translates CSS into CommonJS
          {
            loader: 'postcss-loader', // PostCSS with Tailwind CSS support
            options: {
              postcssOptions: {
                plugins: [
                  require('autoprefixer'), // Add vendor prefixes
                  require('tailwindcss'), // Add Tailwind CSS support
                ],
              },
            },
          },
          {
            loader: 'sass-loader', // Compiles Sass to CSS
            options: {
              implementation: require('sass'), // Use Dart Sass
            },
          },
        ],
      },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: 'style.css',
    }),
    new BrowserSyncPlugin(
      {
        proxy: 'http://localhost:8080',  // Proxy WordPress container
        port: 3000,  // BrowserSync runs on port 3000
        files: ['**/*.php', 'dist/*.css', 'dist/*.js'],  // Watch these files
        injectChanges: true,  // Inject style changes without reloading the page
        open: true,  // Automatically open the BrowserSync browser window
        logLevel: 'debug',  // Enable detailed logging
        logPrefix: 'BrowserSync',
        host: '0.0.0.0',  // Listen on all interfaces
      },
      { reload: true }
    ),
  ], 
}
