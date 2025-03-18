<template>
  <v-card max-width="400" class="ma-auto app_bg" rounded="xl" elevation="5">
    <v-card-title class="text-h4">INSPECTION FOAM</v-card-title>
    <v-card-text>
      <v-img height="180" src="@/assets/softfren.png" />
      <v-row class="mt-2">
        <v-col cols="12"> </v-col>
        <v-col cols="12">
          <loginForm></loginForm>
        </v-col>
      </v-row>
    </v-card-text>
  </v-card>
</template>
<script setup>
import LoginForm from "@/components/forms/loginForm.vue";
</script>
