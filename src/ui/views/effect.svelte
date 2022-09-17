<script>
  import { effect } from '../state.js';
  import Editor from '../components/editor.svelte';
</script>

<Editor state={effect} />
