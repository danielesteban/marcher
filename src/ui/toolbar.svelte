<script>
  import {
    effect,
    effects,
    rendering,
    scenes,
    scene,
    view,
  } from './state.js';
  import Dropdown from './components/dropdown.svelte';
  import File from './file.svelte';

  const views = [
    { id: 'scene', name: 'Scene' },
    { id: 'effect', name: 'Effect' },
    { id: 'settings', name: 'Settings' },
  ];

  const loadEffect = (source) => () => {
    effect.editor = null;
    effect.source.set(source);
  };

  const loadScene = (source) => () => {
    scene.editor = null;
    scene.source.set(source);
    rendering.input.reset();
  };
  
  const setView = (id) => () => {
    $view = id;
  };
</script>

<div class="toolbar">
  <div>
    <File />
    {#each views as { id, name }}
      <div class="view" class:enabled={$view === id} on:click={setView(id)}>
        {name}
      </div>
    {/each}
  </div>
  <div>
    {#if $view !== 'settings'}
      <Dropdown>
        <div class="toggle" slot="toggle">
          <div class="label">Examples</div>
          <div class="arrow" />
        </div>
        <svelte:fragment slot="options">
          {#if $view === 'scene'}
            {#each scenes as source, i}
              <div class="action" on:click={loadScene(source)}>
                Scene {i + 1}
              </div>
            {/each}
          {:else if $view === 'effect'}
            {#each effects as source, i}
              <div class="action" on:click={loadEffect(source)}>
                Effect {i + 1}
              </div>
            {/each}
          {/if}
        </svelte:fragment>
      </Dropdown>
    {/if}
  </div>
</div>

<style>
  .toolbar {
    background-color: #111;
    display: flex;
    white-space: nowrap;
    justify-content: space-between;
  }

  .toolbar > div {
    display: flex;
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
    width: 5rem;
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

  .view {
    position: relative;
    display: flex;
    justify-content: center;
    padding: 0.5rem 0;
    width: 4rem;
    cursor: pointer;
  }

  .view:hover {
    color: #393;
  }

  .view.enabled {
    color: #fff;
    cursor: default;
  }

  .view.enabled::before {
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0.25rem;
    height: 0.25rem;
    content: "";
    background: #393;
    cursor: default;
    border-radius: 0.25rem;
  }
</style>
