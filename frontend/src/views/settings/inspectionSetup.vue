<template>
  <v-card>
    <v-tabs v-model="tab" bg-color="transparent">
      <v-tab value="1">Method Setup</v-tab>
      <v-tab value="2">Tool List</v-tab>
      <v-tab value="3">Inspection Item Type</v-tab>
      <v-tab value="4">Sample Range Setup</v-tab>
    </v-tabs>
    <v-card-text>
      <v-tabs-window v-model="tab">
        <v-tabs-window-item value="1">
          <MethodeTable></MethodeTable>
        </v-tabs-window-item>

        <v-tabs-window-item value="2">
          <ToolsTable></ToolsTable>
        </v-tabs-window-item>

        <v-tabs-window-item value="3">
          <TypeTable></TypeTable>
        </v-tabs-window-item>

        <v-tabs-window-item value="4"
          ><SampleVolRange></SampleVolRange>
        </v-tabs-window-item>
      </v-tabs-window>
    </v-card-text>
  </v-card>
</template>
<script setup>
import SampleVolRange from "@/components/misc/sampleVolRange.vue";
import MethodeTable from "@/components/tables/methodeTable.vue";
import ToolsTable from "@/components/tables/toolsTable.vue";
import TypeTable from "@/components/tables/typeTable.vue";

import { ref } from "vue";

const tab = ref("");
</script>
