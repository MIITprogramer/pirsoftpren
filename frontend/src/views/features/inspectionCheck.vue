<!-- eslint-disable vue/valid-v-slot -->
<template>
  <InspectionResultTable
    v-if="!dialog"
    :open-check="openCheck"
  ></InspectionResultTable>
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
        <InspectionResult
          :selected-data="selectedData"
          :close-modal="closeModal"
        />
      </v-card-text>
    </v-card>
  </v-dialog>
</template>
<script setup>
import InspectionResult from "@/components/misc/inspectionResult.vue";
import InspectionResultTable from "@/components/tables/inspectionResultTable.vue";
import { ref } from "vue";

const dialog = ref(false);
const closeModal = () => {
  dialog.value = false;
};

let selectedData = ref({
  role: "",
  data: null,
});
const openCheck = (data, role) => {
  selectedData.value.data = data;
  selectedData.value.role = role;
  dialog.value = true;
};
</script>
