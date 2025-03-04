import sys
import hashlib
import codecs
import requests
import json
from pathlib import Path

def get_assets():
    response = requests.get("https://api.github.com/repos/CACI-International/cpp-toolchain/releases/tags/" + tag)
    return response.json()["assets"]

def integrity(url):
    response = requests.get(url, stream=True)
    digest = hashlib.file_digest(response.raw, "sha256").hexdigest()
    return "sha256-" + codecs.encode(codecs.decode(digest, "hex"), "base64").decode(
        "utf-8"
    ).replace("\n", "")

tag = sys.argv[1]

output = []
for asset in get_assets():
    output.append({
        "name": asset["name"].removesuffix(".tar.xz"),
        "url": asset["browser_download_url"],
        "integrity": integrity(asset["browser_download_url"]),
    })

with open(Path(__file__).resolve().parent / "assets.json", "w") as f:
    json.dump(output, f, indent="  ")
