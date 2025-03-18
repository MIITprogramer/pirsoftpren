<template>
  <v-row>
    <v-col cols="4">
      <div v-for="item in dataStructure" :key="item.key">
        <v-text-field
          class="mt-2"
          :label="item.label"
          :hint="item.hint"
          :type="item.type"
          v-model="part[item.key]"
          :error-messages="validator[item.key].$errors.map((e) => e.$message)"
          variant="outlined"
          density="compact"
          rounded="pill"
          :hide-spin-buttons="item.type == 'number' ? true : false"
        />
      </div>
      <v-select
        class="mt-2"
        label="Sampling Level"
        variant="outlined"
        density="compact"
        rounded="pill"
        :items="['class_A', 'class_B', 'class_C']"
        v-model="part.samplingLevel"
      >
      </v-select>
    </v-col>

    <v-col cols="8">
      <v-card>
        <v-card-title>Drawing</v-card-title>
        <v-card-text>
          <v-img
            v-if="part.designFile === null"
            src="@/assets/no-new.png"
            height="250"
          />
          <v-img v-else :src="image" height="210" />
          <v-divider class="my-2"></v-divider>
          <v-file-input
            accept="image/png"
            :error-messages="
              validator['designFile'].$errors.map((e) => e.$message)
            "
            prepend-icon=""
            variant="outlined"
            rounded="pill"
            density="compact"
            label="Drawing File"
            @change="onFileSelected"
            @click:clear="part.designFile = null"
          >
            <template v-slot:prepend-inner>
              <v-icon>mdi-image</v-icon>
            </template>
          </v-file-input>
        </v-card-text>
      </v-card>
    </v-col>
    <v-col cols="12">
      <v-table density="compact">
        <template v-slot:top>
          <v-toolbar density="compact" rounded="lg" color="info" class="mb-2">
            <template v-slot:title>Inspection Item</template>
            <template v-slot:append>
              <v-btn
                flat
                prepend-icon="mdi-plus"
                color="white"
                @click="dialog = true"
              >
                add item
              </v-btn>
            </template>
          </v-toolbar>
        </template>
        <thead>
          <tr>
            <th class="text-center">No</th>
            <th>Item Name</th>
            <th>Method/Tool</th>
            <th>Standart</th>
            <th class="text-center">Remove</th>
          </tr>
        </thead>
        <tbody>
          <tr
            class="text-error text-center"
            v-if="validator['inspectionItem'].$errors.length > 0"
          >
            <td
              colspan="5"
              class="text-center"
              style="border: solid 1pt red !important; border-radius: 9999px"
            >
              No Data Available, please add some item.
            </td>
          </tr>
          <tr v-for="(item, index) in part.inspectionItem" :key="item">
            <td class="text-center">{{ index + 1 }}</td>
            <td>{{ item.itemName }}</td>
            <td>{{ methodLabel(item.method).methodName }}</td>
            <td v-if="item.type == 1 || item.type == 2 || item.type == 8">
              {{ item.standart }}
            </td>
            <td v-if="item.type == 3">
              {{ item.standart.value }}
              {{ item.standart.unit }}
            </td>
            <td v-if="item.type == 4">
              ≥
              {{ item.standart.value }}
              {{ item.standart.unit }}
            </td>
            <td v-if="item.type == 5">
              ≤
              {{ item.standart.value }}
              {{ item.standart.unit }}
            </td>
            <td v-if="item.type == 6">
              {{ item.standart.value }}
              {{ item.standart.unit }}
              ± {{ item.standart.tolerance }}
            </td>
            <td v-if="item.type == 7">
              {{ item.standart.value }}
              +{{ item.standart.upperTolerance }}, -{{
                item.standart.lowerTolerance
              }}
              {{ item.standart.unit }}
            </td>
            <td class="text-center">
              <v-icon color="primary" @click="editMe(index)">mdi-pencil</v-icon>
              <v-icon color="error" @click="deleteDialogOpen(index)"
                >mdi-delete</v-icon
              >
            </td>
          </tr>
        </tbody>
      </v-table>
    </v-col>
  </v-row>
  <v-divider class="mb-2"></v-divider>
  <v-btn block color="info" rounded="pill" @click="submit">Submit</v-btn>
  <v-dialog
    v-model="dialog"
    scrollable
    persistent
    :overlay="false"
    max-width="600px"
    transition="dialog-transition"
  >
    <v-card>
      <v-toolbar density="compact">
        <template v-slot:title>New Inspection Item</template>
        <template v-slot:append>
          <v-btn flat icon @click="dialog = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </template>
      </v-toolbar>
      <v-card-text>
        <NewInspectionItem :add-item="addItem"></NewInspectionItem>
      </v-card-text>
    </v-card>
  </v-dialog>
  <v-dialog
    v-model="itemEdit"
    scrollable
    persistent
    :overlay="false"
    max-width="600px"
    transition="dialog-transition"
  >
    <v-card>
      <v-toolbar density="compact">
        <template v-slot:title>Edit Inspection Item</template>
        <template v-slot:append>
          <v-btn flat icon @click="itemEdit = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </template>
      </v-toolbar>
      <v-card-text>
        <EditInspectionItem
          :edit-item="editItem"
          :edit-data="part.inspectionItem[editIndex]"
        ></EditInspectionItem>
      </v-card-text>
    </v-card>
  </v-dialog>

  <v-dialog
    v-model="deleteDialog"
    scrollable
    persistent
    :overlay="false"
    max-width="500px"
    transition="dialog-transition"
  >
    <v-card>
      <v-toolbar density="compact" color="transparent">
        <v-toolbar-title>Delete Item</v-toolbar-title>
      </v-toolbar>
      <v-card-text> Are you sure you want to delete this item? </v-card-text>
      <v-divider></v-divider>
      <v-row class="ma-1">
        <v-col cols="6">
          <v-btn
            color="default"
            block=""
            prepend-icon="mdi-close"
            @click="deleteDialog = false"
            >Cancel</v-btn
          >
        </v-col>
        <v-col cols="6">
          <v-btn
            color="error"
            block=""
            prepend-icon="mdi-delete"
            @click="removeItem()"
            >Delete</v-btn
          >
        </v-col>
      </v-row>
    </v-card>
  </v-dialog>
</template>
<script setup>
import NewInspectionItem from "@/components/forms/newInspectionItem.vue";
import { useAppStore } from "@/store/app";
import useVuelidate from "@vuelidate/core";
import { helpers, required } from "@vuelidate/validators";
import { onMounted, reactive, ref } from "vue";
import EditInspectionItem from "./editInspectionItem.vue";

const props = defineProps(["closeModal"]);

const image = ref("");
const dialog = ref(false);
const deleteKey = ref(null);
const deleteDialog = ref(false);
const method = ref([]);
const alert = useAppStore().alert;
const itemEdit = ref(false);
const editIndex = ref(null);

const part = reactive({
  partNumber: "",
  partName: "",
  customerName: "",
  dieCavity: "",
  deliveryModel: "",
  inspectionItem: [],
  designFile: null,
  samplingLevel: "class_C",
});

const dataStructure = [
  {
    key: "partNumber",
    label: "Part Number",
    hint: "Please enter a part number",
    type: "text",
  },
  {
    key: "partName",
    label: "Part Name",
    hint: "Please enter a part name",
    type: "text",
  },
  {
    key: "customerName",
    label: "Customer Name",
    hint: "Please enter a customer name",
    type: "text",
  },
  {
    key: "dieCavity",
    label: "Die Cavity",
    hint: "Please enter die cavity",
    type: "text",
  },
  {
    key: "deliveryModel",
    label: "Delivery Model",
    hint: "Please enter delivery model",
    type: "text",
  },
];

const rules = {
  partNumber: {
    required: helpers.withMessage("Part number is required", required),
  },
  partName: {
    required: helpers.withMessage("Part name is required", required),
  },
  customerName: {
    required: helpers.withMessage("Customer name is required", required),
  },
  dieCavity: {
    required: helpers.withMessage("Die Cavity is required", required),
  },
  deliveryModel: {
    required: helpers.withMessage("Delivery model is required", required),
  },
  inspectionItem: {
    length: helpers.withMessage("Please add one or more item", () => {
      return part.inspectionItem.length > 0;
    }),
  },
  designFile: {
    required: helpers.withMessage("Drawing is required", required),
  },
};

const validator = useVuelidate(rules, part);
const addItem = (item) => {
  part.inspectionItem.push(item);
  dialog.value = false;
};

const editItem = (item) => {
  part.inspectionItem[editIndex.value] = item;
  itemEdit.value = false;
};

const submit = async () => {
  try {
    const valid = await validator.value.$validate();
    if (valid) {
      let fd = new FormData();

      fd.append("designFile", part["designFile"]);
      fd.append("inspectionItem", JSON.stringify(part["inspectionItem"]));
      fd.append("samplingLevel", part.samplingLevel);
      dataStructure.forEach((element) => {
        const key = element.key;
        fd.append(key, part[key]);
      });
      await useAppStore().ajaxPostWithFile({
        url: "setup/addpir",
        reqData: fd,
      });
      alert.fire({
        icon: "success",
        title: "Success",
        text: "Part successfully added",
      });
      props.closeModal();
    }
  } catch (error) {
    alert.fire({
      icon: "error",
      title: "Duplicate error",
      text: error,
    });
  }
};

const removeItem = () => {
  part.inspectionItem.splice(deleteKey.value, 1);
  deleteDialog.value = false;
};

const deleteDialogOpen = (index) => {
  deleteDialog.value = true;
  deleteKey.value = index;
};

const onFileSelected = (event) => {
  const file = event.target.files[0];
  if (file) {
    part.designFile = file;
    const reader = new FileReader();
    reader.onload = (e) => {
      image.value = e.target.result;
    };
    reader.readAsDataURL(file);
  } else {
    part.designFile = null;
  }
};

const methodLabel = (id) => {
  return method.value.find((e) => e.id == id);
};

const editMe = (index) => {
  editIndex.value = index;
  itemEdit.value = true;
};

onMounted(async () => {
  try {
    const response = await useAppStore().ajaxPost({
      url: "setup/getmethods",
      reqData: {},
    });
    method.value = response.methods;
  } catch (error) {
    console.log(error);
  }
});
</script>
