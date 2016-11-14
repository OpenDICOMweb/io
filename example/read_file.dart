// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:encode/encoder.dart';
import 'package:io/io.dart';

String path = 'C:/odw/test_data/IM-0001-0001.dcm';

void main(List<String> args) {

  Filename fn = new Filename(path);
  Uint8List bytes = fn.file.readAsBytesSync();
  Entity e = DcmDecoder.decode(bytes);
  print(e.format(new Formatter()));

}



