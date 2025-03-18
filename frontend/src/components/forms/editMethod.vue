<template>
  <v-text-field
    label="Method Name"
    variant="outlined"
    rounded="pill"
    density="compact"
    hint="Please insert a method name"
    v-model="formData.methodName"
    :error-messages="vuelidate.methodName.$errors.map((e) => e.$message)"
  ></v-text-field>
  <v-divider class="my-2"></v-divider>
  <v-btn block color="primary" dark rounded="pill" @click="submit"
    >Update</v-btn
  >
</template>
<script setup>
import { useAppStore } from "@/store/app";
import useVuelidate from "@vuelidate/core";
import { helpers, required } from "@vuelidate/validators";
import { reactive } from "vue";

const props = defineProps(["closeModal", "editData"]);
const alert = useAppStore().alert;

const formData = reactive({
  methodName: props.editData.methodName,
  id: props.editData.id,
});

const rules = {
  methodName: {
    required: helpers.withMessage("Method name id required", required),
  },
};

const vuelidate = useVuelidate(rules, formData);
const submit = async () => {
  try {
    const valid = await vuelidate.value.$validate();
    if (valid) {
      await useAppStore().ajaxPost({
        url: "setup/updatemethod",
        reqData: formData,
      });
      alert.fire({
        title: "Success",
        text: "Method updated successfully",
        icon: "success",
      });
      props.closeModal();
    }
  } catch (error) {
    console.log(error);
    alert.fire({
      title: "Error",
      text: error,
      icon: "error",
    });
  }
};
</script>
