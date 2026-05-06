<template>
  <div
    class="input-group mb-3 custom-input-group"
    style="
      width: 100%;
      float: right;
      margin-top: 10%;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    "
  >
    <input
      type="text"
      class="form-control custom-form-control"
      placeholder="Search projects..."
      aria-label="Search"
      aria-describedby="basic-addon2"
      v-model="searchQuery"
      @input="updateSearch"
    />
    <div class="input-group-append">
      <button
        class="btn btn-outline-secondary custom-button"
        type="button"
        @click="clearSearch"
        v-if="searchQuery"
      >
        <i class="fas fa-times"></i>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";

const emit = defineEmits(["search-changed"]);

const searchQuery = ref("");

const updateSearch = () => {
  emit("search-changed", searchQuery.value);
};

const clearSearch = () => {
  searchQuery.value = "";
  emit("search-changed", "");
};
</script>

<style scoped>
.custom-button {
  background-color: #014c87;
  color: white;
  border-radius: 0 5px 5px 0;
  border-color: #014c87;
}
</style>
