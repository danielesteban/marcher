<script>
  import { onMount } from 'svelte';
  import { effect, scene, rendering } from './state.js';
  import Camera from '../renderer/camera.js';
  import Input from './input.js';
  import Raymarcher from '../raymarcher/raymarcher.js';
  import Renderer from '../renderer/renderer.js';

  let viewport;
  onMount(() => {
    const { adapter, device } = rendering.gpu;
    const camera = new Camera({ device });
    const input = new Input({ camera, target: viewport });
    const renderer = new Renderer({ adapter, camera, device });
    viewport.appendChild(renderer.canvas);

    const raymarcher = new Raymarcher(renderer);
    renderer.scene.push(raymarcher);

    const time = new Float32Array([performance.now() / 1000]);
    document.addEventListener('visibilitychange', () => {
      if (document.visibilityState === 'visible') {
        time[0] = performance.now() / 1000;
      }
    }, false);

    let hasError = false;

    const animate = () => {
      requestAnimationFrame(animate);

      const clock = performance.now() / 1000;
      const delta = Math.min(clock - time[0], 1);
      time[0] = clock;

      if (hasError) {
        return;
      }

      input.update(delta);
      device.queue.writeBuffer(renderer.time, 0, time);

      const command = device.createCommandEncoder();
      renderer.render(command);
      device.queue.submit([command.finish()]);
    };

    const processModuleErrors = ({ code, module }, state) => {
      hasError = false;
      const lines = code.split('\n');
      const lineOffset = lines.indexOf('// __SOURCE__') + 1;
      module.compilationInfo().then(({ messages }) => (
        state.set(messages.map(({ length, lineNum, linePos, message, type }) => {
          hasError = true;
          return {
            line: lines[lineNum - 1],
            lineNum: lineNum - lineOffset,
            linePos,
            length,
            message,
            pointer: Array.from({ length: linePos - 1 + length }, (v, i) => (
              i >= (linePos - 1) ? '^' : ' '
            )).join(''),
            type,
          };
        }))
      ));
    };

    rendering.input = input;
    const subscriptions = [
      rendering.iterations.subscribe((count) => raymarcher.setMaxIterations(count)),
      rendering.mode.subscribe((mode) => raymarcher.setMode(mode)),
      rendering.resolution.subscribe((resolution) => {
        renderer.resolution = Math.pow(0.5, Math.floor((1 - resolution) * 6));
        renderer.setSize(input.bounds.width, input.bounds.height);
      }),
      effect.source.subscribe((source) => {
        renderer.postprocessing.setEffect(source);
        processModuleErrors(renderer.postprocessing, effect.errors);
      }),
      scene.source.subscribe((source) => {
        raymarcher.setScene(source);
        processModuleErrors(raymarcher, scene.errors);
      }),
    ];

    requestAnimationFrame(animate);

    window.addEventListener('resize', () => {
      input.updateBounds();
      renderer.setSize(input.bounds.width, input.bounds.height);
    }, false);

    return () => {
      subscriptions.forEach((unsubscribe) => unsubscribe());
      rendering.input = null;
    }
  });
</script>

<div class="viewport" bind:this={viewport} />

<style>
  .viewport {
    overflow: hidden;
  }
</style>
