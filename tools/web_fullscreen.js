// GameMaker's official clickable DOM button calls a preserved gmcallback_* name.
// Run the Fullscreen API synchronously in that click, then feed confirmed browser
// state back to the engine. The GML callback owns the room/controls guard.
function installMenuFullscreen(win, doc) {
    const name = "gml_Script_gmcallback_menu_fullscreen";
    const engine = win[name];
    const canvas = doc.getElementById("canvas");
    const container = doc.getElementById("gm4html5_div_id");
    if (typeof engine !== "function" || !canvas || !container) return false;
    const active = () => (doc.fullscreenElement || doc.webkitFullscreenElement) === container;
    let initialized = false;
    function sync() {
        if (!initialized) return;
        const full = active();
        const maxWidth = Math.max(1, win.innerWidth);
        const maxHeight = Math.max(1, win.innerHeight);
        const scale = full ? Math.min(maxWidth / 960, maxHeight / 570)
                          : Math.min(1, maxWidth / 960, maxHeight / 570);
        const width = Math.max(1, Math.floor(960 * scale));
        const height = Math.max(1, Math.floor(570 * scale));
        const density = Math.max(1, win.devicePixelRatio || 1);
        // Resize the actual engine canvas before CSS size so SDF text is drawn
        // at screen resolution, including Retina/high DPI browser displays.
        engine(null, null, "changed", full, Math.round(width * density), Math.round(height * density), density);
        canvas.style.width = width + "px";
        canvas.style.height = height + "px";
    }
    win[name] = function () {
        if (!engine(null, null, "can_toggle", active(), 0, 0)) return false;
        initialized = true;
        let result;
        try {
            if (active()) {
                const exit = doc.exitFullscreen || doc.webkitExitFullscreen;
                if (exit) result = exit.call(doc);
            } else {
                const request = container.requestFullscreen || container.webkitRequestFullscreen;
                if (request) result = request.call(container);
            }
            if (result && result.catch) result.catch(sync);
        } catch (_) { sync(); }
        return false;
    };
    doc.addEventListener("fullscreenchange", sync);
    doc.addEventListener("webkitfullscreenchange", sync);
    win.addEventListener("resize", sync);
    function waitForMenu() {
        if (initialized) return;
        try {
            if (engine(null, null, "ready")) {
                initialized = true;
                sync();
                return;
            }
        } catch (_) {
            // GameMaker_Init can still be loading resources/managers.
        }
        win.requestAnimationFrame(waitForMenu);
    }
    // The initial menu may appear after asynchronous resource loading. Do not
    // query it before the load handler starts GameMaker_Init, or rely on a resize.
    const start = () => win.requestAnimationFrame(waitForMenu);
    if (doc.readyState === "complete") start();
    else win.addEventListener("load", start, { once: true });
    return true;
}

if (typeof module !== "undefined") module.exports = { installMenuFullscreen };
else window.addEventListener("DOMContentLoaded", () => installMenuFullscreen(window, document));
