<template>
  <div class="d-flex justify-center">
    <table class="text-center">
      <thead>
        <tr>
          <th class="pa-2" rowspan="2" style="width: 250px">
            Lot (batch) size
            <br />
            ロットの大きさ
          </th>
          <th class="pa-2">Level C</th>
          <th class="pa-2">Level B</th>
          <th class="pa-2">Level A</th>
        </tr>
      </thead>
      <tbody>
        <tr v-if="data.length < 1">
          <td colspan="4" class="text-center">No Data</td>
        </tr>
        <tr v-else v-for="(item, index) in data" :key="index">
          <td style="width: 200px" class="pa-2 text-center">
            <v-row>
              <v-col cols="5">
                <v-text-field
                  type="number"
                  hide-spin-buttons
                  hide-details
                  density="compact"
                  variant="outlined"
                  v-model="item.Nmin"
                  @keyup="update(item)"
                />
              </v-col>
              <v-col cols="2">~</v-col>
              <v-col cols="5">
                <v-text-field
                  type="number"
                  hide-spin-buttons
                  hide-details
                  v-model="item.Nmax"
                  density="compact"
                  variant="outlined"
                  @keyup="update(item)"
                />
              </v-col>
            </v-row>
          </td>
          <td class="pa-2 text-center">
            <v-text-field
              type="number"
              hide-spin-buttons
              v-model="item.class_C"
              density="compact"
              hide-details
              variant="outlined"
              @keyup="update(item)"
            />
          </td>
          <td class="pa-2 text-center">
            <v-text-field
              type="number"
              hide-spin-buttons
              hide-details
              v-model="item.class_B"
              density="compact"
              variant="outlined"
              @keyup="update(item)"
            />
          </td>
          <td class="pa-2 text-center">
            <v-text-field
              hide-spin-buttons
              type="number"
              hide-details
              v-model="item.class_A"
              density="compact"
              variant="outlined"
              @keyup="update(item)"
            />
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import { onMounted, ref } from "vue";

const data = ref([]);

const update = async (reqData) => {
  try {
    await useAppStore().ajaxPost({
      url: "setup/changerange",
      reqData,
    });
    console.log(reqData);
  } catch (error) {
    console.log(error);
  }
};

onMounted(async () => {
  const response = await useAppStore().ajaxPost({
    url: "setup/getrange",
    reqData: {},
  });
  data.value = response.range;
});
</script>
