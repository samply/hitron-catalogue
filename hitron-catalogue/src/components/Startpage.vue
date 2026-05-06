<template>
  <div>
    <div style="display: flex; flex-flow: row; width: 100%">
      <div
        style="
          display: flex;
          width: 70%;
          padding-left: 10%;
          justify-content: flex-start;
          align-items: flex-start;
          flex-flow: column;
        "
      >
        <h1
          style="
            display: flex;
            width: 100%;
            padding-left: 0%;
            justify-content: flex-start;
            align-items: flex-start;
          "
        >
          HI-TRON Mainz Data Portal
        </h1>
        <p
          style="
            display: flex;
            width: 100%;
            padding-left: 0%;
            justify-content: flex-start;
            align-items: flex-start;
            color: grey;
          "
        >
          Your gateway to advanced cancer research data
        </p>
        <p style="width: 100%; padding: 0; text-align: justify; color: grey">
          The Data Architecture Platform is an advanced web-based solution for
          data sharing between the Helmholtz-Institute for Translational
          Oncology Mainz Partners (HI-TRON Mainz) - a joint venture of the
          German Cancer Research Center (DKFZ) with the Research Institute for
          Translational Oncology at the University Medical Center of the
          Johannes Gutenberg University Mainz (TRON gGmbH), the University
          Medical Center Mainz (UMC) and the Johannes Gutenberg University Mainz
          (JGU). The platform follows FAIR (Findable, Accessible, Interoperable,
          and Reusable) principles, enabling researchers to explore available
          data and bio-samples from various projects, studies, and analyses.
          Through this platform, users can search the database, submit data
          requests, and access detailed datasets after an initial feasibility
          query.
        </p>
      </div>

      <div
        style="
          display: flex;
          width: 20%;
          padding-left: 0%;
          justify-content: center;
          align-items: center;
          margin-top: 3%;
        "
      >
        <button
          class="btn btn-primary"
          type="button"
          style="
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #014c87;
            color: white;
            border: none;
          "
        >
          <router-link
            :to="{ name: 'Catalogue' }"
            class="always-white-link"
            style="color: white !important; text-decoration: none"
          >
            ENTER PORTAL
          </router-link>
        </button>
      </div>
    </div>
    <br />

    <div
      style="
        display: flex;
        width: 100%;
        justify-content: center;
        align-items: center;
      "
    >
      <div
        class="card text-white bg-dark mb-3"
        style="
          width: 80%;
          display: flex;
          flex-flow: row;
          justify-content: space-around;
          align-items: center;
          padding: 1% 0% 1% 0%;
        "
      >
        <div class="item">
          <h5 class="card-title">13</h5>
          <p class="card-text">Projects</p>
        </div>
        <div class="item">
          <h5 class="card-title">6</h5>
          <p class="card-text">Networks</p>
        </div>
        <div class="item">
          <h5 class="card-title">23</h5>
          <p class="card-text">Publications</p>
        </div>
        <div class="item">
          <h5 class="card-title">345</h5>
          <p class="card-text">data sources</p>
        </div>
      </div>
    </div>

    <!-- SECOND PANEL -->

    <div
      style="
        display: flex;
        width: 100%;
        justify-content: center;
        align-items: center;
      "
    >
      <div
        class="card"
        style="
          width: 80%;
          display: flex;
          flex-flow: row;
          justify-content: space-around;
          align-items: center;
          padding: 0% 0% 0% 0%;
          background-color: #d3d3d3;
          color: grey;
        "
      >
        <!-- Add the images here -->
        <div class="item" style="width: 200px; height: 300px">
          <img
            :src="metastructure"
            alt="Description of Image1"
            @click="openDialog(metastructure)"
            style="cursor: pointer; width: 100%; height: auto"
          />
        </div>
        <div class="item" style="width: 200px; height: 300px">
          <img
            :src="dataflow"
            alt="Description of Image2"
            @click="openDialog(dataflow)"
            style="cursor: pointer; width: 100%; height: auto"
          />
        </div>
        <div class="item" style="width: 300px">
          <img
            :src="psdworkflow"
            alt="Description of Image3"
            @click="openDialog(psdworkflow)"
            style="cursor: pointer; width: 100%; height: auto"
          />
        </div>
      </div>
    </div>

    <!-- Footer-->
    <div
      style="
        display: flex;
        flex-flow: row;
        gap: 50px;
        justify-content: space-between;
        align-items: baseline;
        padding-top: 3%;
        padding-bottom: 1%;
        padding-right: 10%;
        float: right;
      "
    >
      <div style="width: 150px">
        <img
          :src="hitronlogo"
          alt="HI-TRON Logo"
          style="cursor: pointer; width: 100%; height: auto"
        />
      </div>
      <div style="width: 200px">
        <img
          :src="dkfzlogo"
          alt="DKFZ Logo"
          style="cursor: pointer; width: 100%; height: auto"
        />
      </div>
      <div style="width: 100px">
        <img
          :src="tronlogo"
          alt="TRON Logo"
          style="cursor: pointer; width: 100%; height: auto"
        />
      </div>
      <div style="width: 100px">
        <img
          :src="johannesgutenberguniversität"
          alt="JohannesGutenberg Logo"
          style="cursor: pointer; width: 100%; height: auto"
        />
      </div>
      <div style="width: 200px">
        <img
          :src="universitätsmedizinmainz"
          alt="Medizin Logo"
          style="cursor: pointer; width: 100%; height: auto"
        />
      </div>
    </div>

    <!-- Dialog for displaying larger image -->
    <div v-if="dialogVisible" class="dialog-overlay" @click="closeDialog">
      <div class="dialog-content">
        <img
          :src="dialogImage"
          alt="Larger view"
          style="width: 100%; height: auto"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watchEffect } from "vue";
// import SingleCard from "./SingleCard.vue";
// import FilterBar from "./FilterBar.vue";
import { ButtonAction } from "molgenis-components";

import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";
import {
  faAngleUp,
  faAngleDown,
  faArrowDownWideShort,
  faArrowUpShortWide,
} from "@fortawesome/free-solid-svg-icons";
import { request } from "graphql-request";

import metastructure from "../assets/HI-TRON_image_metadatastructure.png";
import dataflow from "../assets/HI-TRON_image_organizations_dataflow.png";
import psdworkflow from "../assets/HI-TRON_image_psd_workflow_v1.png";
import dkfzlogo from "../assets/DKFZ_Logo-Research_en.png";
import tronlogo from "../assets/TRON-Logo.svg";
import hitronlogo from "../assets/HI-TRON_logo_en.png";
import johannesgutenberguniversität from "../assets/johannes-gutenberg-university-mainz-logo.png";
import universitätsmedizinmainz from "../assets/Universitätsmedizin_der_Johannes_Gutenberg-Universität_Mainz_Logo.svg";

const dialogVisible = ref(false);
const dialogImage = ref("");

const openDialog = (image) => {
  dialogImage.value = image;
  dialogVisible.value = true;
};

const closeDialog = () => {
  dialogVisible.value = false;
};
</script>

<style scoped>
.card-title {
  font-size: 30px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.card-text {
  display: flex;
  justify-content: center;
  align-items: center;
}

.card .item {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding: 5px;
  position: relative;
}

.dialog-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.8);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.dialog-content {
  background: white;
  padding: 20px;
  border-radius: 8px;
  max-width: 90%;
  max-height: 90%;
  overflow: auto;
}
</style>
