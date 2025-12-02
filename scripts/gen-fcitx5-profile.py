#!/bin/env python3
import json

with open("config/fcitx5-profile.json", "r") as f:
    profile = json.load(f)

output = ""

for index in range(len(profile)):
    group = profile[index]

    output += f"[Groups/{index}]\n"
    output += f"Name={group["name"]}\n"
    output += f"Default Layout={group["layout"]}\n"

    if "im" in group:
        output += f"DefaultIM={group["im"]}\n"
    else:
        output += f"DefaultIM=\n"

    output += "\n"
    output += f"[Groups/{index}/Items/0]\n"
    output += f"Name=keyboard-{group["layout"]}\n"
    output += "Layout=\n"
    output += "\n"

    if "im" in group:
        output += f"[Groups/{index}/Items/1]\n"
        output += f"Name={group["im"]}\n"
        output += "Layout=\n"
        output += "\n"


output += "[GroupOrder]\n"

for index in range(len(profile)):
    group = profile[index]
    output += f"{index}={group['name']}\n"

print(output)
