<template>
  <v-card elevation="1" class="ma-2">
    <v-card-text>
      <div class="d-flex w-100 align-start">
        <v-row>
          <v-col cols="4">
            <v-img src="@/assets/softfren.png" />
          </v-col>
          <v-col cols="8">
            <div class="d-flex w-100 flex-column">
              <h1>Welcome</h1>
              <h4>{{ data.sureName }}</h4>
              <p>{{ data.roleName }}</p>
            </div>
          </v-col>
        </v-row>
      </div>
    </v-card-text>
  </v-card>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import { onMounted, reactive } from "vue";
let data = reactive({ sureName: "sureName", roleName: "" });
onMounted(async () => {
  try {
    const res = await useAppStore().ajaxPost({
      url: "auth/getakundata",
      reqData: { token: useAppStore().session.auth.token },
    });
    data.roleName = res.response.roleName;
    data.sureName = res.response.sureName;
  } catch (error) {
    console.log(error);
  }
});
</script>
