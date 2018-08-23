// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:dicom_io.dart';

void main([List<String> args = const ['foo']]) {
  final path = args[0];
  final file = DicomFile(path, exists: true);
  final instance = file.read();
  print('Instance: $instance');
}