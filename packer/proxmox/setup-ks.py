#!/usr/bin/env python3

import os
import shutil
import subprocess


KS_FILE = "ks-srv.service"
DEST = "/usr/lib/systemd/system"
PORT = 8080


def copy_srv(src: str, dst: str) -> None:
    print(f"copied {KS_FILE} to {shutil.copy2(src, dst)}")


def reload_daemon() -> None:
    print(subprocess.run(["systemctl", "daemon-reload"]))


def open_port(port: int) -> None:
    print(subprocess.run(["firewall-cmd", f"--add-port={port}/tcp", "--permanent"]))
    print(subprocess.run(["firewall-cmd", "--reload"]))


def close_port(port: int) -> None:
    print(subprocess.run(["firewall-cmd", f"--remove-port={port}/tcp", "--permanent"]))
    print(subprocess.run(["firewall-cmd", "--reload"]))


def remove_srv(src_dir: str, file: str) -> None:
    file_to_remove = f"{src_dir}/{file}"
    os.remove(file_to_remove)
    print(f"removed {file_to_remove}")


def install() -> None:
    copy_srv(KS_FILE, DEST)
    open_port(PORT)
    reload_daemon()


def uninstall() -> None:
    remove_srv(DEST, KS_FILE)
    close_port(PORT)
    reload_daemon()


def main():
    install()
    # uninstall()


if __name__ == "__main__":
    main()
