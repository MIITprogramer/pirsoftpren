<template>
  <div>
    <div v-for="(item, index) in structuredData" :key="index">
      <v-img
        v-if="filePreviews[item.key]"
        :src="filePreviews[item.key]"
        class="mb-2"
        height="200"
      ></v-img>
      <v-img v-else height="200" :src="`data:image/png;base64,${sign}`"></v-img>
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

    <v-btn color="primary" block rounded="pill" @click="submit">
      Change sign
    </v-btn>
  </div>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import useVuelidate from "@vuelidate/core";
import { helpers, required } from "@vuelidate/validators";
import { onMounted, reactive, ref } from "vue";

const props = defineProps(["userId", "closeModule"]);
let sign = ref("");
const filePreviews = reactive({});
const formData = reactive({
  signFile: null,
  userName: "",
});

const structuredData = reactive([
  {
    key: "signFile",
    label: "Sign File",
    hint: "Please input sign file for your account",
    type: "file",
  },
]);

const getSign = async () => {
  try {
    const res = await useAppStore().ajaxPost({
      url: "usersetting/getuserdata",
      reqData: { userId: props.userId },
    });
    sign.value = res.signFile;
    formData.userName = res.response.userName;
  } catch (error) {
    console.log(error);
  }
};

const rules = {
  signFile: {
    required: helpers.withMessage("Sign file is required", required),
  },
};

const validators = useVuelidate(rules, formData);
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

// apus pratinjau file saat input di-clear
const clearFile = (key) => {
  formData[key] = null; // Reset nilai di formData
  filePreviews[key] = null; // Hapus pratinjau
};

onMounted(() => {
  getSign();
});

const submit = async () => {
  try {
    const valid = await validators.value.$validate();
    if (valid) {
      let fd = new FormData();

      fd.append("signFile", formData.signFile, "sign_" + formData.userName);

      await useAppStore().ajaxPostWithFile({
        url: "usersetting/changesign",
        reqData: fd,
      });
      useAppStore().alert.fire({
        text: "file changed successfully",
        title: "Success",
        icon: "success",
      });
      props.closeModule();
    }
  } catch (error) {
    console.log(error);
  }
};
</script>
