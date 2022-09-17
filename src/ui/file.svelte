<script>
  import { get } from 'svelte/store';
  import { effect, scene } from './state.js';
  import Dropdown from './components/dropdown.svelte';

  let loader;
  let downloader;
  const importScene = () => loader.click();
  const readScene = () => {
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
  const exportScene = () => {
    const blob = new Blob([JSON.stringify({
      effect: get(effect.source),
      scene: get(scene.source),
      version: 1,
    })], { type: 'application/json' });
    downloader.download = 'scene.json';
    downloader.href = URL.createObjectURL(blob);
    downloader.click();
  };
</script>

<div class="helpers">
  <input type="file" accept="application/json" on:change={readScene} bind:this={loader} />
  <!-- svelte-ignore a11y-missing-attribute a11y-missing-content -->
  <a bind:this={downloader} />
</div>

<Dropdown>
  <div class="toggle" slot="toggle">
    <div class="arrow" />
    <div class="label">File</div>
  </div>
  <svelte:fragment slot="options">
    <div class="action" on:click={importScene}>
      Import
    </div>
    <div class="action" on:click={exportScene}>
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
