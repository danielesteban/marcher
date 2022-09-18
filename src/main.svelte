<script>
  import { rendering } from './ui/state.js';
  import App from './ui/app.svelte';
  import Embed from './ui/embed.svelte';
  
  let hasError = false;
  let isLoading = true;

  Promise.all([
    (async () => {
      if (!navigator.gpu) {
        throw new Error('WebGPU support');
      }
      const adapter = await navigator.gpu.requestAdapter();
      if (!adapter) {
        throw new Error('WebGPU adapter');
      }
      const device = await adapter.requestDevice();
      return { adapter, device };
    })(),
    new Promise((resolve, reject) => {
      const config = { paths: { 'vs': 'https://cdn.jsdelivr.net/npm/monaco-editor@0.34.0/min/vs' }};
      const script = document.createElement('script');
      script.onload = () => {
        require.config(config);
        require(['vs/editor/editor.main'], resolve);
      };
      script.onerror = reject;
      script.src = `${config.paths.vs}/loader.js`;
      document.head.appendChild(script);
    }),
  ])
    .then(([gpu]) => {
      rendering.gpu = gpu;
    })
    .catch((e) => {
      console.error(e);
      hasError = true;
    })
    .finally(() => {
      isLoading = false;
    });
</script>

{#if isLoading}
  <div class="loading">Loading...</div>
{:else if hasError}
  <div class="support">
    Sorry! You'll need to try this in a browser with WebGPU support like <a href="https://www.google.com/chrome" rel="noopener noreferrer" target="_blank">Chrome</a>.
  </div>
{:else if window !== window.top}
  <Embed />
{:else}
  <App />
{/if}

<div class="info">
  marcher - <a href="https://github.com/danielesteban/marcher" rel="noopener noreferrer" target="_blank">view source</a><br />
  <a href="https://dani.gatunes.com" rel="noopener noreferrer" target="_blank">dani@gatunes</a> © 2022
</div>
<a class="ribbon" href="https://github.com/sponsors/danielesteban" data-ribbon="♥ Become a sponsor" rel="noopener noreferrer" target="_blank">
  ♥ Become a sponsor
</a>

<style>
  :global(:root) {
    font-size: 16px;
  }

  :global(body) {
    margin: 0;
    background: #000;
    color: #fff;
    cursor: default;
    user-select: none;
    overflow: hidden;
    font-family: 'Roboto Condensed', monospace;
    font-size: 0.75rem;
    line-height: 1.125rem;
  }

  :global(canvas) {
    vertical-align: middle;
  }

  :global(::-webkit-scrollbar) {
    width: 8px;
    background-color: rgba(0, 0, 0, 0);
  }

  :global(::-webkit-scrollbar:hover) {
    background-color: rgba(0, 0, 0, 0);
  }

  :global(::-webkit-scrollbar-thumb:vertical) {
    background: #444;
    border-radius: 100px;
  }

  :global(::-webkit-scrollbar-thumb:vertical:active) {
    background: #555;
  }

  .support, .loading {
    position: absolute;
    bottom: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
  }

  .support > a, .info > a {
    color: inherit;
  }

  .info {
    position: absolute;
    bottom: 1rem;
    right: 1rem;
    text-align: right;
    opacity: 0.6;
  }

  .ribbon {
    width: 12.1em;
    height: 12.1em;
    position: absolute;
    overflow: hidden;
    top: 0;
    right: 0;
    pointer-events: none;
    text-decoration: none;
    text-indent: -999999px;
  }

  .ribbon:before, .ribbon:after {
    position: absolute;
    display: block;
    width: 15.38em;
    height: 1.54em;
    top: 3.23em;
    right: -3.23em;
    box-sizing: content-box;
    transform: rotate(45deg);
  }

  .ribbon:before {
    content: "";
    padding: .38em 0;
    background-color: #393;
    background-image: linear-gradient(to bottom, rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.15));
    box-shadow: 0 .15em .23em 0 rgba(0, 0, 0, 0.5);
    pointer-events: auto;
  }

  .ribbon:after {
    content: attr(data-ribbon);
    color: #fff;
    line-height: 1.54em;
    text-decoration: none;
    text-shadow: 0 -.08em rgba(0, 0, 0, 0.5);
    text-align: center;
    text-indent: 0;
    padding: .15em 0;
    margin: .15em 0;
    border-width: .08em 0;
    border-style: dotted;
    border-color: #fff;
    border-color: rgba(255, 255, 255, 0.7);
  }
</style>
