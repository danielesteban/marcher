<script>
  import { onDestroy } from 'svelte';

  export let text;

  let copied = false;
  let timer = null;
  const copy = () => {
    navigator.clipboard.writeText(text);
    copied = true;
    clearTimeout(timer);
    timer = setTimeout(() => {
      copied = false;
    }, 1000);
  };
  onDestroy(() => clearTimeout(timer));
</script>

<button on:click={copy}>
  {#if copied}
    Copied!
  {:else}
    <slot />
  {/if}
</button>

<style>
  button {
    box-sizing: border-box;
    background: #000;
    color: #fff;
    font-family: inherit;
    font-size: inherit;
    padding: 0.25rem 0.5rem;
    border-radius: 0.25rem;
    border: 0;
    outline: 0;
    cursor: pointer;
  }
  button:active {
    transform: translate(0, 1px);
  }
</style>
