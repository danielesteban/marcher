<script>
  import { onMount } from 'svelte';
  import { effect, publishing, rendering, scene, version, serialize } from './state.js';
  import Dropdown from './components/dropdown.svelte';

  let loader;
  let downloader;
  let isFetching = false;
  const exportFile = () => {
    const { content, path } = serialize();
    downloader.download = path;
    downloader.href = URL.createObjectURL(content);
    downloader.click();
  };
  const importFile = () => loader.click();
  const loadData = (data) => {
    if (data.version !== version) {
      throw new Error('version');
    }
    effect.editor = null;
    effect.source.set(data.effect);
    scene.editor = null;
    scene.source.set(data.scene);
    rendering.iterations.set(data.iterations);
    rendering.mode.set(data.mode);
    rendering.resolution.set(data.resolution);
    rendering.input.reset();
  };
  const loadURL = () => {
    const [type, id] = location.hash.slice(2).split('/')[0].split(':');
    if (type === 'ipfs' && id) {
      $publishing = false;
      isFetching = true;
      fetch(`https://ipfs.io/ipfs/${id}`)
        .then((res) => res.json())
        .then(loadData)
        .catch((e) => console.error(e))
        .finally(() => {
          isFetching = false;
        });
    }
  };
  const prevent = (e) => e.preventDefault();
  const publish = () => {
    $publishing = true;
  };
  const readFile = (e) => {
    e.preventDefault();
    const [file] = e.dataTransfer ? e.dataTransfer.files : e.target.files;
    if (!file) {
      return;
    }
    const reader = new FileReader();
    reader.addEventListener('load', () => {
      loader.value = null;
      loadData(JSON.parse(reader.result));
    }, false);
    reader.readAsText(file);
  };
  onMount(loadURL);
</script>

<svelte:window
  on:dragenter={prevent}
  on:dragover={prevent}
  on:drop={readFile}
  on:hashchange={loadURL}
/>

<div class="helpers">
  <input type="file" accept="application/json" on:change={readFile} bind:this={loader} />
  <!-- svelte-ignore a11y-missing-attribute a11y-missing-content -->
  <a bind:this={downloader} />
</div>

{#if isFetching}
  <div class="fetching">Fetching...</div>
{:else}
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
      <div class="action" on:click={publish}>
        Publish
      </div>
    </svelte:fragment>
  </Dropdown>
{/if}

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

  .action, .fetching, .toggle {
    box-sizing: border-box;
    width: 4rem;
  }

  .fetching, .toggle {
    display: flex;
    align-items: center;
    padding: 0.5rem;
  }
  
  .fetching {
    padding: 0.5rem 0;
    color: #393;
    justify-content: center;
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
