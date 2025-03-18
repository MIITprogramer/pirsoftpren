<template>
  <v-text-field
    label="Inspection Item"
    density="compact"
    variant="outlined"
    rounded="pill"
    hint="Please enter a name"
    v-model="formData.itemName"
    :error-messages="validator1.itemName.$errors.map((e) => e.$message)"
  />
  <v-select
    :items="methods"
    class="mt-2"
    label="Method"
    density="compact"
    variant="outlined"
    rounded="pill"
    hint="Please select a method"
    v-model="formData.method"
    item-title="methodName"
    item-value="id"
    :error-messages="validator1.method.$errors.map((e) => e.$message)"
  />
  <v-select
    :items="types"
    class="my-2"
    label="Type"
    density="compact"
    variant="outlined"
    rounded="pill"
    hint="Please select a type"
    v-model="myType"
    item-title="label"
    item-value="id"
    :error-messages="validator1.type.$errors.map((e) => e.$message)"
  />
  <div v-if="formData.type == 1">
    <v-text-field
      label="Standard"
      density="compact"
      variant="outlined"
      rounded="pill"
      hint="Please enter value"
      v-model="formData.standart"
      :error-messages="validator1.standart.$errors.map((e) => e.$message)"
    />
  </div>
  <div v-if="formData.type == 2 || formData.type == 8">
    <v-text-field
      :error-messages="validator1.standart.$errors.map((e) => e.$message)"
      label="Standard"
      density="compact"
      variant="outlined"
      rounded="pill"
      hint="Please enter value"
      v-model="formData.standart"
      :readonly="formData.type == 2"
    />
  </div>
  <div v-if="formData.type == 3 || formData.type == 4 || formData.type == 5">
    <v-row>
      <v-col cols="6">
        <v-text-field
          :error-messages="validator2.value.$errors.map((e) => e.$message)"
          hide-spin-buttons
          type="number"
          label="Standard"
          density="compact"
          variant="outlined"
          rounded="pill"
          hint="Please enter value"
          v-model="rangeData.value"
        />
      </v-col>
      <v-col cols="6">
        <v-text-field
          :error-messages="validator2.unit.$errors.map((e) => e.$message)"
          type="text"
          label="Unit (mm/cm/m etc)"
          density="compact"
          variant="outlined"
          rounded="pill"
          hint="Please enter unit"
          v-model="rangeData.unit"
        />
      </v-col>
    </v-row>
  </div>
  <div v-if="formData.type == 6">
    <v-row>
      <v-col cols="4">
        <v-text-field
          :error-messages="validator2.value.$errors.map((e) => e.$message)"
          hide-spin-buttons
          type="number"
          label="Standard"
          density="compact"
          variant="outlined"
          rounded="pill"
          hint="Please enter value"
          v-model="rangeData.value"
        />
      </v-col>
      <v-col cols="4">
        <v-text-field
          :error-messages="validator2.tolerance.$errors.map((e) => e.$message)"
          hide-spin-buttons
          type="number"
          label="Tolerance (±)"
          density="compact"
          variant="outlined"
          rounded="pill"
          hint="Please enter value"
          v-model="rangeData.tolerance"
        />
      </v-col>
      <v-col cols="4">
        <v-text-field
          :error-messages="validator2.unit.$errors.map((e) => e.$message)"
          type="text"
          label="unit"
          density="compact"
          variant="outlined"
          rounded="pill"
          hint="Please enter unit"
          v-model="rangeData.unit"
        />
      </v-col>
    </v-row>
  </div>
  <div v-if="formData.type == 7">
    <v-row>
      <v-col cols="12">
        <v-text-field
          :error-messages="validator3.value.$errors.map((e) => e.$message)"
          hide-spin-buttons
          type="number"
          label="Standard"
          density="compact"
          variant="outlined"
          rounded="pill"
          hint="Please enter value"
          v-model="rangeData2.value"
        />
      </v-col>
      <v-col cols="4">
        <v-text-field
          :error-messages="
            validator3.upperTolerance.$errors.map((e) => e.$message)
          "
          hide-spin-buttons
          type="number"
          label="Tolerance (+)"
          density="compact"
          variant="outlined"
          rounded="pill"
          hint="Please enter value"
          v-model="rangeData2.upperTolerance"
        />
      </v-col>
      <v-col cols="4">
        <v-text-field
          :error-messages="
            validator3.lowerTolerance.$errors.map((e) => e.$message)
          "
          hide-spin-buttons
          type="number"
          label="Tolerance (-)"
          density="compact"
          variant="outlined"
          rounded="pill"
          hint="Please enter value"
          v-model="rangeData2.lowerTolerance"
        />
      </v-col>
      <v-col cols="4">
        <v-text-field
          :error-messages="validator3.unit.$errors.map((e) => e.$message)"
          type="text"
          label="unit"
          density="compact"
          variant="outlined"
          rounded="pill"
          hint="Please enter unit"
          v-model="rangeData2.unit"
        />
      </v-col>
    </v-row>
  </div>
  <v-divider class="mb-2"></v-divider>
  <v-btn block color="info" rounded="pill" @click="submit">Add Item</v-btn>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import useVuelidate from "@vuelidate/core";
import { helpers, required } from "@vuelidate/validators";
import { onMounted, reactive, ref, watch } from "vue";

const props = defineProps(["addItem"]);

const methods = ref([]);
const types = ref([]);
const myType = ref(2);
const formData = reactive({
  itemName: "",
  method: "",
  type: 2,
  standart: "OK",
});

const rangeData = reactive({
  value: "",
  tolerance: "",
  unit: "mm",
});

const rangeData2 = reactive({
  value: "",
  upperTolerance: "",
  lowerTolerance: "",
  unit: "mm",
});

const rules = {
  itemName: {
    required: helpers.withMessage("Item name is required", required),
  },
  method: {
    required: helpers.withMessage("Method is required", required),
  },
  type: {
    required: helpers.withMessage("Type is required", required),
  },
  standart: {
    required: helpers.withMessage("Standart is required", required),
  },
};

let rules2 = reactive({
  value: {},
  unit: {},
  tolerance: {},
});
let rules3 = reactive({
  value: {},
  unit: {},
  upperTolerance: {},
  lowerTolerance: {},
});

const validator1 = useVuelidate(rules, formData);
const validator2 = useVuelidate(rules2, rangeData);
const validator3 = useVuelidate(rules3, rangeData2);

const submit = async () => {
  try {
    const valid1 = await validator1.value.$validate();
    if (valid1) {
      const valid2 = await validator2.value.$validate();
      if (valid2) {
        const valid3 = await validator3.value.$validate();
        if (valid3) {
          props.addItem(formData);
        }
      } else {
        console.log(validator2.value.$errors);
      }
    } else {
      console.log(validator2.value.$errors);
    }
  } catch (error) {
    console.log(error);
  }
};

const refresh = async () => {
  try {
    const res1 = await useAppStore().ajaxPost({
      url: "setup/getmethods",
      reqData: {},
    });
    const res2 = await useAppStore().ajaxPost({
      url: "setup/gettypes",
      reqData: {},
    });
    types.value = res2.types;
    methods.value = res1.methods;
  } catch (error) {
    console.log(error);
  }
};
watch(myType, (e) => {
  formData.type = e;
  if (e == 2) {
    formData.standart = "OK";
    rules2.tolerance = {};
    rules2.unit = {};
    rules2.value = {};
  } else if (e == 6 || e == 3 || e == 4 || e == 5) {
    formData.standart = rangeData;
    if (e == 6) {
      rules2.tolerance = {
        required: helpers.withMessage("Tolerance value is required", required),
      };
      rules2.unit = {
        required: helpers.withMessage("Measurement unit is required", required),
      };

      rules2.value = {
        required: helpers.withMessage("Standart value is required", required),
      };
    } else {
      rules2.tolerance = {};
      rules2.unit = {};
      rules2.value = {
        required: helpers.withMessage("Standart value is required", required),
      };
    }
  } else if (e == 7) {
    formData.standart = rangeData2;
    rules3.upperTolerance = {
      required: helpers.withMessage("Tolerance value is required", required),
    };
    rules3.lowerTolerance = {
      required: helpers.withMessage("Tolerance value is required", required),
    };
    rules3.unit = {
      required: helpers.withMessage("Measurement unit is required", required),
    };
    rules3.value = {
      required: helpers.withMessage("Standart value is required", required),
    };
  } else {
    formData.standart = "";
    rules2.tolerance = {};
    rules2.unit = {};
    rules2.value = {};
  }
});

onMounted(() => {
  refresh();
});
</script>
