#!/usr/bin/env python3
import sys, os, platform, subprocess, tempfile, shutil, argparse

def require_tool(name):
    if not shutil.which(name):
        print(f"Error: Required tool `{name}` not found in PATH.")
        sys.exit(1)


def detect_os():
    system = platform.system().lower()
    if 'darwin' in system:
        return 'macos'
    elif 'linux' in system:
        return 'linux'
    else:
        print(f"Unsupported OS: {system}")
        sys.exit(1)


def run_cmd(cmd, verbose=False, shell=False):
    if verbose:
        print(f"Running: {cmd}")
    subprocess.run(cmd, shell=shell, check=True)


def run_local(os_name, no_install, verbose):
    script = os.path.join(os.path.dirname(__file__), 'installers', f"{os_name}.sh")
    cmd = ['bash', script]
    if no_install:
        cmd.append('--no-install')
    run_cmd(cmd, verbose=verbose)


def run_remote(host, verbose):
    require_tool('tar')
    require_tool('ssh')
    repo_root = os.path.dirname(__file__)
    tf = tempfile.NamedTemporaryFile(suffix='.tar.gz', delete=False)
    tar_path = tf.name
    tf.close()
    try:
        run_cmd(['tar', 'czf', tar_path, '-C', repo_root, '.'], verbose=verbose)
        stream_cmd = f"cat {tar_path} | ssh -T {host} 'bash -s'"
        run_cmd(stream_cmd, verbose=verbose, shell=True)
    finally:
        if os.path.exists(tar_path):
            os.remove(tar_path)


def main():
    parser = argparse.ArgumentParser(description='Bootstrap dotfiles locally or remotely')
    parser.add_argument('mode', choices=['local', 'remote'], help='Install mode')
    parser.add_argument('host', nargs='?', help='Remote host (user@host)')
    parser.add_argument('-v', '--verbose', action='store_true', help='Verbose output')
    parser.add_argument('--no-install', action='store_true', help='Skip package installation')
    args = parser.parse_args()

    require_tool('bash')

    if args.mode == 'local':
        os_name = detect_os()
        run_local(os_name, args.no_install, args.verbose)
    else:
        if not args.host:
            parser.error('remote mode requires host argument')
        run_remote(args.host, args.verbose)

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print("\nAborted by user.")
        sys.exit(1)
