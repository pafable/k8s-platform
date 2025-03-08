#!/usr/bin/env python3

import argparse
import logging
import os
import shutil
import subprocess

from typing import Final


DATE_FORMAT: Final[str] = "%Y-%m-%d %H:%M:%S"
KS_FILE: Final[str] = "ks-srv.service"
LOG_FORMAT: Final[str] = "%(asctime)s - %(levelname)s - %(message)s"
PORT: Final[int] = 8080
SRV_FILE_DEST: Final[str]  = "/usr/lib/systemd/system"

logging.basicConfig(
    datefmt=DATE_FORMAT,
    format=LOG_FORMAT,
    level=logging.INFO,
)

def copy_srv(src: str, dst: str) -> None:
    logging.info("copied %s to %s",src, shutil.copy(src, dst))


def reload_daemon() -> None:
    logging.info("%s", subprocess.run(["systemctl", "daemon-reload"]))


def open_port(port: int) -> None:
    logging.info("%s", subprocess.run(["firewall-cmd", f"--add-port={port}/tcp", "--permanent"]))
    logging.info("%s", subprocess.run(["firewall-cmd", "--reload"]))


def close_port(port: int) -> None:
    logging.info("%s", subprocess.run(["firewall-cmd", f"--remove-port={port}/tcp", "--permanent"]))
    logging.info("%s", subprocess.run(["firewall-cmd", "--reload"]))


def start_srv(srv: str) -> None:
    logging.info("%s", subprocess.run(["systemctl", "start", srv]))


def stop_srv(srv: str) -> None:
    logging.info("%s", subprocess.run(["systemctl", "stop", srv]))


def remove_srv(src_dir: str, file: str) -> None:
    file_to_remove = f"{src_dir}/{file}"

    try:
        os.remove(file_to_remove)
    except FileNotFoundError:
        logging.error("could not find %s", file_to_remove)


def install() -> None:
    copy_srv(KS_FILE, SRV_FILE_DEST)
    open_port(PORT)
    reload_daemon()
    start_srv(KS_FILE)


def uninstall() -> None:
    stop_srv(KS_FILE)
    remove_srv(SRV_FILE_DEST, KS_FILE)
    close_port(PORT)
    reload_daemon()


def show_status(service: str) -> None:
    subprocess.run(["systemctl", "status", f"{service}"])
    subprocess.run(["firewall-cmd", "--list-all"])


def main():
    parser = argparse.ArgumentParser(description="Configures kick start http server")
    parser.add_argument("--install", "-i", help="Install kick start server")
    parser.add_argument("--uninstall", "-u", help="Uninstall kick start server")
    args = parser.parse_args()
    print(args)
    if args.install:
        install()
    else:
        uninstall()

    show_status(KS_FILE)


if __name__ == "__main__":
    main()
