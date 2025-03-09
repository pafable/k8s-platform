#!/usr/bin/env python3

import argparse
import logging
import os
import shutil
import sys

from typing import Final


DATE_FORMAT: Final[str] = "%Y-%m-%d %H:%M:%S"
AUTO_KS_SRC_DIR: Final[str] = "auto-ks"
AUTO_KS_DEST_DIR: Final[str] = "/srv"
LOG_FORMAT: Final[str] = "%(asctime)s - %(levelname)s - %(message)s"
SRV_FILE_DEST: Final[str]  = "/usr/lib/systemd/system"

logging.basicConfig(
    datefmt=DATE_FORMAT,
    format=LOG_FORMAT,
    level=logging.INFO,
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


def install() -> None:
    copy_dir(AUTO_KS_SRC_DIR, AUTO_KS_DEST_DIR)


def uninstall() -> None:
    remove_dir(f"{AUTO_KS_DEST_DIR}/{AUTO_KS_SRC_DIR}")


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


if __name__ == "__main__":
    main()
