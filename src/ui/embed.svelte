<script>
  import Fetch from './dialogs/fetch.svelte';
  import Viewport from './viewport.svelte';
</script>

<div class="embed">
  <Viewport />
</div>

<Fetch />

<style>
  .embed {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: 1fr;
    width: 100vw;
    height: 100vh;
  }
</style>
