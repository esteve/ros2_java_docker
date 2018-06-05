#!/usr/bin/python3
import os
import sys

def main(distro, flavor):
    if distro not in ('xenial', 'bionic'):
        print('Unknown distro: {}'.format(distro))
        sys.exit(1)
    if flavor not in ('java', 'android'):
        print('Unknown flavor: {}'.format(flavor))
        sys.exit(1)

    os.makedirs(os.path.join(distro, flavor), exist_ok=True)
    with open(os.path.join(distro, flavor, 'Dockerfile'), 'w') as f:
        f.write('FROM ubuntu:{}\n'.format(distro))
        f.write('MAINTAINER esteve@apache.org\n')
        with open(os.path.join('steps', '0000-ros2.txt'), 'r') as f2:
            f.write(f2.read())
        with open(os.path.join('steps', '0001-common-java.txt'), 'r') as f2:
            f.write(f2.read())
        with open(os.path.join('steps', '0002-{}.txt'.format(flavor)), 'r') as f2:
            f.write(f2.read())

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print('Usage: UBUNTU_DISTRO FLAVOR')
        sys.exit(1)

    main(*sys.argv[1:])
