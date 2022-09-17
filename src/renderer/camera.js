import { glMatrix, mat4, vec3 } from 'gl-matrix';

const _worldUp = vec3.fromValues(0, 1, 0);

class Camera {
  constructor({ device, aspect = 1, fov = 75, near = 0.1, far = 10000 }) {
    this.device = device;
    this.data = new Float32Array(16 + 4 + 3 + 3);
    this.buffer = device.createBuffer({
      size: this.data.byteLength + Float32Array.BYTES_PER_ELEMENT,
      usage: GPUBufferUsage.COPY_DST | GPUBufferUsage.UNIFORM,
    });
    this.aspect = aspect;
    this.fov = fov;
    this.near = near;
    this.far = far;

    this.inverseMatrix = this.data.subarray(0, 16);
    this.position = this.data.subarray(16, 19);
    this.direction = this.data.subarray(20, 23);
    this.cone = this.data.subarray(23, 24);
    this.data[24] = near;
    this.data[25] = far;

    this.projectionMatrix = mat4.create();
    this.viewMatrix = mat4.create();
    this.target = vec3.create();
  }

  setSize(width, height) {
    const { fov } = this;
    this.aspect = width / height;
    this.cone[0] = (2 * Math.tan(glMatrix.toRadian(fov) / 2)) / height;
    this.updateProjection();
  }

  updateProjection() {
    const { projectionMatrix, aspect, fov, near, far } = this;
    mat4.perspective(projectionMatrix, glMatrix.toRadian(fov), aspect, near, far);
    this.updateBuffer();
  }

  updateView() {
    const { viewMatrix, direction, position, target } = this;
    vec3.normalize(direction, vec3.sub(direction, target, position));
    mat4.lookAt(viewMatrix, position, target, _worldUp);
    this.updateBuffer();
  }

  updateBuffer() {
    const { buffer, data, device, projectionMatrix, viewMatrix, inverseMatrix } = this;
    mat4.invert(inverseMatrix, mat4.multiply(inverseMatrix, projectionMatrix, viewMatrix));
    device.queue.writeBuffer(buffer, 0, data);
  }
}

Camera.WGSL = `
struct Camera {
  inverseMatrix : mat4x4<f32>,
  position : vec3<f32>,
  direction : vec3<f32>,
  cone : f32,
  near : f32,
  far : f32,
}
`;

export default Camera;
