<!-- eslint-disable vue/valid-v-slot -->
<template>
  <div>
    <v-card>
      <v-toolbar density="compact" color="transparent">
        <v-toolbar-title>User List</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn
          @click="openModal(null)"
          flat
          color="primary"
          prepend-icon="mdi-plus"
          >User</v-btn
        >
      </v-toolbar>
      <v-card-text>
        <v-data-table
          :search="searchUser"
          :items="users"
          :headers="[
            { key: 'no', title: 'No', align: 'center' },
            { key: 'userName', title: 'NIK', align: 'start' },
            { key: 'sureName', title: 'Name', align: 'start' },
            { key: 'roleName', title: 'Role', align: 'center' },
            { key: 'actions', title: 'Actions', align: 'center' },
          ]"
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
                v-model="searchUser"
                id="searchInput"
              ></v-text-field>
            </div>
          </template>
          <template v-slot:item.actions="{ item }">
            <v-icon
              color="primary"
              class="me-2"
              size="small"
              @click="openModal(item.userId)"
            >
              mdi-pencil
            </v-icon>
            <v-icon
              color="error"
              size="small"
              @click="deleteItem(item.userId)"
              v-if="item.role != 36"
            >
              mdi-delete
            </v-icon>
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>
    <v-dialog
      v-model="newUserDialog"
      scrollable
      persistent
      :overlay="false"
      max-width="500px"
      transition="dialog-transition"
    >
      <v-card>
        <v-toolbar density="compact" color="transparent">
          <v-toolbar-title v-if="newUser"> New User </v-toolbar-title>
          <v-toolbar-title v-else> Edit User </v-toolbar-title>
          <v-spacer></v-spacer>
          <v-btn
            color="default"
            icon="mdi-close"
            @click="newUserDialog = false"
          ></v-btn>
        </v-toolbar>
        <v-card-text>
          <NewUser
            v-if="newUser"
            :close-module="
              () => {
                newUserDialog = false;
              }
            "
          ></NewUser>
          <EditUser
            v-else
            :close-module="
              () => {
                newUserDialog = false;
              }
            "
            :user-id="editId"
          ></EditUser>
        </v-card-text>
      </v-card>
    </v-dialog>
    <v-dialog
      v-model="deleteUser"
      scrollable
      persistent
      :overlay="false"
      max-width="500px"
      transition="dialog-transition"
    >
      <v-card>
        <v-toolbar density="compact" color="transparent">
          <v-toolbar-title>Delete User</v-toolbar-title>
          <v-btn flat icon @click="deleteUser = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-toolbar>
        <v-card-text> Are you sure you want to delete this user? </v-card-text>
        <v-divider></v-divider>
        <v-row class="ma-1">
          <v-col cols="6">
            <v-btn
              color="default"
              block=""
              prepend-icon="mdi-close"
              @click="deleteUser = false"
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
  </div>
</template>
<script setup>
import { onBeforeMount, ref, watch } from "vue";
import NewUser from "../forms/newUser.vue";
import { useAppStore } from "@/store/app";
import EditUser from "../forms/editUser.vue";
import Swal from "sweetalert2";

let users = ref([]);
const deleteUser = ref(false);
const deleteId = ref("");
let searchUser = ref("");
onBeforeMount(() => {
  refresh();
});

const newUser = ref(true);
const editId = ref("");

const openModal = (e) => {
  if (e === null) {
    newUser.value = true;
    newUserDialog.value = true;
  } else {
    newUser.value = false;
    newUserDialog.value = true;
    editId.value = e;
  }
};

const refresh = async () => {
  try {
    let response = await useAppStore().ajaxPost({ url: "usersetting/users" });
    response = response.filter((element) => element.role !== 1);

    let n = 1;

    users.value = response;

    users.value.forEach((element, index) => {
      users.value[index].no = n++;
      users.value[index].actions = null;
    });
  } catch (error) {
    console.log(error);
  }
};

const newUserDialog = ref(false);

const deleteItem = (id) => {
  deleteId.value = id;
  deleteUser.value = true;
};

watch(newUserDialog, () => {
  refresh();
});

const deleteMe = async () => {
  try {
    await useAppStore().ajaxPost({
      url: "usersetting/deleteuser",
      reqData: {
        userId: deleteId.value,
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
      text: "User is successfully deleted",
      title: "Deleted",
    });
    closeModal();
  } catch (error) {
    console.log(error);
  }
};

const closeModal = () => {
  deleteUser.value = false;
  refresh();
};
</script>
