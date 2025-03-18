<template>
  <div class="mb-2" v-for="(item, index) in structuredData" :key="index">
    <v-text-field
      v-if="item.type === 'text' || item.type === 'password'"
      variant="outlined"
      rounded="pill"
      density="compact"
      v-model="formData[item.key]"
      :label="item.label"
      :hint="item.hint"
      :type="item.type"
      :error-messages="validators[item.key].$errors.map((e) => e.$message)"
    />
    <v-select
      v-if="item.type === 'select'"
      :label="item.label"
      :items="roles"
      item-title="roleName"
      item-value="roleId"
      variant="outlined"
      rounded="pill"
      density="compact"
      v-model="formData[item.key]"
      :error-messages="validators[item.key].$errors.map((e) => e.$message)"
    ></v-select>
  </div>
  <v-btn color="primary" block rounded="pill" @click="editIdentity">
    Edit Info
  </v-btn>
</template>

<script setup>
import { useAppStore } from "@/store/app";
import useVuelidate from "@vuelidate/core";
import { helpers, required } from "@vuelidate/validators";
import { onBeforeMount, reactive, ref } from "vue";

const props = defineProps(["userId", "closeModal"]);
const roles = ref([]);
const toast = useAppStore().alert;

const formData = reactive({
  userId: "",
  userName: "",
  sureName: "",
  role: "",
});

const rules = {
  userName: {
    required: helpers.withMessage("NIK is required", required),
    nospaces: helpers.withMessage("Do not use spaces", (e) => {
      return !/\s/.test(e);
    }),
  },
  sureName: {
    required: helpers.withMessage("Name is required", required),
  },
  role: {
    required: helpers.withMessage("Role is required", required),
  },
};

const structuredData = [
  {
    key: "userName",
    label: "NIK",
    hint: "Please enter NIK",
    type: "text",
  },
  {
    key: "sureName",
    label: "Name",
    hint: "Please enter account Name",
    type: "text",
  },
  {
    key: "role",
    label: "Role",
    hint: "Please select account's role",
    type: "select",
  },
];

const getData = async () => {
  try {
    const res = await useAppStore().ajaxPost({
      url: "usersetting/getuserdata",
      reqData: { userId: props.userId },
    });

    const obj = res.response;

    Object.keys(formData).forEach((key) => {
      formData[key] = obj[key];
    });
  } catch (error) {
    console.log(error);
  }
};

onBeforeMount(async () => {
  const response = await useAppStore().ajaxPost({
    url: "usersetting/getroles",
    reqData: {},
  });
  roles.value = response.filter((element) => element.roleId !== 1);
  getData();
});

const validators = useVuelidate(rules, formData);

const editIdentity = async () => {
  try {
    const valid = await validators.value.$validate();

    if (valid) {
      await useAppStore().ajaxPost({
        url: "usersetting/edituserdata",
        reqData: formData,
      });
      toast.fire({
        title: "Success",
        text: "Account successfully updated",
        icon: "success",
      });
      props.closeModal();
    }
  } catch (error) {
    console.log(error);
    toast.fire({
      title: "Error",
      text: error,
      icon: "error",
    });
  }
};
</script>
