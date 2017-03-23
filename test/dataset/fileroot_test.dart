// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:convertX/convert.dart';
import 'package:core/core.dart';
import 'package:core/dataset.dart';
import 'package:io/io.dart';
import "package:test/test.dart";

String path0 = 'C:/odw/sdk/test_tools/dcm_files/test_data/TransferUIDs/1.2.840'
    '.10008.1.2.5.dcm';

void main() {

  group("RLE Data set", () {
    test("Verify RLE parsing", () {

      Filename fn = new Filename(path0);
      DSSource dsSource = new DSSource(fn.readAsBytesSync(), fn.path);
      DcmReader reader = new DcmReader(dsSource);

      RootDataset  rds = reader.readRootDataset( (dsSource.lengthInBytes / 64).round());

      print(rds.format(new Formatter(maxDepth: 146)));

    });
  });

}
