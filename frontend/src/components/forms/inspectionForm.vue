<!-- eslint-disable no-case-declarations -->
<style>
.v-select__selection-text {
  font-size: 10pt;
}
</style>
<template>
  <v-row id="homeScroll">
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
          <h1 class="text-h5 text-uppercase w-100 text-center">INSPECTION</h1>
        </v-col>
        <v-col cols="12">
          <h1
            class="text-h5 text-uppercase text-center"
            style="border: 1pt, solid, black"
          >
            {{ myData.partData.partNumber }}
          </h1>
        </v-col>
      </v-row>
    </v-col>
  </v-row>
  <v-row>
    <v-col cols="12">
      <v-img :src="`data:image/png;base64,${image}`" height="270" />
    </v-col>
    <v-col cols="12" v-if="inspect">
      <v-table density="compact" fixed-header height="400">
        <thead>
          <tr>
            <th class="text-center" style="width: 5px">No</th>
            <th class="text-center">Inspection Item</th>
            <th class="text-center">Standard</th>
            <th class="text-center" v-if="step < 1">
              Inspection Method/ <br />
              tools
            </th>
            <th class="text-center">Measuring Tool Number</th>
            <th class="text-center text-no-wrap">N {{ step + 1 }}</th>
          </tr>
        </thead>
        <tbody>
          <tr
            class="text-center"
            v-for="(item, index) in myData.partData.inspectionItem"
            :key="item"
          >
            <td>
              <div style="border: 1px solid black; border-radius: 50%">
                {{ index + 1 }}
              </div>
            </td>
            <td>{{ item.itemName }}</td>
            <td
              class=""
              v-if="item.type == 1 || item.type == 2 || item.type == 8"
            >
              {{ item.standart }}
            </td>
            <td class="text-center" v-if="item.type == 3">
              {{ item.standart.value }} {{ item.standart.unit }}
            </td>
            <td class="text-center" v-if="item.type == 4">
              ≥ {{ item.standart.value }} {{ item.standart.unit }}
            </td>
            <td class="text-center" v-if="item.type == 5">
              ≤ {{ item.standart.value }} {{ item.standart.unit }}
            </td>
            <td class="text-center" v-if="item.type == 6">
              {{ item.standart.value }} ± {{ item.standart.tolerance }}
              {{ item.standart.unit }}
            </td>

            <td class="" v-if="item.type == 7">
              {{ item.standart.value }}
              +{{ item.standart.upperTolerance }}, -
              {{ item.standart.lowerTolerance }}
              {{ item.standart.unit }}
            </td>
            <td v-if="step < 1">{{ item.methodName }}</td>
            <td class="px-1">
              <v-select
                style="width: 140px"
                v-if="step == 0"
                variant="outlined"
                rounded="pill"
                class="ma-1"
                density="compact"
                hide-details=""
                :items="item.tools"
                item-title="toolName"
                item-value="toolId"
                v-model="myData.partData.inspectionItem[index].toolNumber"
                :disabled="isDisabled(index)"
              />
              <div v-else>
                {{
                  myData.partData.inspectionItem[index].tools.find(
                    (e) =>
                      e.toolId ==
                      myData.partData.inspectionItem[index].toolNumber
                  ).toolName
                }}
              </div>
            </td>
            <td class="nField text-center" v-if="item.type == 1">
              <v-text-field
                :width="step > 0 ? '170px' : '85px'"
                @keyup="getJudgement(item.type, index)"
                :error="
                  !myData.partData.inspectionItem[index][`judgement_${step}`]
                "
                variant="outlined"
                rounded="pill"
                class="ma-1"
                density="compact"
                hide-details=""
                type="text"
                hide-spin-buttons
                :disabled="
                  myData.partData.inspectionItem[index].toolNumber == ''
                "
                v-model="
                  myData.partData.inspectionItem[index][`result_${step}`]
                "
              />
            </td>
            <td
              class="nField text-center"
              v-if="item.type == 2 || item.type == 8"
            >
              <v-select
                :width="step > 0 ? '170px' : '85px'"
                @update:model-value="
                  (val) => updateResult(item.type, val, index)
                "
                :error="
                  !myData.partData.inspectionItem[index][`judgement_${step}`]
                "
                variant="outlined"
                rounded="pill"
                class="ma-1"
                density="compact"
                hide-details=""
                :items="[{ value: 'NG' }, { value: 'OK' }]"
                item-title="value"
                item-value="value"
                v-model="
                  myData.partData.inspectionItem[index][`result_${step}`]
                "
                :disabled="
                  myData.partData.inspectionItem[index].toolNumber == ''
                "
              />
            </td>
            <td
              v-if="
                item.type == 3 ||
                item.type == 4 ||
                item.type == 5 ||
                item.type == 6 ||
                item.type == 7
              "
              class="text-center nField"
            >
              <v-text-field
                :width="step > 0 ? '170px' : '85px'"
                @keyup="getJudgement(item.type, index)"
                :error="
                  !myData.partData.inspectionItem[index][`judgement_${step}`]
                "
                variant="outlined"
                rounded="pill"
                class="ma-1"
                density="compact"
                hide-details=""
                type="number"
                hide-spin-buttons
                :disabled="
                  myData.partData.inspectionItem[index].toolNumber == ''
                "
                v-model="
                  myData.partData.inspectionItem[index][`result_${step}`]
                "
              >
              </v-text-field>
            </td>
          </tr>
        </tbody>
      </v-table>
    </v-col>
    <v-col cols="12" v-if="inspect">
      <v-divider class="mb-4"></v-divider>
      <v-row>
        <v-col cols="4">
          <v-btn
            color="primary"
            class="w-100"
            rounded="pill"
            @click="props.closeModal()"
            >Cancel</v-btn
          >
        </v-col>
        <v-col cols="4">
          <v-btn @click="back" color="primary" class="w-100" rounded="pill"
            >Back</v-btn
          >
        </v-col>
        <v-col cols="4">
          <v-btn
            @click="submit"
            :text="
              isReject() && findInvalid().length < 1 ? 'Submit NG' : 'Submit'
            "
            :color="
              isReject() && findInvalid().length < 1 ? 'error' : 'primary'
            "
            class="w-100"
            rounded="pill"
            :disabled="findInvalid().length > 0"
          />
        </v-col>
      </v-row>
    </v-col>
    <v-col v-else cols="12">
      <table class="inspection-table">
        <thead>
          <tr>
            <th>No</th>
            <th>Inspection Item</th>
            <th>Standard</th>
            <th>Measuring Tool No</th>
            <th v-for="(item, index) in nArray" :key="index">
              N{{ index + 1 }}
            </th>
            <th>Judgement</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(item, index) in myData.partData.inspectionItem"
            :key="index"
          >
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
              {{ item.standart.lowerTolerance }}
              {{ item.standart.unit }}
            </td>
            <td class="highlight px-0">
              {{ item.tools.find((e) => e.toolId == item.toolNumber).toolName }}
            </td>
            <td
              v-for="(n, key) in item.n"
              :key="key"
              :class="
                item['judgement_' + key]
                  ? 'highlight text-uppercase '
                  : 'text-uppercase error '
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
    <v-col v-if="!inspect && NgArray.includes(false)" cols="12">
      <v-divider></v-divider>
    </v-col>
    <v-col v-if="!inspect && NgArray.includes(false)" cols="12">
      <div
        class="fill-height w-100 text-uppercase text-center text-error text-h5 border-double"
      >
        SEGERA LAPOR ATASAN !!! JANGAN LOLOSKAN PRODUK NG !!!
      </div>
    </v-col>
    <v-col v-if="!inspect" cols="12">
      <v-divider></v-divider>
    </v-col>
    <v-col v-if="!inspect" cols="12">
      <v-row>
        <v-col cols="6">
          <v-btn @click="back" color="primary" class="w-100" rounded="pill"
            >Back</v-btn
          >
        </v-col>
        <v-col cols="6">
          <v-btn
            block
            v-if="NgArray.includes(false)"
            color="error"
            rounded="pill"
            dark
            @click="submitResultNow('NG')"
            >Report NG</v-btn
          >

          <v-btn
            @click="submitResultNow('OK')"
            v-else
            block
            color="primary"
            rounded="pill"
            dark
            >Submit</v-btn
          >
        </v-col>
      </v-row>
    </v-col>
  </v-row>
  <v-dialog
    v-model="submitResult"
    scrollable
    persistent
    :overlay="false"
    max-width="500px"
    transition="dialog-transition"
  >
    <v-card>
      <v-toolbar density="compact" color="transparent">
        <v-toolbar-title>Submit Inspection Result</v-toolbar-title>
        <v-btn flat icon @click="deleteRole = false">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-toolbar>
      <v-card-text>
        Are you sure you want to submit this result? ({{ submitText }})
      </v-card-text>
      <v-divider></v-divider>
      <v-row class="ma-1">
        <v-col cols="6">
          <v-btn
            color="default"
            block=""
            prepend-icon="mdi-close"
            @click="submitResult = false"
            >Cancel</v-btn
          >
        </v-col>
        <v-col cols="6">
          <v-btn
            v-if="submitText == 'NG'"
            color="error"
            block=""
            prepend-icon="mdi-delete"
            @click="submitInspection"
            >Submit NG</v-btn
          >
          <v-btn
            v-else
            color="primary"
            block=""
            prepend-icon="mdi-check"
            @click="submitInspection"
            >Submit</v-btn
          >
        </v-col>
      </v-row>
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
import { nextTick, onBeforeMount, reactive, ref } from "vue";

const alert = useAppStore().alert;

const props = defineProps(["closeModal", "inspectionData", "backToHeader"]);
let data = reactive({ sureName: "sureName", roleName: "" });
const methods = ref([]);
const tools = ref([]);
const image = ref(null);
let myData = props.inspectionData;
let n = props.inspectionData.headerData.n;
let nArray = ref(new Array(n).fill(""));
let inspect = ref(true);
let NgArray = ref([]);
let submitText = ref();
let finalResult = ref(2);

const step = ref(0);

const submitResult = ref(false);

const submitResultNow = (result) => {
  submitResult.value = true;
  submitText.value = result;
  if (result == "OK") {
    finalResult.value = 1;
  } else {
    finalResult.value = 2;
  }
};

const back = () => {
  if (step.value == 0) {
    props.backToHeader(myData);
  } else {
    if (!inspect.value) {
      inspect.value = true;
    } else {
      window.location.href = "#homeScroll";
      step.value--;
    }
  }
};

const submit = () => {
  NgArray.value = [];
  if (step.value + 1 != n) {
    step.value++;
    window.location.href = "#homeScroll";
  } else {
    myData.partData.inspectionItem.forEach((e, key) => {
      myData.partData.inspectionItem[key].n = new Array(n).fill("");
      myData.partData.inspectionItem[key].judgement = new Array(n).fill("");
      let myN = myData.partData.inspectionItem[key].n;
      myN.forEach((element, index) => {
        myData.partData.inspectionItem[key].judgement[index] =
          e[`judgement_${index}`];
        NgArray.value.push(e[`judgement_${index}`]);
      });
      myData.partData.inspectionItem[key].j = myData.partData.inspectionItem[
        key
      ].judgement.filter((e) => {
        e;
      });
    });
    inspect.value = false;
  }
};

const isDisabled = (index) => {
  if (index == 0) {
    return false;
  } else {
    if (
      myData.partData.inspectionItem[index - 1][`result_${step.value}`] == ""
    ) {
      return true;
    } else {
      return false;
    }
  }
};

const findReject = () => {
  const reject = myData.partData.inspectionItem.filter(
    (e) => e[`judgement_${step.value}`] == false
  );
  return reject;
};

const findInvalid = () => {
  const invalid = myData.partData.inspectionItem.filter(
    (e) => e[`result_${step.value}`] == ""
  );
  return invalid;
};

const isReject = () => {
  return findReject().length > 0;
};

const updateResult = (type, val, index) => {
  myData.partData.inspectionItem[index][`result_${step.value}`] = val;
  nextTick(() => {
    getJudgement(type, index);
  });
};

const getJudgement = (type, index) => {
  let item = myData.partData.inspectionItem[index];
  let value = myData.partData.inspectionItem[index][`result_${step.value}`];
  let standart;
  let tolerance;
  let min;
  let max;

  if (type == 1 || type == 2) {
    standart = myData.partData.inspectionItem[index].standart;
    value = value?.trim().toLowerCase();
    standart = standart?.trim().toLowerCase();
  } else if (type == 8) {
    standart = "ok";
    value = value?.trim().toLowerCase();
  } else {
    standart = Number(item.standart?.value);
    value = Number(value);
  }

  if (standart == null || value == null) {
    console.error("Standart atau value tidak terdefinisi", { value, standart });
    item[`judgement_${step.value}`] = false;
    return;
  }

  switch (type) {
    case 1:
    case 2:
    case 3:
      item[`judgement_${step.value}`] = value === standart;
      break;
    case 4:
      item[`judgement_${step.value}`] = value >= standart;
      break;
    case 5:
      item[`judgement_${step.value}`] = value <= standart;
      break;
    case 6:
      tolerance = Number(item.standart.tolerance);
      min = standart - tolerance;
      max = standart + tolerance;
      item[`judgement_${step.value}`] = value >= min && value <= max;
      break;
    case 7:
      min = standart - Number(item.standart.lowerTolerance);
      max = standart + Number(item.standart.upperTolerance);
      item[`judgement_${step.value}`] = value >= min && value <= max;
      break;
    case 8:
      item[`judgement_${step.value}`] = value === standart;
      console.log(type, index);
      break;
  }
};

const submitInspection = async () => {
  try {
    const token = useAppStore().session.auth.token;
    myData.token = token;
    myData.inspectorJudgement = finalResult.value;
    await useAppStore().ajaxPost({
      url: "inspection/submitInspection",
      reqData: myData,
    });
    alert.fire({
      title: "Success",
      text: "Inspection successfully submitted",
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
    data.roleName = res.response.roleName;
    data.sureName = res.response.sureName;

    const res2 = await useAppStore().ajaxPost({
      url: "setup/getdrawing",
      reqData: { partId: myData.partData.partId },
    });

    image.value = res2.signFileContent;

    const response = await useAppStore().ajaxPost({
      url: "setup/getmethods",
      reqData: {},
    });
    methods.value = response.methods;

    const tol = await useAppStore().ajaxPost({
      url: "setup/gettools",
      reqData: {},
    });
    tools.value = tol.tools;

    myData.partData.inspectionItem.forEach((element, key) => {
      let find = methods.value.find((e) => e.id == element.method);
      myData.partData.inspectionItem[key].methodName = find.methodName;
      myData.partData.inspectionItem[key].tools = tools.value.filter(
        (e) => e.method == element.method
      );

      if (element.method == 2) {
        myData.partData.inspectionItem[key].toolNumber = 1;
      }
    });
  } catch (error) {
    console.log(error);
  }
});
</script>
