<!-- eslint-disable vue/valid-v-slot -->
<template>
  <v-card>
    <v-toolbar density="compact" color="transparent">
      <v-toolbar-title>Role List</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn color="primary" prepend-icon="mdi-plus" @click="dialog = true"
        >Role</v-btn
      >
    </v-toolbar>
    <v-card-text>
      <v-data-table
        sticky=""
        class="table"
        :headers="headers"
        :search="searchRole"
        :items="roles"
      >
        <template v-slot:top>
          <div class="w-100 d-flex justify-end">
            <v-text-field
              max-width="400"
              variant="outlined"
              rounded="pill"
              density="compact"
              label="Search Role"
              prepend-inner-icon="mdi-magnify"
              v-model="searchRole"
              id="searchInput"
            ></v-text-field>
          </div>
        </template>
        <template v-slot:item.actions="{ item }">
          <v-icon
            color="primary"
            class="me-2"
            size="small"
            @click="editItem(item)"
          >
            mdi-pencil
          </v-icon>
          <v-icon color="error" size="small" @click="deleteItem(item.roleId)">
            mdi-delete
          </v-icon>
        </template>
      </v-data-table>
    </v-card-text>
  </v-card>
  <v-dialog
    v-model="dialog"
    scrollable
    persistent
    :overlay="false"
    max-width="500px"
    transition="dialog-transition"
  >
    <v-card>
      <v-toolbar density="compact" color="transparent">
        <v-toolbar-title>New Role</v-toolbar-title>
        <v-btn flat icon @click="dialog = false">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-toolbar>
      <v-card-text>
        <NewRoles :close-modal="closeModal"></NewRoles>
      </v-card-text>
    </v-card>
  </v-dialog>

  <v-dialog
    v-model="updateDialog"
    scrollable
    persistent
    :overlay="false"
    max-width="500px"
    transition="dialog-transition"
  >
    <v-card>
      <v-toolbar density="compact" color="transparent">
        <v-toolbar-title>Edit Role</v-toolbar-title>
        <v-btn flat icon @click="updateDialog = false">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-toolbar>
      <v-card-text>
        <EditRole :close-modal="closeModal" :edit-data="editItemObj"></EditRole>
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
        <v-toolbar-title>Delete Role</v-toolbar-title>
        <v-btn flat icon @click="deleteRole = false">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-toolbar>
      <v-card-text> Are you sure you want to delete the role? </v-card-text>
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
import { onBeforeMount, ref, watch } from "vue";
import NewRoles from "../forms/newRoles.vue";
import { useAppStore } from "@/store/app";
import EditRole from "../forms/editRole.vue";
import Swal from "sweetalert2";

const searchRole = ref("");
const headers = [
  { title: "No", align: "center", key: "no" },
  { title: "Role Name", align: "start", key: "roleName" },
  { align: "center", key: "actions", title: "Actions" },
];

let roles = ref([]);
let editItemObj = ref({});
let deleteRole = ref(false);
let deleteId = ref("");

const deleteItem = (id) => {
  deleteId.value = id;
  deleteRole.value = true;
};

const deleteMe = async () => {
  try {
    await useAppStore().ajaxPost({
      url: "usersetting/deleterole",
      reqData: {
        roleId: deleteId.value,
      },
    });
    const toast = Swal.mixin({
      toast: true,
      position: "top-end",
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: true,
      didOpen: (toast) => {
        toast.onmouseenter = Swal.stopTimer;
        toast.onmouseleave = Swal.resumeTimer;
      },
      customClass: {
        container: "swal-custom-zindex", // Class kustom untuk elemen swal
      },
    });

    toast.fire({
      icon: "success",
      text: "Role is successfully deleted",
      title: "Deleted",
    });
    closeModal();
  } catch (error) {
    console.log(error);
  }
};

onBeforeMount(async () => {
  refresh();
});

const refresh = async () => {
  try {
    let response = await useAppStore().ajaxPost({
      url: "usersetting/getroles",
      reqData: {},
    });

    response = response.filter((element) => element.roleId !== 1);
    response.forEach((element, index) => {
      response[index].no = index + 1;
      response[index].actions = "";
    });
    roles.value = response;
  } catch (error) {
    console.log(error);
  }
};

const dialog = ref(false);

const updateDialog = ref(false);

const closeModal = () => {
  dialog.value = false;
  updateDialog.value = false;
  deleteRole.value = false;
};

watch(dialog, () => {
  refresh();
});

watch(updateDialog, () => {
  refresh();
});

watch(deleteRole, () => {
  refresh();
});

const editItem = (item) => {
  console.log(item);
  editItemObj.value = item;
  updateDialog.value = true;
};
</script>
