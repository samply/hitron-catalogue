<template>
  <div>
    <div v-if="loading">loading...</div>
    <div v-else-if="graphqlError">Error: {{ graphqlError }}</div>
    <div v-else>
      <div class="card" style="margin: 2% 15% 0% 15%; width: 70%">
        <div class="card-body">
          <div class="row">
            <div class="col-6" style="display: flex; align-items: center">
              <router-link style="text-decoration: none" to="/Catalogue">
                <p style="padding-right: 8px">Back to the catalog/</p>
              </router-link>
              <p style="width: auto; padding-right: 8px">Detail-View/</p>
              <p style="width: auto; padding-right: 8px">{{ project.id }}</p>
            </div>
            <div class="col-6">
              <button type="button" class="btn btn-danger" style="float: right">
                Request Data
              </button>
            </div>
          </div>
        </div>
      </div>
      <!--AB HIER DIV KONTROLLIEREN-->
      <!-- REIHE STARTEN ZWEI ELEMENTE MÜSSEN DRIN SEIN-->
      <div class="row" style="margin: 0.5% 0% 0% 15%; width: 70%; padding: 0%">
        <!--ELEMENT EINS ALS COL-->
        <div
          class="col-9"
          style="padding: 0; display: flex; flex-direction: column"
        >
          <div class="card" style="margin: 0; width: 100%; height: auto">
            <div class="card-body">
              <div class="col">
                <p class="title-text">{{ project.title }}</p>
                <br />
                <div
                  class="tag-container"
                  style="display: flex; flex-wrap: wrap; gap: 4px"
                >
                  <!-- Tags Institutions -->
                  <template v-for="(institution, index) in project.institution">
                    <div
                      v-if="
                        institution?.acronym !== 'NOT AVAILABLE' &&
                        institution?.acronym !== 'NOT APPLICABLE'
                      "
                      :key="index"
                      class="tag"
                      :class="getTagClass(institution?.acronym)"
                    >
                      {{ institution?.acronym }}
                    </div>
                  </template>
                  <!-- Tags Cancer Types -->
                  <template v-for="(type, index) in sampleData.cancerTypes">
                    <div
                      v-if="
                        type !== 'NOT AVAILABLE' && type !== 'NOT APPLICABLE'
                      "
                      :key="index"
                      class="tag"
                      :class="getTagClass(sampleData?.cancerTypes)"
                    >
                      {{ type }}
                    </div>
                  </template>
                  <!-- Tags Applied Models -->
                  <template v-for="(model, index) in sampleData.appliedModels">
                    <div
                      v-if="
                        model !== 'NOT AVAILABLE' && model !== 'NOT APPLICABLE'
                      "
                      :key="index"
                      class="tag"
                      :class="getTagClass(sampleData?.appliedModels)"
                    >
                      {{ model }}
                    </div>
                  </template>
                  <!-- Tags Applied Biomaterials -->
                  <template
                    v-for="(material, index) in sampleData.appliedBiomaterials"
                  >
                    <div
                      v-if="
                        material !== 'NOT AVAILABLE' &&
                        material !== 'NOT APPLICABLE'
                      "
                      :key="index"
                      class="tag"
                      :class="getTagClass(sampleData?.appliedBiomaterials)"
                    >
                      {{ material }}
                    </div>
                  </template>
                  <!-- Tags Applied Diagnosis -->
                  <template>
                    <div
                      v-if="
                        clinicalData.appliedDiagnosis !== 'NOT AVAILABLE' &&
                        clinicalData.appliedDiagnosis !== 'NOT APPLICABLE'
                      "
                      :key="index"
                      class="tag"
                      :class="getTagClass(clinicalData?.appliedDiagnosis)"
                    >
                      {{ clinicalData.appliedDiagnosis }}
                    </div>
                  </template>
                  <!-- Tags DGP -->
                  <template
                    v-for="(
                      pipeline, index
                    ) in omicsData.dataGenerationPipelines"
                  >
                    <div
                      v-if="
                        pipeline !== 'NOT AVAILABLE' &&
                        pipeline !== 'NOT APPLICABLE'
                      "
                      :key="index"
                      class="tag"
                      :class="getTagClass(omicsData?.dataGenerationPipelines)"
                    >
                      {{ pipeline }}
                    </div>
                  </template>
                  <!-- Tags Biomarker -->
                  <template
                    v-for="(biomarker, index) in experimentalData.biomarkers"
                  >
                    <div
                      v-if="
                        biomarker !== 'NOT AVAILABLE' &&
                        biomarker !== 'NOT APPLICABLE'
                      "
                      :key="index"
                      class="tag"
                      :class="getTagClass(experimentalData.biomarkers)"
                    >
                      {{ biomarker }}
                    </div>
                  </template>
                  <!-- Functional Implications-->
                  <template
                    v-for="(
                      implication, index
                    ) in experimentalData.functionalImplications"
                  >
                    <div
                      v-if="
                        implication !== 'NOT AVAILABLE' &&
                        implication !== 'NOT APPLICABLE'
                      "
                      :key="index"
                      class="tag"
                      :class="
                        getTagClass(experimentalData?.functionalImplications)
                      "
                    >
                      {{ implication }}
                    </div>
                  </template>
                </div>
              </div>
            </div>
          </div>
          <div
            class="card abstract-card"
            style="margin: 0.5% 0 0 0; width: 100%; flex: 1; display: flex"
          >
            <div
              class="card-body"
              style="display: flex; flex-direction: column; flex: 1"
            >
              <div
                class="col"
                style="display: flex; flex-direction: column; flex: 1"
              >
                <p class="title-text">Abstract</p>
                <p style="flex: 1">{{ project.abstract }}</p>
              </div>
            </div>
          </div>
        </div>
        <!-- ZWEITES ELEMENT FÜR COL-->
        <div class="col-3" style="padding: 0 0 0 0.3%; min-height: 100%">
          <div class="card" style="margin: 0; width: 100%; min-height: 100%">
            <div class="card-body">
              <div style="flex-flow: column">
                <p style="display: flex" class="title-text">
                  Contact Information
                </p>
                <div
                  style="display: flex; flex-flow: column; padding-bottom: 4%"
                >
                  <div v-for="(data, index) in project.division" :key="index">
                    <a style="color: #4d6fa0" :href="data.website">
                      <strong>{{ data.fullname }}</strong>
                    </a>
                    <p
                      v-for="(context, index) in data.address"
                      :key="index"
                      style="padding: 0; margin: 0"
                    >
                      {{ context }}
                    </p>
                  </div>
                </div>
                <div
                  style="display: flex; flex-flow: column; padding-bottom: 4%"
                >
                  <p style="padding: 0; margin: 0">
                    <strong>Principal Investigator (PI)</strong>
                  </p>
                  <p
                    v-for="(pi, index) in project.pi"
                    :key="index"
                    style="padding: 0; margin: 0"
                  >
                    {{ pi }}
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- ENDEEE-->

      <!-- DATA VISUALIZATION CARD -->
      <div class="card" style="margin: 0.5% 0% 0% 15%; width: 70%">
        <div class="card-body">
          <div class="row">
            <p class="title-text">
              <font-awesome-icon
                :icon="faChartPie"
                style="margin-right: 20px"
              />
              Data Overview
            </p>
          </div>
          <div class="row" style="padding: 20px 0">
            <!-- Patients Pie Chart -->
            <div class="col-4 text-center">
              <div class="pie-chart-container">
                <div
                  class="pie-chart patients-chart"
                  :class="{
                    'empty-chart': isDataEmpty(clinicalData.numberOfPatients),
                  }"
                >
                  <div class="pie-chart-inner">
                    <span class="pie-chart-number">{{
                      getDisplayValue(clinicalData.numberOfPatients)
                    }}</span>
                    <span class="pie-chart-label">Patients</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- Samples Pie Chart -->
            <div class="col-4 text-center">
              <div class="pie-chart-container">
                <div
                  class="pie-chart samples-chart"
                  :class="{
                    'empty-chart': isDataEmpty(sampleData.numberOfSamples),
                  }"
                >
                  <div class="pie-chart-inner">
                    <span class="pie-chart-number">{{
                      getDisplayValue(sampleData.numberOfSamples)
                    }}</span>
                    <span class="pie-chart-label">Samples</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- Experiments Pie Chart -->
            <div class="col-4 text-center">
              <div class="pie-chart-container">
                <div
                  class="pie-chart experiments-chart"
                  :class="{
                    'empty-chart': isDataEmpty(
                      experimentalData.numberOfExperiments
                    ),
                  }"
                >
                  <div class="pie-chart-inner">
                    <span class="pie-chart-number">{{
                      getDisplayValue(experimentalData.numberOfExperiments)
                    }}</span>
                    <span class="pie-chart-label">Experiments</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div
        style="
          margin: 0.5% 0% 0% 15%;
          width: 70%;
          border-radius: 5px 5px 0px 0px;
        "
      >
        <ul
          class="nav nav-tabs"
          id="myTab"
          role="tablist"
          style="border-radius: 5px 5px 0px 0px; background-color: #014c87"
        >
          <li class="nav-item" role="presentation">
            <button
              class="nav-link"
              :class="{ active: selectedTab === 'clinicalData' }"
              id="clinicalData-tab"
              data-bs-toggle="tab"
              data-bs-target="#clinicalData"
              type="button"
              role="tab"
              aria-controls="clinicalData"
              @click="selectTab('clinicalData')"
            >
              Clinical Data
            </button>
          </li>
          <li class="nav-item" role="presentation">
            <button
              class="nav-link"
              :class="{ active: selectedTab === 'experimentalData' }"
              id="experimentalData-tab"
              data-bs-toggle="tab"
              data-bs-target="#experimentalData"
              type="button"
              role="tab"
              aria-controls="experimentalData"
              @click="selectTab('experimentalData')"
            >
              Experimental Data
            </button>
          </li>
          <li class="nav-item" role="presentation">
            <button
              class="nav-link"
              :class="{ active: selectedTab === 'sampleData' }"
              id="sampleData-tab"
              data-bs-toggle="tab"
              data-bs-target="#sampleData"
              type="button"
              role="tab"
              aria-controls="sampleData"
              @click="selectTab('sampleData')"
            >
              (Bio-)Samples
            </button>
          </li>
          <li class="nav-item" role="presentation">
            <button
              class="nav-link"
              :class="{ active: selectedTab === 'omicsData' }"
              id="omicsData-tab"
              data-bs-toggle="tab"
              data-bs-target="#omicsData"
              type="button"
              role="tab"
              aria-controls="omicsData"
              @click="selectTab('omicsData')"
            >
              Omics Data
            </button>
          </li>
          <li class="nav-item" role="presentation">
            <button
              class="nav-link"
              :class="{ active: selectedTab === 'publications' }"
              id="publications-tab"
              data-bs-toggle="tab"
              data-bs-target="#publications"
              type="button"
              role="tab"
              aria-controls="publications"
              @click="selectTab('publications')"
            >
              Publications
            </button>
          </li>
          <li class="nav-item" role="presentation">
            <button
              class="nav-link"
              :class="{ active: selectedTab === 'collaborators' }"
              id="collaborators-tab"
              data-bs-toggle="tab"
              data-bs-target="#collaborators"
              type="button"
              role="tab"
              aria-controls="collaborators"
              @click="selectTab('collaborators')"
            >
              Collaborators
            </button>
          </li>
        </ul>
      </div>

      <!-- Begin of first Row-->

      <!-- CLINICAL DATA CARD-->
      <div
        v-if="selectedTab === 'clinicalData'"
        class="tab-pane fade show active"
        id="clinicalData"
        role="tabpanel"
        aria-labelledby="clinicalData-tab"
        style="margin: 0% 0% 0% 15%; width: 70%"
      >
        <div class="card" style="border-radius: 0px 0px 5px 5px">
          <div class="card-body">
            <div class="row">
              <p class="title-text">
                <font-awesome-icon
                  :icon="faHouseChimneyMedical"
                  style="margin-right: 20px"
                />
                Clinical Data
              </p>
            </div>
            <div style="padding-left: 3%">
              <table style="width: 100%; border-collapse: collapse">
                <tr style="padding-bottom: 20%">
                  <td style="padding: 8px; width: 25%">Number of Patients</td>
                  <td style="padding: 8px; width: 5%">
                    <div class="tooltip-container">
                      <font-awesome-icon
                        :icon="faQuestionCircle"
                        @mouseover="showTooltip = true"
                        @mouseleave="showTooltip = false"
                      />
                      <div v-show="showTooltip" class="tooltip-text">
                        Number of patients in the study
                      </div>
                    </div>
                  </td>
                  <td style="padding: 8px">
                    {{ clinicalData.numberOfPatients }}
                  </td>
                </tr>
                <tr style="padding-bottom: 20%">
                  <td style="padding: 8px; width: 25%">Demographics</td>
                  <td style="padding: 8px; width: 5%">
                    <font-awesome-icon :icon="faQuestionCircle" />
                  </td>
                  <td style="padding: 8px">
                    <span
                      v-for="(demographic, index) in clinicalData.demographics"
                      :key="index"
                    >
                      {{ demographic
                      }}<span
                        v-if="index < clinicalData.demographics.length - 1"
                        >,
                      </span>
                    </span>
                  </td>
                </tr>
                <tr style="padding-bottom: 20%">
                  <td style="padding: 8px; width: 25%">Applied Diagnosis</td>
                  <td style="padding: 8px; width: 5%">
                    <font-awesome-icon :icon="faQuestionCircle" />
                  </td>
                  <td style="padding: 8px">
                    {{ clinicalData.appliedDiagnosis }}
                  </td>
                </tr>
                <tr style="padding-bottom: 20%">
                  <td style="padding: 8px; width: 25%">Applied Procedure</td>
                  <td style="padding: 8px; width: 5%">
                    <font-awesome-icon :icon="faQuestionCircle" />
                  </td>
                  <td style="padding: 8px">
                    <span
                      v-for="(
                        procedure, index
                      ) in clinicalData.appliedProcedure"
                      :key="index"
                    >
                      {{ procedure
                      }}<span
                        v-if="index < clinicalData.appliedProcedure.length - 1"
                        >,
                      </span>
                    </span>
                  </td>
                </tr>
                <tr style="padding-bottom: 20%">
                  <td style="padding: 8px; width: 25%">Biobank</td>
                  <td style="padding: 8px; width: 5%">
                    <font-awesome-icon :icon="faQuestionCircle" />
                  </td>
                  <td style="padding: 8px">
                    <span
                      v-for="(item, index) in clinicalData.biobank"
                      :key="index"
                    >
                      {{ item.name
                      }}<span v-if="index < clinicalData.biobank.length - 1"
                        >,
                      </span>
                    </span>
                  </td>
                </tr>
                <tr style="padding-bottom: 20%">
                  <td style="padding: 8px; width: 25%">Biosample Types</td>
                  <td style="padding: 8px; width: 5%">
                    <font-awesome-icon :icon="faQuestionCircle" />
                  </td>
                  <td style="padding: 8px">
                    <span
                      v-for="(biosample, index) in clinicalData.biosampleTypes"
                      :key="index"
                    >
                      {{ biosample
                      }}<span
                        v-if="index < clinicalData.biosampleTypes.length - 1"
                        >,
                      </span>
                    </span>
                  </td>
                </tr>
                <tr style="padding-bottom: 20%">
                  <td style="padding: 8px; width: 25%">Lab Tests</td>
                  <td style="padding: 8px; width: 5%">
                    <font-awesome-icon :icon="faQuestionCircle" />
                  </td>
                  <td style="padding: 8px">
                    <span
                      v-for="(labTest, index) in clinicalData.labTests"
                      :key="index"
                    >
                      {{ labTest
                      }}<span v-if="index < clinicalData.labTests.length - 1"
                        >,
                      </span>
                    </span>
                  </td>
                </tr>
                <tr style="padding-bottom: 20%">
                  <td style="padding: 8px; width: 25%">Informed Consent</td>
                  <td style="padding: 8px; width: 5%">
                    <font-awesome-icon :icon="faQuestionCircle" />
                  </td>
                  <td style="padding: 8px">
                    {{ clinicalData.informedConsent }}
                  </td>
                </tr>
                <tr style="padding-bottom: 5%">
                  <td style="padding: 8px; width: 25%">
                    Ethical Consideration
                  </td>
                  <td style="padding: 8px; width: 10%">
                    <font-awesome-icon :icon="faQuestionCircle" />
                  </td>
                  <td style="padding: 8px">
                    {{ clinicalData.ethicalConsideration }}
                  </td>
                </tr>
              </table>
            </div>
          </div>
        </div>
      </div>

      <!-- END OF TABNAV-->
      <!-- EXPERIMENTAL DATA CARD-->
      <!-- EXPERIMENTAL DATA CARD-->
      <div
        v-if="selectedTab === 'experimentalData'"
        class="tab-pane fade show active"
        id="experimentalData"
        role="tabpanel"
        aria-labelledby="experimentalData-tab"
        style="margin: 0% 0% 0% 15%; width: 70%"
      >
        <div class="card" style="border-radius: 0px 0px 5px 5px">
          <div class="card-body">
            <div class="row">
              <p class="title-text">
                <font-awesome-icon
                  :icon="faFlask"
                  style="margin-right: 20px"
                />Experimental Data
              </p>
            </div>
            <div style="padding-left: 3%">
              <table style="width: 100%; border-collapse: collapse">
                <tr style="padding-bottom: 5%">
                  <td style="padding: 8px; width: 25%">
                    Number of Experiments
                  </td>
                  <td style="padding: 8px; width: 10%">
                    <font-awesome-icon :icon="faQuestionCircle" />
                  </td>
                  <td style="padding: 8px">
                    {{ experimentalData.numberOfExperiments }}
                  </td>
                </tr>
                <tr style="padding-bottom: 20%">
                  <td style="padding: 8px; width: 25%">Experimental Methods</td>
                  <td style="padding: 8px; width: 5%">
                    <font-awesome-icon :icon="faQuestionCircle" />
                  </td>
                  <td style="padding: 8px">
                    <span
                      v-for="(
                        method, index
                      ) in experimentalData.experimentalMethods"
                      :key="index"
                    >
                      {{ method
                      }}<span
                        v-if="
                          index <
                          experimentalData.experimentalMethods.length - 1
                        "
                        >,
                      </span>
                    </span>
                  </td>
                </tr>
                <tr style="padding-bottom: 20%">
                  <td style="padding: 8px; width: 25%">
                    Biological Replicates
                  </td>
                  <td style="padding: 8px; width: 5%">
                    <font-awesome-icon :icon="faQuestionCircle" />
                  </td>
                  <td style="padding: 8px">
                    <span
                      v-for="(
                        replica, index
                      ) in experimentalData.biologicalReplicates"
                      :key="index"
                    >
                      {{ replica
                      }}<span
                        v-if="
                          index <
                          experimentalData.biologicalReplicates.length - 1
                        "
                        >,
                      </span>
                    </span>
                  </td>
                </tr>
                <tr style="padding-bottom: 20%">
                  <td style="padding: 8px; width: 25%">Technical Replicates</td>
                  <td style="padding: 8px; width: 5%">
                    <font-awesome-icon :icon="faQuestionCircle" />
                  </td>
                  <td style="padding: 8px">
                    <span
                      v-for="(
                        replica, index
                      ) in experimentalData.technicalReplicates"
                      :key="index"
                    >
                      {{ replica
                      }}<span
                        v-if="
                          index <
                          experimentalData.technicalReplicates.length - 1
                        "
                        >,
                      </span>
                    </span>
                  </td>
                </tr>
                <tr style="padding-bottom: 520%">
                  <td style="padding: 8px; width: 25%">
                    Models or Platforms used
                  </td>
                  <td style="padding: 8px; width: 5%">
                    <font-awesome-icon :icon="faQuestionCircle" />
                  </td>
                  <td style="padding: 8px">
                    <span
                      v-for="(
                        model, index
                      ) in experimentalData.modelsOrPlatformsUsed"
                      :key="index"
                    >
                      {{ model
                      }}<span
                        v-if="
                          index <
                          experimentalData.modelsOrPlatformsUsed.length - 1
                        "
                        >,
                      </span>
                    </span>
                  </td>
                </tr>
                <tr style="padding-bottom: 20%">
                  <td style="padding: 8px; width: 25%">Small Molecules used</td>
                  <td style="padding: 8px; width: 5%">
                    <font-awesome-icon :icon="faQuestionCircle" />
                  </td>
                  <td style="padding: 8px">
                    <span
                      v-for="(
                        molecule, index
                      ) in experimentalData.smallMoleculesUsed"
                      :key="index"
                    >
                      {{ molecule
                      }}<span
                        v-if="
                          index < experimentalData.smallMoleculesUsed.length - 1
                        "
                        >,
                      </span>
                    </span>
                  </td>
                </tr>
                <tr style="padding-bottom: 20%">
                  <td style="padding: 8px; width: 25%">Biomarkers</td>
                  <td style="padding: 8px; width: 5%">
                    <font-awesome-icon :icon="faQuestionCircle" />
                  </td>
                  <td style="padding: 8px">
                    <span
                      v-for="(biomarker, index) in experimentalData.biomarkers"
                      :key="index"
                    >
                      {{ biomarker
                      }}<span
                        v-if="index < experimentalData.biomarkers.length - 1"
                        >,
                      </span>
                    </span>
                  </td>
                </tr>
                <tr style="padding-bottom: 20%">
                  <td style="padding: 8px; width: 25%">
                    Functional Implications
                  </td>
                  <td style="padding: 8px; width: 5%">
                    <font-awesome-icon :icon="faQuestionCircle" />
                  </td>
                  <td style="padding: 8px">
                    <span
                      v-for="(
                        implication, index
                      ) in experimentalData.functionalImplications"
                      :key="index"
                    >
                      {{ implication
                      }}<span
                        v-if="
                          index <
                          experimentalData.functionalImplications.length - 1
                        "
                        >,
                      </span>
                    </span>
                  </td>
                </tr>
                <tr style="padding-bottom: 20%">
                  <td style="padding: 8px; width: 25%">Mechanisms</td>
                  <td style="padding: 8px; width: 5%">
                    <font-awesome-icon :icon="faQuestionCircle" />
                  </td>
                  <td style="padding: 8px">
                    <span
                      v-for="(mechanism, index) in experimentalData.mechanisms"
                      :key="index"
                    >
                      {{ mechanism
                      }}<span
                        v-if="index < experimentalData.mechanisms.length - 1"
                        >,
                      </span>
                    </span>
                  </td>
                </tr>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- SAMPLE DATA CARD-->
    <div
      v-if="selectedTab === 'sampleData'"
      class="tab-pane fade show active"
      id="sampleData"
      role="tabpanel"
      aria-labelledby="sampleData-tab"
      style="margin: 0% 0% 0% 15%; width: 70%"
    >
      <div class="card" style="border-radius: 0px 0px 5px 5px">
        <div class="card-body">
          <div class="row">
            <p class="title-text">
              <font-awesome-icon :icon="faVial" style="margin-right: 20px" />
              Sample Data
            </p>
          </div>
          <div style="padding-left: 3%">
            <table style="width: 100%; border-collapse: collapse">
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">Number of Samples</td>
                <td style="padding: 8px; width: 5%">
                  <font-awesome-icon
                    :icon="faQuestionCircle"
                    data-bs-toggle="tooltip"
                    data-bs-placement="top"
                    data-bs-title="Total count of biological samples collected for the study"
                  />
                </td>
                <td style="padding: 8px">
                  {{ sampleData.numberOfSamples }}
                </td>
              </tr>
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">Applied Models</td>
                <td style="padding: 8px; width: 5%">
                  <font-awesome-icon
                    :icon="faQuestionCircle"
                    data-bs-toggle="tooltip"
                    data-bs-placement="top"
                    data-bs-title="Patient-derived samples or explants or mouse, xenograft samples "
                  />
                </td>
                <td style="padding: 8px">
                  <span
                    v-for="(model, index) in sampleData.appliedModels"
                    :key="index"
                  >
                    {{ model
                    }}<span v-if="index < sampleData.appliedModels.length - 1"
                      >,
                    </span>
                  </span>
                </td>
              </tr>
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">Applied Biomaterials</td>
                <td style="padding: 8px; width: 5%">
                  <font-awesome-icon
                    :icon="faQuestionCircle"
                    data-bs-toggle="tooltip"
                    data-bs-placement="top"
                    data-bs-title="Biological materials utilized in the research"
                  />
                </td>
                <td style="padding: 8px">
                  <span
                    v-for="(material, index) in sampleData.appliedBiomaterials"
                    :key="index"
                  >
                    {{ material
                    }}<span
                      v-if="index < sampleData.appliedBiomaterials.length - 1"
                      >,
                    </span>
                  </span>
                </td>
              </tr>
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">Material Types</td>
                <td style="padding: 8px; width: 5%">
                  <font-awesome-icon
                    :icon="faQuestionCircle"
                    data-bs-toggle="tooltip"
                    data-bs-placement="top"
                    data-bs-title="Categories of materials, such as tissues, cells, or fluids"
                  />
                </td>
                <td style="padding: 8px">
                  <span
                    v-for="(type, index) in sampleData.materialTypes"
                    :key="index"
                  >
                    {{ type
                    }}<span v-if="index < sampleData.materialTypes.length - 1"
                      >,
                    </span>
                  </span>
                </td>
              </tr>
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 10%">Cancer Types</td>
                <td style="padding: 8px; width: 5%">
                  <font-awesome-icon
                    :icon="faQuestionCircle"
                    data-bs-toggle="tooltip"
                    data-bs-placement="top"
                    data-bs-title="Specific types of cancer studied in the project"
                  />
                </td>
                <td style="padding: 8px">
                  <span
                    v-for="(type, index) in sampleData.cancerTypes"
                    :key="index"
                  >
                    {{ type
                    }}<span v-if="index < sampleData.cancerTypes.length - 1"
                      >,
                    </span>
                  </span>
                </td>
              </tr>
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">Collection Types</td>
                <td style="padding: 8px; width: 5%">
                  <font-awesome-icon
                    :icon="faQuestionCircle"
                    data-bs-toggle="tooltip"
                    data-bs-placement="top"
                    data-bs-title="Methods or sources of sample collection"
                  />
                </td>
                <td style="padding: 8px">
                  <span
                    v-for="(type, index) in sampleData.collectionTypes"
                    :key="index"
                  >
                    {{ type
                    }}<span v-if="index < sampleData.collectionTypes.length - 1"
                      >,
                    </span>
                  </span>
                </td>
              </tr>
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">Case or Control</td>
                <td style="padding: 8px; width: 5%">
                  <div
                    data-bs-toggle="tooltip"
                    data-bs-placement="top"
                    data-bs-title="Comparison groups used in the study, typically involving affected vs unaffected individuals"
                  >
                    <font-awesome-icon :icon="faQuestionCircle" />
                  </div>
                </td>
                <td style="padding: 8px">
                  {{ sampleData.caseOrControl }}
                </td>
              </tr>
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">Xenograft</td>
                <td style="padding: 8px; width: 5%">
                  <span
                    data-bs-toggle="tooltip"
                    data-bs-placement="top"
                    data-bs-title="Transplantation of human tissue into an animal model for research purposes"
                  >
                    <font-awesome-icon :icon="faQuestionCircle"
                  /></span>
                </td>
                <td style="padding: 8px">
                  {{ sampleData.xenograft }}
                </td>
              </tr>
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">
                  Sample Collection Centers
                </td>
                <td style="padding: 8px; width: 5%">
                  <font-awesome-icon
                    :icon="faQuestionCircle"
                    data-bs-toggle="tooltip"
                    data-bs-placement="top"
                    data-bs-title="Locations or facilities where samples are gathered"
                  />
                </td>
                <td style="padding: 8px">
                  <span
                    v-for="(
                      center, index
                    ) in sampleData.sampleCollectionCenters"
                    :key="index"
                  >
                    {{ center
                    }}<span
                      v-if="
                        index < sampleData.sampleCollectionCenters.length - 1
                      "
                      >,
                    </span>
                  </span>
                </td>
              </tr>
            </table>
          </div>
        </div>
      </div>
    </div>
    <!-- OMICS DATA CARD-->
    <div
      v-if="selectedTab === 'omicsData'"
      class="tab-pane fade show active"
      id="omicsData"
      role="tabpanel"
      aria-labelledby="omicsData-tab"
      style="margin: 0% 0% 0% 15%; width: 70%"
    >
      <div class="card" style="border-radius: 0px 0px 5px 5px">
        <div class="card-body">
          <div class="row">
            <p class="title-text">
              <font-awesome-icon :icon="faDna" style="margin-right: 10px" />
              Omics Data
            </p>
          </div>
          <div style="padding-left: 3%">
            <table style="width: 100%; border-collapse: collapse">
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">Sequencing Center</td>
                <td style="padding: 8px; width: 5%">
                  <font-awesome-icon :icon="faQuestionCircle" />
                </td>
                <td style="padding: 8px">
                  {{ omicsData.sequencingCenter?.acronym }}
                </td>
              </tr>
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">
                  Library Preparation Kit
                </td>
                <td style="padding: 8px; width: 5%">
                  <font-awesome-icon :icon="faQuestionCircle" />
                </td>
                <td style="padding: 8px">
                  {{ omicsData.libraryPreparationKit }}
                </td>
              </tr>
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">Sequencing Technique</td>
                <td style="padding: 8px; width: 5%">
                  <font-awesome-icon :icon="faQuestionCircle" />
                </td>
                <td style="padding: 8px">
                  <span
                    v-for="(technique, index) in omicsData.sequencingTechnique"
                    :key="index"
                  >
                    {{ technique
                    }}<span
                      v-if="index < omicsData.sequencingTechnique.length - 1"
                      >,
                    </span>
                  </span>
                </td>
              </tr>
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">Instrument Models</td>
                <td style="padding: 8px; width: 5%">
                  <font-awesome-icon :icon="faQuestionCircle" />
                </td>
                <td style="padding: 8px">
                  <span
                    v-for="(model, index) in omicsData.instrumentModels"
                    :key="index"
                  >
                    {{ model
                    }}<span v-if="index < omicsData.instrumentModels.length - 1"
                      >,
                    </span>
                  </span>
                </td>
              </tr>
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; vertical-align: top; width: 25%">
                  Description
                </td>
                <td style="padding: 8px; vertical-align: top; width: 5%">
                  <font-awesome-icon :icon="faQuestionCircle" />
                </td>
                <td style="padding: 8px">
                  <div style="white-space: pre-wrap">
                    {{ omicsData.description }}
                  </div>
                </td>
              </tr>

              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">
                  Data Generation Pipelines
                </td>
                <td style="padding: 8px; width: 5%">
                  <font-awesome-icon :icon="faQuestionCircle" />
                </td>
                <td style="padding: 8px">
                  <span
                    v-for="(
                      pipeline, index
                    ) in omicsData.dataGenerationPipelines"
                    :key="index"
                  >
                    {{ pipeline
                    }}<span
                      v-if="
                        index < omicsData.dataGenerationPipelines.length - 1
                      "
                      >,
                    </span>
                  </span>
                </td>
              </tr>
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">Data Types</td>
                <td style="padding: 8px; width: 5%">
                  <font-awesome-icon :icon="faQuestionCircle" />
                </td>
                <td style="padding: 8px">
                  <span
                    v-for="(type, index) in omicsData.dataTypes"
                    :key="index"
                  >
                    {{ type
                    }}<span v-if="index < omicsData.dataTypes.length - 1"
                      >,
                    </span>
                  </span>
                </td>
              </tr>
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">Omics Methods</td>
                <td style="padding: 8px; width: 5%">
                  <font-awesome-icon :icon="faQuestionCircle" />
                </td>
                <td style="padding: 8px">
                  <span
                    v-for="(method, index) in omicsData.omicsMethods"
                    :key="index"
                  >
                    {{ method
                    }}<span v-if="index < omicsData.omicsMethods.length - 1"
                      >,
                    </span>
                  </span>
                </td>
              </tr>
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">Sequencing Pipelines</td>
                <td style="padding: 8px; width: 5%">
                  <font-awesome-icon :icon="faQuestionCircle" />
                </td>
                <td style="padding: 8px">
                  <span
                    v-for="(pipeline, index) in omicsData.sequencingPipelines"
                    :key="index"
                  >
                    {{ pipeline
                    }}<span
                      v-if="index < omicsData.sequencingPipelines.length - 1"
                      >,
                    </span>
                  </span>
                </td>
              </tr>
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">Programming</td>
                <td style="padding: 8px; width: 5%">
                  <font-awesome-icon :icon="faQuestionCircle" />
                </td>
                <td style="padding: 8px">
                  <span
                    v-for="(programm, index) in omicsData.programming"
                    :key="index"
                  >
                    {{ programm
                    }}<span v-if="index < omicsData.programming.length - 1"
                      >,
                    </span>
                  </span>
                </td>
              </tr>
            </table>
          </div>
        </div>
      </div>
    </div>

    <div
      v-if="selectedTab === 'publications'"
      class="tab-pane fade show active"
      id="omicsData"
      role="tabpanel"
      aria-labelledby="omicsData-tab"
      style="margin: 0% 0% 0% 15%; width: 70%"
    >
      <div class="card" style="border-radius: 0px 0px 5px 5px">
        <div class="card-body">
          <div class="row">
            <p class="title-text">
              <font-awesome-icon
                :icon="faNewspaper"
                style="margin-right: 10px"
              />
              Publications
            </p>
          </div>
          <div style="display: flex; flex-flow: column; padding-left: 3%">
            <p>
              {{ publications.pub1 }}
            </p>
            <p>
              {{ publications.pub2 }}
            </p>
            <p>
              {{ publications.pub3 }}
            </p>
            <p>
              {{ publications.pub4 }}
            </p>
            <p>
              {{ publications.pub5 }}
            </p>
          </div>
        </div>
      </div>
    </div>

    <div
      v-if="selectedTab === 'collaborators'"
      class="tab-pane fade show active"
      id="omicsData"
      role="tabpanel"
      aria-labelledby="collaborators-tab"
      style="margin: 0% 0% 0% 15%; width: 70%"
    >
      <div class="card" style="border-radius: 0px 0px 5px 5px">
        <div class="card-body">
          <div class="row">
            <p class="title-text">
              <font-awesome-icon
                :icon="faHandshake"
                style="margin-right: 10px"
              />
              Collaborators
            </p>
          </div>
          <div style="display: flex; flex-flow: column; padding-left: 3%">
            <table style="width: 100%; border-collapse: collapse">
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">
                  <p>Internal HI-TRON Mainz Collaborators</p>
                </td>
                <td style="padding: 8px; width: 5%">
                  <font-awesome-icon :icon="faQuestionCircle" />
                </td>
                <td style="padding: 8px">
                  <p
                    v-for="(collaborator, index) in project.internCollaborators"
                    :key="index"
                    style="padding: 0; margin: 0"
                  >
                    {{ collaborator.name }}
                  </p>
                </td>
              </tr>
              <tr style="padding-bottom: 20%">
                <td style="padding: 8px; width: 25%">
                  <p>External Collaborators</p>
                </td>
                <td style="padding: 8px; width: 5%">
                  <font-awesome-icon :icon="faQuestionCircle" />
                </td>
                <td style="padding: 8px">
                  <p
                    v-for="(collaborator, index) in project.externCollaborators"
                    :key="index"
                    style="padding: 0; margin: 0"
                  >
                    {{ collaborator.name }} ({{ collaborator.acronym }})
                  </p>
                </td>
              </tr>
            </table>
            <div></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import projectsData from "../data/projects.json";
import { request } from "graphql-request";
import { ref, onMounted } from "vue";
import { useRoute } from "vue-router";
import {
  faQuestionCircle,
  faHouseChimneyMedical,
  faFlask,
  faVial,
  faDna,
  faNewspaper,
  faHandshake,
  faChartPie,
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";

export default {
  name: "DetailView",
  components: {
    FontAwesomeIcon,
  },
  setup() {
    const route = useRoute();
    const projectId = route.params.id;
    const loading = ref(true);
    const graphqlError = ref(null);
    const project = ref(null);
    const rowsProjects = ref([]);
    const rowsClinicalData = ref([]);
    const rowsExperimentalData = ref([]);
    const rowsSampleData = ref([]);
    const rowsOmicsData = ref([]);
    const rowsPublications = ref([]);
    const clinicalData = ref({});
    const experimentalData = ref({});
    const sampleData = ref([]);
    const omicsData = ref([]);
    const publications = ref([]);
    let selectedTab = ref("sampleData");

    let showTooltip = ref(false);

    function selectTab(tabName) {
      selectedTab.value = tabName;
      console.log("tabName: " + tabName);
      console.log("selectedTab.value: " + selectedTab.value);
    }

    const getTagClass = (tag) => {
      return {
        "dataset-tag": tag === "Dataset",
        "other-tag": tag !== "Dataset",
      };
    };

    const isDataEmpty = (value) => {
      return (
        !value ||
        value === "NOT AVAILABLE" ||
        value === "NOT APPLICABLE" ||
        value === 0 ||
        value === "0"
      );
    };

    const getDisplayValue = (value) => {
      return isDataEmpty(value) ? "0" : value;
    };

    const queryProjects =
      "{Projects{id title abstract institution{acronym} pi division{fullname address website} email internCollaborators{name} externCollaborators{acronym name}}}";

    const queryClinicalMetadata =
      "{ClinicalMetadata {project{id} appliedDiagnosis biosampleTypes biobank{name} numberOfPatients labTests informedConsent ethicalConsideration appliedProcedure demographics}}";

    const queryExperimentalMetadata =
      "{ExperimentalMetadata {project{id} numberOfExperiments experimentalMethods biologicalReplicates technicalReplicates modelsOrPlatformsUsed smallMoleculesUsed biomarkers functionalImplications mechanisms}}";

    const querySampleMetadata =
      "{SampleMetadata {project{id} numberOfSamples appliedModels appliedBiomaterials materialTypes cancerTypes collectionTypes caseOrControl xenograft sampleCollectionCenters}}";

    const queryOmicsMetadata =
      "{OmicsMetadata {project{id} sequencingCenter{acronym} libraryPreparationKit sequencingTechnique instrumentModels description dataGenerationPipelines dataTypes omicsMethods sequencingPipelines programming}}";

    const queryPublications =
      "{Publications {project{id} pub1 pub2 pub3 pub4 pub5}}";

    const fetchProjectData = async () => {
      try {
        const data = await request("graphql", queryProjects);
        rowsProjects.value = data.Projects;
      } catch (error) {
        graphqlError.value = error.response.errors
          ? error.response.errors[0].message
          : error.message;
      }
    };

    const fetchClinicalData = async () => {
      try {
        const data = await request("graphql", queryClinicalMetadata);
        rowsClinicalData.value = data.ClinicalMetadata;
      } catch (error) {
        graphqlError.value = error.response.errors
          ? error.response.errors[0].message
          : error.message;
      }
    };

    const fetchExperimentalData = async () => {
      try {
        const data = await request("graphql", queryExperimentalMetadata);
        rowsExperimentalData.value = data.ExperimentalMetadata;
      } catch (error) {
        graphqlError.value = error.response.errors
          ? error.response.errors[0].message
          : error.message;
      }
    };

    const fetchSampleData = async () => {
      try {
        const data = await request("graphql", querySampleMetadata);
        rowsSampleData.value = data.SampleMetadata;
      } catch (error) {
        graphqlError.value = error.response.errors
          ? error.response.errors[0].message
          : error.message;
      }
    };

    const fetchOmicsData = async () => {
      try {
        const data = await request("graphql", queryOmicsMetadata);
        rowsOmicsData.value = data.OmicsMetadata;
      } catch (error) {
        graphqlError.value = error.response.errors
          ? error.response.errors[0].message
          : error.message;
      }
    };

    const fetchPublications = async () => {
      try {
        const data = await request("graphql", queryPublications);
        rowsPublications.value = data.Publications;
      } catch (error) {
        graphqlError.value = error.response.errors
          ? error.response.errors[0].message
          : error.message;
      }
    };

    const fetchAllData = async () => {
      await Promise.all([
        fetchProjectData(),
        fetchClinicalData(),
        fetchExperimentalData(),
        fetchSampleData(),
        fetchOmicsData(),
        fetchPublications(),
      ]);
      project.value = rowsProjects.value.find((proj) => proj.id === projectId);
      clinicalData.value =
        rowsClinicalData.value.find((data) => data.project.id === projectId) ||
        {};
      experimentalData.value =
        rowsExperimentalData.value.find(
          (data) => data.project.id === projectId
        ) || {};
      sampleData.value =
        rowsSampleData.value.find((data) => data.project.id === projectId) ||
        {};
      omicsData.value =
        rowsOmicsData.value.find((data) => data.project.id === projectId) || {};
      publications.value =
        rowsPublications.value.find((data) => data.project.id === projectId) ||
        {};

      console.log(clinicalData.value); // Debugging
      console.log(omicsData.value); // Debugging
      console.log(experimentalData.value); // Debugging
      console.log(sampleData.value); // Debugging
      console.log(publications.value); // Debugging

      loading.value = false;
    };

    onMounted(fetchAllData);

    return {
      loading,
      graphqlError,
      project,
      clinicalData,
      experimentalData,
      omicsData,
      sampleData,
      publications,
      getTagClass,
      isDataEmpty,
      getDisplayValue,
      faQuestionCircle,
      faHouseChimneyMedical,
      faFlask,
      faVial,
      faDna,
      selectedTab,
      selectTab,
      faNewspaper,
      faHandshake,
      faChartPie,
    };
  },
};
</script>

<style scoped>
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

.title-text {
  font-weight: 600;
  font-size: 20px;
  text-align: left;
  color: #333;
}

.abstract-card {
  flex: 1; /* Passt sich an die verbleibende Höhe an */
}

.card-body {
  display: flex;
  flex-flow: column;
  text-align: left;
  padding-left: 3%;
}

.nav-item {
  background-color: #014c87;
  color: white;
  border-radius: 5px 5px 0px 0px;

  padding: 0% 2% 0% 2%;
}

.nav-link {
  background-color: #014c87;
  color: white;
  border-radius: 5px 5px 0px 0px;
}

.nav-link active {
  background-color: #f8f9fa;
  color: #333;
  border-radius: 5px 5px 0px 0px;
}

.nav-tabs .nav-link {
  border: 0px;
  margin-bottom: 0px;
}

.row-container {
  display: grid;
  grid-template-columns: auto 1fr;
  align-items: flex-start;
  gap: 4px;
  height: 60px; /* Feste Höhe für jede Zeile */
}

.tag-container {
  display: flex;
  flex-wrap: wrap; /* Erlaubt Umbruch der Tags */
  gap: 5px; /* Abstand zwischen den Tags */
}

.tooltip-container {
  position: relative;
  display: inline-block;
}

.tooltip-text {
  position: absolute;
  background-color: #555;
  color: #fff;
  padding: 5px;
  border-radius: 5px;
  bottom: 125%; /* Position above the icon */
  left: 50%;
  transform: translateX(-50%);
  white-space: nowrap;
  visibility: hidden;
  opacity: 0;
  transition: opacity 0.3s;
}

.tooltip-container:hover .tooltip-text {
  visibility: visible;
  opacity: 1;
}

/* Pie Chart Styles */
.pie-chart-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin: 10px 0;
}

.pie-chart {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  background: conic-gradient(#014c87 0deg 270deg, #e9ecef 270deg 360deg);
  margin-bottom: 10px;
}

.pie-chart-inner {
  width: 80px;
  height: 80px;
  background-color: white;
  border-radius: 50%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.pie-chart-number {
  font-size: 20px;
  font-weight: 600;
  color: #014c87;
  line-height: 1;
}

.pie-chart-label {
  font-size: 12px;
  color: #666;
  font-weight: 500;
  margin-top: 2px;
}

/* Different colors for each chart */
.patients-chart {
  background: conic-gradient(#014c87 0deg 270deg, #e9ecef 270deg 360deg);
}

.samples-chart {
  background: conic-gradient(#28a745 0deg 270deg, #e9ecef 270deg 360deg);
}

.experiments-chart {
  background: conic-gradient(#17a2b8 0deg 270deg, #e9ecef 270deg 360deg);
}

/* Empty chart styles - only outline */
.empty-chart.patients-chart {
  background: transparent;
  border: 3px solid #014c87;
}

.empty-chart.samples-chart {
  background: transparent;
  border: 3px solid #28a745;
}

.empty-chart.experiments-chart {
  background: transparent;
  border: 3px solid #17a2b8;
}
</style>
