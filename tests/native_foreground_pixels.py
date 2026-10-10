"""Verify native foreground redraw alignment against the untouched background.

Run MapSafety first. The runner captures the same stationary bridge view with
actors hidden, first without and then with the native railing polygons.
Reading diagnostic captures never changes game bitmap assets.
"""
from pathlib import Path
import os
import unittest
import numpy as np
from PIL import Image

CAPTURES=Path(os.environ['LOCALAPPDATA'])/'ParadoxoDeWilson'

class Foreground(unittest.TestCase):
    def test_city_arch_redraw_matches_the_cropped_map(self):
        before=np.asarray(Image.open(CAPTURES/'scenery-arch-background.png').convert('RGB')).astype(int)
        after=np.asarray(Image.open(CAPTURES/'scenery-arch-overlay.png').convert('RGB')).astype(int)
        delta=np.abs(before-after)
        self.assertLess(float(np.mean(np.max(delta,axis=2)>8)),0.002)
        self.assertLess(float(delta.mean()),0.2)

    def test_city_arch_actually_occludes_the_player(self):
        before=np.asarray(Image.open(CAPTURES/'scenery-arch-actor-above.png').convert('RGB')).astype(int)
        after=np.asarray(Image.open(CAPTURES/'scenery-arch-actor-under.png').convert('RGB')).astype(int)
        self.assertGreater(int(np.sum(np.max(np.abs(before-after),axis=2)>16)),25,
                           'foreground must visibly cover Wilson under the arch')

    def test_native_rail_redraw_matches_background(self):
        before=np.asarray(Image.open(CAPTURES/'safety-rail-background.png').convert('RGB')).astype(int)
        after=np.asarray(Image.open(CAPTURES/'safety-rail-overlay.png').convert('RGB')).astype(int)
        self.assertEqual(before.shape,after.shape)
        delta=np.abs(before-after)
        changed=float(np.mean(np.max(delta,axis=2)>8))
        mean=float(delta.mean())
        print(f'Native rail alignment: changed fraction={changed:.6f}, mean channel error={mean:.6f}')
        # Allow fractional sampling along polygon edges, never a shifted patch.
        self.assertLess(changed,0.002)
        self.assertLess(mean,0.2)

if __name__=='__main__':unittest.main()
