#!/usr/bin/env python3

import os
import shutil
import subprocess


KS_FILE = "ks-srv.service"
SRV_FILE_DEST = "/usr/lib/systemd/system"
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


def start_srv(srv: str) -> None:
    subprocess.run(["systemctl", "start", srv])


def stop_srv(srv: str) -> None:
    subprocess.run(["systemctl", "stop", srv])


def remove_srv(src_dir: str, file: str) -> None:
    file_to_remove = f"{src_dir}/{file}"

    try:
        os.remove(file_to_remove)
    except FileNotFoundError:
        print(f"could not find {file_to_remove}")


def install() -> None:
    copy_srv(KS_FILE, SRV_FILE_DEST)
    open_port(PORT)
    reload_daemon()
    start_srv(KS_FILE)


def uninstall() -> None:
    remove_srv(SRV_FILE_DEST, KS_FILE)
    close_port(PORT)
    reload_daemon()
    stop_srv(KS_FILE)


def show_status(service: str) -> None:
    subprocess.run(["systemctl", "status", f"{service}"])
    subprocess.run(["firewall-cmd", "--list-all"])


def main():
    install()
    # uninstall()
    show_status(KS_FILE)


if __name__ == "__main__":
    main()
