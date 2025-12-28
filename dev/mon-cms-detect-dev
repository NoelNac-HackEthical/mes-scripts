#!/usr/bin/env python3
# NAME=mon-cms-detect-dev
# VERSION=0.1.0
# STATUS=DEV
# DESCRIPTION=Détection simple de CMS via empreintes dans la page HTML (requests).

import argparse
import sys
import requests


BOLD = "\033[1m"
GREEN = "\033[92m"
RED = "\033[91m"
RED_BOLD = "\033[1;31m"
RESET = "\033[0m"


FINGERPRINTS = [
    # (needle, label, color_prefix)
    ("wp-content", "WordPress", BOLD),
    ("content/themes", "WordPress", BOLD),
    ("Joomla", "Joomla", BOLD),
    ("Drupal", "Drupal", BOLD),
    ("sites/default", "Drupal", BOLD),
    ("modules/system", "Drupal", RED_BOLD),
    ("typo3conf", "TYPO3", BOLD),
    ("app/code/core", "Magento", BOLD),
    ("var/cache", "PrestaShop", BOLD),
    ("themes/jupiter", "Jupiter", BOLD),
]


def normalize_url(url: str) -> str:
    u = url.strip()
    if not u:
        return u
    if not (u.startswith("http://") or u.startswith("https://")):
        u = "http://" + u
    return u


def detect_cms(url: str, timeout: float = 10.0, verify_tls: bool = True, user_agent: str = None) -> int:
    headers = {}
    if user_agent:
        headers["User-Agent"] = user_agent

    try:
        r = requests.get(url, timeout=timeout, allow_redirects=True, headers=headers, verify=verify_tls)
        text = r.text or ""

        for needle, label, prefix in FINGERPRINTS:
            if needle in text:
                print(f"{prefix}The website {url} is running on {GREEN}{label}{RESET}")
                return 0

        print(f"{RED}No CMS detected on the website {url}{RESET}")
        return 1

    except requests.exceptions.RequestException as e:
        print(f"{RED_BOLD}Error: {e}{RESET}")
        return 2


def main() -> int:
    p = argparse.ArgumentParser(description="Simple CMS detector (HTML fingerprints).")
    p.add_argument("url", nargs="?", help="URL or host (ex: heal.htb or http://heal.htb)")
    p.add_argument("--timeout", type=float, default=10.0, help="HTTP timeout in seconds (default: 10)")
    p.add_argument("-k", "--insecure", action="store_true", help="Disable TLS verification (https)")
    p.add_argument("--user-agent", default=None, help="Custom User-Agent header")
    args = p.parse_args()

    url = args.url
    if not url:
        # comportement proche de ton script original
        url = input("Enter the URL of the website to detect the CMS for: ").strip()

    url = normalize_url(url)
    if not url:
        print(f"{RED_BOLD}Error: empty URL{RESET}")
        return 2

    return detect_cms(url, timeout=args.timeout, verify_tls=(not args.insecure), user_agent=args.user_agent)


if __name__ == "__main__":
    raise SystemExit(main())
