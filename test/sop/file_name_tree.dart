// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:io';

import 'package:io/io.dart';

Future main() async {
  final root = r'C:\odw\test_data\sfd\CR_and_RF';
  final dir = new Directory(root);
  //List<String> tree = await getFilesSync(root, isDcmFile);
  print(root);
  final format = new FSFormatter();
  final out = format(dir);

  print('Tree:\n$out');
}
