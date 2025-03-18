<template>
  <v-data-table :items="menus" :headers="headers">
    <template v-slot:item.access="{ item }">
      <v-row>
        <v-col cols="4" v-for="(i, index) in roles" :key="index">
          <v-checkbox
            hide-details
            density="compact"
            :true-value="i.roleId"
            v-model="item.access"
            @change="changeAccess(item.access, item.id)"
          >
            <template v-slot:label>
              <small>{{ i.roleName }}</small>
            </template>
          </v-checkbox>
        </v-col>
      </v-row>
    </template>

    <template v-slot:item.view="{ item }">
      <v-row>
        <v-col cols="4" v-for="(i, index) in roles" :key="index">
          <v-checkbox
            hide-details
            density="compact"
            :true-value="i.roleId"
            v-model="item.view"
            @change="changeView(item.view, item.id)"
          >
            <template v-slot:label>
              <small>{{ i.roleName }}</small>
            </template>
          </v-checkbox>
        </v-col>
      </v-row>
    </template>
  </v-data-table>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import { onBeforeMount, reactive, ref } from "vue";

let menus = ref([]);
let roles = ref([]);
let token = useAppStore().session.auth.token;
let menuAccess = reactive({});
let headers = [
  { title: "Menu Name", key: "label" },
  { title: "Access", key: "access" },
  { title: "View", key: "view" },
];

onBeforeMount(async () => {
  try {
    let response = await useAppStore().ajaxPost({
      url: "auth/getmenusadmin",
      reqData: {
        token,
      },
    });
    response.settings.map((element) => {
      element.access = JSON.parse(element.access);
      element.view = JSON.parse(element.view);
      return element;
    });
    menus.value = response.settings;

    let rolesres = await useAppStore().ajaxPost({
      url: "usersetting/getroles",
      reqData: {},
    });

    rolesres = rolesres.filter((element) => element.roleId !== 1);
    rolesres.forEach((element, index) => {
      rolesres[index].no = index + 1;
      rolesres[index].actions = "";
    });
    roles.value = rolesres;
  } catch (error) {
    console.log(error);
  }
});

const changeAccess = async (access, menuId) => {
  try {
    const data = { access, menuId };
    await useAppStore().ajaxPost({ url: "auth/updateaccess", reqData: data });
  } catch (error) {
    console.log(error);
  }
};

const changeView = async (view, menuId) => {
  try {
    const data = { view, menuId };
    await useAppStore().ajaxPost({ url: "auth/updatemenuview", reqData: data });
  } catch (error) {
    console.log(error);
  }
};
</script>
