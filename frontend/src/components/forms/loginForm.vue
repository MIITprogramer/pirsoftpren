<template>
  <div>
    <div class="text-start" v-for="(item, index) in dataStructure" :key="index">
      <v-text-field
        class="mb-2"
        :label="item.label"
        :hint="item.hint"
        :type="item.type"
        variant="outlined"
        rounded="pill"
        density="comfortable"
        v-model="formData[index]"
        :error-messages="vuelidate[index].$errors.map((e) => e.$message)"
      />
    </div>
    <v-switch label="Show Password" v-model="showPass" color="info" />
    <v-btn text="login" rounded="pill" color="info" @click="submit" block="" />
  </div>
</template>
<script setup>
import { ref, reactive, watch } from "vue";
import useVuelidate from "@vuelidate/core";
import { helpers, required } from "@vuelidate/validators";
import { useAppStore } from "@/store/app";
import router from "@/router";
import Swal from "sweetalert2";

const formData = reactive({
  userName: "",
  password: "",
});

const dataStructure = reactive({
  userName: {
    label: "NIK",
    hint: "Input NIK",
    type: "text",
  },
  password: {
    label: "Password",
    hint: "Input password",
    type: "password",
  },
});

const showPass = ref(false);

watch(showPass, (e) => {
  if (e) {
    dataStructure.password.type = "text";
  } else {
    dataStructure.password.type = "password";
  }
});

const rules = {
  userName: {
    required: helpers.withMessage("Harus diisi!", required),
  },
  password: {
    required: helpers.withMessage("Harus diisi!", required),
  },
};

const vuelidate = useVuelidate(rules, formData);

const submit = async () => {
  try {
    const valid = await vuelidate.value.$validate();
    if (valid) {
      const response = await useAppStore().ajaxPost({
        url: "auth/login",
        reqData: formData,
      });
      useAppStore().session.auth.token = response.token;
      const home = response.useData[0].home;
      useAppStore().session.auth.home = home;
      const toast = Swal.mixin({
        toast: true,
        position: "top-end",
        showConfirmButton: false,
        showCloseButton: true,
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
        title: "Loged In",
        text: "Successfully Loged In",
      });
      setTimeout(() => {
        window.location.reload();
      }, 500);
    }
  } catch (error) {
    if (error) {
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
        title: "Error",
        text: error,
        icon: "error",
      });
    }
  }
};
</script>
