<template>
  <div class="h-100 d-flex" v-if="step == 0">
    <v-card max-width="500" class="ma-auto">
      <v-card-text>
        <v-row class="ma-auto">
          <v-col cols="3">
            <div
              class="ma-auto d-flex w-100 h-100 text-center justify-center flex-column"
            >
              <v-img height="100" src="@/assets/softfren.png" />
              <small> {{ data.sureName }}</small>
              <small> {{ data.roleName }}</small>
            </div>
          </v-col>
          <v-col cols="9">
            <v-row>
              <v-col cols="12">
                <h1 class="text-h5 text-uppercase w-100 text-center">
                  Header Input
                </h1>
              </v-col>
              <v-col cols="12">
                <h1
                  class="text-h5 text-uppercase w-100 text-center"
                  style="border: 1pt, solid, black"
                >
                  {{ partData.partNumber }}
                </h1>
              </v-col>
            </v-row>
          </v-col>
        </v-row>
        <div v-for="(item, index) in dataStructure" :key="index">
          <v-text-field
            @change="selectDate"
            v-if="index == 'deliveryDate'"
            v-model="headerData[index]"
            variant="outlined"
            rounded="pill"
            density="compact"
            :hide-spin-buttons="item.type == 'number' ? true : false"
            :label="item.label"
            :type="item.type"
            :hint="item.hint"
            :error-messages="
              item.validate
                ? validators[index].$errors.map((e) => e.$message)
                : ''
            "
            :readonly="index == 'inspectionDate' || index == 'n' ? true : false"
          />
          <v-text-field
            v-if="
              index != 'deliveryQuantity' &&
              index != 'deliveryDate' &&
              index != 'category'
            "
            v-model="headerData[index]"
            variant="outlined"
            rounded="pill"
            density="compact"
            :hide-spin-buttons="item.type == 'number' ? true : false"
            :label="item.label"
            :type="item.type"
            :hint="item.hint"
            :error-messages="
              item.validate
                ? validators[index].$errors.map((e) => e.$message)
                : ''
            "
            :readonly="index == 'inspectionDate' || index == 'n' ? true : false"
          />
          <v-text-field
            v-if="index == 'deliveryQuantity'"
            @keyup="sampleCalculator"
            v-model="headerData[index]"
            :error-messages="
              item.validate
                ? validators[index].$errors.map((e) => e.$message)
                : ''
            "
            variant="outlined"
            rounded="pill"
            density="compact"
            :hide-spin-buttons="item.type == 'number' ? true : false"
            :label="item.label"
            :type="item.type"
            :hint="item.hint"
            :readonly="index == 'inspectionDate' || index == 'n' ? true : false"
          />
          <v-select
            class="text-start mb-2"
            v-if="index == 'category'"
            v-model="headerData[index]"
            :error-messages="
              item.validate
                ? validators[index].$errors.map((e) => e.$message)
                : ''
            "
            variant="outlined"
            rounded="pill"
            density="compact"
            :hide-spin-buttons="item.type == 'number' ? true : false"
            :label="item.label"
            :items="categories"
            item-title="label"
            item-value="id"
            :hint="item.hint"
            :readonly="index == 'inspectionDate' || index == 'n' ? true : false"
          />
        </div>
        <hr class="my-1" />
        <v-row>
          <v-col cols="6">
            <v-btn rounded="pill" block color="primary" dark @click="closeModal"
              >CANCEL</v-btn
            >
          </v-col>
          <v-col cols="6">
            <v-btn
              @click="submitHeader"
              rounded="pill"
              block
              color="primary"
              dark
              >NEXT</v-btn
            >
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </div>

  <v-card v-if="step > 0">
    <v-card-text>
      <InspectionForm
        :close-modal="props.closeModal"
        :inspection-data="inspectionData"
        :back-to-header="backToHeader"
      />
    </v-card-text>
  </v-card>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import useVuelidate from "@vuelidate/core";
import { helpers, minValue, required } from "@vuelidate/validators";
import moment from "moment";
import { onMounted, reactive, ref } from "vue";
import InspectionForm from "./inspectionForm.vue";

let data = reactive({ sureName: "sureName", roleName: "" });
const date = new Date();
const momentDate = moment(date).format("yyyy-MM-DD");
const rangeData = ref();
const props = defineProps(["partData", "closeModal"]);
const inspectionData = ref({});
const headerData = reactive({
  deliveryDate: "",
  inspectionDate: momentDate,
  deliveryQuantity: "",
  lotNumber: "",
  category: "",
  n: 0,
});
let categories = ref([]);
const step = ref(0);

const selectDate = () => {
  const selectedDate = headerData.deliveryDate;
  const mnt = moment(selectedDate).format("DDMMYY");
  headerData.lotNumber = mnt;
};

const dataStructure = {
  deliveryDate: {
    label: "Delivery Date",
    type: "date",
    hint: "Please select a date",
    validate: true,
  },
  inspectionDate: {
    validate: false,
    label: "Inspection Date",
    type: "date",
    hint: "Please select a date",
  },
  deliveryQuantity: {
    validate: true,
    label: "Delivery Quantity",
    type: "number",
    hint: "Please enter a number",
  },
  lotNumber: {
    validate: true,
    label: "Lot number",
    type: "text",
    hint: "Please select a date",
  },
  category: {
    validate: true,
    label: "Category",
    type: "text",
    hint: "Please enter a category",
  },
  n: {
    validate: true,
    label: "Quantity of Measured Part/Lot",
    type: "number",
  },
};

const rules = {
  deliveryDate: {
    required: helpers.withMessage("Please enter a delivery date", required),
  },
  deliveryQuantity: {
    required: helpers.withMessage(
      "Please enter a delivery quantity more than 0",
      minValue(1)
    ),
  },
  lotNumber: {
    required: helpers.withMessage("Please enter a lot number", required),
  },
  category: {
    required: helpers.withMessage("Please enter a category", required),
  },
  n: {
    required: helpers.withMessage(
      "Please enter a delivery quantity more than 0",
      minValue(1)
    ),
  },
};

const validators = useVuelidate(rules, headerData);

const sampleCalculator = () => {
  const sampleClass = props.partData.samplingLevel;
  const deliverySize = headerData.deliveryQuantity;
  if (deliverySize > 0) {
    if (deliverySize == 1) {
      headerData.n = 1;
    } else {
      const range = rangeData.value.find((e) => {
        if (e.Nmax >= deliverySize && e.Nmin <= deliverySize) {
          return true;
        } else {
          if (e.Nmax == 0 && e.Nmin <= deliverySize) {
            return true;
          }
        }
      });
      headerData.n = range[sampleClass];
    }
  } else {
    headerData.n = 0;
  }
};

onMounted(async () => {
  try {
    const res = await useAppStore().ajaxPost({
      url: "auth/getakundata",
      reqData: { token: useAppStore().session.auth.token },
    });
    data.roleName = res.response.roleName;
    data.sureName = res.response.sureName;

    const rangeResponse = await useAppStore().ajaxPost({
      url: "setup/getrange",
      reqData: {},
    });
    const categoriesResponse = await useAppStore().ajaxPost({
      url: "inspection/getcategory",
      reqData: {},
    });
    rangeData.value = rangeResponse.range;
    categories.value = categoriesResponse;
  } catch (error) {
    console.log(error);
  }
});

const submitHeader = async () => {
  try {
    const valid = await validators.value.$validate();
    let n = headerData.n;
    let arr = new Array(n).fill("");

    let sendData;
    let items;

    if (inspectionData.value.partData == undefined) {
      sendData = props.partData;
      items = JSON.parse(sendData.inspectionItem);
      sendData.inspectionItem = items;
      sendData.inspectionItem.forEach((e, key) => {
        arr.forEach((e, i) => {
          sendData.inspectionItem[key][`result_${i}`] = "";
          sendData.inspectionItem[key][`judgement_${i}`] = false;
        });
        sendData.inspectionItem[key].toolNumber = "";
      });
      inspectionData.value = {
        partData: sendData,
        headerData,
      };
    }

    if (valid) {
      step.value++;
    }
  } catch (error) {
    console.log(error);
  }
};

let backToHeader = (data) => {
  step.value = 0;
  inspectionData.value = data;
};
</script>
