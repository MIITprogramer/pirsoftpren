<template>
  <v-app>
    <v-app-bar elevation="5" class="app_bg">
      <v-app-bar-nav-icon
        variant="text"
        @click.stop="drawer = !drawer"
      ></v-app-bar-nav-icon>
      <v-spacer></v-spacer>
      <v-menu>
        <template v-slot:activator="{ props }">
          <v-btn icon="mdi-dots-vertical" variant="text" v-bind="props"></v-btn>
        </template>
        <v-list density="compact">
          <div>
            <SettingMenus></SettingMenus>
          </div>
          <v-divider class="my-1"></v-divider>
          <v-list-item @click="logoutDialog = true">
            <template v-slot:prepend>
              <v-icon>mdi-logout</v-icon>
            </template>
            <v-list-item-title>Logout</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-app-bar>
    <v-navigation-drawer class="app_bg" elevation="5" v-model="drawer">
      <IdCard></IdCard>
      <v-divider></v-divider>
      <DrawerMenus></DrawerMenus>
    </v-navigation-drawer>
    <v-main>
      <v-card class="ma-2">
        <v-card-title>{{ router.currentRoute.value.name }}</v-card-title>
        <v-card-text>
          <v-divider class="mb-5"></v-divider>
          <router-view />
        </v-card-text>
      </v-card>
    </v-main>
  </v-app>
  <v-dialog v-model="logoutDialog" persistent="">
    <v-card class="ma-auto">
      <v-card-title>Log Out</v-card-title>
      <v-card-text> Are you sure you want to log out? </v-card-text>
      <v-divider></v-divider>
      <v-row class="ma-1">
        <v-col cols="6">
          <v-btn
            color="error"
            block=""
            prepend-icon="mdi-close"
            @click="logoutDialog = false"
            >Cancel</v-btn
          >
        </v-col>
        <v-col cols="6">
          <v-btn
            color="success"
            block=""
            prepend-icon="mdi-logout"
            @click="logout"
            >Log Out</v-btn
          >
        </v-col>
      </v-row>
    </v-card>
  </v-dialog>
</template>
<script setup>
import DrawerMenus from "@/components/menus/drawerMenus.vue";
import SettingMenus from "@/components/menus/settingMenus.vue";

import IdCard from "@/components/misc/idCard.vue";
import router from "@/router";
import { useAppStore } from "@/store/app";
import { ref } from "vue";

const drawer = ref(false);
const logoutDialog = ref(false);

const logout = () => {
  useAppStore().session.auth.token = null;
  router.push("/login");
};
</script>
