// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:async';

import 'package:io/io.dart';


Future main()  async {
  String root = r"C:\odw\test_data\sfd\CR_and_RF";
  List<String> tree = await getDcmFiles(root);
  Formatter format  = new Formatter();
  var out = format(tree);

  print('Tree:\n$out');
}



