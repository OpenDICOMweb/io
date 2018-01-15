// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.


import 'package:core/server.dart';
import 'package:convert/convert.dart';
import 'package:io/io.dart';
import 'package:test/test.dart';

String path0 = 'C:/acr/odw/sdk/test_tools/test_data/TransferUIDs/1.2.840'
    '.10008.1.2.5.dcm';

void main() {
  Server.initialize(name: 'fileroot_test.dart', level: Level.info0);

  group('RLE Data set', () {
    test('Verify RLE parsing', () {
      final fn = new Filename(path0);
      final  rds  = TagReader.readFile(fn.file);
      print(rds.format(new Formatter(maxDepth: 146)));
    });
  });

}
