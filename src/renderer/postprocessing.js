import Code from './postprocessing.wgsl';
import Light from '../lib/light.wgsl';
import Rotation from '../lib/rotation.wgsl';

class Postprocessing {
  constructor({ device, camera, format, time }) {
    this.device = device;
    this.camera = camera;
    this.format = format;
    this.time = time;
    this.descriptor = {
      colorAttachments: [{
        clearValue: { r: 0, g: 0, b: 0, a: 1 },
        loadOp: 'clear',
        storeOp: 'store',
      }],
    };
  }

  render(command, view) {
    const { bindings, descriptor, pipeline, uniforms } = this;
    descriptor.colorAttachments[0].view = view;
    const pass = command.beginRenderPass(descriptor);
    pass.setPipeline(pipeline);
    pass.setBindGroup(0, uniforms);
    pass.setBindGroup(1, bindings);
    pass.draw(6);
    pass.end();
  }
  
  bindTextures() {
    const { device, pipeline, textures } = this;
    if (!pipeline || !textures) {
      return;
    }
    this.bindings = device.createBindGroup({
      layout: pipeline.getBindGroupLayout(1),
      entries: [
        {
          binding: 0,
          resource: textures.color,
        },
        {
          binding: 1,
          resource: textures.data,
        },
        {
          binding: 2,
          resource: textures.position,
        },
      ],
    });
  }

  setEffect(effect) {
    const { device, camera, format, time } = this;
    this.code = [
      camera.constructor.WGSL,
      Code, Light, Rotation,
      '// __SOURCE__',
      effect,
    ].join('\n');
    this.module = device.createShaderModule({ code: this.code });
    this.pipeline = device.createRenderPipeline({
      layout: 'auto',
      vertex: {
        entryPoint: 'vertex',
        module: this.module,
      },
      fragment: {
        entryPoint: 'fragment',
        module: this.module,
        targets: [{ format }],
      },
      primitive: {
        topology: 'triangle-list',
      },
    });
    this.uniforms = device.createBindGroup({
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
    this.bindTextures();
  }

  setTextures({ color, data, position }) {
    this.textures = { color, data, position };
    this.bindTextures();
  }
}

export default Postprocessing;
