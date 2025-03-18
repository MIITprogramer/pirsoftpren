<template>
  <v-card>
    <v-toolbar
      density="compact"
      :color="updateInfo ? 'primary' : 'transparent'"
    >
      <v-toolbar-title>Update User Info</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn
        flat
        icon
        color="default"
        @click="
          () => {
            updatePassword = false;
            updateInfo = !updateInfo;
            changeSign = false;
          }
        "
      >
        <v-icon v-if="updateInfo">mdi-chevron-up</v-icon>
        <v-icon v-else>mdi-chevron-down</v-icon>
      </v-btn>
    </v-toolbar>
    <VExpandTransition>
      <v-card-text v-if="updateInfo">
        <EditUserInfo
          :user-id="props.userId"
          :close-modal="props.closeModule"
        ></EditUserInfo>
      </v-card-text>
    </VExpandTransition>
  </v-card>
  <v-divider class="my-5"></v-divider>
  <v-card
    ><v-toolbar
      density="compact"
      :color="changeSign ? 'primary' : 'transparent'"
    >
      <v-toolbar-title>Change Sign File</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn
        flat
        icon
        @click="
          () => {
            updatePassword = false;
            updateInfo = false;
            changeSign = !changeSign;
          }
        "
      >
        <v-icon v-if="changeSign">mdi-chevron-up</v-icon>
        <v-icon v-else>mdi-chevron-down</v-icon>
      </v-btn>
    </v-toolbar>
    <VExpandTransition>
      <v-card-text v-if="changeSign">
        <EditSign
          :user-id="props.userId"
          :close-module="closeModule"
        ></EditSign>
      </v-card-text>
    </VExpandTransition>
  </v-card>

  <v-divider class="my-5"></v-divider>
  <v-card
    ><v-toolbar
      density="compact"
      :color="updatePassword ? 'primary' : 'transparent'"
    >
      <v-toolbar-title>Change Password</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn
        flat
        icon
        @click="
          () => {
            updatePassword = !updatePassword;
            updateInfo = false;
            changeSign = false;
          }
        "
      >
        <v-icon v-if="updatePassword">mdi-chevron-up</v-icon>
        <v-icon v-else>mdi-chevron-down</v-icon>
      </v-btn>
    </v-toolbar>
    <VExpandTransition>
      <v-card-text v-if="updatePassword">
        <EditPassword
          :props-user="userId"
          :close-module="closeModule"
        ></EditPassword>
      </v-card-text>
    </VExpandTransition>
  </v-card>
</template>

<script setup>
import { ref } from "vue";
import EditUserInfo from "./editUserInfo.vue";
import EditSign from "./editSign.vue";
import EditPassword from "./editPassword.vue";

const props = defineProps(["closeModule", "userId"]);

const changeSign = ref(false);
const updateInfo = ref(false);
const updatePassword = ref(false);
</script>
