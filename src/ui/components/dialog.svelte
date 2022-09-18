<script>
  export let state;
  let overlay;
  const close = ({ target }) => {
    if (target === overlay) {
      $state = false;
    }
  };
</script>

{#if $state}
  <div class="overlay" bind:this={overlay} on:mousedown={close}>
    <div class="wrapper">
      <slot />
    </div>
  </div>
{/if}

<style>
  @keyframes fade {
    from {
      backdrop-filter: blur(0px);
      background: rgba(0, 0, 0, 0);
      opacity: 0;
    }
    to {
      backdrop-filter: blur(8px);
      background: rgba(0, 0, 0, 0.5);
      opacity: 1;
    }
  }

  .overlay {
    animation: fade 0.25s forwards;
    position: fixed;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    z-index: 1;
  }

  .wrapper {
    position: absolute;
    top: 45%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: #1e1e1e;
    border-radius: 0.5rem;
    box-shadow: 0 0 0.5rem rgba(0, 0, 0, 0.2);
  }
</style>
