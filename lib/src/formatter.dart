// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:io';

//TODO: use regular formatter
class FSFormatter {
  int level = 0;
  int count = 0;
  int indent;

  FSFormatter({this.indent: 2});

  String get sp => "".padRight(indent * level, " ");

  String fmt(Object o) => '$sp$count: $o';

  String call(FileSystemEntity fse, [String output = ""]) {
    var s = fmt(fse);
    count++;
  //  print(s);
    output += s;
    if (fse is Directory) {
      level++;
      var list = fse.listSync(followLinks: false);
      for (var e in list) output += call(e, output);
      level--;
    }
    return output;
  }
}
