import Postprocessing from './postprocessing.js';

class Renderer {
  constructor({ adapter, camera, device }) {
    const format = navigator.gpu.getPreferredCanvasFormat(adapter);
    this.camera = camera;
    this.device = device;
    this.canvas = document.createElement('canvas');
    this.canvas.style.imageRendering = 'pixelated';
    this.context = this.canvas.getContext('webgpu');
    this.descriptor = {
      colorAttachments: [
        {
          clearValue: { r: 0, g: 0, b: 0, a: 1 },
          loadOp: 'clear',
          storeOp: 'store',
        },
        {
          clearValue: { r: 0, g: 0, b: 0, a: camera.far },
          loadOp: 'clear',
          storeOp: 'store',
        },
        {
          clearValue: { r: 0, g: 0, b: 0, a: 0 },
          loadOp: 'clear',
          storeOp: 'store',
        },
      ],
    };
    this.time = device.createBuffer({
      size: Float32Array.BYTES_PER_ELEMENT,
      usage: GPUBufferUsage.COPY_DST | GPUBufferUsage.UNIFORM,
    });
    this.postprocessing = new Postprocessing({ device, camera, format, time: this.time });
    this.resolution = 1;
    this.scene = [];
    this.textures = new Map();
    // I have no idea why but if I don't do this, it crashes with:
    // D3D12 reset command allocator failed with E_FAIL
    this.setSize(window.innerWidth, window.innerHeight);
    this.context.configure({ alphaMode: 'opaque', device, format });
  }

  render(command) {
    const { context, descriptor, postprocessing, scene } = this;
    const pass = command.beginRenderPass(descriptor);
    scene.forEach((object) => object.render(pass));
    pass.end();
    postprocessing.render(command, context.getCurrentTexture().createView());
  }

  setSize(width, height, pixelRatio = (window.devicePixelRatio || 1)) {
    const { camera, canvas, descriptor, postprocessing, resolution } = this;
    const size = [
      Math.max(Math.floor(width * pixelRatio * resolution), 1),
      Math.max(Math.floor(height * pixelRatio * resolution), 1),
    ];
    canvas.width = size[0];
    canvas.height = size[1];
    canvas.style.width = `${width}px`;
    canvas.style.height = `${height}px`;
    camera.setSize(size[0], size[1]);

    this.updateTexture(descriptor.colorAttachments[0], 'rgba32float', 'color', size);
    this.updateTexture(descriptor.colorAttachments[1], 'rgba32float', 'data', size);
    this.updateTexture(descriptor.colorAttachments[2], 'rgba32float', 'position', size);
    postprocessing.setTextures({
      color: descriptor.colorAttachments[0].view,
      data: descriptor.colorAttachments[1].view,
      position: descriptor.colorAttachments[2].view,
    });
  }

  updateTexture(object, format, key, size) {
    const { device, textures } = this;
    const current = textures.get(key);
    if (current) {
      current.destroy();
    }
    const texture = device.createTexture({
      format,
      size,
      usage: GPUTextureUsage.RENDER_ATTACHMENT | GPUTextureUsage.TEXTURE_BINDING,
    });
    object.view = texture.createView();
    textures.set(key, texture);
  }
}

export default Renderer;
