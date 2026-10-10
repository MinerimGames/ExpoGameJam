"""Regenerate native font atlases from the bundled TrueType outlines via FreeType.

Keeps the existing logical glyph advances and line heights. The font atlas must
actually contain signed distances before usesSDF can be enabled in GameMaker.
"""
import argparse
import ctypes as C
import json
from pathlib import Path
from PIL import Image
from evento_project import load


class Vector(C.Structure):
    _fields_ = [('x', C.c_long), ('y', C.c_long)]


class Generic(C.Structure):
    _fields_ = [('data', C.c_void_p), ('finalizer', C.c_void_p)]


class BBox(C.Structure):
    _fields_ = [(n, C.c_long) for n in ('xMin', 'yMin', 'xMax', 'yMax')]


class Face(C.Structure):
    _fields_ = [(n, C.c_long) for n in ('num_faces', 'face_index', 'face_flags', 'style_flags', 'num_glyphs')] + [
        ('family_name', C.c_char_p), ('style_name', C.c_char_p),
        ('num_fixed_sizes', C.c_int), ('available_sizes', C.c_void_p),
        ('num_charmaps', C.c_int), ('charmaps', C.c_void_p),
        ('generic', Generic), ('bbox', BBox), ('units_per_EM', C.c_ushort),
    ] + [(n, C.c_short) for n in ('ascender', 'descender', 'height', 'max_advance_width',
                                'max_advance_height', 'underline_position', 'underline_thickness')] + [
        ('glyph', C.c_void_p), ('size', C.c_void_p), ('charmap', C.c_void_p)]


class Bitmap(C.Structure):
    _fields_ = [('rows', C.c_uint), ('width', C.c_uint), ('pitch', C.c_int),
                ('buffer', C.POINTER(C.c_ubyte)), ('num_grays', C.c_ushort),
                ('pixel_mode', C.c_ubyte), ('palette_mode', C.c_ubyte), ('palette', C.c_void_p)]


class Slot(C.Structure):
    _fields_ = [('library', C.c_void_p), ('face', C.c_void_p), ('next', C.c_void_p),
                ('glyph_index', C.c_uint), ('generic', Generic)] + [
                    (n, C.c_long) for n in ('width', 'height', 'horiBearingX', 'horiBearingY',
                                          'horiAdvance', 'vertBearingX', 'vertBearingY', 'vertAdvance')
                ] + [('linearHoriAdvance', C.c_long), ('linearVertAdvance', C.c_long),
                     ('advance', Vector), ('format', C.c_uint), ('bitmap', Bitmap),
                     ('bitmap_left', C.c_int), ('bitmap_top', C.c_int)]


def checked(result):
    if result:
        raise RuntimeError(f'FreeType returned error {result}')


def regenerate(root, library_path):
    ft = C.CDLL(str(library_path))
    ft.FT_Init_FreeType.argtypes = [C.POINTER(C.c_void_p)]
    ft.FT_New_Face.argtypes = [C.c_void_p, C.c_char_p, C.c_long, C.POINTER(C.c_void_p)]
    ft.FT_Set_Char_Size.argtypes = [C.c_void_p, C.c_long, C.c_long, C.c_uint, C.c_uint]
    ft.FT_Load_Char.argtypes = [C.c_void_p, C.c_ulong, C.c_int32]
    ft.FT_Render_Glyph.argtypes = [C.c_void_p, C.c_int]
    ft.FT_Done_Face.argtypes = [C.c_void_p]
    ft.FT_Done_FreeType.argtypes = [C.c_void_p]
    library = C.c_void_p()
    checked(ft.FT_Init_FreeType(C.byref(library)))
    try:
        for name in ('fnt_ui', 'fnt_title'):
            directory = root / 'fonts' / name
            resource = load(directory / (name + '.yy'))
            face_ptr = C.c_void_p()
            checked(ft.FT_New_Face(library, str(directory / resource['TTFName']).encode(), 0, C.byref(face_ptr)))
            try:
                checked(ft.FT_Set_Char_Size(face_ptr, 0, round(resource['size'] * 64), 96, 96))
                spread = resource['sdfSpread']
                if spread != 8:
                    raise ValueError('This atlas generator uses the FreeType default SDF spread of 8 pixels')
                baseline = resource['ascender'] + resource['ascenderOffset']
                row_height = resource['lineHeight'] + resource['ascenderOffset'] + spread * 2
                glyph_images = []
                for code, glyph in resource['glyphs'].items():
                    checked(ft.FT_Load_Char(face_ptr, int(code), 0))
                    face = C.cast(face_ptr, C.POINTER(Face)).contents
                    checked(ft.FT_Render_Glyph(face.glyph, 5))  # FT_RENDER_MODE_SDF
                    slot = C.cast(face.glyph, C.POINTER(Slot)).contents
                    bitmap = slot.bitmap
                    if bitmap.width == 0 or bitmap.rows == 0:
                        image = Image.new('L', (1, 1))
                        glyph['w'] = glyph['h'] = 0
                    else:
                        raw = C.string_at(bitmap.buffer, abs(bitmap.pitch) * bitmap.rows)
                        field = Image.frombytes('L', (bitmap.width, bitmap.rows), raw, 'raw', 'L', abs(bitmap.pitch))
                        image = Image.new('L', (bitmap.width, row_height))
                        image.paste(field, (0, baseline + spread - slot.bitmap_top))
                        # Engine subtracts SDF spread from x/y when placing the
                        # quad (yyFont.js). Keep the logical offset unpadded.
                        glyph['offset'] = slot.bitmap_left + spread
                        glyph['w'], glyph['h'] = image.size
                    glyph_images.append((glyph, image))
                width = 1024
                x = y = 2
                for glyph, image in glyph_images:
                    if x + image.width + 2 > width:
                        x = 2
                        y += row_height + 4
                    glyph['x'], glyph['y'] = x, y
                    x += image.width + 4
                height = 2 ** ((y + row_height + 2 - 1).bit_length())
                alpha = Image.new('L', (width, height))
                for glyph, image in glyph_images:
                    alpha.paste(image, (glyph['x'], glyph['y']))
                atlas = Image.new('RGBA', (width, height), (255, 255, 255, 0))
                atlas.putalpha(alpha)
                atlas.save(directory / (name + '.png'))
                resource['regenerateBitmap'] = False
                (directory / (name + '.yy')).write_text(json.dumps(resource, ensure_ascii=False, indent=2), encoding='utf-8')
                print(f'{name}: vector outline SDF atlas {width} x {height}, {len(glyph_images)} glyphs')
            finally:
                checked(ft.FT_Done_Face(face_ptr))
    finally:
        checked(ft.FT_Done_FreeType(library))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--root', type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument('--freetype', type=Path, required=True)
    args = parser.parse_args()
    regenerate(args.root, args.freetype)
