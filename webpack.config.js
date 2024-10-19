const path = require("path");
const { VueLoaderPlugin } = require("vue-loader");
const HtmlWebpackPlugin = require("html-webpack-plugin");

// Dynamically set mode based on NODE_ENV
const isProduction = process.env.NODE_ENV === "production";
const mode = isProduction ? "production" : "development";

module.exports = {
  mode: mode, // Set the mode dynamically
  entry: "./src/main.js",
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "bundle.js",
    clean: true,
  },
  resolve: {
    extensions: [".js", ".vue"],
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        use: "vue-loader",
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: "babel-loader",
      },
      {
        test: /\.css$/,
        use: ["style-loader", "css-loader"],
      },
    ],
  },
  plugins: [
    new VueLoaderPlugin(),
    new HtmlWebpackPlugin({
      template: "./public/index.html",
      filename: "index.html",
    }),
  ],
  devServer: {
    static: {
      directory: path.join(__dirname, "dist"),
    },
    compress: true,
    port: 3004,
  },
};
