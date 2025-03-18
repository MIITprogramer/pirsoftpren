<template>
  <div>
    <v-list-item
      v-for="(item, index) in menus"
      :key="index"
      @click="router.push(item.path)"
    >
      <template v-slot:prepend>
        <v-icon>{{ item.icon }}</v-icon>
      </template>
      <v-list-item-title>{{ item.label }}</v-list-item-title>
    </v-list-item>
  </div>
</template>
<script setup>
import router from "@/router";
import { useAppStore } from "@/store/app";
import { onBeforeMount, ref } from "vue";
let menus = ref([]);
let token = useAppStore().session.auth.token;

onBeforeMount(async () => {
  try {
    const response = await useAppStore().ajaxPost({
      url: "auth/getsetting",
      reqData: {
        token,
      },
    });
    menus.value = response.settings;
  } catch (error) {
    console.log(error);
  }
});
</script>
