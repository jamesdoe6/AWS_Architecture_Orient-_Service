#!/usr/bin/env python3
import sys
import time
import urllib.request
import urllib.error
from datetime import datetime

def check(url: str) -> str:
    try:
        req = urllib.request.Request(url, method="GET")
        with urllib.request.urlopen(req, timeout=2) as resp:
            return str(resp.status)
    except urllib.error.HTTPError as e:
        return str(e.code)
    except Exception:
        return "000"

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 monitor.py <URL_DU_SERVICE>")
        sys.exit(1)

    url = sys.argv[1]
    print(f"Monitoring {url} (Ctrl+C pour arreter)\n")

    count_ok = 0
    count_fail = 0

    try:
        while True:
            code = check(url)
            ts = datetime.now().strftime("%H:%M:%S")
            status = "OK" if code == "200" else "FAIL"
            if status == "OK":
                count_ok += 1
            else:
                count_fail += 1
            print(f"[{ts}] HTTP {code}  {status}   (ok={count_ok} fail={count_fail})")
            time.sleep(0.5)
    except KeyboardInterrupt:
        print(f"\nArret. Total: ok={count_ok} fail={count_fail}")

if __name__ == "__main__":
    main()
