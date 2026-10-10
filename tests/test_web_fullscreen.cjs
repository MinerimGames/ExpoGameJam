const test = require('node:test');
const assert = require('node:assert/strict');
const { installMenuFullscreen } = require('../tools/web_fullscreen.js');

function page(allowed = true, options = {}) {
  const events = new Map();
  const calls = [];
  const frames = [];
  const canvas = { style: {} };
  const container = { requestFullscreen() { calls.push('request'); return Promise.resolve(); } };
  const doc = {
    readyState: 'loading',
    fullscreenElement: null,
    getElementById(id) { return id === 'canvas' ? canvas : container; },
    exitFullscreen() { calls.push('exit'); return Promise.resolve(); },
    addEventListener(name, fn) { events.set(name, fn); }
  };
  const win = {
    innerWidth: 1920, innerHeight: 1080, devicePixelRatio: 2,
    startupReady: options.ready !== false,
    addEventListener(name, fn) { events.set(name, fn); },
    requestAnimationFrame(fn) { frames.push(fn); },
    gml_Script_gmcallback_menu_fullscreen(self, other, action, full, width, height, density) {
      calls.push([action, full, width, height, density]);
      return action === 'ready' ? win.startupReady : allowed;
    }
  };
  installMenuFullscreen(win, doc);
  const nextFrame = () => { const frame = frames.shift(); if (frame) frame(); };
  if (options.boot !== false && events.has('load')) { events.get('load')(); nextFrame(); calls.length = 0; }
  return { win, doc, calls, canvas, container, events, frames, nextFrame };
}

test('trusted menu callback requests fullscreen synchronously', () => {
  const p = page();
  p.win.gml_Script_gmcallback_menu_fullscreen(null, null);
  assert.ok(p.calls.includes('request'), 'Fullscreen request must happen before the click callback returns');
});

test('room or controls guard prevents fullscreen requests', () => {
  const p = page(false);
  p.win.gml_Script_gmcallback_menu_fullscreen(null, null);
  assert.ok(!p.calls.includes('request'));
});

test('clicking again exits fullscreen rather than entering twice', () => {
  const p = page(); p.doc.fullscreenElement = p.container;
  p.win.gml_Script_gmcallback_menu_fullscreen(null, null);
  assert.ok(p.calls.includes('exit'));
  assert.ok(!p.calls.includes('request'));
});

test('browser fullscreen event updates label and high DPI canvas with preserved aspect', () => {
  const p = page(); p.doc.fullscreenElement = p.container;
  assert.ok(p.events.has('fullscreenchange'));
  p.events.get('fullscreenchange')();
  const changed = p.calls.find(c => Array.isArray(c) && c[0] === 'changed');
  assert.equal(changed[1], true);
  assert.ok(Math.abs(changed[2] / changed[3] - 640 / 380) < .005);
  assert.ok(changed[3] >= 2160, 'SDF renderer receives physical pixels, not a CSS-upscaled low resolution canvas');
  assert.equal(p.canvas.style.height, '1080px');
});

test('Escape/fullscreen exit restores windowed rendering dimensions', () => {
  const p = page();
  assert.ok(p.events.has('fullscreenchange')); p.events.get('fullscreenchange')();
  const changed = p.calls.find(c => Array.isArray(c) && c[0] === 'changed');
  assert.equal(changed[1], false);
  assert.deepEqual(changed.slice(2,4), [1920, 1140]);
  assert.equal(p.canvas.style.width, '960px');
});

test('DPI two is passed to the engine so DOM hitbox uses CSS pixels', () => {
  const p = page(); p.doc.fullscreenElement = p.container;
  p.events.get('fullscreenchange')();
  const changed = p.calls.find(c => Array.isArray(c) && c[0] === 'changed');
  assert.equal(changed[4], 2, 'DOM clickable size must divide the engine physical width by browser density');
});

test('small viewport startup waits for menu readiness and aligns without a resize event', () => {
  const p = page(true, {ready:false, boot:false});
  p.win.innerWidth = 700; p.win.innerHeight = 420;
  assert.ok(p.events.has('load'), 'Startup must begin after GameMaker_Init on load');
  assert.equal(p.calls.length, 0, 'No engine calls before load');
  p.events.get('load')(); p.nextFrame();
  assert.ok(!p.calls.some(c => Array.isArray(c) && c[0] === 'changed'));
  assert.ok(p.frames.length > 0, 'Readiness is checked again while resources load');
  p.win.startupReady = true; p.nextFrame();
  const changed = p.calls.find(c => Array.isArray(c) && c[0] === 'changed');
  assert.deepEqual(changed.slice(2), [1400,830,2]);
  assert.equal(p.canvas.style.width, '700px');
  assert.equal(p.canvas.style.height, '415px');
  assert.ok(!p.calls.some(c => c === 'request' || (Array.isArray(c) && c[0] === 'can_toggle')),
            'Readiness must not play selection audio or request fullscreen');
  assert.equal(p.frames.length, 0, 'Startup polling stops after first successful sync');
});
