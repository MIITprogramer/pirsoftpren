<template>
  <v-text-field
    variant="outlined"
    rounded="pill"
    density="compact"
    label="Tool Number"
    hint="Please enter a Tool Number"
    v-model="formData.toolName"
    :error-messages="validate.toolName.$errors.map((e) => e.$message)"
  />
  <v-select
    :items="methods"
    item-title="methodName"
    item-value="id"
    class="mt-2"
    variant="outlined"
    rounded="pill"
    density="compact"
    label="Method"
    hint="Please enter select a method"
    v-model="formData.method"
    :error-messages="validate.method.$errors.map((e) => e.$message)"
  ></v-select>
  <v-divider class="my-2"></v-divider>
  <v-btn block="" flat color="primary" rounded="pill" @click="submit"
    >Add Tool</v-btn
  >
</template>
<script setup>
import { useAppStore } from "@/store/app";
import useVuelidate from "@vuelidate/core";
import { helpers, required } from "@vuelidate/validators";
import { onBeforeMount, reactive, ref } from "vue";

const props = defineProps(["closeModal", "editId"]);
const alert = useAppStore().alert;
const methods = ref([]);
const refresh = async () => {
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
const formData = reactive({
  toolName: "",
  method: "",
});
const rules = {
  toolName: {
    Required: helpers.withMessage("Tool Number is required", required),
  },
  method: {
    required: helpers.withMessage("please select a method", required),
  },
};

const validate = useVuelidate(rules, formData);

const submit = async () => {
  try {
    const valid = await validate.value.$validate();
    if (valid) {
      await useAppStore().ajaxPost({
        url: "setup/addtool",
        reqData: formData,
      });

      alert.fire({
        title: "Success",
        text: "Tool added successfully",
        icon: "success",
      });

      props.closeModal();
    }
  } catch (error) {
    alert.fire({
      title: "Error",
      text: error,
      icon: "error",
    });
  }
};

onBeforeMount(() => {
  refresh();
});
</script>
