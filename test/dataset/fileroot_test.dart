// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.


import 'package:core/server.dart' hide group;
import 'package:converter/converter.dart';
import 'package:io_extended/io_extended.dart';
import 'package:test/test.dart';

String path0 = 'C:/odw_test_data/mweb/TransferUIDs/1.2.840.10008.1.2.5.dcm';

void main() {
  Server.initialize(name: 'fileroot_test.dart', level: Level.info0);

  group('RLE Data set', () {
    test('Verify RLE parsing', () {
      final fn = Filename(path0);
      final bytes = fn.file.readAsBytesSync();
      final  rds  = TagReader(bytes).readRootDataset();
      print(rds.format(Formatter(maxDepth: 146)));
    });
  });

}
