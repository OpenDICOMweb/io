// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

class FSFormatter {
    int level = 0;
    int count = 0;
    int indent;

    FSFormatter({this.indent: 2});

    String get sp => "".padRight(indent * level, " ");

    String call(List tree, [String output = ""]) {
        print('Level: $level');
        output += '${sp}Level: $level\n';
        for (var v in tree) {
            if (v is String) {
                count++;
                output += '$sp$v\n';
            } else if (v is List) {
                level++;
                output = call(v, output);
                level--;
            } else {
                throw "invalid object: $v";
            }
        }
        print('loops: $level');
        print('count: $count');
        return output;
    }
}