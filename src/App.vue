<template>
    <div id="app">
      <nav>
        <ul>
          <li><router-link to="/">Home</router-link></li>
          <li><router-link to="/about">About</router-link></li>
        </ul>
      </nav>
      <router-view></router-view> <!-- This is where the routed components will be displayed -->
    </div>
  </template>
  
  <script>
  export default {
    name: 'App',
  };
  </script>
  
  <style>
  nav {
    background-color: #f0f0f0;
    padding: 10px;
  }
  
  ul {
    list-style: none;
    padding: 0;
  }
  
  li {
    display: inline;
    margin-right: 10px;
  }
  
  a {
    text-decoration: none;
    color: #42b983;
  }
  </style>
  