#!/usr/bin/env python3
"""
Cross-platform tar assembly script.
Creates reproducible tar.xz files with path mappings and exclusions.
"""

import tarfile
import sys
import json
from pathlib import Path

def should_exclude(rel_path, exclusions):
    """Exclude a file if it contains any of the excluded path components"""
    return any(pattern in rel_path.parts for pattern in exclusions)

def add_file_reproducible(tar, file_path, arc_name):
    """Add file with reproducible metadata"""
    tarinfo = tar.gettarinfo(file_path, arcname=arc_name)
    tarinfo.mtime = 0  # Unix epoch
    tarinfo.uid = 0
    tarinfo.gid = 0
    tarinfo.uname = "root"
    tarinfo.gname = "root"

    if tarinfo.isreg():
        with open(file_path, 'rb') as f:
            tar.addfile(tarinfo, f)
    else:
        tar.addfile(tarinfo)

def collect_directory_files(source_dir, target_path, exclusions):
    """Collect all files from directory with their archive paths"""
    source_path = Path(source_dir)
    assert source_path.exists(), f"Source directory {source_dir} does not exist"

    files_to_add = []

    for file_path in source_path.rglob('*'):
        if not file_path.is_file():
            continue
        
        rel_path = file_path.relative_to(source_path)

        # Check exclusions against the relative path from source
        if should_exclude(rel_path, exclusions):
            continue

        arc_name = (Path(target_path) / rel_path).as_posix()
        files_to_add.append((str(file_path), arc_name))

    return files_to_add

def collect_all_files(config):
    """Parse config and collect all files to be archived"""
    all_files = []

    # Collect files from directories
    for mapping in config.get('directories', []):
        source = mapping['source']
        target = mapping.get('target', '')
        exclusions = mapping.get('exclude', [])
        directory_files = collect_directory_files(source, target, exclusions)
        all_files.extend(directory_files)

    # Collect individual files
    for file_mapping in config.get('files', []):
        source = Path(file_mapping['source'])
        target = file_mapping['target']
        assert source.exists(), f"Source file {source} does not exist"
        all_files.append((str(source), target))

    return all_files

def create_tar(output_file, config):
    """Create tar.xz file from config"""
    all_files = collect_all_files(config)
    all_files.sort(key=lambda x: x[1])  # Sort by archive name
    with tarfile.open(output_file, 'w:xz') as tar:
        for file_path, arc_name in all_files:
            add_file_reproducible(tar, file_path, arc_name)

def merge_configs(config_files):
    """Merge multiple config files into a single config"""
    merged_config = {
        'directories': [],
        'files': []
    }

    for config_file in config_files:
        with open(config_file, 'r') as f:
            config = json.load(f)

        # Merge directories and files
        merged_config['directories'].extend(config.get('directories', []))
        merged_config['files'].extend(config.get('files', []))

    return merged_config

def main():
    if len(sys.argv) < 3:
        print("Usage: python tar.py <output.tar.xz> <config1.json> [config2.json] ...")
        sys.exit(1)

    output_file = sys.argv[1]
    config_files = sys.argv[2:]

    config = merge_configs(config_files)

    create_tar(output_file, config)
    print(f"Created {output_file}")

if __name__ == "__main__":
    main()
