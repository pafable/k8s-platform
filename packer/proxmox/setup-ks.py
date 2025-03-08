#!/usr/bin/env python3

import shutil

KS_FILE = "ks-srv.service"
DEST = "/usr/lib/systemd/system/"


def copy_srv(src: str, dst: str) -> None:
    print(f"copied {KS_FILE} to {shutil.copy2(KS_FILE, DEST)}")


def main():
    copy_srv(KS_FILE, DEST)


if __name__ == "__main__":
    main()
