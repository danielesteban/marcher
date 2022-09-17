<script>
  export let id;
  export let max;
  export let min;
  export let step;
  export let state;
  const update = ({ target: { value } }) => {
    $state = parseInt(value, 10);
  };
</script>

<input
  type="number"
  id={id}
  max={max} min={min} step={step}
  on:input={update} value={$state}
/>

<style>
  input {
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
