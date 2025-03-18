import os
import sys

from frictionless import Resource, Schema, validate


def main():
    # read in the schema
    schema = Schema.from_descriptor(sys.argv[1])
    # print(schema)
    # todo: include schema validation
    report = validate(schema)
    # print(report)

    # apply the schema while loading
    resource = Resource(sys.argv[2], schema=schema)

    # print(resource)
    print(resource.to_view(type="see"))
    # resource.open()
    # for row in resource.text_stream:
    #     print(row.strip())
    resource.write(sys.argv[3])  # write to file
    return os.EX_OK


if __name__ == '__main__':
    sys.exit(main())
