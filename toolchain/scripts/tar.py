#!/usr/bin/env python3
"""
Cross-platform tar assembly script.
Creates reproducible tar.xz files with path mappings and exclusions.
"""

import tarfile
import sys
import json
import fnmatch
from pathlib import Path

def should_exclude(rel_path, exclusions):
    """Check if a file should be excluded based on patterns"""
    return any(pattern in rel_path.parts for pattern in exclusions)

def add_file_reproducible(tar, file_path, arc_name):
    """Add file with reproducible metadata"""
    # Get file info
    tarinfo = tar.gettarinfo(file_path, arcname=arc_name)
    
    # Set reproducible metadata
    tarinfo.mtime = 0  # Unix epoch
    tarinfo.uid = 0
    tarinfo.gid = 0
    tarinfo.uname = "root"
    tarinfo.gname = "root"
    
    # Add file with reproducible metadata
    if tarinfo.isreg():
        with open(file_path, 'rb') as f:
            tar.addfile(tarinfo, f)
    else:
        tar.addfile(tarinfo)

def add_directory(tar, source_dir, target_path, exclusions):
    """Add directory contents to tar with exclusions in deterministic order"""
    source_path = Path(source_dir)
    assert source_path.exists(), f"Source directory {source_dir} does not exist"
    
    for file_path in sorted(source_path.rglob('*')):
        if not file_path.is_file():
            continue
            
        rel_path = file_path.relative_to(source_path)
        
        # Check exclusions against the relative path from source
        if should_exclude(rel_path, exclusions):
            continue
        
        arc_name = (Path(target_path) / rel_path).as_posix()
        add_file_reproducible(tar, str(file_path), arc_name)

def create_tar(output_file, config):
    """Create tar.xz file from config"""
    print(f"Creating {output_file}")
    
    with tarfile.open(output_file, 'w:xz') as tar:
        # Add directories
        for mapping in config.get('directories', []):
            source = mapping['source']
            target = mapping.get('target', '')
            exclusions = mapping.get('exclude', [])
            print(f"Adding directory: {source} -> {target or '(root)'}")
            add_directory(tar, source, target, exclusions)
        
        # Add individual files
        for file_mapping in config.get('files', []):
            source = Path(file_mapping['source'])
            target = file_mapping['target']
            assert source.exists(), f"Source file {source} does not exist"
            print(f"Adding file: {source} -> {target}")
            add_file_reproducible(tar, str(source), target)

def merge_configs(config_files):
    """Merge multiple config files into a single config"""
    merged_config = {
        'directories': [],
        'files': []
    }

    for config_file in config_files:
        print(f"Loading config: {config_file}")
        with open(config_file, 'r') as f:
            config = json.load(f)

        # Merge directories and files
        merged_config['directories'].extend(config.get('directories', []))
        merged_config['files'].extend(config.get('files', []))

    return merged_config

def main():
    if len(sys.argv) < 3:
        print("Usage: python tar_assembler.py <output.tar.xz> <config1.json> [config2.json] ...")
        sys.exit(1)
    
    output_file = sys.argv[1]
    config_files = sys.argv[2:]
    
    config = merge_configs(config_files)
    
    create_tar(output_file, config)
    print(f"Successfully created {output_file}")

if __name__ == "__main__":
    main()
