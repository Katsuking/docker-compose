#!/usr/bin/env python
# coding: utf-8

import os

def doc2unix(DIR=os.getcwd()):
    """Change CRLF to LF

    Args:
        DIR (string, optional): LFに変更したいファイルのディレクトリ. Defaults to os.getcwd().
    """
    WINDOWS_LINE_ENDING = b'\r\n'
    UNIX_LINE_ENDING = b'\n'

    all_files_dir = [f for f in os.listdir(DIR) if os.path.isfile(f) ]

    for f in all_files_dir:
        with open(f, 'rb') as open_f:
            content = open_f.read()

        # Windows -> Unix
        content = content.replace(WINDOWS_LINE_ENDING, UNIX_LINE_ENDING)

        with open(f, 'wb') as open_f:
            open_f.write(content)

if __name__ == "__main__":
    doc2unix()

