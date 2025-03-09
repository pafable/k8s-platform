#!/usr/bin/env python3

import argparse
import logging
import os
import shutil
import subprocess
import sys

from typing import Final


DATE_FORMAT: Final[str] = "%Y-%m-%d %H:%M:%S"
KS_SRV_FILE: Final[str] = "ks-srv.service"
AUTO_KS_SRC_DIR: Final[str] = "auto-ks"
AUTO_KS_DEST_DIR: Final[str] = "/srv"
LOG_FORMAT: Final[str] = "%(asctime)s - %(levelname)s - %(message)s"
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
    os.makedirs(f"{dst}/{src}", exist_ok=True)
    logging.info(
        "copied contents of %s to %s",
        src,
        shutil.copytree(
            src,
            f"{dst}/{src}",
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
    reload_daemon()
    start_srv(KS_SRV_FILE)


def uninstall() -> None:
    stop_srv(KS_SRV_FILE)
    reload_daemon()
    remove_files(SRV_FILE_DEST, KS_SRV_FILE)
    remove_dir(f"{AUTO_KS_DEST_DIR}/{AUTO_KS_SRC_DIR}")


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

    if len(sys.argv) <= 1:
        parser.print_help()
        sys.exit(1)

    if args.install:
        install()

    if args.uninstall:
        uninstall()

    show_status(KS_SRV_FILE)


if __name__ == "__main__":
    main()
