// Test the real HTML5 renderer, natural timeline and held-input protection.
const {chromium}=require('C:/Users/jrhre/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const fs=require('fs'),path=require('path'),http=require('http');
(async()=>{
 const root=path.join(process.env.PARADOXO_FIXTURE_HOME||path.join(process.env.LOCALAPPDATA,'CodexBuilds/ParadoxoDeWilson'),'web-secret-throne-export');
 const output=path.resolve('output/ending-20261010/web');fs.mkdirSync(output,{recursive:true});
 const report={people:[],phases:[],frames:[],music:[],errors:[],failedRequests:[],httpErrors:[]};const shots=[];
 const server=http.createServer((req,res)=>{
  const relative=decodeURIComponent(new URL(req.url,'http://localhost').pathname);
  const file=path.resolve(root,'.'+(relative==='/'?'/index.html':relative));
  if(!file.startsWith(root+path.sep)||!fs.existsSync(file)){res.writeHead(404);res.end();return;}
  const types={'.html':'text/html','.js':'application/javascript','.png':'image/png','.ogg':'audio/ogg','.wav':'audio/wav'};
  res.writeHead(200,{'Content-Type':types[path.extname(file)]||'application/octet-stream'});fs.createReadStream(file).pipe(res);
 });
 await new Promise(r=>server.listen(0,'127.0.0.1',r));
 const browser=await chromium.launch({channel:'msedge',headless:true});
 const page=await browser.newPage({viewport:{width:1280,height:800}});
 page.on('pageerror',e=>report.errors.push(e.message));page.on('requestfailed',r=>report.failedRequests.push(r.url()));
 page.on('response',r=>{if(r.status()>=400)report.httpErrors.push(r.url());});
 page.on('console',m=>{
  const t=m.text();
  if(t.startsWith('CLASSROOM_PERSON:')){
   const person=Number(t.slice(17));report.people.push(person);
   shots.push(page.waitForTimeout(250).then(()=>page.screenshot({path:path.join(output,'classroom-person-'+person+'.png')})));
  }
  if(t.startsWith('SECRET_PHASE:')){
   const phase=t.slice(13).trim();report.phases.push(phase);
   const delay=phase==='BLACKOUT'||phase==='QUOTE_BLACKOUT'?0:500;
   shots.push(page.waitForTimeout(delay).then(()=>page.screenshot({path:path.join(output,phase+'.png')})));
  }
  if(t.startsWith('SECRET_FRAME:'))report.frames.push(Number(t.slice(13)));
  if(t.startsWith('SECRET_MUSIC:'))report.music.push(t.slice(13).trim().split(':'));
  if(t.startsWith('SECRET_SHADER:'))report.shader=t.trim().endsWith(':1');
  if(t.startsWith('SECRET_CLEANUP:'))report.cleanup=t.trim().endsWith(':1');
  if(t.startsWith('SECRET_DONE:'))report.done=t;
 });
 try{
  await page.goto(`http://127.0.0.1:${server.address().port}/`,{waitUntil:'load',timeout:90000});
  await page.mouse.click(640,400);await page.keyboard.down('Enter');
  for(let i=0;i<115&&!report.done;i++)await page.waitForTimeout(1000);
  const wanted=['FINAL_SCREEN','GLITCH_SEQUENCE','BLACKOUT','CINEMATIC_01','CINEMATIC_02','CINEMATIC_03','REVEAL_HOLD','QUOTE_BLACKOUT','NEWTON_QUOTE','FINAL_FADEOUT','CREDITS','COMPLETE'];
  if(JSON.stringify(report.people)!==JSON.stringify([0,1,2,3,4,5]))throw new Error('Missing or reordered classroom portraits: '+report.people);
  if(JSON.stringify(report.phases)!==JSON.stringify(wanted))throw new Error('Wrong natural ending order: '+report.phases);
  if(JSON.stringify(report.frames)!==JSON.stringify(Array.from({length:19},(_,i)=>i)))throw new Error('Missing or reordered corrected source frames: '+report.frames);
  if(!report.done?.includes(':12:0'))throw new Error('Held input skipped the ending');
  if(!report.shader||!report.cleanup)throw new Error('Camera shader or surface cleanup failed');
  const music=report.music.filter(part=>part[0]!=='COMPLETE');
  if(music.length!==11||music.some(part=>part[1]!=='snd_final_cinematic_music'||part[2]!==music[0][2]||part[3]!=='1'))throw new Error('Final music stopped or restarted across scene boundaries');
  await page.keyboard.up('Enter');await Promise.all(shots);
  for(const size of [{width:700,height:420},{width:900,height:1200}]){
   await page.setViewportSize(size);await page.waitForTimeout(200);
   await page.screenshot({path:path.join(output,`credits-${size.width}x${size.height}.png`)});
  }
  report.audio=await page.evaluate(()=>typeof g_WebAudioContext==='undefined'?null:g_WebAudioContext.state);
  if(report.audio!=='running')throw new Error('Browser audio context failed to start');
  if(report.errors.length||report.failedRequests.length||report.httpErrors.length)throw new Error('Browser runtime or resource errors');
  report.passed=true;
 }finally{
  fs.writeFileSync(path.join(output,'report.json'),JSON.stringify(report,null,2));
  await browser.close();await new Promise(r=>server.close(r));
 }
 console.log(JSON.stringify(report,null,2));
})().catch(e=>{console.error(e);process.exitCode=1;});
