// Plugins
import vue from "@vitejs/plugin-vue";
import vuetify, { transformAssetUrls } from "vite-plugin-vuetify";
import { VitePWA } from 'vite-plugin-pwa';

// Utilities
import { defineConfig } from "vite";
import { fileURLToPath, URL } from "node:url";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue({
      template: { transformAssetUrls },
    }),
    // https://github.com/vuetifyjs/vuetify-loader/tree/next/packages/vite-plugin
    vuetify({
      autoImport: true,
    }),
    VitePWA({
      registerType: 'autoUpdate',
      manifest: { "theme_color": "#3859ff", "background_color": "#ffffff", "icons": [{ "purpose": "maskable", "sizes": "512x512", "src": "icon512_maskable.png", "type": "image/png" }, { "purpose": "any", "sizes": "512x512", "src": "icon512_rounded.png", "type": "image/png" }], "orientation": "landscape", "display": "standalone", "dir": "auto", "lang": "en-EN", "name": "PIR Softpren", "short_name": "PIR", "start_url": "/" },
    }),
  ],
  define: { "process.env": {} },
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
    },
    extensions: [".js", ".json", ".jsx", ".mjs", ".ts", ".tsx", ".vue"],
  },
  server: {
    port: 3002,
    host: true,
  },
});
