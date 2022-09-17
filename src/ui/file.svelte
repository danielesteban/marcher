<script>
  import { get } from 'svelte/store';
  import { effect, scene } from './state.js';
  import Dropdown from './components/dropdown.svelte';

  let loader;
  let downloader;
  const importFile = () => loader.click();
  const readFile = () => {
    const file = loader.files[0];
    if (!file) {
      return;
    }
    const reader = new FileReader();
    reader.addEventListener('load', () => {
      loader.value = null;
      const data = JSON.parse(reader.result);
      effect.editor = null;
      effect.source.set(data.effect);
      scene.editor = null;
      scene.source.set(data.scene);
    }, false);
    reader.readAsText(file);
  };
  const exportFile = () => {
    const blob = new Blob([JSON.stringify({
      effect: get(effect.source),
      scene: get(scene.source),
      version: 1,
    })], { type: 'application/json' });
    const now = new Date();
    const f = (v) => ('00' + v).slice(-2);
    const date = `${f(now.getMonth() + 1)}${f(now.getDate())}`;
    const time = `${f(now.getHours())}${f(now.getMinutes())}`;
    downloader.download = `marcher-${date}${time}.json`;
    downloader.href = URL.createObjectURL(blob);
    downloader.click();
  };
</script>

<div class="helpers">
  <input type="file" accept="application/json" on:change={readFile} bind:this={loader} />
  <!-- svelte-ignore a11y-missing-attribute a11y-missing-content -->
  <a bind:this={downloader} />
</div>

<Dropdown>
  <div class="toggle" slot="toggle">
    <div class="arrow" />
    <div class="label">File</div>
  </div>
  <svelte:fragment slot="options">
    <div class="action" on:click={importFile}>
      Import
    </div>
    <div class="action" on:click={exportFile}>
      Export
    </div>
  </svelte:fragment>
</Dropdown>

<style>
  .helpers {
    display: none;
  }

  .arrow {
    width: 0; 
    height: 0;
    border-left: 0.25rem solid transparent;
    border-right: 0.25rem solid transparent;
    border-top: 0.25rem solid #fff;
  }

  .toggle, .action {
    box-sizing: border-box;
    width: 4rem;
  }

  .toggle {
    display: flex;
    align-items: center;
    padding: 0.5rem;
  }

  .toggle .label {
    flex-grow: 1;
    display: flex;
    justify-content: center;
  }

  .action {
    padding: 0.5rem 1rem;
  }

  .action:hover {
    color: #393;
    cursor: pointer;
  }
</style>
