<template>
  <router-view />
  <v-dialog
    v-model="useAppStore().preload"
    fullscreen
    persistent
    :overlay="false"
    transition="dialog-transition"
  >
    <v-container class="fill-height">
      <v-responsive class="d-flex align-center text-center fill-height">
        <v-progress-circular size="200" determinate=""></v-progress-circular>
      </v-responsive>
    </v-container>
  </v-dialog>
</template>

<script setup>
import { useAppStore } from "./store/app";
</script>
