<script>
  import { dialogs, serialize } from '../state.js';
  import Clipboard from '../components/clipboard.svelte';
  import Dialog from '../components/dialog.svelte';
  import IPFS from '../ipfs.js';

  const publish = () => (
    IPFS()
      .then((ipfs) => ipfs.add(serialize()))
      .then((file) => {
        fetch(`https://ipfs.io/ipfs/${file.cid}`).catch(() => {});
        const url = new URL(location);
        url.hash = `#/ipfs:${file.cid}`;
        return url.toString();
      })
      .catch((e) => console.error(e))
  );
</script>

<Dialog state={dialogs.publish}>
  {#await publish()}
    <div class="heading">
      Publishing...
    </div>
  {:then link}
    <div class="heading">
      Successfully published!
    </div>
    <div class="link">
      {link}
    </div>
    <div class="actions">
      <Clipboard text={link}>
        Copy link
      </Clipboard>
    </div>
  {/await}
</Dialog>

<style>
  .heading {
    font-size: 1.5em;
    line-height: 1.25rem;
    text-align: center;
  }
  .link {
    background: #000;
    padding: 0.25rem 0.5rem;
    border-radius: 0.25rem;
    text-align: center;
    text-overflow: ellipsis;
    overflow: hidden;
    white-space: nowrap;
    user-select: all;
  }
  .actions {
    text-align: center;
  }
</style>
