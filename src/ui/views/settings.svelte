<script>
  import { rendering } from '../state.js';
  import Number from '../components/number.svelte';
  import Select from '../components/select.svelte';

  const { iterations, mode } = rendering;
  const controls = [
    { id: 'W', name: 'Move forwards'},
    { id: 'A', name: 'Move leftwards'},
    { id: 'S', name: 'Move backwards'},
    { id: 'D', name: 'Move rightwards'},
    { id: 'Q', name: 'Move downwards'},
    { id: 'E', name: 'Move upwards'},
    { id: 'R', name: 'Reset camera'},
    { id: 'Shift', name: 'Double movement speed'},
    { id: 'Wheel', name: 'Set movement speed'},
  ];
  const modes = [
    { id: 'raymarching', name: 'Raymarching (better performance)'},
    { id: 'conetracing', name: 'Conetracing (better antialiasing)'},
  ];
  const reference = [
    {
      name: 'Color',
      items: [
        'fn hsl2Rgb(hsl : vec3<f32>) -> vec3<f32>',
      ],
    },
    {
      name: 'Light',
      items: [
        'struct Light { position : vec3<f32>, diffuse : vec3<f32>, specular : vec3<f32> }',
        'fn getAttenuation(dist : f32, constant : f32, linear : f32, quadratic : f32) -> f32',
        'fn getDirectLight(light : Light, normal : vec3<f32>, position : vec3<f32>, shininess : f32) -> vec3<f32>',
      ],
    },
    {
      name: 'Noise',
      items: [
        'fn SimplexNoise(v : vec3<f32>) -> f32',
      ],
    },
    {
      name: 'Rotation',
      items: [
        'const PI : f32',
        'fn rotateX(radians : f32) -> mat3x3<f32>',
        'fn rotateY(radians : f32) -> mat3x3<f32>',
        'fn rotateZ(radians : f32) -> mat3x3<f32>',
        'fn spherical(phi : f32, theta : f32, radius : f32) -> vec3<f32>',
      ],
    },
    {
      name: 'SDF',
      items: [
        'struct SDF { color : vec3<f32>, distance : f32 }',
        'fn opUnion(a : SDF, b : SDF) -> SDF',
        'fn opSubstraction(a : SDF, b : SDF) -> SDF',
        'fn opSmoothUnion(a : SDF, b : SDF, k : f32) -> SDF',
        'fn opSmoothSubstraction(a : SDF, b : SDF, k : f32) -> SDF',
        'fn sdBox(p : vec3<f32>, r : vec3<f32>) -> f32',
        'fn sdCapsule(p : vec3<f32>, r : vec2<f32>) -> f32',
        'fn sdEllipsoid(p : vec3<f32>, r : vec3<f32>) -> f32',
        'fn sdPlane(p : vec3<f32>, n : vec3<f32>, h : f32) -> f32',
        'fn sdSphere(p : vec3<f32>, r : f32) -> f32',
        'fn sdTorus(p : vec3<f32>, r : vec2<f32>) -> f32',
      ],
    },
    {
      name: 'Uniforms',
      items: [
        'struct Camera {',
        'inverseMatrix : mat4x4<f32>,',
        'position : vec3<f32>,',
        'direction : vec3<f32>,',
        'cone : f32,',
        'near : f32,',
        'far : f32,',
        '}',
        'var<uniform> camera : Camera;',
        'var<uniform> time : f32;',
      ],
    },
  ];
</script>

<div class="wrapper">
  <div class="input">
    <label for="mode">Mode:</label>
    <Select id="mode" options={modes} state={mode} />
  </div>
  <div class="input">
    <label for="iterations">Max iterations:</label>
    <Number id="iterations" state={iterations} step={100} min={100} max={1000} />
  </div>
  <div class="heading">Reference</div>
  <div class="reference">
    {#each reference as { name, items }}
      <div>
        <div>{name}</div>
        <div>
          {#each items as item}
            <div>{item}</div>
          {/each}
        </div>
      </div>
    {/each}
  </div>
  <div class="heading">Controls</div>
  <div class="controls">
    {#each controls as { id, name }}
      <div>
        <div>{id}</div>
        <div>{name}</div>
      </div>
    {/each}
  </div>
</div>

<style>
  .wrapper {
    background-color: #1e1e1e;
    padding: 1rem 0;
    overflow: hidden;
    overflow-y: overlay;
  }

  .input {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem 1rem;
  }

  .input > label {
    color: #bbb;
    width: 10rem;
  }

  .heading {
    margin-top: 1rem;
    display: flex;
    padding: 0.5rem 1rem;
    background: #2A2A2A;
  }

  .reference {
    color: #eee;
    padding: 1rem 1rem 0;
    white-space: nowrap;
    user-select: text;
  }

  .reference > div {
    margin-bottom: 0.5rem;
  }

  .reference > div > div:first-child {
    color: #bbb;
  }

  .controls {
    color: #eee;
    padding: 1rem 0;
  }

  .controls > div {
    display: flex;
  }

  .controls > div > div:first-child {
    color: #bbb;
    display: flex;
    width: 4rem;
    justify-content: center;
  }
</style>
