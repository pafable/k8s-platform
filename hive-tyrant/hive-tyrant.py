#!/usr/bin/env python3

"""
HIVE TYRANT
This script will check a proxmox's cluster
"""

import configparser
import os
import pprint
from proxmoxer import ProxmoxAPI

pp = pprint.PrettyPrinter(indent=4)

# Reads creds from config.ini
config = configparser.ConfigParser()
config.read("config.ini")

try:
    SECTION = "DEFAULT"
    HOST = config.get(SECTION, "PM_HOST")
    USER = config.get(SECTION, "PM_USER")
    TOKEN_NAME = config.get(SECTION, "PM_TOKEN_NAME")
    TOKEN_VALUE = config.get(SECTION, "PM_TOKEN_VALUE")
except configparser.NoOptionError:
    HOST = os.environ.get("PM_HOST")
    USER = os.environ.get("PM_USER")
    TOKEN_NAME = os.environ.get("PM_TOKEN_NAME")
    TOKEN_VALUE = os.environ.get("PM_TOKEN_VALUE")


class PMSession:
    def __init__(self, host, token_name, token_value, user, verify_ssl=False):
        self.host = host
        self.proxmox = ProxmoxAPI(
                            host=host,
                            token_name=token_name,
                            token_value=token_value,
                            user=user,
                            verify_ssl=verify_ssl
                        )


    def __str__(self) -> str:
        return f"Session for {self.host}"


    def get_all_nodes(self) -> list:
        """
        Get all nodes in the Proxmox cluster
        :return:
        """
        return self.proxmox.nodes.get()


    def get_proxmox_version(self) -> str:
        """
        Get Proxmox version
        :return:
        """
        return self.proxmox("version").get()["version"]


def main():
    p1 = PMSession(
        HOST,
        TOKEN_NAME,
        TOKEN_VALUE,
        USER
    )

    pp.pprint(p1.__str__())

    for node in p1.get_all_nodes():
        pp.pprint(node["id"])

    pp.pprint(f"proxmox_version: {p1.get_proxmox_version()}")


if __name__ == '__main__':
    main()
