<template>
  <div class="mb-2" v-for="(item, index) in structuredData" :key="index">
    <v-text-field
      variant="outlined"
      rounded="pill"
      density="compact"
      v-model="formData[item.key]"
      :label="item.label"
      :hint="item.hint"
      :type="item.type"
      :error-messages="validators[item.key].$errors.map((e) => e.$message)"
    />
  </div>

  <v-switch label="Show Password" color="info" v-model="showPass"></v-switch>

  <v-btn color="primary" block rounded="pill" @click="editIdentity">
    change password
  </v-btn>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import useVuelidate from "@vuelidate/core";
import { helpers, required } from "@vuelidate/validators";
import { onMounted, reactive, ref, watch } from "vue";

const props = defineProps(["propsUser", "closeModule"]);
const toast = useAppStore().alert;
const formData = reactive({
  userId: "",
  password: "",
  confirmPassword: "",
});

const rules = {
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

const structuredData = reactive([
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

const validators = useVuelidate(rules, formData);

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

onMounted(() => {
  console.log(props);
  if (props.propsUser) {
    formData.userId = props.propsUser;
  } else {
    getuserData();
  }
});

const getuserData = async () => {
  try {
    const res = await useAppStore().ajaxPost({
      url: "auth/getakundata",
      reqData: { token: useAppStore().session.auth.token },
    });
    formData.userId = res.response.userId;
  } catch (error) {
    console.log(error);
  }
};

const editIdentity = async () => {
  try {
    const valid = await validators.value.$validate();

    if (valid) {
      console.log(formData);
      await useAppStore().ajaxPost({
        url: "usersetting/editpassword",
        reqData: formData,
      });
      toast.fire({
        title: "Success",
        text: "Password successfully updated",
        icon: "success",
      });
      props.closeModule();
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
