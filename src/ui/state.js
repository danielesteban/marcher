import { get, writable } from 'svelte/store';
import Effect1 from '../effects/effect1.wgsl';
import Effect2 from '../effects/effect2.wgsl';
import Effect3 from '../effects/effect3.wgsl';
import Effect4 from '../effects/effect4.wgsl';
import Scene1 from '../scenes/scene1.wgsl';
import Scene2 from '../scenes/scene2.wgsl';
import Scene3 from '../scenes/scene3.wgsl';
import Scene4 from '../scenes/scene4.wgsl';
import Scene5 from '../scenes/scene5.wgsl';

let isFromRouter = false;

const persistentWritable = (key, defaultValue) => {
  key = `marcher:${key}`;
  const stored = localStorage.getItem(key);
  const { subscribe, set } = writable(stored ? JSON.parse(stored) : defaultValue);
  return {
    subscribe,
    set: (value) => {
      set(value);
      localStorage.setItem(key, JSON.stringify(value));
      if (!isFromRouter && location.hash.slice(2)) {
        location.hash = '/';
      }
    },
  };
};

export const dialogs = {
  publish: writable(false),
};
export const view = writable('scene');
export const version = 1;

export const effects = [Effect1, Effect2, Effect3, Effect4];
export const effect = {
  editor: null,
  errors: writable([]),
  source: persistentWritable('effect', effects[0]),
};

export const scenes = [Scene1, Scene2, Scene3, Scene4, Scene5];
export const scene = {
  editor: null,
  errors: writable([]),
  source: persistentWritable('scene', scenes[0]),
};

export const rendering = {
  gpu: null,
  input: null,
  iterations: persistentWritable('iterations', 300),
  mode: persistentWritable('mode', 'raymarching'),
  resolution: persistentWritable('resolution', 1),
};

export const deserialize = (data) => {
  if (data.version !== version) {
    throw new Error('version');
  }
  effect.editor = null;
  effect.source.set(data.effect);
  scene.editor = null;
  scene.source.set(data.scene);
  rendering.iterations.set(data.iterations);
  rendering.mode.set(data.mode);
  rendering.resolution.set(data.resolution);
  if (rendering.input) rendering.input.reset();
};

export const serialize = () => {
  const blob = new Blob([JSON.stringify({
    effect: get(effect.source),
    scene: get(scene.source),
    iterations: get(rendering.iterations),
    mode: get(rendering.mode),
    resolution: get(rendering.resolution),
    version,
  })], { type: 'application/json' });
  const now = new Date();
  const f = (v) => ('00' + v).slice(-2);
  const date = `${f(now.getMonth() + 1)}${f(now.getDate())}`;
  const time = `${f(now.getHours())}${f(now.getMinutes())}`;
  return {
    path: `marcher-${date}${time}.json`,
    content: blob,
  };
};

const Router = () => {
  const [type, id] = location.hash.slice(2).split('/')[0].split(':');
  if (type === 'ipfs' && id) {
    dialogs.publish.set(false);
    fetch(`https://ipfs.io/ipfs/${id}`)
      .then((res) => res.json())
      .then((data) => {
        isFromRouter = true;
        try {
          deserialize(data);
        } finally {
          isFromRouter = false;
        }
      })
      .catch((e) => console.error(e));
  }
};
window.addEventListener('hashchange', Router, false);
Router();
