import sys
import yaml
from frictionless import Schema


def main():
    descriptor = yaml.safe_load(sys.argv[1])

    return 0


if __name__ == '__main__':
    sys.exit(main())