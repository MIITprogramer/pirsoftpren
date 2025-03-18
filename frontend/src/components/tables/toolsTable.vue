<!-- eslint-disable vue/valid-v-slot -->
<template>
  <v-data-table :headers="headers" :search="search" :items="tools">
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
            @click="openModal()"
            >Tool</v-btn
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
      <v-icon color="error" size="small" @click="deleteItem(item.toolId)">
        mdi-delete
      </v-icon>
    </template>
  </v-data-table>
  <v-dialog
    v-model="dialog"
    scrollable
    persistent
    :overlay="false"
    max-width="500px"
    transition="dialog-transition"
  >
    <v-card>
      <v-toolbar color="transparent">
        <v-toolbar-title>{{ dialogTitle }}</v-toolbar-title>
        <v-spacer />
        <v-btn flat icon @click="closeModal">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-toolbar>
      <v-card-text>
        <NewTool
          v-if="dialogTitle == 'New Tool'"
          :close-modal="closeModal"
        ></NewTool>
        <EditTool
          v-else
          :edit-item="editItem"
          :close-modal="closeModal"
        ></EditTool>
      </v-card-text>
    </v-card>
  </v-dialog>
  <v-dialog
    v-model="deleteTool"
    scrollable
    persistent
    :overlay="false"
    max-width="500px"
    transition="dialog-transition"
  >
    <v-card>
      <v-toolbar density="compact" color="transparent">
        <v-toolbar-title>Delete Tool</v-toolbar-title>
        <v-btn flat icon @click="deleteTool = false">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-toolbar>
      <v-card-text> Are you sure you want to delete the tool? </v-card-text>
      <v-divider></v-divider>
      <v-row class="ma-1">
        <v-col cols="6">
          <v-btn
            color="default"
            block=""
            prepend-icon="mdi-close"
            @click="deleteTool = false"
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
import { onBeforeMount, ref } from "vue";
import NewTool from "../forms/newTool.vue";

import { useAppStore } from "@/store/app";
import EditTool from "../forms/editTool.vue";

const alert = useAppStore().alert;
const search = ref();
const dialog = ref(false);
const dialogTitle = ref("New Tool");
const tools = ref([]);
const editItem = ref(null);
const deleteTool = ref(false);
let deleteId = ref("");
const openModal = (e) => {
  dialog.value = true;
  if (e) {
    dialogTitle.value = "Edit Tool";
    editItem.value = e;
  } else {
    dialogTitle.value = "New Tool";
  }
};
const closeModal = () => {
  dialog.value = false;
  deleteTool.value = false;
  refresh();
};
const headers = [
  {
    key: "toolName",
    title: "Tool Number",
    align: "start",
  },
  {
    key: "methodName",
    title: "Method",
    align: "start",
  },
  {
    key: "actions",
    title: "Actions",
    align: "center",
  },
];

const refresh = async () => {
  try {
    const response = await useAppStore().ajaxPost({
      url: "setup/gettools",
      reqData: {},
    });
    tools.value = response.tools;
  } catch (error) {
    console.log(error);
  }
};

const deleteItem = (id) => {
  deleteId.value = id;
  deleteTool.value = true;
};

const deleteMe = async () => {
  try {
    await useAppStore().ajaxPost({
      url: "setup/deletetool",
      reqData: { deleteId: deleteId.value },
    });
    closeModal();
    alert.fire({
      title: "Success",
      text: "tool deleted successfully",
      icon: "success",
    });
  } catch (error) {
    console.log(error);
  }
};
onBeforeMount(() => {
  refresh();
});
</script>
