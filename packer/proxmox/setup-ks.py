#!/usr/bin/env python3

import argparse
import logging
import os
import shutil
import subprocess

from typing import Final


DATE_FORMAT: Final[str] = "%Y-%m-%d %H:%M:%S"
KS_SRV_FILE: Final[str] = "ks-srv.service"
AUTO_KS_SRC_DIR: Final[str] = "auto-ks"
AUTO_KS_DEST_DIR: Final[str] = "/srv"
LOG_FORMAT: Final[str] = "%(asctime)s - %(levelname)s - %(message)s"
PORT: Final[int] = 8080
SRV_FILE_DEST: Final[str]  = "/usr/lib/systemd/system"

logging.basicConfig(
    datefmt=DATE_FORMAT,
    format=LOG_FORMAT,
    level=logging.INFO,
)


def copy_files(src: str, dst: str) -> None:
    """
    :param src:
    :param dst:
    :return:
    """
    logging.info(
        "copied %s to %s",
        src,
        shutil.copy(src, dst)
    )


def copy_dir(src: str, dst: str) -> None:
    """
    :param src:
    :param dst:
    :return:
    """
    logging.info(
        "copied %s to %s",
        src,
        shutil.copytree(
            src,
            dst,
            dirs_exist_ok=True
        )
    )


def remove_dir(src: str) -> None:
    """
    :param src:
    :return:
    """
    try:
        shutil.rmtree(src)
    except FileNotFoundError:
        logging.error("could not find %s", src)


def reload_daemon() -> None:
    logging.info("%s", subprocess.run(["systemctl", "daemon-reload"]))


def open_port(port: int) -> None:
    """
    :param port:
    :return:
    """
    logging.info("%s", subprocess.run(["firewall-cmd", f"--add-port={port}/tcp", "--permanent"]))
    logging.info("%s", subprocess.run(["firewall-cmd", "--reload"]))


def close_port(port: int) -> None:
    """
    :param port:
    :return:
    """
    logging.info("%s", subprocess.run(["firewall-cmd", f"--remove-port={port}/tcp", "--permanent"]))
    logging.info("%s", subprocess.run(["firewall-cmd", "--reload"]))


def start_srv(srv: str) -> None:
    """
    :param srv:
    :return:
    """
    logging.info("%s", subprocess.run(["systemctl", "start", srv]))


def stop_srv(srv: str) -> None:
    """
    :param srv:
    :return:
    """
    logging.info("%s", subprocess.run(["systemctl", "stop", srv]))


def remove_files(src_dir: str, file: str) -> None:
    """
    :param src_dir:
    :param file:
    :return:
    """
    file_to_remove = f"{src_dir}/{file}"

    try:
        os.remove(file_to_remove)
    except FileNotFoundError:
        logging.error("could not find %s", file_to_remove)


def install() -> None:
    copy_files(KS_SRV_FILE, SRV_FILE_DEST)
    copy_dir(AUTO_KS_SRC_DIR, AUTO_KS_DEST_DIR)
    open_port(PORT)
    reload_daemon()
    start_srv(KS_SRV_FILE)


def uninstall() -> None:
    stop_srv(KS_SRV_FILE)
    remove_files(SRV_FILE_DEST, KS_SRV_FILE)
    remove_dir(f"{AUTO_KS_DEST_DIR}/{AUTO_KS_SRC_DIR}")
    close_port(PORT)
    reload_daemon()


def show_status(service: str) -> None:
    """
    :param service:
    :return:
    """
    subprocess.run(["systemctl", "status", f"{service}"])
    subprocess.run(["firewall-cmd", "--list-all"])


def main():
    parser = argparse.ArgumentParser(description="Configures kick start http server")
    parser.add_argument("--install", "-i", help="Install kick start server", action="store_true")
    parser.add_argument("--uninstall", "-u", help="Uninstall kick start server", action="store_true")
    args = parser.parse_args()

    if args.install:
        install()
    else:
        uninstall()

    show_status(KS_SRV_FILE)


if __name__ == "__main__":
    main()
