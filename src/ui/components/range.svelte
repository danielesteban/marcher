<script>
  export let id;
  export let max;
  export let min;
  export let step;
  export let state;
  const update = ({ target: { value } }) => {
    $state = parseFloat(value);
  };
</script>

<input
  type="range"
  id={id}
  max={max} min={min} step={step}
  on:input={update} value={$state}
/>

<style>
  input {
    box-sizing: border-box;
    display: block;
    width: 100%;
    accent-color: #000;
    border: 0;
    outline: 0;
  }
</style>
