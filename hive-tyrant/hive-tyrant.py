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
        self.token_name = token_name
        self.token_value = token_value
        self.user = user
        self.verify_ssl = verify_ssl


    def __str__(self) -> str:
        return f"Session for {self.host}"


    def _authenticate(self) -> ProxmoxAPI:
        return ProxmoxAPI(
            host=self.host,
            token_name=self.token_name,
            token_value=self.token_value,
            user=self.user,
            verify_ssl=False
        )


    def get_all_nodes(self) -> list:
        proxmox = self._authenticate()
        return proxmox.nodes.get()


def main():
    p1 = PMSession(
        HOST,
        TOKEN_NAME,
        TOKEN_VALUE,
        USER
    )

    for node in p1.get_all_nodes():
        pp.pprint(node)


if __name__ == '__main__':
    main()
