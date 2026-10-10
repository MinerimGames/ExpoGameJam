// Execute the production GML helper's JavaScript-compatible arithmetic/functions
// against fixed engine boundary values. Actual exported browser clicks are also
// covered by tools/web_release_smoke.cjs; this file does not emulate the game.
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const source = fs.readFileSync(require('node:path').join(__dirname,
  '../scripts/gmcallback_menu_fullscreen/gmcallback_menu_fullscreen.gml'), 'utf8');

function pointer({browser=true,density=2,x=169,y=176,gui=[640,380],surface=[0,0,1400,830]}={}) {
  const context = {
    os_browser: browser ? 0 : -1, browser_not_a_browser: -1,
    global: density === undefined ? {} : {menu_browser_density:density},
    variable_global_exists(name) { return Object.hasOwn(context.global,name); },
    device_mouse_x_to_gui() { return x; }, device_mouse_y_to_gui() { return y; },
    display_get_gui_width() { return gui[0]; }, display_get_gui_height() { return gui[1]; },
    application_get_position() { return surface; }, max:Math.max
  };
  vm.createContext(context); vm.runInContext(source,context);
  return [context.ui_mouse_x_to_gui(0),context.ui_mouse_y_to_gui(0)];
}

test('DPI two canvas click reaches the visible controls button', () => {
  const [x,y]=pointer();
  assert.ok(x>=238 && x<=402 && y>=341 && y<=365,
    `Visible controls click was converted outside its GUI button: ${x},${y}`);
});

test('battle GUI letterbox offset is corrected in physical pixels exactly once', () => {
  assert.deepEqual(pointer({x:224,y:126,gui:[960,540],surface:[40,20,1240,620]}),[480,270]);
});

test('native pointer stays unchanged even if browser density state exists', () => {
  assert.deepEqual(pointer({browser:false,density:2,x:728,y:350}),[728,350]);
});

test('DPI one preserves pointer and off-canvas coordinates are not clamped', () => {
  assert.deepEqual(pointer({density:1,x:-27,y:399}),[-27,399]);
  assert.deepEqual(pointer({density:2,x:-27,y:399}),[-54,798]);
});
