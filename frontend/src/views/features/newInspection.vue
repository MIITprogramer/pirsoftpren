<template>
  <v-card>
    <v-toolbar color="transparent">
      <v-autocomplete
        :items="parts"
        item-value="partNumber"
        item-title="partNumber"
        clearable
        v-model="search"
        class="ms-2 w-100"
        density="compact"
        hide-details
        label="Search Part"
        variant="outlined"
        rounded="pill"
        prepend-inner-icon="mdi-magnify"
      ></v-autocomplete>
      <v-spacer></v-spacer>
      <v-btn
        @click="searchPart"
        rounded="pill"
        variant="flat"
        class="ms-2"
        prepend-icon="mdi-magnify"
        color="primary"
        :disabled="search == '' ? true : false"
        >Search</v-btn
      >
    </v-toolbar>
  </v-card>
  <v-divider class="my-2"></v-divider>
  <v-card v-if="!dialog">
    <v-card-text>
      <InspectionTable></InspectionTable>
    </v-card-text>
  </v-card>
  <v-dialog
    v-model="dialog"
    scrollable
    fullscreen
    persistent
    :overlay="false"
    transition="dialog-transition"
  >
    <v-card>
      <v-card-text>
        <InspectionHeader
          :part-data="partData"
          :close-modal="
            () => {
              dialog = false;
            }
          "
        />
      </v-card-text>
    </v-card>
  </v-dialog>
</template>
<script setup>
import InspectionHeader from "@/components/forms/inspectionHeader.vue";
import InspectionTable from "@/components/tables/inspectionTable.vue";
import { useAppStore } from "@/store/app";
import { onMounted, ref } from "vue";

const search = ref("");
const alert = useAppStore().alert;
const dialog = ref(false);
const partData = ref(null);
const parts = ref([]);
const searchPart = async () => {
  try {
    const response = await useAppStore().ajaxPost({
      url: "inspection/searchpart",
      reqData: { partNumber: search.value },
    });
    partData.value = response[0];
    dialog.value = true;
  } catch (error) {
    alert.fire({
      icon: "info",
      text: error,
      title: "Error",
    });
  }
};

onMounted(async () => {
  const response = await useAppStore().ajaxPost({
    url: "setup/getparts",
    reqData: {},
  });
  parts.value = response;
});
</script>
