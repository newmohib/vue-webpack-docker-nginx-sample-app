<!-- src/App.vue -->
<template>
    <div id="app">
      <h1>Vue Babel Sample App</h1>
      <HelloWorld />
    </div>
  </template>
  
  <script>
  import HelloWorld from './components/HelloWorld.vue';
  
  export default {
    name: 'App',
    components: {
      HelloWorld,
    },
  };
  </script>
  
  <style>
  /* Add some basic styling */
  #app {
    font-family: Avenir, Helvetica, Arial, sans-serif;
    text-align: center;
    color: #2c3e50;
    margin-top: 60px;
  }
  </style>
  