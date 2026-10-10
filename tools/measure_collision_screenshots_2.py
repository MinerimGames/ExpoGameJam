"""Register supplied screenshots against unchanged map art for collision QA."""
from pathlib import Path
import cv2
import numpy as np
import json

ROOT = Path(__file__).resolve().parents[1]
SHOTS = Path('C:/Users/jrhre/Videos/NVIDIA/Windows')
CASES = [
    ('09.13.57.73','steam',(588,580)),
    ('09.14.16.15','steam',(1350,539)),
    ('09.17.59.66','city',(822,500)),
    ('09.10.38.73','hall',(807,558)),
    ('09.10.48.02','hall',(383,505)),
    ('09.10.58.75','hall',(212,643)),
    ('09.11.13.40','hall',(441,474)),
    ('09.11.26.12','hall',(930,620)),
    ('09.11.43.64','hall',(1145,668)),
    ('09.11.54.50','hall',(1328,541)),
    ('09.13.37.28','steam',(1119,759)),
    ('09.13.43.32','steam',(783,700)),
    ('09.11.37.02','hall',(1114,623)),
]
ART = {
 'steam':('spr_steampunk_foundry','e9a3952b-e0c1-4420-be02-891faf717f23',(960,640)),
 'city':('spr_autumn_city','afecf349-5937-4a39-9378-5c5b50db3d05',(800,600)),
 'hall':('spr_castle_hall','31f00526-3342-4db0-93e2-cca341a8cff2',(800,600)),
}
def read(path):
    return cv2.imdecode(np.fromfile(str(path),np.uint8),cv2.IMREAD_GRAYSCALE)
def main():
    sift=cv2.SIFT_create(nfeatures=9000)
    matcher=cv2.BFMatcher()
    refs={}
    for name,(sprite,frame,size) in ART.items():
        ref=cv2.resize(read(ROOT/f'sprites/{sprite}/{frame}.png'),size,interpolation=cv2.INTER_NEAREST)
        refs[name]=sift.detectAndCompute(ref,None)
    results=[]
    for time,name,feet in CASES:
        shot=read(SHOTS/f'Windows Screenshot 2026.10.09 - {time}.png')
        kp,desc=sift.detectAndCompute(shot,None)
        rk,rd=refs[name]
        good=[m for m,n in matcher.knnMatch(rd,desc,k=2) if m.distance<.7*n.distance]
        h,mask=cv2.findHomography(np.float32([rk[m.queryIdx].pt for m in good]),np.float32([kp[m.trainIdx].pt for m in good]),cv2.RANSAC,4)
        point=cv2.perspectiveTransform(np.float32([[feet]]),np.linalg.inv(h))[0,0]
        item={'screenshot':time,'map':name,'inliers':int(mask.sum()),'world_feet':point.tolist(),'player_origin':[float(point[0]),float(point[1]-7)]}
        results.append(item)
        print(time,name,'feet',point.round(2),'origin',np.array(item['player_origin']).round(2), 'inliers',item['inliers'])
    out=ROOT/'output/revision-20261009/collision-screenshots-2'
    out.mkdir(parents=True,exist_ok=True)
    (out/'measured-points.json').write_text(json.dumps(results,indent=2),encoding='utf-8')
if __name__=='__main__':main()
