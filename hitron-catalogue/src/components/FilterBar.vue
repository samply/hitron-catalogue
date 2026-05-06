<template>
  <div class="filter-bar">
    <div
      class="card"
      v-for="card in cards"
      :key="card.id"
      style="background-color: white"
    >
      <div
        class="card-header"
        style="background-color: white; border-bottom: none"
      >
        <!-- @click="toggleCollapse(card)"-->

        <div class="title">
          {{ card.title }}
        </div>
        <div class="arrow">
          <!-- <i
          class="fas"
          :class="card.isRotated ? 'fa-angle-up' : 'fa-angle-down'"
        ></i>-->
        </div>
      </div>
      <div
        class="card-body"
        :style="{ display: card.isCollapsed ? 'none' : 'block' }"
      >
        <div
          style="
            display: flex;
            flex-flow: row;
            font-size: 11px;
            float: right;
            align-content: flex-end;
            justify-content: right;
            width: 100%;
            padding-left: 40%;
          "
        >
          <div class="form-check" style="margin-right: 7%">
            <input class="form-check-input" type="checkbox" id="matchany" />
            <label class="form-check-label text-right" for="matchany"
              >Match any</label
            >
          </div>
          <div class="form-check" style="margin-right: 7%">
            <input class="form-check-input" type="checkbox" id="matchall" />
            <label class="form-check-label text-right" for="matchall"
              >Match all</label
            >
          </div>
        </div>
        <br />
        <div class="form-check" v-for="option in card.options" :key="option.id">
          <input class="form-check-input" type="checkbox" :id="option.id" />
          <!-- :checked="option.checked @change="toggleOption(card, option)" "-->
          <label
            class="form-check-label"
            :for="option.id"
            style="font-size: 13px"
          >
            <template v-if="card.id === 'diagnosis'">
              {{ option.icd10 }} - {{ option.name }}
            </template>
            <template v-else-if="card.id === 'omicsdatatypes'">
              {{ option.name }}
            </template>
            <template v-else-if="card.id === 'cancertypes'">
              {{ option.code }} - {{ option.name }}
            </template>
            <template v-else-if="card.id === 'materialtypes'">
              {{ option.code }} - {{ option.name }}
            </template>
            <template v-else-if="card.id === 'collectiontypes'">
              {{ option.name }}
            </template>
            <template v-else-if="card.id === 'datagenerationpipelines'">
              {{ option.name }}
            </template>
            <template v-else-if="card.id === 'dataanalysismethods'">
              {{ option.name }}
            </template>
            <template v-else-if="card.id === 'experimentalmethods'">
              {{ option.name }}
            </template>
          </label>
        </div>
        <div
          style="
            display: flex;
            flex-flow: row;
            font-size: 11px;
            float: right;
            align-content: flex-end;
            justify-content: right;
            width: 100%;
          "
        >
          <div class="form-check" style="margin-right: 1%">
            <button
              type="button"
              class="btn"
              style="
                --bs-btn-padding-y: 0.25rem;
                --bs-btn-padding-x: 0.5rem;
                --bs-btn-font-size: 0.75rem;
                font-style: italic;
                color: darkblue;
                border: none;
              "
            >
              {{ card.selectAll ? "Unselect all" : "Select all" }}
            </button>
            <!-- @click="toggleSelectAll(card)"-->
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import diagnosesData from "../data/diagnosis.json";
import omicsData from "../data/omicsdatatypes.json";
import cancertypes from "../data/cancertypes.json";
import materialtypes from "../data/materialtypes.json";
import collectiontypes from "../data/collectiontypes.json";
import datagenerationpipelines from "../data/datagenerationpipelines.json";
import dataanalysismethods from "../data/dataanalysismethods.json";
import experimentalmethods from "../data/experimentalmethods.json";
// import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";
// import { faAngleUp, faAngleDown } from "@fortawesome/free-solid-svg-icons";

let cards = [
  {
    id: "diagnosis",
    title: "Diagnosis",
    isCollapsed: true,
    isRotated: false,
    selectAll: false,
    options: diagnosesData.diagnoses,
  },
  {
    id: "omicsdatatypes",
    title: "Omics Data Types",
    isCollapsed: true,
    isRotated: false,
    selectAll: false,
    options: omicsData,
  },
  {
    id: "cancertypes",
    title: "Cancer Types",
    isCollapsed: true,
    isRotated: false,
    selectAll: false,
    options: cancertypes,
  },
  {
    id: "materialtypes",
    title: "Material types",
    isCollapsed: true,
    isRotated: false,
    selectAll: false,
    options: materialtypes.materialTypes,
  },
  {
    id: "collectiontypes",
    title: "Collection Types",
    isCollapsed: true,
    isRotated: false,
    selectAll: false,
    options: collectiontypes.collectionTypes,
  },
  {
    id: "datagenerationpipelines",
    title: "Data Generation Pipelines",
    isCollapsed: true,
    isRotated: false,
    selectAll: false,
    options: datagenerationpipelines.dataGenerationPipelines,
  },
  {
    id: "dataanalysismethods",
    title: "Data Analysis Methods",
    isCollapsed: true,
    isRotated: false,
    selectAll: false,
    options: dataanalysismethods.dataAnalysisMethods,
  },
  {
    id: "experimentalmethods",
    title: "Experimental Methods",
    isCollapsed: true,
    isRotated: false,
    selectAll: false,
    options: experimentalmethods.experimentalMethods,
  },
];
/*
function toggleCollapse(card) {
  card.isCollapsed = !card.isCollapsed;
  card.isRotated = !card.isRotated;
}*/
/*
function toggleOption(card, option) {
  option.checked = !option.checked;
  this.$emit("toggle-option", { card, option });
}*/

/*function toggleSelectAll(card: any) {
  card.selectAll = !card.selectAll;
  card.options.forEach((option: any) => {
    option.checked = card.selectAll;
    this.$emit("toggle-select-all", card);
  });
}*/
</script>

<style scoped>
.filter-bar {
  display: flex;
  flex-direction: column;
  width: 100%;
  float: right;
  padding-top: 3%;
  text-align: left;
}

.card {
  margin-bottom: 5%;
  border: 1px solid #ccc;
  box-shadow: 0 3px 5px rgba(0, 0, 0, 0.1);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 15px;
  cursor: pointer;
  background-color: #f8f9fa;
}

.title {
  flex-grow: 1;
  margin: 0;
  font-size: 18px;
}

.arrow {
  margin-left: auto;
}

.card-body {
  padding: 15px;
  border-top: none;
  display: flex;
  flex-flow: column;
}

.card-header-closed {
  border-bottom: 1px solid #ccc;
}
</style>
