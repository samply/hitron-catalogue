<template>
  <div class="footer">
    <div>
      <div class="logo" style="display: flex; flex-flow: row; width: 35%">
        <img class="dkfzlogo" alt="DKFZ" src="@/assets/DKFZ_Logo.png" />
        <img class="jgulogo" alt="JGU" src="@/assets/JGU.jpg" />
        <img class="ummainzlogo" alt="UMMainz" src="@/assets/ummainz.png" />
        <img
          class="hitronlogo"
          alt="HI-TRON"
          src="@/assets/Logo_HI-TRON_EN-Transparent.png"
        />
      </div>
    </div>
    <div class="molgeniscredits">
      <div class="centered-line">
        <hr />
      </div>

      <p>
        Please cite Holub Petr, Swertz Morris, Reihs Robert, van Enckevort
        David, Mueller Heimo, and Litton Jan-Eric. Biopreservation and
        Biobanking. December 2016, 14(6): 559-562. doi:10.1089/bio.2016.0088
        upon use.
      </p>
      <p>
        This database was created using the open source MOLGENIS software 10.1.0
        built on 2023-01-30 11:41 UTC.
      </p>
      <p>App version: 1.0.0.</p>
      <p>
        Please cite Van der Velde et al (2018), Swertz et al (2010) or Swertz &
        Jansen (2007) on use.
      </p>
    </div>
  </div>
</template>

<script></script>

<style scoped>
.footer {
  display: flex;
  flex-flow: column;
}

hr {
  margin-top: 3%;
  border: 1px solid gray;
  width: 100%;
}

.centered-line {
  width: 80%;
  text-align: center;
}

.dkfzlogo {
  width: 250px;
  height: 70px;
  margin-right: 3%;
}
.ummainzlogo {
  width: 90px;
  height: 70px;
  margin-right: 3%;
}
.jgulogo {
  width: 130px;
  height: 60px;
  margin-right: 3%;
}
.hitronlogo {
  width: 170px;
  height: 60px;
}

.molgeniscredits {
  text-align: center;
  margin-top: 5px;
  line-height: 1.2;
  display: flex;
  flex-flow: column;
  justify-content: center;
  align-items: center;
  color: gray;
}

.logo {
  float: right;
  margin-top: 5%;
}
</style>
