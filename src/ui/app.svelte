<script>
  import { tick } from 'svelte';
  import { view } from './state.js';
  import Effect from './views/effect.svelte';
  import Fetch from './dialogs/fetch.svelte';
  import Publish from './dialogs/publish.svelte';
  import Scene from './views/scene.svelte';
  import Settings from './views/settings.svelte';
  import Toolbar from './toolbar.svelte';
  import Viewport from './viewport.svelte';

  const drag = {
    enabled: false,
    initial: 0,
    offset: 0,
    state: 512,
  };
  const mousedown = ({ clientX }) => {
    drag.enabled = true;
    drag.initial = drag.state;
    drag.offset = clientX;
  };
  const mousemove = ({ clientX }) => {
    drag.state = Math.max(Math.floor(drag.initial + clientX - drag.offset), 340);
    tick().then(() => window.dispatchEvent(new Event('resize')));
  };
  const mouseup = () => {
    drag.enabled = false;
  };
</script>

<svelte:window on:mousemove={drag.enabled && mousemove} on:mouseup={drag.enabled && mouseup} />

<div class="app">
  <div class="ui" style="width: {drag.state}px">
    <Toolbar />
    {#if $view === 'effect'}
      <Effect />
    {:else if $view === 'scene'}
      <Scene />
    {:else if $view === 'settings'}
      <Settings />
    {/if}
  </div>
  <div class="divider" on:mousedown={mousedown} />
  <Viewport />
</div>

<Fetch />
<Publish />

<style>
  .app {
    display: grid;
    grid-template-columns: auto auto 1fr;
    grid-template-rows: 1fr;
    width: 100vw;
    height: 100vh;
  }

  .ui {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: auto 1fr;
    min-height: 0;
  }

  .divider {
    width: 0.5rem;
    border-color: #1e1e1e;
    border-style: solid;
    border-left-width: 1px;
    border-right-width: 1px;
    background-color: #111;
    cursor: ew-resize;
  }
</style>
