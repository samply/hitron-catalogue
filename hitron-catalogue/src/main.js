import { createApp } from "vue";
import { createRouter, createWebHashHistory } from "vue-router";
import App from "./App.vue";
import HitronCatalogue from "./components/HitronCatalogue.vue";
import Startpage from "./components/Startpage.vue";
import DetailView from "./components/DetailView.vue";
import SomeHitronQuery from "./components/SomeHitronQuery.vue";

import "molgenis-components/dist/style.css";

const router = createRouter({
  history: createWebHashHistory(),
  routes: [
    {
      path: "/",
      name: "Startpage",
      component: Startpage,
      props: true,
    },
    {
      path: "/Catalogue",
      name: "Catalogue",
      component: HitronCatalogue,
      props: true,
    },
    {
      path: "/somehitronquery",
      component: SomeHitronQuery,
      props: true,
    },
    {
      path: "/detail/:id",
      name: "detailview",
      component: DetailView,
      props: true,
    },
  ],
});

const app = createApp(App);
app.use(router);
app.mount("#app");
