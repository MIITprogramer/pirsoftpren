<template>
  <div v-for="(item, index) in menus" :key="index">
    <div class="my-2 px-2" v-if="JSON.parse(item.view).includes(role)">
      <v-btn
        rounded="pill"
        @click="router.push(item.path)"
        :disabled="!JSON.parse(item.access).includes(role)"
        :color="
          item.path == router.currentRoute.value.path ? 'info' : 'default'
        "
        block=""
        >{{ item.label }}</v-btn
      >
    </div>
  </div>
</template>
<script setup>
import router from "@/router";
import { useAppStore } from "@/store/app";
import { onBeforeMount, ref } from "vue";

let menus = ref([]);
let token = useAppStore().session.auth.token;
let role = ref("");
onBeforeMount(async () => {
  try {
    const response = await useAppStore().ajaxPost({
      url: "auth/getmenus",
      reqData: {
        token,
      },
    });
    menus.value = response.settings;
    role.value = response.role;
  } catch (error) {
    console.log(error);
  }
});
</script>
