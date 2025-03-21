import fnmatch
import json
import sys
import tarfile
from pathlib import Path

spec = sys.argv[1]
output = sys.argv[2]

with open(spec) as f:
    spec = json.load(f)

files = spec["files"]
exclude = spec["exclude"]

def erase_metadata(tarinfo):
    tarinfo.mtime = 946684800
    tarinfo.uid = 0
    tarinfo.gid = 0
    tarinfo.uname = ""
    tarinfo.gname = ""
    tarinfo.mode = 0o755
    return tarinfo

def insert(archive, path, destination):
    if any(fnmatch.fnmatchcase(str(destination), p) for p in exclude):
        return None

    # remove absolute symlinks created by bazel, but keep relative symlinks
    while path.is_symlink() and path.readlink().is_absolute():
        path = path.readlink()

    f.add(path, arcname=destination, filter=erase_metadata)

with tarfile.open(output, 'x:xz') as f:
    for path, destination in sorted(files.items(), key=lambda v: v[1]):

        path = Path(path)
        destination = Path(destination)
        
        if path.is_dir():
            for p in sorted(path.glob('**/*')):
                if p.is_dir():
                    continue
                insert(f, p, destination / p.relative_to(path))
        else:
            insert(f, path, destination)
