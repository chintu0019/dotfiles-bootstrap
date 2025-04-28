#!/usr/bin/env python3
import sys, os, platform, subprocess, tempfile

def detect_os():
    system = platform.system().lower()
    if 'darwin' in system:
        return 'macos'
    elif 'linux' in system:
        return 'linux'
    else:
        print(f"Unsupported OS: {system}")
        sys.exit(1)


def run_local(os_name):
    script = os.path.join(os.path.dirname(__file__), 'installers', f"{os_name}.sh")
    subprocess.run(['bash', script], check=True)


def run_remote(host):
    # Create a tar of the repo root
    repo_root = os.path.dirname(__file__)
    with tempfile.NamedTemporaryFile(suffix='.tar.gz', delete=False) as tf:
        tar_path = tf.name
        subprocess.run(['tar', 'czf', tar_path, '-C', repo_root, '.'], check=True)
    # Stream tar and execute remote.sh
    cmd = f"cat {tar_path} | ssh {host} 'bash -s' --"
    subprocess.run(cmd, shell=True, check=True)
    os.remove(tar_path)


def main():
    if len(sys.argv) < 2:
        print("Usage: bootstrap.py [local|remote] [host]")
        sys.exit(1)

    mode = sys.argv[1]
    if mode == 'local':
        os_name = detect_os()
        run_local(os_name)
    elif mode == 'remote':
        if len(sys.argv) != 3:
            print("Usage: bootstrap.py remote user@host")
            sys.exit(1)
        run_remote(sys.argv[2])
    else:
        print("Unknown mode. Use 'local' or 'remote'.")
        sys.exit(1)


if __name__ == '__main__':
    main()