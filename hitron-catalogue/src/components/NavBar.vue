<template>
  <nav class="navbar" style="width: 100%; display: flex; flex-flow: row">
    <div class="logo" style="display: flex; flex-flow: row; width: 35%">
      <div style="width: 20%; color: white">..</div>
      <router-link to="/" class="card-link"
        ><img alt="HI-TRON Logo" src="@/assets/Logo_HI-TRON_EN-Transparent.png"
      /></router-link>
      <div style="width: 80%; color: white">..</div>
    </div>
    <div style="width: 60%; background-color: white; color: white">..</div>
    <div class="nav-links" style="width: 13%">
      <ul>
        <li><a>Sign in</a></li>
        <li><a>About</a></li>
        <li><a>Contact</a></li>
      </ul>
    </div>
  </nav>
</template>

<script></script>

<style scoped>
.navbar {
  padding: 5px 0; /* Reduced padding */
  color: #014c87;
  box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.1);
}

.logo img {
  width: 170px;
  height: 70px;
}

.nav-links ul {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
}

.nav-links li {
  margin-right: 20px;
}

.nav-links a {
  text-decoration: none;
  color: #014c87;
  font-weight: 300;
  font-size: 14px; /* Reduced font size */
}

.nav-links a:hover {
  text-decoration: underline;
}
</style>
