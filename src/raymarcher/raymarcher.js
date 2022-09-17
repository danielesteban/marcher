import Code from './raymarcher.wgsl';
import Color from '../lib/color.wgsl';
import Noise from '../lib/noise.wgsl';
import Rotation from '../lib/rotation.wgsl';
import SDF from '../lib/sdf.wgsl';

class Raymarcher {
  constructor(renderer) {
    this.renderer = renderer;
  }

  render(pass) {
    const { bindings, pipeline } = this;
    pass.setPipeline(pipeline);
    pass.setBindGroup(0, bindings);
    pass.draw(6);
  }

  setMaxIterations(count) {
    this.maxIterations = count;
    this.updatePipeline();
  }

  setMode(mode) {
    this.mode = mode;
    this.updatePipeline();
  }

  setScene(scene) {
    this.scene = scene;
    this.updatePipeline();
  }

  updatePipeline() {
    const { renderer: { camera, device, time }, maxIterations, mode, scene } = this;
    if (!maxIterations || !mode || !scene) {
      return;
    }
    this.code = [
      `const maxIterations : u32 = ${maxIterations};`,
      camera.constructor.WGSL,
      Code, Color, Noise, Rotation, SDF,
      '// __SOURCE__',
      scene,
    ].join('\n');
    this.module = device.createShaderModule({ code: this.code });
    this.pipeline = device.createRenderPipeline({
      layout: 'auto',
      vertex: {
        entryPoint: 'vertex',
        module: this.module,
      },
      fragment: {
        entryPoint: mode,
        module: this.module,
        targets: [
          { format: 'rgba32float' },
          { format: 'rgba32float' },
          { format: 'rgba32float' },
        ],
      },
      primitive: {
        topology: 'triangle-list',
      },
    });
    this.bindings = device.createBindGroup({
      layout: this.pipeline.getBindGroupLayout(0),
      entries: [
        {
          binding: 0,
          resource: { buffer: camera.buffer },
        },
        {
          binding: 1,
          resource: { buffer: time },
        },
      ],
    });
  }
}

export default Raymarcher;
