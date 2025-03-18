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
    <div v-if="item.type === 'file'">
      <v-img
        v-if="filePreviews[item.key]"
        :src="filePreviews[item.key]"
        class="mb-2"
      ></v-img>
      <v-file-input
        :error-messages="validators[item.key].$errors.map((e) => e.$message)"
        counter
        :show-size="1000"
        variant="outlined"
        rounded="pill"
        density="compact"
        v-model="formData[item.key]"
        :label="item.label"
        :hint="item.hint"
        accept="image/png"
        @change="handleFileChange(item.key)"
        @click:clear="clearFile(item.key)"
      />
    </div>
  </div>
  <v-switch label="Show Password" color="info" v-model="showPass"></v-switch>
  <v-btn color="primary" block="" rounded="pill" @click="submit">submit</v-btn>
</template>

<script setup>
import { useAppStore } from "@/store/app";
import useVuelidate from "@vuelidate/core";
import { helpers, required } from "@vuelidate/validators";
import { onBeforeMount, reactive, ref, watch } from "vue";

const props = defineProps(["closeModule"]);

// Data form
const formData = reactive({
  userName: "",
  sureName: "",
  role: "",
  signFile: null,
  password: "",
  confirmPassword: "",
});

const rules = {
  userName: {
    required: helpers.withMessage("NIK is required", required),
    nospaces: helpers.withMessage("Do not use spaces", (e) => {
      // Cek apakah ada spasi dalam string
      return !/\s/.test(e); // Mengembalikan true jika tidak ada spasi
    }),
  },
  sureName: {
    required: helpers.withMessage("Name is required", required),
  },
  role: {
    required: helpers.withMessage("Role is required", required),
  },
  signFile: {
    required: helpers.withMessage("Sign file is required", required),
  },
  password: {
    required: helpers.withMessage("Password is required", required),
  },
  confirmPassword: {
    required: helpers.withMessage("Confirm password is required", required),
    match: helpers.withMessage(
      "Confirm password is not match with the password",
      () => {
        return formData.password == formData.confirmPassword;
      }
    ),
  },
};

// Data URL untuk preview
const filePreviews = reactive({});

// Data roles dari API
const roles = ref([]);

// Struktur data form
const structuredData = reactive([
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
  {
    key: "signFile",
    label: "Sign File",
    hint: "Please input sign file for your account",
    type: "file",
  },
  {
    key: "password",
    label: "Password",
    hint: "Please enter your password",
    type: "password",
  },
  {
    key: "confirmPassword",
    label: "Confirm Password",
    hint: "Please re-enter your password",
    type: "password",
  },
]);

// Memuat roles dari API
onBeforeMount(async () => {
  const response = await useAppStore().ajaxPost({
    url: "usersetting/getroles",
    reqData: {},
  });
  roles.value = response.filter((element) => element.roleId !== 1);
});

// Konversi file ke Data URL
const handleFileChange = (key) => {
  const file = formData[key];
  if (file) {
    const reader = new FileReader();
    reader.onload = () => {
      filePreviews[key] = reader.result; // Simpan Data URL
    };
    reader.readAsDataURL(file);
  }
};

// Hapus pratinjau file saat input di-clear
const clearFile = (key) => {
  formData[key] = null; // Reset nilai di formData
  filePreviews[key] = null; // Hapus pratinjau
};

const validators = useVuelidate(rules, formData);

const submit = async () => {
  try {
    const valid = await validators.value.$validate();
    if (valid) {
      let fd = new FormData();
      structuredData.forEach((element) => {
        const key = element.key;
        if (key != "signFile") {
          fd.append(key, formData[key]);
        } else {
          fd.append(key, formData[key], "sign_" + formData.userName);
        }
      });

      await useAppStore().ajaxPostWithFile({
        url: "usersetting/newuser",
        reqData: fd,
      });
      props.closeModule();
    }
  } catch (error) {
    console.log(error);
  }
};

const showPass = ref(false);
watch(showPass, (e) => {
  console.log(e);
  if (e) {
    structuredData.find((e) => e.key == "password").type = "text";
    structuredData.find((e) => e.key == "confirmPassword").type = "text";
  } else {
    structuredData.find((e) => e.key == "password").type = "password";
    structuredData.find((e) => e.key == "confirmPassword").type = "password";
  }
});
</script>
