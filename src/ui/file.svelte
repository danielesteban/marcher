<script>
  import { dialogs, deserialize, serialize, reset } from './state.js';
  import Dropdown from './components/dropdown.svelte';

  let downloader;
  let loader;
  const exportFile = () => {
    const { content, path } = serialize();
    URL.revokeObjectURL(downloader.href);
    downloader.download = path;
    downloader.href = URL.createObjectURL(content);
    downloader.click();
  };
  const importFile = () => loader.click();
  const prevent = (e) => e.preventDefault();
  const publish = () => dialogs.publish.set(true);
  const readFile = (e) => {
    prevent(e);
    const [file] = e.dataTransfer ? e.dataTransfer.files : e.target.files;
    if (!file) {
      return;
    }
    const reader = new FileReader();
    reader.addEventListener('load', () => {
      loader.value = null;
      deserialize(JSON.parse(reader.result));
    }, false);
    reader.readAsText(file);
  };
</script>

<svelte:window
  on:dragenter={prevent}
  on:dragover={prevent}
  on:drop={readFile}
/>

<div class="helpers">
  <!-- svelte-ignore a11y-missing-attribute a11y-missing-content -->
  <a bind:this={downloader} />
  <input type="file" accept="application/json" bind:this={loader} on:change={readFile} />
</div>

<Dropdown>
  <div class="toggle" slot="toggle">
    <div class="arrow" />
    <div class="label">File</div>
  </div>
  <svelte:fragment slot="options">
    <div class="action" on:click={reset}>
      New
    </div>
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

  .action, .toggle {
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
