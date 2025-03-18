<template>
  <div
    class="printContainer ma-auto"
    id="print"
    style="font-family: 'MS PGothic', sans-serif !important"
  >
    <div id="printMe" ref="a4">
      <div id="docnum" class="pt-1" style="font-size: 8px">
        (様式SPI-QC-FM-1001-002)
      </div>
      <table
        class="pir-table w-100"
        style="border-bottom: 0px solid black !important"
      >
        <tbody>
          <tr>
            <td width="40" class="ps-2 pe-0">
              <img width="30" src="@/assets/logo2.png" alt="" />
            </td>
            <td class="ps-0" style="font-size: 11px; width: 200px">
              <span
                style="
                  width: 166px;
                  color: #005bac;
                  font-weight: bold;
                  line-height: 0.1 !important;
                "
                >PT SOFTPREN INDUSTRIES <br />INDONESIA</span
              >
            </td>
            <td>
              <div class="text-h4 text-start" style="font-weight: bolder">
                Parts Inspection Report
              </div>
            </td>
          </tr>
        </tbody>
      </table>
      <table
        class="pir-table w-100"
        style="border-bottom: 0px solid black !important"
      >
        <tbody>
          <tr>
            <td rowspan="2" colspan="1" class="text-no-wrap">Part Name</td>
            <td rowspan="2">:</td>
            <td
              rowspan="2"
              colspan="6"
              class="border-right"
              style="font-size: 15pt; font-weight: bold"
            >
              {{ selectedData.partName }}
            </td>
            <td
              class="text-no-wrap"
              style="width: 20px; border-bottom: solid 1px black"
            >
              Customer
            </td>
            <td style="width: 5px; border-bottom: solid 1px black">:</td>
            <td
              colspan="7"
              class="text-no-wrap"
              style="border-bottom: solid 1px black"
            >
              {{ selectedData.customerName }}
            </td>
          </tr>
          <tr>
            <td class="text-no-wrap" style="width: 20px">Supplier</td>
            <td style="width: 5px">:</td>
            <td colspan="7" class="text-no-wrap">
              PT Softpren Industries Indonesia
            </td>
          </tr>
          <tr class="top-border">
            <td rowspan="2" colspan="1" class="text-no-wrap">Product No.</td>
            <td rowspan="2" width="5px">:</td>
            <td
              rowspan="2"
              colspan="6"
              class="border-right"
              style="font-size: 15pt; font-weight: bold"
            >
              {{ selectedData.partNumber }}
            </td>
            <td
              colspan="4"
              class="text-no-wrap border-right"
              style="border-bottom: dotted 1px black"
            >
              Delivery Date:
            </td>
            <td
              colspan="4"
              class="text-no-wrap"
              style="border-bottom: dotted 1px black"
            >
              Inspection Date:
            </td>
          </tr>
          <tr>
            <td colspan="4" class="text-no-wrap border-right">
              {{ moment(selectedData.deliveryDate).format("DD/MM/YYYY") }}
            </td>
            <td colspan="4">
              {{ moment(selectedData.inspectionDate).format("DD/MM/YYYY") }}
            </td>
          </tr>
          <tr class="top-border">
            <td rowspan="3" class="text-center border-right">
              <span style="display: inline-block; transform: rotate(90deg)"
                >Category</span
              >
            </td>
            <td colspan="7" rowspan="3" class="border-right">
              <span v-for="(item, index) in categories" :key="index">
                <span
                  v-if="selectedData.category == item.id"
                  style="
                    border: solid 2px black;
                    border-radius: 50%;
                    padding: 1px;
                  "
                  >{{ index + 1 }}.</span
                >
                <span v-else style="padding: 1px">{{ index + 1 }}.</span>
                {{ item.label }}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              </span>
            </td>
            <td
              colspan="8"
              class="text-center"
              style="border-bottom: dotted 1px black"
            >
              Delivery Quantity:
            </td>
          </tr>
          <tr>
            <td colspan="8" class="text-center">
              {{ selectedData.deliveryQty }} Pcs
            </td>
          </tr>
          <tr>
            <td
              colspan="4"
              style="border-bottom: dotted 1px black !important"
              class="border-right top-border"
            >
              Lot No. :
            </td>
            <td
              colspan="4"
              class="text-no-wrap top-border"
              style="border-bottom: dotted 1px black !important"
            >
              Die Cavity Number :
            </td>
          </tr>
          <tr>
            <td
              style="border-top: solid 1px black"
              rowspan="8"
              class="text-center border-right"
            >
              <span style="display: inline-block; transform: rotate(90deg)"
                >Details</span
              >
            </td>
            <td
              class="border-right"
              style="border-top: solid 1px black"
              rowspan="3"
              colspan="2"
            >
              A) Trial Samples . . . th time
            </td>
            <td style="border-top: solid 1px black" class="text-no-wrap py-0">
              1. Tentative Process ====> Original Process
            </td>
            <td style="border-top: solid 1px black"></td>
            <td style="border-top: solid 1px black"></td>
            <td style="border-top: solid 1px black"></td>
            <td style="border-top: solid 1px black" class="border-right"></td>
            <td colspan="4" class="border-right">
              {{ selectedData.lotNumber }}
            </td>
            <td colspan="4" class="text-no-wrap">
              {{ selectedData.dieCavity }}
            </td>
          </tr>
          <tr>
            <td class="text-no-wrap py-0">
              2. Changes of production process/sites
            </td>
            <td></td>
            <td></td>
            <td></td>
            <td class="border-right"></td>
            <td
              colspan="4"
              class="top-border border-right"
              style="border-bottom: dotted 1px black !important"
            >
              Quantity of measured parts/lot :
            </td>
            <td
              colspan="4"
              class="top-border text-no-wrap"
              style="border-bottom: dotted 1px black !important"
            >
              Delivery Model No.
            </td>
          </tr>
          <tr>
            <td class="text-no-wrap py-0">
              3. Change or remodeling of equipment
            </td>
            <td></td>
            <td></td>
            <td></td>
            <td class="border-right"></td>
            <td colspan="4" class="border-right">
              {{ selectedData.sampleQty }} Pcs
            </td>
            <td colspan="4" class="text-no-wrap">
              {{ selectedData.deliveryModel }}
            </td>
          </tr>
          <tr>
            <td rowspan="5" colspan="2" class="border-right top-border">
              B) Initial Production Parts ... th time
            </td>
            <td class="text-no-wrap py-0">
              4. Creation or modification of dies
            </td>
            <td></td>
            <td></td>
            <td></td>
            <td class="border-right"></td>
            <td
              colspan="3"
              class="text-no-wrap top-border border-right text-center"
            >
              Approved By :
            </td>
            <td
              colspan="3"
              class="text-no-wrap top-border border-right text-center"
            >
              Checked By :
            </td>
            <td colspan="3" class="text-no-wrap top-border text-center">
              Inspected By :
            </td>
          </tr>

          <tr>
            <td class="text-no-wrap py-0">
              5. Changes of processing method or conditions
            </td>
            <td></td>
            <td></td>
            <td></td>
            <td class="border-right"></td>
            <td
              colspan="3"
              rowspan="3"
              class="text-no-wrap top-border border-right"
            >
              <v-img
                height="50"
                :src="`data:image/png;base64,${signData.approvalId.signFile}`"
              ></v-img>
            </td>
            <td
              colspan="3"
              rowspan="3"
              class="text-no-wrap top-border border-right"
            >
              <v-img
                height="50"
                :src="`data:image/png;base64,${signData.checkerID.signFile}`"
              ></v-img>
            </td>
            <td
              colspan="3"
              rowspan="3"
              class="text-no-wrap top-border border-right"
            >
              <v-img
                height="50"
                :src="`data:image/png;base64,${signData.akunId.signFile}`"
              ></v-img>
            </td>
          </tr>
          <tr>
            <td class="text-no-wrap py-0">
              6. Delivery of post-countermeasure nonconforming parts
            </td>
            <td></td>
            <td></td>
            <td></td>
            <td class="border-right"></td>
          </tr>

          <tr>
            <td class="text-no-wrap py-0">
              7. Change of material suppliers or grade
            </td>
            <td></td>
            <td></td>
            <td></td>
            <td class="border-right"></td>
          </tr>
          <tr>
            <td class="text-no-wrap py-0">8. Others</td>
            <td></td>
            <td></td>
            <td></td>
            <td class="border-right"></td>
            <td
              colspan="3"
              class="text-no-wrap top-border border-right text-center text-capitalize"
              style="font-size: 9px"
            >
              {{ signData.approvalId.name }}
            </td>
            <td
              colspan="3"
              class="text-no-wrap top-border border-right text-center text-capitalize"
              style="font-size: 9px"
            >
              {{ signData.checkerID.name }}
            </td>
            <td
              colspan="3"
              class="text-no-wrap top-border border-right text-center text-capitalize"
              style="font-size: 9px"
            >
              {{ signData.akunId.name }}
            </td>
          </tr>
          <tr>
            <td
              colspan="16"
              class="text-center"
              style="border-top: 1px solid black"
            >
              <div class="d-flex">
                <div>sketch</div>
                <div class="w-100 text-center">
                  <img
                    style="max-width: 180mm !important; height: 220px"
                    :src="`data:image/png;base64,${image}`"
                    alt=""
                  />
                </div>
              </div>
              <!-- <v-img height="210" :src="`data:image/png;base64,${image}`"></v-img> -->
            </td>
          </tr>
        </tbody>
      </table>
      <table class="pir-table w-100">
        <thead>
          <tr class="y-border" style="border-bottom: solid 1px black">
            <td class="text-center border-right">No</td>
            <td class="text-no-wrap border-right">Inspection Item</td>
            <td class="text-no-wrap text-center border-right w-25">Standar</td>
            <td class="border-right text-center">Inspection Method/ Tool</td>
            <td class="border-right text-center">Measuring Tool No.</td>
            <td
              style="width: 55px"
              class="text-no-wrap text-center border-right"
              v-for="(item, index) in n"
              :key="index"
            >
              N {{ index + 1 }}
            </td>
            <td class="text-center text-no-wrap">Judgement</td>
            <td class="text-center" style="border-left: solid 2px black">
              Customer Judgement
            </td>
          </tr>
        </thead>
        <tbody>
          <tr
            class="top-border isiInpsection"
            v-for="(item, index) in array"
            :key="index"
          >
            <td
              v-if="item.itemName"
              class="text-center border-right text-no-wrap"
              style="text-align: center !important"
            >
              <div
                style="
                  border: 1px solid black;
                  border-radius: 50%;
                  font-size: xx-small;
                "
              >
                {{ index + 1 }}
              </div>
            </td>
            <td
              v-else
              class="text-center border-right text-no-wrap text-white"
              style="text-align: center !important"
            >
              {{ index + 1 }}
            </td>
            <td class="text-no-wrap text-center border-right">
              {{ item.itemName }}
            </td>
            <td
              class="text-capitalize text-center border-right text-no-wrap"
              v-if="item.type == 1 || item.type == 2 || item.type == 8"
            >
              {{ item.standart }}
            </td>
            <td
              class="text-center text-no-wrap border-right"
              v-if="item.type == 3"
            >
              {{ item.standart.value }} {{ item.standart.unit }}
            </td>
            <td
              class="text-center text-no-wrap border-right"
              v-if="item.type == 4"
            >
              ≥ {{ item.standart.value }} {{ item.standart.unit }}
            </td>
            <td
              class="text-center text-no-wrap border-right"
              v-if="item.type == 5"
            >
              ≤ {{ item.standart.value }} {{ item.standart.unit }}
            </td>
            <td
              class="text-center text-no-wrap border-right"
              v-if="item.type == 6"
            >
              {{ item.standart.value }} ± {{ item.standart.tolerance }}
              {{ item.standart.unit }}
            </td>
            <td
              v-if="item.type == 7"
              class="text-center border-right text-no-wrap"
            >
              {{ item.standart.value }}
              +{{ item.standart.upperTolerance }}, -
              {{ item.standart.lowerTolerance }}
              {{ item.standart.unit }}
            </td>

            <td class="text-center border-right text-no-wrap px-1">
              {{ item.tools[0].methodName }}
            </td>
            <td class="highlight text-center border-right text-no-wrap px-1">
              {{ item.tools.find((e) => e.toolId == item.toolNumber).toolName }}
            </td>
            <td
              style="width: 50px; text-align: center !important"
              :class="
                array[index][`judgement_${ind}`]
                  ? 'text-no-wrap text-center border-right text-uppercase px-1'
                  : 'text-no-wrap text-center border-right text-uppercase bg-pink px-1'
              "
              v-for="(it, ind) in n"
              :key="ind"
            >
              {{ array[index][`result_${ind}`] }}
            </td>
            <td
              class="bg-pink text-center"
              style="
                text-align: center !important;
                border-top: solid 1px black;
                font-weight: bolder;
                font-size: 11.5px;
              "
              v-if="array[index].judgement.includes(false)"
            >
              NG
            </td>
            <td
              v-if="
                array[index].judgement.includes(true) &&
                !array[index].judgement.includes(false)
              "
              style="
                padding: 0;
                text-align: center !important;
                border-top: solid 1px black;
                font-weight: bolder;
                font-size: 11.5px;
              "
            >
              OK
            </td>
            <td
              v-if="item.itemName == ''"
              style="
                text-align: center !important;
                border-top: solid 1px black;
                font-weight: bolder;
                font-size: 11.5px;
              "
            ></td>
            <td
              style="
                text-align: center !important;
                border-left: solid 2px black;
              "
            ></td>
          </tr>
        </tbody>
      </table>
      <div
        class="w-100"
        style="
          height: 5px;
          border-left: 1px solid black;
          border-right: 1px solid black;
        "
      ></div>
      <table class="pir-table">
        <tbody>
          <tr>
            <td
              class="border-right"
              rowspan="4"
              style="width: 137px !important"
            >
              Findings (What to do especially in case of nonconformity
              occurrence)
            </td>
            <td
              class="text-error"
              v-if="selectedData.checkerNote"
              style="width: 550px; font-weight: bold"
            >
              Checker Note: {{ selectedData.checkerNote }}
            </td>
            <td v-else class="text-white" style="width: 550px">w</td>
            <td rowspan="3" class="border-right">
              <div
                style="z-index: 5000; opacity: 0.5; bottom: 25px; right: 150px"
              >
                <v-img
                  v-if="selectedData.category == 1"
                  width="150"
                  src="@/assets/sp.png"
                />
                <v-img
                  v-if="selectedData.category == 2"
                  width="150"
                  src="@/assets/fp.png"
                />
              </div>
            </td>
            <td class="text-no-wrap text-center">FINAL JUDGEMENT</td>
          </tr>
          <tr>
            <td
              class="text-error"
              style="font-weight: bold"
              v-if="selectedData.approvalNote"
            >
              Approval Note: {{ selectedData.approvalNote }}
            </td>
            <td v-else class="text-white">w</td>
            <td
              rowspan="3"
              class="text-no-wrap text-center top-border text-h4"
              v-if="selectedData.managerJudgement == 1"
            >
              OK
            </td>
            <td
              rowspan="3"
              class="text-no-wrap text-center top-border text-h4 text-error"
              style="background-color: #fec6cd !important"
              v-else
            >
              NG
            </td>
          </tr>
          <tr></tr>
        </tbody>
      </table>
    </div>
  </div>

  <v-divider class="my-5"> </v-divider>
  <v-btn block color="primary" dark @click="print">Download</v-btn>
</template>
<style scoped>
.itemArr td {
  border-top: dotted 1px black;
}
</style>
<script setup>
import { useAppStore } from "@/store/app";
import html2canvas from "html2canvas";
import moment from "moment";
import { onMounted, reactive, ref } from "vue";
import { jsPDF } from "jspdf";
let a4 = ref(null);
const props = defineProps(["selectedData"]);

let array = ref(
  new Array(16).fill({
    itemName: "",
    standart: "",
    methodName: "",
    tools: [{ toolName: "" }],
    judgement: [],
    type: 1,
  })
);

const n = new Array(props.selectedData.sampleQty).fill(0);
array.value.forEach((element, index) => {
  n.forEach((e, i) => {
    array.value[index][`result_${i}`] = "";
    array.value[index][`judgement_${i}`] = "1";
  });
});
props.selectedData.inspectionData.forEach((element, index) => {
  array.value[index] = element;
});
const print = () => {
  const e = document.getElementById("print");
  let fileName = "";
  if (props.selectedData.category == 2) {
    fileName = `${props.selectedData.lotNumber} ${props.selectedData.partNumber} ${props.selectedData.deliveryQty}pcs (F).pdf`;
  } else if (props.selectedData.category == 1) {
    fileName = `${props.selectedData.lotNumber} ${props.selectedData.partNumber} ${props.selectedData.deliveryQty}pcs (S).pdf`;
  } else {
    fileName = `${props.selectedData.lotNumber} ${props.selectedData.partNumber} ${props.selectedData.deliveryQty}pcs.pdf`;
  }

  html2canvas(e, {
    scale: 3,
  }).then((canvas) => {
    const imgData = canvas.toDataURL("image/jpeg");
    const pdf = new jsPDF({
      // Unit pengukuran: mm, pt, in, px
      orientation: "p",
      format: "a4",
      unit: "mm",
    });
    pdf.addImage(imgData, "PNG", 0, 0, 210, 297);
    pdf.save(`${fileName}`);
  });
};

const image = ref(null);
const categories = ref();

const signData = reactive({
  approvalId: {
    signFile: null,
    name: "",
  },
  checkerID: {
    signFile: null,
    name: "",
  },
  akunId: {
    signFile: null,
    name: "",
  },
});

const tools = ref([]);

onMounted(async () => {
  try {
    const categoriesResponse = await useAppStore().ajaxPost({
      url: "inspection/getcategory",
      reqData: {},
    });

    const res2 = await useAppStore().ajaxPost({
      url: "setup/getdrawing",
      reqData: { partId: props.selectedData.partId },
    });

    image.value = res2.signFileContent;

    const response = await useAppStore().ajaxPost({
      url: "setup/gettools",
      reqData: {},
    });
    tools.value = response.tools;

    props.selectedData.inspectionData.forEach((element, index) => {
      props.selectedData.inspectionData[index].method = findTool(
        element.tools[0].toolId
      );
    });

    categories.value = categoriesResponse;
    for (const key in signData) {
      const resp = await useAppStore().ajaxPost({
        url: "usersetting/getuserdata",
        reqData: {
          userId: props.selectedData[key],
        },
      });
      signData[key].signFile = resp.signFile;
      signData[key].name = resp.response.sureName;
    }
  } catch (error) {
    console.error(error);
  }
});

const findTool = (id) => {
  const tool = tools.value.find((e) => e.toolId == id);
  const name = tool.toolName;
  return name;
};
</script>
