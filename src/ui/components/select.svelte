<script>
  export let id;
  export let options;
  export let state;
</script>

<select id={id} bind:value={$state}>
  {#each options as { id, name }}
    <option value={id}>{name}</option>
  {/each}
</select>

<style>
  select {
    box-sizing: border-box;
    display: block;
    width: 100%;
    background: #000;
    color: #fff;
    font-family: inherit;
    font-size: inherit;
    padding: 0.25rem 0.5rem;
    border-radius: 0.25rem;
    border: 0;
    outline: 0;
  }
</style>
