#!/usr/bin/python3
# Version: v1.2
# Description:
import redis
import sys
import argparse
import json

def parse_args():
    argParse = argparse.ArgumentParser()
    argParse.add_argument("-p", help="Redis port to monitor", required=True)
    argParse.add_argument("-i", help="Redis IP", default="127.0.0.1")
    argParse.add_argument("-a", help="Redis port's password")
    argParse.add_argument("-w", help="Warning Threshold", type=int, default=80)
    argParse.add_argument("-c", help="Critical Threshold", type=int, default=90)
    argParse.add_argument("-t", help="Type check memory or check role", required=True)
    argParse.add_argument("-role", help="Role master or slave")
    return argParse.parse_args()

def load_passwords(file_path):
    with open(file_path, 'r') as f:
        data = f.read()
    obj = json.loads(data)
    return {key.split(":")[-1]: value for key, value in obj.items()}

def get_output_redis(key, host, port, pwd, timeout=10):
    try:
        r = redis.Redis(host=host, port=port, password=pwd, decode_responses=True, socket_timeout=timeout)
        return 0, r.info()[key]
    except Exception as e:
        return -1, str(e)

def check_memory(ip, port, password, warn, crit):
    ret1, used_mem = get_output_redis("used_memory", ip, port, password)
    if ret1 == -1:
        return "Crit! " + used_mem, 2

    ret2, total_mem = get_output_redis("maxmemory", ip, port, password)
    if ret2 == -1:
        return "Crit! " + total_mem, 2

    percent_use_mem = (float(used_mem) / float(total_mem)) * 100
    if percent_use_mem >= crit:
        return f"Crit! Port {port} used {round(percent_use_mem)}% memory", 2
    elif percent_use_mem >= warn:
        return f"Warn! Port {port} used {round(percent_use_mem)}% memory", 1
    else:
        return f"Ok! Port {port} used {round(percent_use_mem)}% memory", 0

def check_role(ip, port, password, expected_role):
    ret, role = get_output_redis("role", ip, port, password)
    if ret == -1:
        return "Crit! Check role master/slave.", 2
    elif role != expected_role:
        return "Crit! Role mismatch. Expected: " + expected_role, 2
    else:
        return "Ok! Role is " + role, 0

def main():
    args = parse_args()
    port = args.p
    ip = args.i
    warn = args.w
    crit = args.c
    check_type = args.t
    expected_role = args.role

    lst_pass = load_passwords('/opt/redis-auth.json')
    password = lst_pass.get(port)

    if not password:
        print(f"Crit! No password found for port {port}")
        sys.exit(2)

    memory_status, memory_code = check_memory(ip, port, password, warn, crit) if check_type in ["memory", "both"] else ("", 0)
    role_status, role_code = check_role(ip, port, password, expected_role) if check_type in ["role", "both"] else ("", 0)

    if memory_code == 2 or role_code == 2:
        print(f"{memory_status} {role_status}".strip())
        sys.exit(2)
    elif memory_code == 1 or role_code == 1:
        print(f"{memory_status} {role_status}".strip())
        sys.exit(1)
    else:
        print(f"{memory_status} {role_status}".strip())
        sys.exit(0)

if __name__ == "__main__":
    main()