<script>
  import { dialogs } from '../state.js';
  const { fetch } = dialogs;
</script>

{#if $fetch}
  <div class="wrapper">
    Fetching: <span>{$fetch}</span>
  </div>
{/if}

<style>
  @keyframes pop {
    from {
      transform: translate(-50%, -100%);
    }
    to {
      transform: translate(-50%, 0);
    }
  }

  .wrapper {
    animation: pop 0.25s forwards;
    position: absolute;
    top: 0;
    left: 50%;
    gap: 1rem;
    box-sizing: border-box;
    padding: 1rem;
    backdrop-filter: blur(8px);
    background: rgba(30, 30, 30, 0.5);
    border-radius: 0 0 0.5rem 0.5rem;
    box-shadow: 0 0 0.5rem rgba(0, 0, 0, 0.2);
    white-space: nowrap;
  }
  
  .wrapper > span {
    color: #bbb;
  }
</style>
