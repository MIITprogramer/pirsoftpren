<template>
  <v-card>
    <v-card-text>
      <v-row>
        <v-col cols="6">
          <v-btn
            rounded="pill"
            @click="section = true"
            :color="section ? 'primary' : ''"
            block
            >Users</v-btn
          >
        </v-col>
        <v-col cols="6">
          <v-btn
            rounded="pill"
            @click="section = false"
            :color="section ? '' : 'primary'"
            block
            >Roles</v-btn
          >
        </v-col>
      </v-row>
      <v-col cols="12" v-if="section">
        <UsersTable />
      </v-col>
      <v-col cols="12" v-else>
        <RolesTable />
      </v-col>
    </v-card-text>
  </v-card>
</template>
<script setup>
import RolesTable from "@/components/tables/rolesTable.vue";
import UsersTable from "@/components/tables/usersTable.vue";
import { ref } from "vue";
const section = ref(true);
</script>
