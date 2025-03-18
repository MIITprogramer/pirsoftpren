<template>
  <v-data-table :headers="headers" :items="types">
    <template v-slot:top>
      <v-card>
        <template v-slot:prepend>
          <v-icon size="xx-large" color="primary">mdi-information</v-icon>
        </template>
        <template v-slot:title>
          <small class="text-wrap">
            Halaman ini hanya menampilkan informasi jenis-jenis type
            pemeriksaan. Setiap item mempengaruhi sistem secara programatical,
            untuk penambahkan atau perubahan item silahkan hubungi developer.
          </small>
        </template>
      </v-card>
      <v-divider class="my-2"></v-divider>
    </template>
  </v-data-table>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import { onMounted, ref } from "vue";

const types = ref([]);
const headers = [
  {
    title: "Index",
    key: "label",
    align: "start",
  },
  {
    title: "Description",
    key: "description",
    align: "start",
  },
];
const refresh = async () => {
  try {
    const response = await useAppStore().ajaxPost({
      url: "setup/gettypes",
      reqData: {},
    });
    types.value = response.types;
  } catch (error) {
    console.log(error);
  }
};

onMounted(() => {
  refresh();
});
</script>
