let node;

export default () => {
  if (node) {
    return Promise.resolve(node);
  }
  return (new Promise((resolve, reject) => {
    const script = document.createElement('script');
    script.type = 'text/javascript';
    script.onload = resolve;
    script.onerror = reject;
    script.src = 'https://cdn.jsdelivr.net/npm/ipfs-core@0.16.0/dist/index.min.js';
    document.head.appendChild(script);
  }))
    .then(() => window.IpfsCore.create({
      repo: String(Math.random() + Date.now()),
      init: { alogorithm: 'ed25519' }
    }))
    .then((ipfs) => {
      node = ipfs;
      return ipfs;
    });
}
