<template>
  <v-row>
    <v-col cols="3">
      <div class="d-flex w-100 h-100 text-center justify-center flex-column">
        <v-img height="60" src="@/assets/softfren.png" />
        <small> {{ data.sureName }}</small>
        <small> {{ data.roleName }}</small>
      </div>
    </v-col>
    <v-col cols="9">
      <v-row>
        <v-col cols="12">
          <h1 class="text-h5 text-uppercase w-100 text-center">
            INSPECTION RESULT
          </h1>
        </v-col>
        <v-col cols="12">
          <h1
            class="text-h5 text-uppercase text-center"
            style="border: 1pt, solid, black"
          >
            {{ myData.partNumber }}
          </h1>
        </v-col>
      </v-row>
    </v-col>
  </v-row>
  <v-row>
    <v-col cols="12">
      <v-img :src="`data:image/png;base64,${image}`" height="200" />
    </v-col>
    <v-col cols="12">
      <table class="inspection-table">
        <thead>
          <tr>
            <th>No</th>
            <th>Inspection Item</th>
            <th>Standard</th>
            <th>Measuring Tool No</th>
            <th class="px-1" v-for="(item, index) in nArray" :key="index">
              N{{ index + 1 }}
            </th>
            <th>Judgement</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in myData.inspectionData" :key="index">
            <td>
              <div style="border: 1px solid black; border-radius: 50%">
                {{ index + 1 }}
              </div>
            </td>
            <td>{{ item.itemName }}</td>
            <td
              class="text-capitalize"
              v-if="item.type == 1 || item.type == 2 || item.type == 8"
            >
              {{ item.standart }}
            </td>
            <td class="text-center text-no-wrap" v-if="item.type == 3">
              {{ item.standart.value }} {{ item.standart.unit }}
            </td>
            <td class="text-center text-no-wrap" v-if="item.type == 4">
              ≥ {{ item.standart.value }} {{ item.standart.unit }}
            </td>
            <td class="text-center text-no-wrap" v-if="item.type == 5">
              ≤ {{ item.standart.value }} {{ item.standart.unit }}
            </td>
            <td class="text-center text-no-wrap" v-if="item.type == 6">
              {{ item.standart.value }} ± {{ item.standart.tolerance }}
              {{ item.standart.unit }}
            </td>
            <td v-if="item.type == 7">
              {{ item.standart.value }}
              +{{ item.standart.upperTolerance }}, -
              {{ item.standart.lowerTolerance }},
              {{ item.standart.unit }}
            </td>
            <td class="highlight">
              {{ item.tools.find((e) => e.toolId == item.toolNumber).toolName }}
            </td>
            <td
              v-for="(n, key) in item.n"
              :key="key"
              :class="
                item['judgement_' + key]
                  ? 'highlight text-uppercase px-1'
                  : 'text-uppercase error px-1'
              "
            >
              {{ item["result_" + key] }}
            </td>
            <td v-if="item.judgement.includes(false)" class="error">NG</td>
            <td v-else>OK</td>
          </tr>
        </tbody>
      </table>
    </v-col>
    <v-col v-if="NgArray.includes(false)" cols="12">
      <v-divider></v-divider>
    </v-col>
    <v-col v-if="NgArray.includes(false)" cols="12">
      <div
        class="fill-height w-100 text-uppercase text-center text-error text-h5 border-double"
      >
        SEGERA LAPOR ATASAN !!! JANGAN LOLOSKAN PRODUK NG !!!
      </div>
    </v-col>
    <v-col cols="12" v-if="myData.checkerNote">
      <v-divider></v-divider>
    </v-col>
    <v-col cols="12" v-if="myData.checkerNote">
      <div class="fill-height w-100 text-start pa-5 border-double">
        Checker Note: {{ myData.checkerNote }}
      </div>
    </v-col>
    <v-col cols="12">
      <v-divider></v-divider>
    </v-col>
  </v-row>
  <v-row v-if="role == 'checker'">
    <v-col :cols="NgArray.includes(false) ? 4 : 6">
      <v-btn
        @click="props.closeModal()"
        rounded="pill"
        block
        color="primary"
        dark
        >Cancel</v-btn
      ></v-col
    >
    <v-col :cols="NgArray.includes(false) ? 4 : 6">
      <v-btn
        rounded="pill"
        v-if="NgArray.includes(false)"
        block
        color="error"
        dark
        @click="rejectDialog = true"
        >Report NG</v-btn
      >
      <v-btn
        rounded="pill"
        v-else
        block
        color="primary"
        dark
        @click="checkDialog = true"
        >SIGN</v-btn
      >
    </v-col>
    <v-col cols="4" v-if="NgArray.includes(false)">
      <v-btn
        @click="noteDialog = true"
        rounded="pill"
        block
        color="warning"
        dark
      >
        Accept With Note</v-btn
      >
    </v-col>
  </v-row>

  <v-row v-else>
    <v-col :cols="NgArray.includes(false) ? 4 : 6">
      <v-btn
        @click="props.closeModal()"
        rounded="pill"
        block
        color="primary"
        dark
        >Cancel</v-btn
      ></v-col
    >
    <v-col :cols="NgArray.includes(false) ? 4 : 6">
      <v-btn
        rounded="pill"
        v-if="NgArray.includes(false)"
        block
        color="error"
        dark
        @click="rejectDialog = true"
        >Report NG</v-btn
      >
      <v-btn
        rounded="pill"
        v-else
        block
        color="primary"
        dark
        @click="checkDialog = true"
        >SIGN</v-btn
      >
    </v-col>
    <v-col cols="4" v-if="NgArray.includes(false)">
      <v-btn
        @click="noteDialog = true"
        rounded="pill"
        block
        color="warning"
        dark
      >
        Accept With Note</v-btn
      >
    </v-col>
  </v-row>
  <v-dialog
    v-model="checkDialog"
    persistent
    :overlay="false"
    max-width="500px"
    transition="dialog-transition"
  >
    <v-card class="ma-auto w-100">
      <v-card-title class="text-uppercase bg-primary">
        Sign Inspection
      </v-card-title>
      <v-card-text>
        <div class="text-h6 text-center">
          Are you sure you want to sign this inspection?
        </div>
        <v-divider class="my-3"></v-divider>
        <v-row>
          <v-col cols="6">
            <v-btn rounded="pill" block @click="checkDialog = false"
              >Cancel</v-btn
            >
          </v-col>
          <v-col cols="6">
            <v-btn rounded="pill" block color="primary" @click="sign"
              >Sign</v-btn
            >
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </v-dialog>

  <v-dialog
    v-model="rejectDialog"
    persistent
    :overlay="false"
    max-width="500px"
    transition="dialog-transition"
  >
    <v-card class="ma-auto w-100">
      <v-card-title class="text-uppercase bg-error">
        Reject Inspection
      </v-card-title>
      <v-card-text>
        <div class="text-h6 text-center">
          Are you sure you want to reject this inspection?
        </div>
        <v-divider class="my-3"></v-divider>
        <v-row>
          <v-col cols="6">
            <v-btn rounded="pill" block @click="rejectDialog = false"
              >Cancel</v-btn
            >
          </v-col>
          <v-col cols="6">
            <v-btn rounded="pill" block color="error" @click="reject"
              >Reject</v-btn
            >
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </v-dialog>
  <v-dialog
    v-model="noteDialog"
    persistent
    :overlay="false"
    max-width="500px"
    transition="dialog-transition"
  >
    <v-card class="ma-auto w-100">
      <v-card-title class="text-uppercase bg-error">
        Special Acceptance
      </v-card-title>
      <v-card-text>
        <div class="text-h6 text-center mb-2">
          Are you sure you want to accept this inspection with note?
        </div>
        <v-textarea
          label="Note"
          variant="outlined"
          hint="Please provide a note"
          v-model="note"
        ></v-textarea>
        <v-divider class="my-3"></v-divider>
        <v-row>
          <v-col cols="6">
            <v-btn rounded="pill" block @click="noteDialog = false"
              >Cancel</v-btn
            >
          </v-col>
          <v-col cols="6">
            <v-btn rounded="pill" block color="error" @click="acceeptWithNote"
              >Accept</v-btn
            >
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>
<style>
.inspection-table {
  width: 100%;
  border-collapse: collapse;
  font-family: Arial, sans-serif;
}

.inspection-table th,
.inspection-table td {
  border: 1px solid black;
  padding: 8px;
  text-align: center;
}

.inspection-table th {
  background-color: #f0f0f0;
  font-weight: bold;
}

.inspection-table .highlight {
  background-color: yellow;
}

.inspection-table .error {
  background-color: rgb(255, 38, 0);
  color: white;
}
</style>
<script setup>
import { useAppStore } from "@/store/app";
import { onBeforeMount, onMounted, reactive, ref } from "vue";

let props = defineProps(["selectedData", "closeModal"]);
let myData = props.selectedData.data;
let role = props.selectedData.role;
let data = reactive({ sureName: "sureName", roleName: "" });
const image = ref(null);
let n = myData.sampleQty;
let nArray = ref(new Array(n).fill(""));
let NgArray = ref([]);
let checkDialog = ref(false);
const alert = useAppStore().alert;
let rejectDialog = ref(false);
let noteDialog = ref(false);
let note = ref(null);

const tools = ref([]);

let sign = async () => {
  try {
    let reqData = {
      inspectionId: myData.inspectionId,
      token: useAppStore().session.auth.token,
      value: 1,
    };
    if (role == "checker") {
      reqData.field = "checkerJudgement";
      reqData.id = "checkerID";
      reqData.updateDate = "checkerJudgementDate";
    } else {
      reqData.field = "managerJudgement";
      reqData.id = "approvalId";
      reqData.updateDate = "managerJudgementDate";
    }
    await useAppStore().ajaxPost({
      url: "inspection/signinspection",
      reqData,
    });
    alert.fire({
      title: "Success",
      text: "Inspection successfully signed",
      icon: "success",
    });
    props.closeModal();
  } catch (error) {
    console.log(error);
  }
};

let acceeptWithNote = async () => {
  try {
    let reqData = {
      inspectionId: myData.inspectionId,
      token: useAppStore().session.auth.token,
      value: 1,
      note: note.value,
      noteId: null,
    };
    if (role == "checker") {
      reqData.field = "checkerJudgement";
      reqData.id = "checkerID";
      reqData.updateDate = "checkerJudgementDate";
      reqData.noteId = "checkerNote";
    } else {
      reqData.field = "managerJudgement";
      reqData.id = "approvalId";
      reqData.updateDate = "managerJudgementDate";
      reqData.noteId = "approvalNote";
    }
    await useAppStore().ajaxPost({
      url: "inspection/signinspection",
      reqData,
    });
    alert.fire({
      title: "Success",
      text: "Inspection successfully accepted",
      icon: "success",
    });
    props.closeModal();
  } catch (error) {
    console.log(error);
  }
};
let reject = async () => {
  try {
    let reqData = {
      inspectionId: myData.inspectionId,
      token: useAppStore().session.auth.token,
      value: 2,
    };
    if (role == "checker") {
      reqData.field = "checkerJudgement";
      reqData.id = "checkerID";
      reqData.updateDate = "checkerJudgementDate";
    } else {
      reqData.field = "managerJudgement";
      reqData.id = "approvalId";
      reqData.updateDate = "managerJudgementDate";
    }
    await useAppStore().ajaxPost({
      url: "inspection/signinspection",
      reqData,
    });
    alert.fire({
      title: "Success",
      text: "Inspection successfully rejected",
      icon: "success",
    });
    props.closeModal();
  } catch (error) {
    console.log(error);
  }
};
onBeforeMount(async () => {
  try {
    const res = await useAppStore().ajaxPost({
      url: "auth/getakundata",
      reqData: { token: useAppStore().session.auth.token },
    });
    const res2 = await useAppStore().ajaxPost({
      url: "setup/getdrawing",
      reqData: { partId: myData.partId },
    });

    const response = await useAppStore().ajaxPost({
      url: "setup/gettools",
      reqData: {},
    });
    tools.value = response.tools;

    image.value = res2.signFileContent;
    data.roleName = res.response.roleName;
    data.sureName = res.response.sureName;

    myData.inspectionData.forEach((element, index) => {
      myData.inspectionData[index].methodName = findTool(
        element.tools[0].toolId
      );
      nArray.value.forEach((e, i) => {
        NgArray.value.push(element[`judgement_${i}`]);
      });
    });
  } catch (error) {
    console.log(error);
  }
});

const findTool = (id) => {
  const tool = tools.value.find((e) => e.toolId == id);
  const name = tool.toolName;
  return name;
};
</script>
