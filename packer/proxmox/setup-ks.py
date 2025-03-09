#!/usr/bin/env python3

import argparse
import logging
import os
import shutil
import sys

from typing import Final


DATE_FORMAT: Final[str] = "%Y-%m-%d %H:%M:%S"
AUTO_KS_SRC_DIR: Final[str] = "kickstart"
AUTO_KS_DEST_DIR: Final[str] = "/srv"
LOG_FORMAT: Final[str] = "%(asctime)s - %(levelname)s - %(message)s"

logging.basicConfig(
    datefmt=DATE_FORMAT,
    format=LOG_FORMAT,
    level=logging.INFO,
)


class Installer:
    def __init__(self, ks_src: str, ks_dest: str):
        self.src: str = ks_src
        self.dest: str = ks_dest

    def _copy_dir(self) -> None:
        os.makedirs(f"{self.dest}/{self.src}", exist_ok=True)
        logging.info(
            "copied contents of %s to %s",
            self.src,
            shutil.copytree(
                self.src,
                f"{self.dest}/{self.src}",
                dirs_exist_ok=True
            )
        )

    def _remove_dir(self) -> None:
        try:
            shutil.rmtree(f"{self.dest}/{self.src}")
        except FileNotFoundError:
            logging.error("could not find %s", self.src)

    def install(self) -> None:
        self._copy_dir()

    def uninstall(self) -> None:
        self._remove_dir()


def main():
    parser = argparse.ArgumentParser(description="Configures kick start http server")
    parser.add_argument("-i", "--install", help="Install kick start server", action="store_true")
    parser.add_argument("-u", "--uninstall", help="Uninstall kick start server", action="store_true")
    args = parser.parse_args()

    if len(sys.argv) <= 1:
        parser.print_help()
        sys.exit(1)

    init = Installer(AUTO_KS_SRC_DIR, AUTO_KS_DEST_DIR)

    if args.install:
        init.install()

    if args.uninstall:
        init.uninstall()


if __name__ == "__main__":
    main()
