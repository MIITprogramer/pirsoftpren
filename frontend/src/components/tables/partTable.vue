<!-- eslint-disable vue/valid-v-slot -->
<template>
  <v-card>
    <v-toolbar density="compact" color="transparent">
      <template v-slot:title>Part List</template>
      <template v-slot:append>
        <v-btn flat @click="openModal(null)" prepend-icon="mdi-plus"
          >Add Part</v-btn
        >
      </template>
    </v-toolbar>
    <v-card-text>
      <v-data-table
        :search="search"
        :items="items"
        :headers="headers"
        item-value="partId"
      >
        <template v-slot:top>
          <div class="w-100 d-flex justify-end">
            <v-text-field
              max-width="400"
              variant="outlined"
              rounded="pill"
              density="compact"
              label="Search Part"
              prepend-inner-icon="mdi-magnify"
              v-model="search"
              id="searchInput"
            />
          </div>
        </template>

        <template v-slot:item.partNumber="{ item }">
          <div class="text-uppercase">{{ item.partNumber }}</div>
        </template>
        <template v-slot:item.partName="{ item }">
          <div class="text-uppercase text-no-wrap">{{ item.partName }}</div>
        </template>
        <template v-slot:item.customerName="{ item }">
          <div class="text-uppercase text-no-wrap">{{ item.customerName }}</div>
        </template>
        <template v-slot:item.deliveryModel="{ item }">
          <div class="text-uppercase">{{ item.deliveryModel }}</div>
        </template>
        <template v-slot:item.dieCavity="{ item }">
          <div class="text-uppercase">{{ item.dieCavity }}</div>
        </template>
        <template v-slot:item.itemCheck="{ item }">
          <div class="text-uppercase">
            {{ JSON.parse(item.inspectionItem).length }} Item
          </div>
        </template>
        <template v-slot:item.actions="{ item }">
          <v-icon
            color="primary"
            class="me-2"
            size="small"
            @click="openModal(item)"
          >
            mdi-pencil
          </v-icon>
          <v-icon @click="deleteModal(item.partId)" color="error" size="small">
            mdi-delete
          </v-icon>
        </template>
      </v-data-table>
    </v-card-text>
  </v-card>
  <v-dialog
    v-model="dialog"
    scrollable
    fullscreen
    persistent
    :overlay="false"
    max-width="500px"
    transition="dialog-transition"
  >
    <v-card>
      <v-toolbar density="compact" color="transparent">
        <template v-slot:title>{{ modalTitles }}</template>
        <template v-slot:append>
          <v-btn flat icon @click="dialog = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </template>
      </v-toolbar>
      <v-card-text>
        <NewPir
          v-if="modalTitles == 'New Part'"
          :close-modal="closeModal"
        ></NewPir>
        <EditPir v-else :part-data="editId" :close-modal="closeModal"></EditPir>
      </v-card-text>
    </v-card>
  </v-dialog>

  <v-dialog
    v-model="deleteRole"
    scrollable
    persistent
    :overlay="false"
    max-width="500px"
    transition="dialog-transition"
  >
    <v-card>
      <v-toolbar density="compact" color="transparent">
        <v-toolbar-title>Delete Part</v-toolbar-title>
        <v-btn flat icon @click="deleteRole = false">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-toolbar>
      <v-card-text> Are you sure you want to delete this part? </v-card-text>
      <v-divider></v-divider>
      <v-row class="ma-1">
        <v-col cols="6">
          <v-btn
            color="default"
            block=""
            prepend-icon="mdi-close"
            @click="deleteRole = false"
            >Cancel</v-btn
          >
        </v-col>
        <v-col cols="6">
          <v-btn
            color="error"
            block=""
            prepend-icon="mdi-delete"
            @click="deleteMe()"
            >Delete</v-btn
          >
        </v-col>
      </v-row>
    </v-card>
  </v-dialog>
</template>
<script setup>
import NewPir from "@/components/forms/newPir.vue";

import { useAppStore } from "@/store/app";
import { onBeforeMount, ref } from "vue";
import EditPir from "../forms/editPir.vue";

const dialog = ref(false);
const deletePart = ref(null);
const deleteRole = ref(false);
let editId = ref("");
const search = ref("");
const headers = [
  {
    key: "partNumber",
    title: "Part Number",
  },
  {
    key: "partName",
    title: "Part Name",
  },
  {
    key: "customerName",
    title: "Customer Name",
  },
  {
    key: "itemCheck",
    title: "Total Inspection Item",
  },

  {
    key: "samplingLevel",
    title: "Sampling Level",
  },
  {
    key: "actions",
    title: "Actions",
  },
];
let items = ref([]);
let modalTitles = ref("New Part");
const toast = useAppStore().alert;

const openModal = (id) => {
  if (id == null) {
    modalTitles.value = "New Part";
    dialog.value = true;
  } else {
    editId.value = id;
    modalTitles.value = "Edit Part";
    dialog.value = true;
  }
};

const deleteModal = (id) => {
  deleteRole.value = true;
  deletePart.value = id;
};

const deleteMe = async () => {
  try {
    await useAppStore().ajaxPost({
      url: "setup/deletepart",
      reqData: { partId: deletePart.value },
    });
    toast.fire({
      icon: "success",
      title: "Part Deleted",
      text: "part deleted successfully",
    });
    closeModal();
  } catch (error) {
    console.error(error);
  }
};

const refresh = async () => {
  try {
    items.value = await useAppStore().ajaxPost({
      url: "setup/getparts",
      reqData: {},
    });
  } catch (error) {
    console.log(error);
  }
};

const closeModal = () => {
  dialog.value = false;
  deleteRole.value = false;
  refresh();
};

onBeforeMount(() => {
  refresh();
});
</script>
