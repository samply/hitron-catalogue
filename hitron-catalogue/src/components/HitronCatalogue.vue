<template>
  <div>
    <div>
      <h1 style="margin-left: 15%">HI-TRON Mainz Data Portal</h1>
      <!--<ButtonAction @click="plusOne">Test Button{{ count }}</ButtonAction> -->
    </div>
    <br />
    <div style="display: flex; flex-flow: row">
      <!-- LEFT SIDE OF THE PAGE-->
      <div class="col" style="max-width: 30%; padding-left: 15%">
        <SearchBar @search-changed="handleSearchChange" />

        <!-- GLOBALER UNSELECT ALL BUTTON -->
        <div
          v-if="hasAnySelectedFilters"
          style="margin-bottom: 15px; padding-top: 3%"
        >
          <button
            type="button"
            class="btn btn-outline-danger"
            style="
              width: 100%;
              font-size: 14px;
              font-weight: bold;
              border: 2px solid #dc3545;
              color: #dc3545;
              background-color: white;
              padding: 8px 16px;
            "
            @click="unselectAllFilters"
          >
            Clear All Filters
          </button>
        </div>

        <div class="filter-bar">
          <div
            class="filterbarCard"
            v-for="card in cards"
            :key="card.id"
            :class="{ 'filterbarCard-collapsed': card.isCollapsed }"
          >
            <div @click="toggleCollapse(card)" class="filterbarCard-header">
              <div class="filterbarTitle">
                {{ card.title }}
                <!-- BADGE FÜR AKTIVE FILTER -->
                <span
                  v-if="getSelectedOptionsCount(card) > 0"
                  class="badge ms-2"
                  style="
                    background-color: #014c87;
                    color: white;
                    font-size: 11px;
                    padding: 4px 8px;
                    border-radius: 12px;
                    font-weight: bold;
                  "
                >
                  {{ getSelectedOptionsCount(card) }}
                </span>
              </div>
              <div class="filterbarArrow">
                <i v-if="card.isCollapsed" class="fas fa-angle-down"></i>
                <i v-else class="fas fa-angle-up"></i>
              </div>
            </div>
            <div class="filterbarCard-body" v-show="!card.isCollapsed">
              <div
                style="
                  display: flex;
                  flex-flow: row;
                  font-size: 11px;
                  float: right;
                  align-content: flex-end;
                  justify-content: right;
                  width: 90%;
                  padding-left: 10%;
                "
              >
                <div
                  style="
                    margin-right: 7%;
                    width: 100%;
                    display: flex;
                    align-items: center;
                  "
                >
                  <input
                    class="form-check-input"
                    style="border-color: red; background-color: red"
                    type="checkbox"
                    :id="`matchany-${card.id}`"
                    :checked="!card.matchAll"
                    @change="toggleMatchMode(card)"
                  />
                  <label
                    class="form-check-label text-right"
                    :for="`matchany-${card.id}`"
                    style="margin-left: 5px"
                    >Match any</label
                  >
                </div>
                <div
                  style="
                    margin-right: 7%;
                    width: 100%;
                    display: flex;
                    align-items: center;
                  "
                >
                  <input
                    class="form-check-input"
                    style="border-color: red; background-color: red"
                    type="checkbox"
                    :id="`matchall-${card.id}`"
                    :checked="card.matchAll"
                    @change="toggleMatchMode(card)"
                  />
                  <label
                    class="form-check-label text-right"
                    :for="`matchall-${card.id}`"
                    style="margin-left: 5px"
                  >
                    Match all
                  </label>
                </div>
              </div>
              <br />
              <div
                class="form-check"
                v-for="option in card.options"
                :key="option.id"
                style="flex-flow: column"
              >
                <div style="flex-flow: row">
                  <input
                    type="checkbox"
                    :id="`filter-${card.id}-${option.id}`"
                    :checked="option.checked"
                    @change="
                      handleFilterChange(card.id, option.id, option.name)
                    "
                  />
                  <label
                    :for="`filter-${card.id}-${option.id}`"
                    style="margin-left: 5px; font-size: 11px"
                  >
                    {{ option.name }}</label
                  >
                </div>
              </div>
              <div style="font-size: 11px; width: 100%">
                <div>
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
                      font-size: small;
                    "
                    @click="toggleSelectAll(card)"
                  >
                    {{ card.selectAll ? "Unselect all" : "Select all" }}
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- RIGHT SIDE OF THE PAGE-->
      <div class="col" style="min-width: 70%; padding-right: 15%">
        <div
          class="container"
          style="padding-top: 3%; display: flex; flex-flow: column"
        >
          <!-- Start of Paginator and Result Display-->
          <div
            style="
              display: flex;
              flex-flow: row;
              justify-content: space-between;
              margin-left: 3%;
              width: 96.5%;
              margin-bottom: 1%;
            "
          >
            <div
              style="
                display: flex;
                flex-flow: column;
                align-items: flex-start;
                min-width: 10%;
                float: left;
              "
            >
              <p
                style="
                  margin: 0;
                  font-size: 13px;
                  font-family: Arial;
                  font-weight: bold;
                "
              >
                Results
              </p>
              <p style="margin: 0; font-size: 13px; font-family: Arial">
                <!-- FILTERED PROJECTS NUMBER-->
                {{ filteredProjects.length }} Projects
              </p>
            </div>
            <!-- PAGINATOR START-->
            <nav
              aria-label="Page navigation example"
              style="display: flex; align-self: center"
            >
              <ul class="pagination">
                <li class="page-item">
                  <a
                    class="page-link"
                    href="#"
                    aria-label="Previous"
                    style="color: darkgray"
                  >
                    <span aria-hidden="true">&laquo;</span>
                  </a>
                </li>
                <li
                  v-for="pageNumber in pageCount"
                  :key="pageNumber"
                  class="page-item"
                >
                  <a
                    class="page-link"
                    @click="changePage(pageNumber)"
                    :style="
                      pageNumber === currentPage
                        ? 'color: #014c87'
                        : 'color: darkgray'
                    "
                    >{{ pageNumber }}</a
                  >
                </li>
                <li class="page-item">
                  <a
                    class="page-link"
                    href="#"
                    aria-label="Next"
                    style="color: darkgray"
                  >
                    <span aria-hidden="true">&raquo;</span>
                  </a>
                </li>
              </ul>
            </nav>
            <div style="min-width: 10%">
              <button
                class="btn btn-primary"
                type="button"
                style="
                  display: flex;
                  justify-content: right;
                  align-content: right;
                  background-color: #014c87;
                  color: white;
                  border: none;
                "
              >
                <router-link
                  :to="{ name: 'Startpage' }"
                  class="always-white-link"
                  style="color: white !important; text-decoration: none"
                >
                  Back to Start
                </router-link>
              </button>
            </div>
          </div>

          <div v-if="loading">loading...</div>
          <div v-else-if="graphqlError">Error: {{ graphqlError }}</div>

          <!-- Project List of Cards-->
          <div style="margin-bottom: 2%">
            <!-- PAGINIERTE PROJEKTE ANZEIGEN -->
            <div
              v-for="(project, index) in paginatedProjects"
              :key="index"
              class="card"
              style="margin-bottom: 2%; min-height: 220px"
            >
              <div
                class="card-header"
                style="background-color: #014c87; color: white"
              >
                <router-link
                  :to="{ name: 'detailview', params: { id: project.id } }"
                  class="always-white-link"
                  style="color: white !important; text-decoration: none"
                >
                  <h7 class="card-title">{{ project.title }}</h7>
                </router-link>
              </div>
              <div class="card-body">
                <div
                  class="card-description"
                  :style="{
                    display: 'flex',
                    'flex-wrap': 'wrap',
                    gap: '2px',
                    width: '95%',
                    'max-height':
                      showFullAbstract || project.showTags
                        ? 'none'
                        : 'calc(1.8em * 3)',
                    overflow:
                      showFullAbstract || project.showTags ? 'none' : 'hidden',
                    paddingbottom: '3px',
                  }"
                >
                  {{
                    project.showFullAbstract
                      ? project.abstract
                      : truncateText(project.abstract, 50)
                  }}
                </div>

                <div style="display: flex; flex-flow: row">
                  <div
                    class="tag-container"
                    :style="{
                      display: 'flex',
                      'flex-wrap': 'wrap',
                      gap: '4px',
                      width: '75%',
                      'max-height':
                        showAllTags || project.showTags ? 'none' : '45px',
                      overflow:
                        showAllTags || project.showTags ? 'none' : 'hidden',
                    }"
                  >
                    <template
                      v-for="(institution, index) in project.institution"
                    >
                      <div
                        v-if="
                          institution?.acronym !== 'NOT AVAILABLE' &&
                          institution?.acronym !== 'NOT APPLICABLE'
                        "
                        :key="index"
                        class="tag"
                        :class="getTagClass(institution.acronym)"
                      >
                        {{ institution.acronym }}
                      </div>
                    </template>
                    <!-- Tags Cancer Types -->
                    <template
                      v-for="(type, index) in getProjectData(
                        project.id,
                        rowsSampleData,
                        'cancerTypes'
                      )"
                    >
                      <div
                        v-if="
                          type !== 'NOT AVAILABLE' && type !== 'NOT APPLICABLE'
                        "
                        :key="index"
                        class="tag"
                        :class="getTagClass(type)"
                      >
                        {{ type }}
                      </div>
                    </template>
                    <!-- Tags Applied Models -->
                    <template
                      v-for="(model, index) in getProjectData(
                        project.id,
                        rowsSampleData,
                        'appliedModels'
                      )"
                    >
                      <div
                        v-if="
                          model !== 'NOT AVAILABLE' &&
                          model !== 'NOT APPLICABLE'
                        "
                        :key="index"
                        class="tag"
                        :class="getTagClass(model)"
                      >
                        {{ model }}
                      </div>
                    </template>
                    <!-- Tags Applied Biomaterials -->
                    <template
                      v-for="(material, index) in getProjectData(
                        project.id,
                        rowsSampleData,
                        'appliedBiomaterials'
                      )"
                    >
                      <div
                        v-if="
                          material !== 'NOT AVAILABLE' &&
                          material !== 'NOT APPLICABLE'
                        "
                        :key="index"
                        class="tag"
                        :class="getTagClass(material)"
                      >
                        {{ material }}
                      </div>
                    </template>
                    <!-- Tags Applied Diagnosis -->
                    <template>
                      <div
                        v-if="
                          getProjectData(
                            project.id,
                            rowsClinicalData,
                            'appliedDiagnosis'
                          ) !== 'NOT AVAILABLE' &&
                          getProjectData(
                            project.id,
                            rowsClinicalData,
                            'appliedDiagnosis'
                          ) !== 'NOT APPLICABLE'
                        "
                        :key="index"
                        class="tag"
                        :class="
                          getTagClass(
                            getProjectData(
                              project.id,
                              rowsClinicalData,
                              'appliedDiagnosis'
                            )
                          )
                        "
                      >
                        {{
                          getProjectData(
                            project.id,
                            rowsClinicalData,
                            "appliedDiagnosis"
                          )
                        }}
                      </div>
                    </template>
                    <!-- Tags DGP -->
                    <template
                      v-for="(pipeline, index) in getProjectData(
                        project.id,
                        rowsOmicsData,
                        'dataGenerationPipelines'
                      )"
                    >
                      <div
                        v-if="
                          pipeline !== 'NOT AVAILABLE' &&
                          pipeline !== 'NOT APPLICABLE'
                        "
                        :key="index"
                        class="tag"
                        :class="getTagClass(pipeline)"
                      >
                        {{ pipeline }}
                      </div>
                    </template>
                    <!-- Tags Biomarker -->
                    <template
                      v-for="(biomarker, index) in getProjectData(
                        project.id,
                        rowsExperimentalData,
                        'biomarkers'
                      )"
                    >
                      <div
                        v-if="
                          biomarker !== 'NOT AVAILABLE' &&
                          biomarker !== 'NOT APPLICABLE'
                        "
                        :key="index"
                        class="tag"
                        :class="getTagClass(biomarker)"
                      >
                        {{ biomarker }}
                      </div>
                    </template>
                    <!-- Functional Implications -->
                    <template
                      v-for="(implication, index) in getProjectData(
                        project.id,
                        rowsExperimentalData,
                        'functionalImplications'
                      )"
                    >
                      <div
                        v-if="
                          implication !== 'NOT AVAILABLE' &&
                          implication !== 'NOT APPLICABLE'
                        "
                        :key="index"
                        class="tag"
                        :class="getTagClass(implication)"
                      >
                        {{ implication }}
                      </div>
                    </template>
                  </div>
                  <button
                    type="button"
                    style="
                      position: absolute;
                      bottom: 0;
                      right: 0;
                      background: none;
                      border: none;
                      color: #014c87;
                      padding: 2%;
                    "
                    @click="toggleShowTags(project)"
                  >
                    {{ project.showTags ? "Hide" : "Show" }}
                    <font-awesome-icon
                      :icon="
                        project.showTags || project.showFullAbstract
                          ? faArrowUpShortWide
                          : faArrowDownWideShort
                      "
                    />
                  </button>
                </div>
              </div>
            </div>
          </div>
          <!-- Bottom of CardView-->
          <div
            style="
              display: flex;
              flex-flow: row;
              justify-content: space-between;
              margin-left: 3%;
              width: 90%;
              margin-bottom: 1%;
            "
          >
            <div
              style="
                display: flex;
                flex-flow: column;
                align-items: flex-start;
                min-width: 10%;
                float: left;
              "
            ></div>
            <nav aria-label="Page navigation">
              <ul class="pagination">
                <li class="page-item">
                  <a
                    class="page-link"
                    href="#"
                    aria-label="Previous"
                    @click="changePage(currentPage - 1)"
                    style="color: darkgray"
                  >
                    <span aria-hidden="true">&laquo;</span>
                  </a>
                </li>
                <li
                  v-for="pageNumber in pageCount"
                  :key="pageNumber"
                  class="page-item"
                >
                  <a
                    class="page-link"
                    @click="changePage(pageNumber)"
                    :style="
                      pageNumber === currentPage
                        ? 'color: #014c87'
                        : 'color: darkgray'
                    "
                  >
                    {{ pageNumber }}
                  </a>
                </li>
                <li class="page-item">
                  <a
                    class="page-link"
                    href="#"
                    aria-label="Next"
                    @click="changePage(currentPage + 1)"
                    style="color: darkgray"
                  >
                    <span aria-hidden="true">&raquo;</span>
                  </a>
                </li>
              </ul>
            </nav>
            <div style="min-width: 10%"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from "vue";
// import SingleCard from "./SingleCard.vue";
// import FilterBar from "./FilterBar.vue";
import SearchBar from "./SearchBar.vue";
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";
import {
  faAngleUp,
  faAngleDown,
  faArrowDownWideShort,
  faArrowUpShortWide,
} from "@fortawesome/free-solid-svg-icons";
import { request } from "graphql-request";

const currentPage = ref(1);
const itemsPerPage = 6;
const searchQuery = ref("");

const truncateText = (text, wordLimit) => {
  const words = text.split(" ");
  if (words.length > wordLimit) {
    return words.slice(0, wordLimit).join(" ") + "...";
  }
  return text;
};

// GraphQL Queries
const queryProjects = "{Projects{id title abstract institution{acronym}}}";
const queryClinicalMetadata =
  "{ClinicalMetadata {project{id} appliedDiagnosis biobank{name} appliedProcedure }}";
const queryExperimentalMetadata =
  "{ExperimentalMetadata {project{id} experimentalMethods biomarkers functionalImplications}}";
const querySampleMetadata =
  "{SampleMetadata {project{id} appliedModels appliedBiomaterials cancerTypes sampleCollectionCenters}}";
const queryOmicsMetadata =
  "{OmicsMetadata {project{id} sequencingCenter{acronym} dataGenerationPipelines}}";

// Reactive States
const loading = ref(true);
const graphqlError = ref(null);
const rowsProjects = ref([]);
const rowsClinicalData = ref([]);
const rowsExperimentalData = ref([]);
const rowsSampleData = ref([]);
const rowsOmicsData = ref([]);

// Computed property for filtered projects - KORRIGIERT
const filteredProjects = computed(() => {
  if (!rowsProjects.value || rowsProjects.value.length === 0) {
    return [];
  }

  let projects = rowsProjects.value;

  // SCHRITT 1: Text-Suche anwenden
  if (searchQuery.value && searchQuery.value.trim() !== "") {
    const query = searchQuery.value.toLowerCase().trim();
    projects = projects.filter((project) => {
      // Suche in Titel und Abstract
      const titleMatch =
        project.title && project.title.toLowerCase().includes(query);
      const abstractMatch =
        project.abstract && project.abstract.toLowerCase().includes(query);

      // Suche in Institution
      const institutionMatch =
        project.institution &&
        project.institution.some(
          (inst) => inst.acronym && inst.acronym.toLowerCase().includes(query)
        );

      return titleMatch || abstractMatch || institutionMatch;
    });
  }

  // SCHRITT 2: Filter-Kategorien anwenden
  const filtersByCategory = {};
  cards.value.forEach((card) => {
    const selectedOptions = card.options.filter((option) => option.checked);
    if (selectedOptions.length > 0) {
      filtersByCategory[card.id] = {
        values: selectedOptions.map((option) => option.name),
        matchAll: card.matchAll,
      };
    }
  });

  // Wenn keine Filter ausgewählt sind, gib die bereits durch Suche gefilterten Projekte zurück
  if (Object.keys(filtersByCategory).length === 0) {
    return projects;
  }

  // Filter projects: AND zwischen Kategorien
  return projects.filter((project) => {
    // Jede Kategorie muss erfüllt werden (AND)
    return Object.entries(filtersByCategory).every(([cardId, filterConfig]) => {
      const { values, matchAll } = filterConfig;

      if (matchAll) {
        // Match ALL: Alle ausgewählten Filter müssen erfüllt werden
        return values.every((filterValue) => {
          return isProjectMatchingFilter(project.id, cardId, filterValue);
        });
      } else {
        // Match ANY: Mindestens ein ausgewählter Filter muss erfüllt werden
        return values.some((filterValue) => {
          return isProjectMatchingFilter(project.id, cardId, filterValue);
        });
      }
    });
  });
});

// Computed property um zu prüfen, ob irgendwelche Filter ausgewählt sind
const hasAnySelectedFilters = computed(() => {
  return cards.value.some((card) =>
    card.options.some((option) => option.checked)
  );
});

let availableBiomaterials = ref([]);
let availableModels = ref([]);
let availableCancerTypes = ref([]);
let availableBiobanks = ref([]);
let availableDiagnosis = ref([]);
let availableDGP = ref([]);
let availableExperimentalMethods = ref([]);
let availableBiomarker = ref([]);
let availableFunctionalImplications = ref([]);

const getAvailableBiomaterials = () => {
  const biomaterialsSet = new Set();
  rowsSampleData.value.forEach((sample) => {
    sample.appliedBiomaterials.forEach((biomaterial) => {
      if (biomaterial !== "NOT APPLICABLE" && biomaterial !== "NOT AVAILABLE") {
        biomaterialsSet.add(biomaterial);
      }
    });
  });
  return Array.from(biomaterialsSet).map((item, index) => ({
    id: index,
    name: item,
    checked: false,
  }));
};

const getAvailableModels = () => {
  const modelsSet = new Set();
  rowsSampleData.value.forEach((sample) => {
    sample.appliedModels.forEach((model) => {
      if (model !== "NOT APPLICABLE" && model !== "NOT AVAILABLE") {
        modelsSet.add(model);
      }
    });
  });
  return Array.from(modelsSet).map((item, index) => ({
    id: index,
    name: item,
    checked: false,
  }));
};

const getAvailableCancerTypes = () => {
  const cancerTypesSet = new Set();
  rowsSampleData.value.forEach((sample) => {
    sample.cancerTypes.forEach((type) => {
      if (type !== "NOT APPLICABLE" && type !== "NOT AVAILABLE") {
        cancerTypesSet.add(type);
      }
    });
  });
  return Array.from(cancerTypesSet).map((item, index) => ({
    id: index,
    name: item,
    checked: false,
  }));
};

const getAvailableBiobanks = () => {
  const biobankSet = new Set();

  rowsClinicalData.value.forEach((clinicalData) => {
    // Biobank ist ein Array, nicht ein einzelnes Objekt
    if (clinicalData.biobank && Array.isArray(clinicalData.biobank)) {
      clinicalData.biobank.forEach((biobank) => {
        if (
          biobank.name &&
          biobank.name !== "NOT APPLICABLE" &&
          biobank.name !== "NOT AVAILABLE"
        ) {
          biobankSet.add(biobank.name);
        }
      });
    }
  });

  return Array.from(biobankSet).map((item, index) => ({
    id: index,
    name: item,
    checked: false,
  }));
};

const getAvailableDiagnosis = () => {
  const diagnosisSet = new Set();
  rowsClinicalData.value.forEach((clinicalData) => {
    if (
      clinicalData.appliedDiagnosis !== "NOT APPLICABLE" &&
      clinicalData.appliedDiagnosis !== "NOT AVAILABLE"
    ) {
      diagnosisSet.add(clinicalData.appliedDiagnosis);
    }
  });
  return Array.from(diagnosisSet).map((item, index) => ({
    id: index,
    name: item,
    checked: false,
  }));
};

const getAvailableDGP = () => {
  const dgpSet = new Set();
  rowsOmicsData.value.forEach((omicsData) => {
    omicsData.dataGenerationPipelines.forEach((dgp) => {
      if (dgp !== "NOT APPLICABLE" && dgp !== "NOT AVAILABLE") {
        dgpSet.add(dgp);
      }
    });
  });
  return Array.from(dgpSet).map((item, index) => ({
    id: index,
    name: item,
    checked: false,
  }));
};

const getAvailableExperimentalMethods = () => {
  const methodsSet = new Set();
  rowsExperimentalData.value.forEach((experimentalData) => {
    experimentalData.experimentalMethods.forEach((method) => {
      if (method !== "NOT APPLICABLE" && method !== "NOT AVAILABLE") {
        methodsSet.add(method);
      }
    });
  });
  return Array.from(methodsSet).map((item, index) => ({
    id: index,
    name: item,
    checked: false,
  }));
};
const getAvailableBiomarker = () => {
  const biomarkerSet = new Set();
  rowsExperimentalData.value.forEach((experimentalData) => {
    experimentalData.biomarkers.forEach((biomarker) => {
      if (biomarker !== "NOT APPLICABLE" && biomarker !== "NOT AVAILABLE") {
        biomarkerSet.add(biomarker);
      }
    });
  });
  return Array.from(biomarkerSet).map((item, index) => ({
    id: index,
    name: item,
    checked: false,
  }));
};

const getAvailableFunctionalImplications = () => {
  const implicationsSet = new Set();
  rowsExperimentalData.value.forEach((experimentalData) => {
    experimentalData.functionalImplications.forEach((implication) => {
      if (implication !== "NOT APPLICABLE" && implication !== "NOT AVAILABLE") {
        implicationsSet.add(implication);
      }
    });
  });
  return Array.from(implicationsSet).map((item, index) => ({
    id: index,
    name: item,
    checked: false,
  }));
};

// Fetch Data
async function fetchData() {
  try {
    const [projectData, clinicalData, experimentalData, sampleData, omicsData] =
      await Promise.all([
        request("graphql", queryProjects),
        request("graphql", queryClinicalMetadata),
        request("graphql", queryExperimentalMetadata),
        request("graphql", querySampleMetadata),
        request("graphql", queryOmicsMetadata),
      ]);

    rowsProjects.value = projectData.Projects;
    rowsClinicalData.value = clinicalData.ClinicalMetadata;
    rowsExperimentalData.value = experimentalData.ExperimentalMetadata;
    rowsSampleData.value = sampleData.SampleMetadata;
    rowsOmicsData.value = omicsData.OmicsMetadata;

    availableBiomaterials.value = getAvailableBiomaterials();
    availableModels.value = getAvailableModels();
    availableCancerTypes.value = getAvailableCancerTypes();
    availableBiobanks.value = getAvailableBiobanks();
    availableDiagnosis.value = getAvailableDiagnosis();
    availableDGP.value = getAvailableDGP();
    availableExperimentalMethods.value = getAvailableExperimentalMethods();
    availableBiomarker.value = getAvailableBiomarker();
    availableFunctionalImplications.value =
      getAvailableFunctionalImplications();

    // Filter projects after data is fetched

    cards.value[0].options = availableBiomaterials.value;
    cards.value[1].options = availableCancerTypes.value;
    cards.value[2].options = availableBiobanks.value;
    cards.value[3].options = availableModels.value;
    cards.value[4].options = availableDiagnosis.value;
    cards.value[5].options = availableDGP.value;
    cards.value[6].options = availableExperimentalMethods.value;
    cards.value[7].options = availableBiomarker.value;
    cards.value[8].options = availableFunctionalImplications.value;

    loading.value = false;
  } catch (error) {
    graphqlError.value = error;
    loading.value = false;
  }
}

fetchData();

// Filter Cards Setup - KORRIGIERT mit matchAll Property
let cards = ref([
  {
    id: "materialtypes",
    title: "Biomaterials",
    isCollapsed: true,
    selectAll: false,
    matchAll: false, // NEU HINZUGEFÜGT
    options: [],
  },
  {
    id: "cancertypes",
    title: "Cancer Types",
    isCollapsed: true,
    selectAll: false,
    matchAll: false, // NEU HINZUGEFÜGT
    options: [],
  },
  {
    id: "biobank",
    title: "Biobank",
    isCollapsed: true,
    selectAll: false,
    matchAll: false, // NEU HINZUGEFÜGT
    options: [],
  },
  {
    id: "models",
    title: "Models",
    isCollapsed: true,
    selectAll: false,
    matchAll: false, // NEU HINZUGEFÜGT
    options: [],
  },
  {
    id: "diagnosis",
    title: "Diagnosis",
    isCollapsed: true,
    selectAll: false,
    matchAll: false, // NEU HINZUGEFÜGT
    options: [],
  },
  {
    id: "dgp",
    title: "Data Generation Pipelines (DGP)",
    isCollapsed: true,
    selectAll: false,
    matchAll: false, // NEU HINZUGEFÜGT
    options: [],
  },
  {
    id: "experimentalMethods",
    title: "Experimental Methods",
    isCollapsed: true,
    selectAll: false,
    matchAll: false, // NEU HINZUGEFÜGT
    options: [],
  },
  {
    id: "biomarker",
    title: "Biomarkers",
    isCollapsed: true,
    selectAll: false,
    matchAll: false, // NEU HINZUGEFÜGT
    options: [],
  },
  {
    id: "functionalImplications",
    title: "Functional Implications",
    isCollapsed: true,
    selectAll: false,
    matchAll: false, // NEU HINZUGEFÜGT
    options: [],
  },
]);

// NEU HINZUGEFÜGT: Funktion für Match any/Match all Toggle
const toggleMatchMode = (card) => {
  card.matchAll = !card.matchAll;
};

// NEU HINZUGEFÜGT: Funktion für Filteränderungen
function handleFilterChange(cardId, optionId) {
  // Stelle sicher, dass du auf das reaktive `cards.value` zugreifst
  if (!Array.isArray(cards.value)) {
    console.error("cards ist kein Array:", cards.value);
    return;
  }

  // Suchen der passenden Karte
  const card = cards.value.find((c) => c.id === cardId);

  if (!card || !Array.isArray(card.options)) {
    console.error("Optionen wurden nicht gefunden oder sind kein Array.");
    return;
  }

  // Suchen der passenden Option in der Karte
  const option = card.options.find((o) => o.id === optionId);

  if (option) {
    option.checked = !option.checked; // Den Zustand der Option umschalten

    // Die Filterung erfolgt automatisch durch die computed property
  } else {
    console.error("Option wurde nicht gefunden.");
  }
}

// Pagination
const paginatedProjects = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  const end = start + itemsPerPage;
  return filteredProjects.value.slice(start, end);
});

const pageCount = computed(() => {
  return Math.ceil(filteredProjects.value.length / itemsPerPage);
});

const changePage = (pageNumber) => {
  if (pageNumber >= 1 && pageNumber <= pageCount.value) {
    currentPage.value = pageNumber;
  }
};

// Toggle Functions
const toggleSelectAll = (card) => {
  card.selectAll = !card.selectAll;
  card.options.forEach((option) => {
    option.checked = card.selectAll;
  });
};

// NEUE FUNKTION: Alle Filter in allen Kategorien zurücksetzen
const unselectAllFilters = () => {
  cards.value.forEach((card) => {
    card.selectAll = false;
    card.options.forEach((option) => {
      option.checked = false;
    });
  });
  // Setze auch die aktuelle Seite zurück auf 1
  currentPage.value = 1;
};

// NEUE FUNKTION: Anzahl der ausgewählten Optionen für eine Karte zählen
const getSelectedOptionsCount = (card) => {
  return card.options.filter((option) => option.checked).length;
};

// NEUE FUNKTION: Suchänderungen behandeln
const handleSearchChange = (query) => {
  searchQuery.value = query;
  // Setze die aktuelle Seite zurück auf 1 bei neuer Suche
  currentPage.value = 1;
};

const openCardId = ref(null);

const toggleCollapse = (card) => {
  if (openCardId.value === card.id) {
    openCardId.value = null;
  } else {
    openCardId.value = card.id;
  }
  cards.value.forEach((c) => {
    c.isCollapsed = c.id !== openCardId.value;
  });
};

// Project Data Helper Functions
const getProjectData = (projectId, dataArray, field) => {
  if (!Array.isArray(dataArray)) return [];

  const matchingRow = dataArray.find(
    (row) => row.project && row.project.id === projectId
  );

  if (matchingRow && matchingRow[field]) {
    if (Array.isArray(matchingRow[field])) {
      return matchingRow[field];
    } else {
      return [matchingRow[field]];
    }
  }

  return [];
};

// Tag Class Function
const getTagClass = (tagName) => {
  // Sicherheitscheck für tagName
  if (!tagName || typeof tagName !== "string") {
    return "other-tag";
  }

  // Definiere hier die Logik für die Tag-Klassen
  const datasetTags = ["TRON", "DKFZ", "UMM", "Breast Cancer", "Lung Cancer"];

  if (
    datasetTags.some((tag) => tagName.toLowerCase().includes(tag.toLowerCase()))
  ) {
    return "dataset-tag";
  }
  return "other-tag";
};

// Show/Hide Tags Functions
const showFullAbstract = ref(false);
const showAllTags = ref(false);

const toggleShowTags = (project) => {
  // Stelle sicher, dass das Projekt die notwendigen Properties hat
  if (!project.showTags) {
    project.showTags = false;
  }
  if (!project.showFullAbstract) {
    project.showFullAbstract = false;
  }

  project.showTags = !project.showTags;
  project.showFullAbstract = !project.showFullAbstract;
};

// Helper function to check if a project matches a specific filter
function isProjectMatchingFilter(projectId, cardId, filterValue) {
  switch (cardId) {
    case "materialtypes":
      return isMatchingInTable(
        projectId,
        rowsSampleData.value,
        filterValue,
        "appliedBiomaterials"
      );
    case "cancertypes":
      return isMatchingInTable(
        projectId,
        rowsSampleData.value,
        filterValue,
        "cancerTypes"
      );
    case "biobank":
      // SPEZIELLE BEHANDLUNG FÜR BIOBANK
      return isMatchingInTableBiobank(
        projectId,
        rowsClinicalData.value,
        filterValue
      );
    case "models":
      return isMatchingInTable(
        projectId,
        rowsSampleData.value,
        filterValue,
        "appliedModels"
      );
    case "diagnosis":
      return isMatchingInTable(
        projectId,
        rowsClinicalData.value,
        filterValue,
        "appliedDiagnosis"
      );
    case "dgp":
      return isMatchingInTable(
        projectId,
        rowsOmicsData.value,
        filterValue,
        "dataGenerationPipelines"
      );
    case "experimentalMethods":
      return isMatchingInTable(
        projectId,
        rowsExperimentalData.value,
        filterValue,
        "experimentalMethods"
      );
    case "biomarker":
      return isMatchingInTable(
        projectId,
        rowsExperimentalData.value,
        filterValue,
        "biomarkers"
      );
    case "functionalImplications":
      return isMatchingInTable(
        projectId,
        rowsExperimentalData.value,
        filterValue,
        "functionalImplications"
      );
    default:
      return false;
  }
}

// NEUE FUNKTION FÜR BIOBANK-MATCHING
function isMatchingInTableBiobank(projectId, table, filterValue) {
  if (!Array.isArray(table)) return false;

  const matchingRow = table.find(
    (row) => row.project && row.project.id === projectId
  );

  if (
    matchingRow &&
    matchingRow.biobank &&
    Array.isArray(matchingRow.biobank)
  ) {
    // Biobank ist ein Array, durchsuche alle Einträge
    return matchingRow.biobank.some(
      (biobank) => biobank.name && biobank.name === filterValue
    );
  }

  return false;
}

// ALLGEMEINE FUNKTION FÜR TABLE-MATCHING
function isMatchingInTable(projectId, table, filterValue, fieldName) {
  if (!Array.isArray(table)) return false;

  const matchingRow = table.find(
    (row) => row.project && row.project.id === projectId
  );

  if (matchingRow && matchingRow[fieldName]) {
    // Wenn das Feld ein Array ist
    if (Array.isArray(matchingRow[fieldName])) {
      return matchingRow[fieldName].includes(filterValue);
    } else {
      // Wenn das Feld ein einzelner Wert ist
      return matchingRow[fieldName] === filterValue;
    }
  }

  return false;
}
</script>

<style scoped>
.tag-container {
  padding-top: 1%;
  display: flex;
  flex-wrap: wrap; /* Erlaubt Umbruch der Tags */
  gap: 5px; /* Abstand zwischen den Tags */
  width: 75%;
}

.tag {
  white-space: nowrap;
  margin-right: 4px;
  margin-bottom: 4px;
  padding: 5px 15px;
  font-weight: 300;
  font-size: 13px;
  font-family: "Inter", sans-serif;
  border-radius: 5px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  background-color: #f8f9fa;
}

.dataset-tag {
  background-color: #cbe9ff;
  border: 1px solid #61abe1;
  color: #014c87;
}

.other-tag {
  background-color: #ebebeb;
  border: 1px solid #cecece;
  color: #333333;
}

.filter-bar {
  display: flex;
  flex-direction: column;
  width: 100%;
  float: right;
  padding-top: 3%;
  text-align: left;
}

.filterbarCard {
  margin-bottom: 5%;
  border: 1px solid #ccc;
  box-shadow: 0 3px 5px rgba(0, 0, 0, 0.1);
}

.filterbarCard-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 15px;
  cursor: pointer;
  background-color: white;
}

.filterbarTitle {
  flex-grow: 1;
  margin: 0;
  font-size: 16px;
}

.filterbarArrow {
  margin-left: auto;
}

.filterbarCard-body {
  padding: 15px;
  border-top: none;
  display: flex;
  flex-flow: column;
  background-color: white;
}

.filterbarCard-header-closed {
  border-bottom: 1px solid #ccc;
}

.card-description {
  overflow: hidden;
  text-overflow: ellipsis;
  transition: max-height 0.5s ease-out;
}

.always-white-link {
  color: white !important;
  text-decoration: none;
}
.always-white-link:hover {
  color: white !important;
}
</style>
