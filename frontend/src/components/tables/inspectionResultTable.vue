<template>
  <v-table fixed-header style="max-height: 900px">
    <thead>
      <tr>
        <th rowspan="2" class="text-center">No</th>
        <th rowspan="2" class="text-center">Part Number</th>
        <th rowspan="2" class="text-center">Delivery Date</th>
        <th rowspan="2" class="text-center">Inspector Name</th>
        <th colspan="3" class="text-center">JUDGEMENT</th>
      </tr>
      <tr>
        <th class="text-center">INSPECTOR</th>
        <th class="text-center">CHECKER</th>
        <th class="text-center">APPROVED</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="(item, index) in inspections" :key="index">
        <td class="text-center">{{ item.No }}</td>
        <td class="text-center">{{ item.partNumber }}</td>
        <td class="text-center">
          {{ moment(item.deliveryDate).format("DD/MM/YYYY") }}
        </td>
        <td class="text-center text-uppercase">
          {{ item.sureName }}
        </td>
        <td class="text-center" v-if="item.inspectorJudgement == 2">
          <v-btn color="error" disabled>NG</v-btn>
        </td>
        <td class="text-center" v-else>
          <v-btn color="success" disabled>OK</v-btn>
        </td>
        <!-- checkerCheck Start -->
        <td class="text-center">
          <v-btn
            :color="item.inspectorJudgement == 2 ? 'error' : 'primary'"
            @click="props.openCheck(item, 'checker')"
            v-if="item.checkerJudgement == 0"
            :disabled="
              akunData.role != 1 &&
              akunData.role != 38 &&
              akunData.role != 37 &&
              akunData.role != 36
            "
          >
            Check
          </v-btn>
          <v-btn
            color="success"
            disabled=""
            v-if="item.checkerJudgement == 1 && item.checkerNote == null"
          >
            OK
          </v-btn>
          <v-btn
            color="warning"
            disabled=""
            v-if="item.checkerJudgement == 1 && item.checkerNote != null"
          >
            OK (SA)
          </v-btn>
          <v-btn color="error" disabled="" v-if="item.checkerJudgement == 2">
            STOP
          </v-btn>
        </td>
        <!-- checkerCheck End -->

        <!-- managerCheck start -->
        <td class="text-center">
          <v-btn
            @click="props.openCheck(item, 'approved')"
            :color="item.checkerJudgement == 2 ? 'error' : 'primary'"
            v-if="item.checkerNote == null"
            :disabled="
              (akunData.role != 1 &&
                akunData.role != 37 &&
                akunData.role != 36) ||
              item.checkerJudgement == 0
            "
          >
            SIGN
          </v-btn>
          <v-btn
            @click="props.openCheck(item, 'approved')"
            color="warning"
            v-if="item.checkerNote != null"
            :disabled="
              (akunData.role != 1 &&
                akunData.role != 37 &&
                akunData.role != 36) ||
              item.checkerJudgement == 0
            "
          >
            SIGN
          </v-btn>
        </td>
        <!-- managerCheck end -->
      </tr>
    </tbody>
  </v-table>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import moment from "moment";
import { onMounted, ref } from "vue";

let akunData = ref({});
const inspections = ref([]);

let props = defineProps(["openCheck"]);

const conditions = ref([
  {
    inspectorJudgement: 1,
    checkerJudgement: 0,
    managerJudgement: 0,
  },
  {
    inspectorJudgement: 2,
    checkerJudgement: 0,
    managerJudgement: 0,
  },
  {
    inspectorJudgement: 1,
    checkerJudgement: 1,
    managerJudgement: 0,
  },
  {
    inspectorJudgement: 1,
    checkerJudgement: 2,
    managerJudgement: 0,
  },

  {
    inspectorJudgement: 2,
    checkerJudgement: 1,
    managerJudgement: 0,
  },
  {
    inspectorJudgement: 2,
    checkerJudgement: 2,
    managerJudgement: 0,
  },

  //

  {
    inspectorJudgement: 1,
    checkerJudgement: 1,
    managerJudgement: 1,
  },
  {
    inspectorJudgement: 1,
    checkerJudgement: 2,
    managerJudgement: 1,
  },

  {
    inspectorJudgement: 2,
    checkerJudgement: 1,
    managerJudgement: 1,
  },
  {
    inspectorJudgement: 2,
    checkerJudgement: 2,
    managerJudgement: 1,
  },
  //

  {
    inspectorJudgement: 1,
    checkerJudgement: 1,
    managerJudgement: 2,
  },
  {
    inspectorJudgement: 1,
    checkerJudgement: 2,
    managerJudgement: 2,
  },

  {
    inspectorJudgement: 2,
    checkerJudgement: 1,
    managerJudgement: 2,
  },
  {
    inspectorJudgement: 2,
    checkerJudgement: 2,
    managerJudgement: 2,
  },
]);

const getConditions = (item) => {
  const checkerJudgement = item.checkerJudgement;
  const managerJudgement = item.managerJudgement;
  const inspectorJudgement = item.inspectorJudgement;

  const cond = conditions.value.findIndex(
    (e) =>
      e.inspectorJudgement == inspectorJudgement &&
      e.checkerJudgement == checkerJudgement &&
      e.managerJudgement == managerJudgement
  );
  return cond;
};

onMounted(async () => {
  let response = await useAppStore().ajaxPost({
    url: "inspection/getinspection",
  });
  const akunRes = await useAppStore().ajaxPost({
    url: "auth/getakundata",
    reqData: { token: useAppStore().session.auth.token },
  });
  akunData.value = akunRes.response;
  response = response.map((e, index) => {
    e.inspectionData = JSON.parse(e.inspectionData);
    e.No = index + 1;
    return e;
  });
  inspections.value = response;
});
</script>
