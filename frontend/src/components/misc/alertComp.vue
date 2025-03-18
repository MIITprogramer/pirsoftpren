<template>
  <div class="position-fixed w-100" style="z-index: 5000; top: 5px">
    <div class="ma-auto d-flex align-center" style="width: 80%">
      <v-alert
        width="300"
        class="ma-auto"
        density="compact"
        :color="data.color"
        :icon="data.icon"
        :title="data.title"
        :text="data.text"
      ></v-alert>
    </div>
  </div>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import { onMounted } from "vue";
const data = useAppStore().alertData;
onMounted(() => {
  setTimeout(() => {
    useAppStore().alert = false;
  }, 3000);
});
</script>
