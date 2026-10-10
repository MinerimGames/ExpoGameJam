// Exercise the exported game in an isolated browser, without a user profile.
const { chromium } = require('C:/Users/jrhre/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const fs = require('fs');
const path = require('path');
const http = require('http');
(async () => {
  const output = path.resolve(process.env.WEB_SMOKE_OUTPUT || (process.env.WEB_SCENE_FIXTURE?'output/revision-20261009/web-scenes':'output/revision-20261009/web-smoke'));
  fs.mkdirSync(output, { recursive: true });
  const webRoot = path.resolve(process.env.WEB_SMOKE_ROOT || 'dist/ParadoxoDeWilson-Final-20261009/Web');
  const mime = {'.html':'text/html','.js':'text/javascript','.png':'image/png','.ogg':'audio/ogg','.mp3':'audio/mpeg','.wav':'audio/wav','.ico':'image/x-icon'};
  const server = http.createServer((req,res)=>{
    const url = new URL(req.url,'http://localhost');
    const relative = url.pathname==='/'?'/index.html':decodeURIComponent(url.pathname);
    const file = path.resolve(webRoot,'.'+relative);
    if (!file.startsWith(webRoot+path.sep) || !fs.existsSync(file) || !fs.statSync(file).isFile()) {
      res.writeHead(404);res.end();return;
    }
    res.writeHead(200,{'Content-Type':mime[path.extname(file)] || 'application/octet-stream','Cache-Control':'no-store'});
    fs.createReadStream(file).pipe(res);
  });
  await new Promise(resolve=>server.listen(0,'127.0.0.1',resolve));
  const browser = await chromium.launch({ channel: 'msedge', headless: true });
  const page = await browser.newPage({ viewport: { width: 1280, height: 800 } });
  const report = { errors: [], failedRequests: [], console: [], responses: [], checks: [] };
  page.on('pageerror', error => report.errors.push(error.message));
  page.on('console', msg => report.console.push({type:msg.type(), text:msg.text()}));
  const sceneCaptures=[];
  if(process.env.WEB_SCENE_FIXTURE) page.on('console',msg=>{
    const match=msg.text().match(/^WEB_SCENE:(\d)$/);
    if(match) sceneCaptures.push(page.waitForTimeout(100).then(()=>page.screenshot({path:path.join(output,`scene-${match[1]}.png`)})));
  });
  page.on('requestfailed', req => report.failedRequests.push({url:req.url(), failure:req.failure()}));
  page.on('response', response => { if (response.status() >= 400) report.responses.push({url:response.url(),status:response.status()}); });
  async function alignedFullscreenButton(target, name) {
    await target.waitForFunction(()=>document.querySelectorAll('button').length===1,
      null,{timeout:30000});
    await target.waitForTimeout(250);
    const geometry=await target.evaluate(()=>{
      const canvas=document.getElementById('canvas');
      const c=canvas.getBoundingClientRect();
      const b=document.querySelector('button').getBoundingClientRect();
      return {canvas:c.toJSON(),button:b.toJSON(),pixels:[canvas.width,canvas.height],
        density:devicePixelRatio,expected:{x:c.left+416/640*c.width,y:c.top+341/380*c.height,
          width:164/640*c.width,height:24/380*c.height}};
    });
    report.checks.push({name,value:geometry});
    for(const key of ['x','y','width','height'])
      if(Math.abs(geometry.button[key]-geometry.expected[key])>3)
        throw new Error(`${name}: fullscreen hitbox ${key} is displaced`);
    if(Math.abs(geometry.pixels[0]/geometry.canvas.width-geometry.density)>.05)
      throw new Error(`${name}: canvas is not rendered at display density`);
  }
  try {
    await page.goto(`http://127.0.0.1:${server.address().port}/`, {waitUntil:'load', timeout:60000});
    if(process.env.WEB_SCENE_FIXTURE) {
      for(let i=0;i<45 && sceneCaptures.length<6;i++) await page.waitForTimeout(1000);
      await Promise.all(sceneCaptures);
      if(sceneCaptures.length!==6) throw new Error('All six map render checks must finish');
      if(report.errors.length || report.failedRequests.length || report.responses.length) throw new Error('Map fixture reported browser errors');
      console.log('WEB_SCENE_PASS: 6 views, 0 browser errors');
      return;
    }
    await page.waitForTimeout(12000);
    await alignedFullscreenButton(page,'fullscreen_windowed_dpi1');
    await page.locator('button').click();
    await page.waitForFunction(()=>document.fullscreenElement?.id==='gm4html5_div_id');
    await alignedFullscreenButton(page,'fullscreen_enter_dpi1');
    await page.screenshot({path:path.join(output,'fullscreen.png')});
    await page.locator('button').click();
    await page.waitForFunction(()=>!document.fullscreenElement);
    await alignedFullscreenButton(page,'fullscreen_exit_dpi1');
    const smallContext=await browser.newContext({viewport:{width:700,height:420},deviceScaleFactor:2});
    const smallPage=await smallContext.newPage();
    smallPage.on('pageerror',error=>report.errors.push(error.message));
    await smallPage.goto(`http://127.0.0.1:${server.address().port}/`,{waitUntil:'load',timeout:60000});
    await smallPage.waitForTimeout(12000);
    await alignedFullscreenButton(smallPage,'fresh_small_window_dpi2');
    await smallPage.locator('button').click();
    await smallPage.waitForFunction(()=>document.fullscreenElement?.id==='gm4html5_div_id');
    await alignedFullscreenButton(smallPage,'fullscreen_enter_dpi2');
    await smallPage.locator('button').click();
    await smallPage.waitForFunction(()=>!document.fullscreenElement);
    await alignedFullscreenButton(smallPage,'fullscreen_exit_dpi2');
    await smallPage.screenshot({path:path.join(output,'small-dpi2-menu.png')});
    const smallRect=await smallPage.locator('#canvas').evaluate(el=>el.getBoundingClientRect().toJSON());
    await smallPage.mouse.click(smallRect.x+338/640*smallRect.width,smallRect.y+353/380*smallRect.height,{delay:80});
    await smallPage.waitForTimeout(350);
    if(await smallPage.locator('button').count()!==0) throw new Error('DPI2 menu controls click is misaligned');
    await smallPage.keyboard.press('Escape');
    await alignedFullscreenButton(smallPage,'dpi2_controls_closed');
    await smallContext.close();
    // Controls temporarily remove the menu-only DOM button.
    await page.bringToFront();
    const menuRect=await page.locator('#canvas').evaluate(el=>el.getBoundingClientRect().toJSON());
    await page.mouse.click(menuRect.x+338/640*menuRect.width,menuRect.y+353/380*menuRect.height,{delay:80});
    await page.waitForTimeout(300);
    if(await page.locator('button').count()!==0) throw new Error('Controls retained fullscreen hitbox');
    await page.keyboard.press('Escape');
    await alignedFullscreenButton(page,'fullscreen_controls_closed');
    await page.screenshot({path:path.join(output,'menu.png')});
    report.checks.push({name:'canvas_loaded', value:await page.locator('#canvas').evaluate(el=>({width:el.width,height:el.height,rect:el.getBoundingClientRect().toJSON()}))});
    await page.keyboard.press('ArrowLeft');
    await page.keyboard.press('Enter');
    await page.waitForTimeout(3000);
    if(await page.locator('button').count()!==0) throw new Error('Fullscreen hitbox survived menu room change');
    await page.screenshot({path:path.join(output,'start.png')});
    await page.keyboard.down('ArrowRight');
    await page.waitForTimeout(3700);
    await page.keyboard.up('ArrowRight');
    await page.waitForTimeout(700);
    await page.screenshot({path:path.join(output,'movement.png')});
    await page.keyboard.down('ArrowDown');
    await page.waitForTimeout(1080);
    await page.keyboard.up('ArrowDown');
    await page.waitForTimeout(500);
    await page.keyboard.press('e');
    await page.waitForTimeout(600);
    await page.screenshot({path:path.join(output,'dialogue.png')});
    for (let i=0;i<8;i++) {
      await page.keyboard.press('Space');
      await page.waitForTimeout(180);
    }
    await page.waitForTimeout(600);
    await page.screenshot({path:path.join(output,'battle.png')});
    await page.keyboard.press('1');
    await page.waitForTimeout(500);
    await page.screenshot({path:path.join(output,'challenge.png')});
    report.checks.push({name:'audio_context',value:await page.evaluate(()=>typeof g_WebAudioContext==='undefined'?null:{state:g_WebAudioContext.state,sampleRate:g_WebAudioContext.sampleRate})});
    if (report.checks.find(check=>check.name==='audio_context').value?.state!=='running') throw new Error('Web audio did not resume after ordinary keyboard input');
    await page.setViewportSize({width:700,height:420});
    await page.waitForTimeout(300);
    await page.screenshot({path:path.join(output,'responsive.png')});
    const bounds=await page.locator('#canvas').evaluate(el=>el.getBoundingClientRect().toJSON());
    report.checks.push({name:'small_window_canvas',value:bounds});
    if(bounds.x<-.1 || bounds.y<-.1 || bounds.right>700.1 || bounds.bottom>420.1) throw new Error('Game canvas overflows small browser window');
    report.checks.push({name:'title',value:await page.title()});
    report.checks.push({name:'html_language',value:await page.locator('html').getAttribute('lang')});
    if(process.env.WEB_TEST_SKIP==='1') {
      const ratio=Math.min(640/960,380/540);
      const point={x:bounds.x+((640-960*ratio)/2+813*ratio)/640*bounds.width,
        y:bounds.y+((380-540*ratio)/2+40*ratio)/380*bounds.height};
      await page.mouse.click(point.x,point.y,{delay:120});
      await page.waitForTimeout(700);
      await page.screenshot({path:path.join(output,'skip-battle.png')});
      report.checks.push({name:'battle_test_button_click_capture',value:point});
    }
  } finally {
    fs.writeFileSync(path.join(output,'report.json'),JSON.stringify(report,null,2));
    await browser.close();
    await new Promise(resolve=>server.close(resolve));
  }
  console.log(JSON.stringify({errors:report.errors,failedRequests:report.failedRequests,httpErrors:report.responses,checks:report.checks},null,2));
  if(report.errors.length || report.failedRequests.length || report.responses.length) process.exitCode=1;
})().catch(error=>{console.error(error);process.exitCode=1;});
