<template>
  <div v-for="(item, index) in dataStructure" :key="index">
    <v-text-field
      :label="item.label"
      :hint="item.hint"
      v-model="formData[index]"
      variant="outlined"
      rounded="pill"
      density="compact"
      :error-messages="validate[index].$errors.map((e) => e.$message)"
    />
  </div>
  <v-select
    label="Home Page"
    variant="outlined"
    density="compact"
    rounded="pill"
    v-model="formData['home']"
    :items="menus"
    item-title="label"
    item-value="path"
  >
  </v-select>
  <v-divider class="my-2"></v-divider>
  <v-btn @click="submit" color="primary" block rounded="pill">submit</v-btn>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import useVuelidate from "@vuelidate/core";
import { helpers, required } from "@vuelidate/validators";
import Swal from "sweetalert2";
import { onMounted, reactive, ref } from "vue";

const props = defineProps(["closeModal", "editData"]);
const menus = ref([]);

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

const formData = reactive({
  roleId: props.editData.roleId,
  roleName: props.editData.roleName,
  home: props.editData.home,
});

const dataStructure = {
  roleName: {
    label: "Role name",
    hint: "Insert Role Name",
  },
};

const rules = {
  roleName: {
    required: helpers.withMessage("Role name is required", required),
  },
};

const validate = useVuelidate(rules, formData);

const submit = async () => {
  try {
    const valid = await validate.value.$validate();
    if (valid) {
      await useAppStore().ajaxPost({
        url: "usersetting/editrole",
        reqData: formData,
      });
      props.closeModal();
    }
  } catch (error) {
    toast.fire({
      title: "Error",
      text: error,
      icon: "error",
    });
  }
};

onMounted(async () => {
  try {
    menus.value = await useAppStore().ajaxPost({
      url: "setup/gethomes",
      reqData: {},
    });
    console.log(menus.value);
  } catch (error) {
    console.log(error);
  }
});
</script>
