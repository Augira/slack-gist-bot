var path = require('path');

const SRC_DIR = path.resolve(__dirname, 'src');
const OUT_DIR = path.resolve(__dirname, 'dist');

module.exports = {
  mode: "production",
  target: "node",
  optimization: { minimize: true },
  entry: path.resolve(SRC_DIR, 'index.js'),
  output: {
    filename: 'index.js',
    path: OUT_DIR,
    library: '[name]',
    libraryTarget: 'umd'
  }
}

