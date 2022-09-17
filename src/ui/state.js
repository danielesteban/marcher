import { writable } from 'svelte/store';
import Effect1 from '../effects/effect1.wgsl';
import Effect2 from '../effects/effect2.wgsl';
import Effect3 from '../effects/effect3.wgsl';
import Effect4 from '../effects/effect4.wgsl';
import Scene1 from '../scenes/scene1.wgsl';
import Scene2 from '../scenes/scene2.wgsl';
import Scene3 from '../scenes/scene3.wgsl';
import Scene4 from '../scenes/scene4.wgsl';
import Scene5 from '../scenes/scene5.wgsl';

const persistentWritable = (key, defaultValue) => {
  key = `marcher:${key}`;
  const stored = localStorage.getItem(key);
  const { subscribe, set } = writable(stored ? JSON.parse(stored) : defaultValue);
  return {
    subscribe,
    set: (value) => {
      set(value);
      localStorage.setItem(key, JSON.stringify(value));
    },
  };
};

export const effects = [Effect1, Effect2, Effect3, Effect4];
export const effect = {
  errors: writable([]),
  source: persistentWritable('effect', effects[0]),
};

export const scenes = [Scene1, Scene2, Scene3, Scene4, Scene5];
export const scene = {
  errors: writable([]),
  source: persistentWritable('scene', scenes[0]),
};

export const rendering = {
  gpu: null,
  input: null,
  iterations: persistentWritable('iterations', 300),
  mode: persistentWritable('mode', 'raymarching'),
};

export const view = writable('scene');
