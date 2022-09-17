<script>
  import { onMount } from 'svelte';
  import { get } from 'svelte/store';
  import { effect, rendering, scene } from './state.js';
  import Dropdown from './components/dropdown.svelte';
  import IPFS from './ipfs.js';

  let loader;
  let downloader;
  const version = 1;
  const getFile = () => {
    const blob = new Blob([JSON.stringify({
      effect: get(effect.source),
      scene: get(scene.source),
      version,
    })], { type: 'application/json' });
    const now = new Date();
    const f = (v) => ('00' + v).slice(-2);
    const date = `${f(now.getMonth() + 1)}${f(now.getDate())}`;
    const time = `${f(now.getHours())}${f(now.getMinutes())}`;
    return {
      path: `marcher-${date}${time}.json`,
      content: blob,
    };
  }
  const exportFile = () => {
    const { content, path } = getFile();
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
    rendering.input.reset();
  };
  const loadURL = () => {
    const [type, id] = location.hash.slice(2).split('/')[0].split(':');
    if (type === 'ipfs' && id) {
      fetch(`https://ipfs.io/ipfs/${id}`)
        .then((res) => res.json())
        .then(loadData)
        .catch((e) => console.error(e));
    }
  };
  const prevent = (e) => e.preventDefault();
  const publish = () => (
    IPFS()
      .then((ipfs) => ipfs.add(getFile()))
      .then((file) => {
        const url = new URL(location);
        url.hash = `#/ipfs:${file.cid}`;
        window.open(url.toString());
      })
      .catch((e) => console.error(e))
  );
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
