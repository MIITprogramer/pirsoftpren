<template>
  <v-row>
    <v-col cols="8">
      <v-text-field
        type="month"
        variant="outlined"
        rounded="pill"
        density="compact"
        label="Search by Month"
        v-model="month"
      >
      </v-text-field>
    </v-col>
    <v-col cols="4">
      <v-text-field
        label="Search Part"
        variant="outlined"
        rounded="pill"
        density="compact"
        hide-details
        prepend-inner-icon="mdi-magnify"
        v-model="search"
      />
    </v-col>
  </v-row>
  <v-table fixed-header style="max-height: 900px">
    <thead>
      <tr>
        <th class="text-center">No</th>
        <th class="text-center">Delivery Date</th>
        <th class="text-center">Part Number</th>
        <th class="text-center">Delivery Quantity</th>
        <th class="text-center">Customer Name</th>
        <th class="text-center">Final Judgement</th>
        <th class="text-center">Report</th>
        <th class="text-center">Select</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="(item, index) in viewItem" :key="index">
        <td class="text-center">{{ item.No }}</td>
        <td class="text-center">
          {{ moment(item.deliveryDate).format("DD/MM/YYYY") }}
        </td>
        <td class="text-center text-no-wrap">{{ item.partNumber }}</td>
        <td class="text-center text-uppercase">{{ item.deliveryQty }} pcs</td>
        <td class="text-center text-uppercase">
          {{ item.customerName }}
        </td>
        <td>
          <v-btn
            block
            color="warning"
            disabled=""
            v-if="item.approvalNote != null"
            >OK (SA)</v-btn
          >
          <v-btn block color="success" disabled="" v-else>OK</v-btn>
        </td>
        <!-- managerCheck end -->
        <td class="text-center">
          <v-btn color="primary" @click="openPDF(item)">pdf</v-btn>
        </td>
        <td class="text-center">
          <v-checkbox
            label=""
            v-model="checked"
            :value="index"
            hide-details
          ></v-checkbox>
        </td>
      </tr>
    </tbody>
  </v-table>
  <v-dialog
    v-model="pdf"
    fullscreen
    persistent
    :overlay="false"
    transition="dialog-transition"
  >
    <v-card>
      <v-toolbar density="compact">
        <v-toolbar-title>Print PDF</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn @click="pdf = false" flat icon color="black">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-toolbar>
      <v-card-text>
        <div class="pir-container">
          <PdfReport :selected-data="selectedData"></PdfReport>
        </div>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import moment from "moment";
import { onMounted, ref, watch } from "vue";
import PdfReport from "../misc/pdfReport.vue";

const checked = ref([]);

const date = new Date();
const momentDate = moment(date);
const month = ref("1991-01");

let akunData = ref({});
const inspections = ref([]);
const pdf = ref(false);
const selectedData = ref(null);
let search = ref("");

let viewItem = ref([]);

watch(search, (e) => {
  if (e == "") {
    viewItem.value = inspections.value;
  } else {
    viewItem.value = inspections.value.filter((x) =>
      x.partNumber.toLowerCase().includes(e.toLowerCase())
    );
  }
});

watch(month, (e) => {
  const splited = e.split("-");
  if (e == "") {
    viewItem.value = inspections.value;
  } else {
    viewItem.value = inspections.value.filter((x) => {
      const date = new Date(x.deliveryDate);
      const formattedDate = `${String(date.getMonth() + 1).padStart(
        2,
        "0"
      )}/${date.getFullYear()}`;
      return formattedDate === `${splited[1]}/${splited[0]}`;
    });
  }
});

const openPDF = (item) => {
  selectedData.value = item;
  pdf.value = true;
};

onMounted(async () => {
  let response = await useAppStore().ajaxPost({
    url: "inspection/getinspectionfinish",
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

  viewItem.value = response;

  month.value = momentDate.format("YYYY-MM");
});
</script>
