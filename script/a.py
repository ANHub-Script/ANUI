import os
import xml.etree.ElementTree as ET
from pathlib import Path

# Daftar class script yang ingin diekstrak
SCRIPT_CLASSES = {"Script", "LocalScript", "ModuleScript"}

def sanitize_name(name):
    """Ganti karakter ilegal pada nama file/folder dengan underscore."""
    return "".join(c if c.isalnum() or c in ('-', '_') else '_' for c in name)

def get_item_name(item):
    """Ambil properti Name dari sebuah Item, fallback ke class jika tidak ada."""
    properties = item.find('Properties')
    if properties is not None:
        name_elem = properties.find('string[@name="Name"]')
        if name_elem is not None and name_elem.text:
            return name_elem.text.strip()
    return item.get('class', 'Unknown')

def build_folder_path(item, parent_map):
    """
    Bangun list nama folder dari ancestor (tanpa root dan item itu sendiri)
    untuk membuat path relatif.
    """
    folders = []
    current = parent_map.get(item)
    while current is not None and current.tag != 'roblox':
        if current.tag == 'Item':
            # Hindari memasukkan item script itu sendiri (karena current adalah parent)
            folders.append(get_item_name(current))
        current = parent_map.get(current)
    folders.reverse()
    return folders

def extract_all_scripts(rblx_path, output_dir=None):
    """
    Ekstrak semua Script, LocalScript, dan ModuleScript dari file .rbxlx
    ke dalam folder output dengan struktur hierarki game.
    """
    if not os.path.isfile(rblx_path):
        print(f"Error: File {rblx_path} tidak ditemukan.")
        return

    # Tentukan direktori output
    if output_dir is None:
        output_dir = Path(rblx_path).parent
    else:
        output_dir = Path(output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)

    # Parse XML
    try:
        tree = ET.parse(rblx_path)
        root = tree.getroot()
    except ET.ParseError as e:
        print(f"Error parsing XML: {e}")
        return

    # Mapping parent untuk setiap elemen
    parent_map = {child: parent for parent in tree.iter() for child in parent}

    # Cari semua item dengan class script
    script_items = []
    for item in root.iter('Item'):
        if item.get('class') in SCRIPT_CLASSES:
            script_items.append(item)

    if not script_items:
        print("Tidak ada script ditemukan dalam file.")
        return

    total = 0
    for idx, item in enumerate(script_items, start=1):
        properties = item.find('Properties')
        if properties is None:
            continue

        # Ambil Source
        source_elem = properties.find('ProtectedString[@name="Source"]')
        if source_elem is None or source_elem.text is None:
            print(f"[{idx}] Script tanpa Source, dilewati.")
            continue

        # Ambil nama script
        script_name = get_item_name(item)

        # Bangun path folder dari ancestor
        folders = build_folder_path(item, parent_map)
        safe_folders = [sanitize_name(f) for f in folders]
        safe_script = sanitize_name(script_name)

        # Tentukan direktori tujuan
        target_dir = output_dir.joinpath(*safe_folders) if safe_folders else output_dir
        target_dir.mkdir(parents=True, exist_ok=True)

        # Tangani duplikasi nama file di folder yang sama
        base_name = safe_script
        counter = 1
        output_file = target_dir / f"{base_name}.lua"
        while output_file.exists():
            output_file = target_dir / f"{base_name}_{counter}.lua"
            counter += 1

        # Tulis source code
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(source_elem.text)

        print(f"[{idx}] {output_file}")
        total += 1

    print(f"\nTotal {total} script berhasil diekstrak.")

def main():
    # Ganti dengan path file .rbxlx Anda
    input_file = "YAHA.rbxlx"
    # Biarkan output_dir = None untuk menyimpan di folder yang sama dengan input
    extract_all_scripts(input_file, output_dir="D:/Roblox/A/WindUI/Roblox")

if __name__ == '__main__':
    main()