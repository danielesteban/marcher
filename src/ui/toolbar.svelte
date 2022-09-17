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

  const views = [
    { id: 'scene', name: 'Scene' },
    { id: 'effect', name: 'Effect' },
    { id: 'settings', name: 'Settings' },
  ];

  const loadEffect = (source) => () => {
    delete effect.editor;
    effect.source.set(source);
  };

  const loadScene = (source) => () => {
    delete scene.editor;
    rendering.input.reset();
    scene.source.set(source);
  };
  
  const setView = (id) => () => {
    $view = id;
  };
</script>

<div class="toolbar">
  <div>
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
          Examples
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
    border-left: 5px solid transparent;
    border-right: 5px solid transparent;
    border-top: 5px solid #fff;
  }

  .toggle, .action {
    box-sizing: border-box;
    width: 88px;
  }

  .toggle {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem;
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
    padding: 0.5rem 1rem;
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
    left: 0.5rem;
    right: 0.5rem;
    bottom: 0.25rem;
    height: 0.25rem;
    content: "";
    background: #393;
    cursor: default;
    border-radius: 0.25rem;
  }
</style>
