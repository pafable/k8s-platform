#!/usr/bin/env python3

import shutil
import subprocess


KS_FILE = "ks-srv.service"
DEST = "/usr/lib/systemd/system"
PORT = 8080


def copy_srv(src: str, dst: str) -> None:
    print(f"copied {KS_FILE} to {shutil.copy2(KS_FILE, DEST)}")


def reload_daemon() -> None:
    print(subprocess.run(["systemctl", "daemon-reload"]))


def open_firewall() -> None:
    print(subprocess.run(["firewall-cmd", f"--add-port={PORT}/tcp", "--permanent"]))
    print(subprocess.run(["firewall-cmd", "--reload"]))


def main():
    copy_srv(KS_FILE, DEST)
    open_firewall()
    reload_daemon()


if __name__ == "__main__":
    main()
