"""Import generated character atlases; perform only resizing and UI crops.

Usage: python tools/import_character_art.py --claude INPUT --deepseek INPUT
Requires Pillow for development only. The game uses the resulting PNG files.
"""
import argparse
from pathlib import Path
import xml.etree.ElementTree as ET
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
parser = argparse.ArgumentParser()
parser.add_argument('--claude', required=True)
parser.add_argument('--deepseek', required=True)
args = parser.parse_args()

menu = Image.new('RGBA', (256, 128))
labels = Image.new('RGBA', (256, 64))
font = ImageFont.load_default()
for index, (key, name, source) in enumerate([
    ('claudechan', 'Claude-chan', args.claude),
    ('deepseekchan', 'DeepSeek-chan', args.deepseek),
]):
    image = Image.open(source).convert('RGBA')
    assert image.width == image.height, 'Expected the square animation layout'
    image = image.resize((512, 512), Image.Resampling.NEAREST)
    assert image.getextrema()[3][0] == 0, 'Atlas must contain real transparency'
    output = ROOT / 'resources/gfx/characters/costumes' / f'character_{key}.png'
    output.parent.mkdir(parents=True, exist_ok=True)
    image.save(output)
    # The first 64px special-pose cell is the character's full-body front pose.
    pose = image.crop((0, 128, 64, 192))
    portrait = Image.new('RGBA', (144, 144))
    portrait.alpha_composite(pose.resize((128, 128), Image.Resampling.NEAREST), (8, 8))
    portrait_path = ROOT / f'resources/gfx/ui/stage/playerportrait_{key}.png'
    portrait_path.parent.mkdir(parents=True, exist_ok=True)
    portrait.save(portrait_path)
    menu.alpha_composite(pose, (index * 64, 0))
    draw = ImageDraw.Draw(labels)
    draw.text((4, index * 32 + 8), name.upper(), font=font, fill=(32, 20, 20, 255))
    name_path = ROOT / f'resources/gfx/ui/boss/playername_{key}.png'
    name_path.parent.mkdir(parents=True, exist_ok=True)
    labels.crop((0, index * 32, 128, index * 32 + 32)).save(name_path)

content = ROOT / 'content/gfx'
content.mkdir(parents=True, exist_ok=True)
menu.save(content / 'ai_portraits.png')
labels.save(content / 'ai_names.png')

def frame(**attributes):
    values = dict(XPosition='0', YPosition='0', XScale='100', YScale='100',
                  Delay='1', Visible='true', RedTint='255', GreenTint='255',
                  BlueTint='255', AlphaTint='255', RedOffset='0', GreenOffset='0',
                  BlueOffset='0', Rotation='0', Interpolated='false')
    values.update({key: str(value) for key, value in attributes.items()})
    return ET.Element('Frame', values)

for filename, sheet, portrait in [('characterportraits.anm2', 'ai_portraits.png', True),
                                   ('charactermenu.anm2', 'ai_names.png', False)]:
    actor = ET.Element('AnimatedActor')
    ET.SubElement(actor, 'Info', CreatedBy='Claude-chan contributors', Version='1', Fps='30')
    info = ET.SubElement(actor, 'Content')
    sheets = ET.SubElement(info, 'Spritesheets')
    ET.SubElement(sheets, 'Spritesheet', Path=sheet, Id='0')
    layers = ET.SubElement(info, 'Layers')
    names = ['Portrait'] if portrait else [
        'Background', 'Left Arrow', 'Right Arrow', 'Name', 'Life Icon', 'Speed Icon',
        'Power Icon', 'Item Icon', 'Item Name', 'Life Stat', 'Speed Stat', 'Power Stat',
        'Item Icon 2', 'Item Name 2', 'Item Icon 3', 'Item Name 3', 'Unlocked By',
        'Blood', 'Blood2', 'Blood3', 'Overlay',
    ]
    for number, name in enumerate(names):
        ET.SubElement(layers, 'Layer', Name=name, Id=str(number), SpritesheetId='0')
    ET.SubElement(info, 'Nulls'); ET.SubElement(info, 'Events')
    animations = ET.SubElement(actor, 'Animations', DefaultAnimation='Claude-chan')
    for index, name in enumerate(['Claude-chan', 'DeepSeek-chan']):
        animation = ET.SubElement(animations, 'Animation', Name=name, FrameNum='1', Loop='false')
        ET.SubElement(animation, 'RootAnimation').append(frame())
        layer_animations = ET.SubElement(animation, 'LayerAnimations')
        layer = ET.SubElement(layer_animations, 'LayerAnimation', LayerId='0' if portrait else '3', Visible='true')
        layer.append(frame(XPosition=0 if portrait else 224, YPosition=0 if portrait else 147,
                           XPivot=32 if portrait else 64, YPivot=44 if portrait else 16,
                           XCrop=index * 64 if portrait else 0, YCrop=0 if portrait else index * 32,
                           Width=64 if portrait else 128, Height=64 if portrait else 32))
        ET.SubElement(animation, 'NullAnimations'); ET.SubElement(animation, 'Triggers')
    ET.indent(actor)
    ET.ElementTree(actor).write(content / filename, encoding='utf-8', xml_declaration=True)
print('Imported two character atlases, portraits, names and character selection animations.')
