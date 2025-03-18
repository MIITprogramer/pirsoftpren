<!-- eslint-disable vue/valid-v-slot -->
<template>
  <v-data-table :headers="headers" :search="search" :items="methods">
    <template v-slot:top>
      <v-row class="mt-1">
        <v-col cols="10">
          <v-text-field
            v-model="search"
            label="search"
            prepend-inner-icon="mdi-magnify"
            variant="outlined"
            rounded="pill"
            density="compact"
          />
        </v-col>
        <v-col cols="2">
          <v-btn
            variant="plain"
            block
            color="primary"
            flat
            prepend-icon="mdi-plus"
            @click="openModal('new')"
            >Method</v-btn
          >
        </v-col>
      </v-row>
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
      <v-icon color="error" size="small" @click="deleteItem(item.id)">
        mdi-delete
      </v-icon>
    </template>
  </v-data-table>
  <v-dialog
    v-model="methodeModal"
    scrollable
    persistent
    :overlay="false"
    max-width="500px"
    transition="dialog-transition"
  >
    <v-card>
      <v-toolbar density="compact" color="transparent">
        <v-toolbar-title v-if="newModal">New Method Check</v-toolbar-title>
        <v-toolbar-title v-else>Edit Method Check</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn flat icon color="" @click="closeModal">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-toolbar>
      <v-card-text>
        <NewMethod v-if="newModal" :close-modal="closeModal"></NewMethod>
        <EditMethod
          v-else
          :close-modal="closeModal"
          :edit-data="editId"
        ></EditMethod>
      </v-card-text>
    </v-card>
  </v-dialog>

  <v-dialog
    v-model="deleteMethod"
    scrollable
    persistent
    :overlay="false"
    max-width="500px"
    transition="dialog-transition"
  >
    <v-card>
      <v-toolbar density="compact" color="transparent">
        <v-toolbar-title>Delete Method</v-toolbar-title>
        <v-btn flat icon @click="deleteMethod = false">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-toolbar>
      <v-card-text> Are you sure you want to delete the method? </v-card-text>
      <v-divider></v-divider>
      <v-row class="ma-1">
        <v-col cols="6">
          <v-btn
            color="default"
            block=""
            prepend-icon="mdi-close"
            @click="deleteMethod = false"
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
import { onMounted, ref } from "vue";
import NewMethod from "../forms/newMethod.vue";

import { useAppStore } from "@/store/app";
import EditMethod from "../forms/editMethod.vue";

const search = ref("");
const methodeModal = ref(false);
const newModal = ref(false);
const headers = [
  {
    title: "Method",
    key: "methodName",
  },
  {
    title: "Actions",
    key: "actions",
    align: "center",
    sortable: false,
  },
];
const methods = ref([]);
const editId = ref("");
const deleteId = ref("");
const deleteMethod = ref(false);
const alert = useAppStore().alert;

const openModal = (e) => {
  if (e == "new") {
    newModal.value = true;
  }
  methodeModal.value = true;
  editId.value = e;
};

const refreshTable = async () => {
  try {
    const response = await useAppStore().ajaxPost({
      url: "setup/getmethods",
      reqData: {},
    });
    methods.value = response.methods;
  } catch (error) {
    console.log(error);
  }
};

const closeModal = () => {
  methodeModal.value = false;
  newModal.value = false;
  deleteMethod.value = false;
  refreshTable();
};

onMounted(() => {
  refreshTable();
});

const deleteItem = (id) => {
  deleteId.value = id;
  deleteMethod.value = true;
};

const deleteMe = async () => {
  try {
    await useAppStore().ajaxPost({
      url: "setup/deletemethod",
      reqData: { deleteId: deleteId.value },
    });
    closeModal();
    alert.fire({
      title: "Success",
      text: "Method deleted successfully",
      icon: "success",
    });
  } catch (error) {
    console.log(error);
  }
};
</script>
