// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:io/io.dart';

import 'sop_data.dart';

const String tdir = "C:/mint_test_data/CR";

String t1dir = "D:/M2sata/mint_test_data/sfd/cr";

String f1 = "D:/M2sata/mint_test_data/sfd/CR/PID_MINT10/1_DICOM_Original/CR.2.16.840.1.114255.393386351.1568457295.17895.5.dcm";
String f2 = "D:/M2sata/mint_test_data/sfd/CR/PID_MINT10/1_DICOM_Original/CR.2.16.840.1.114255.393386351.1568457295.48879.7.dcm";

void main() {

  var files = SopFiles.cr1.list;

  print(SopFiles.cr2.list);

  for (String s in files) {
    Uint8List data = readSync(files[0]);
    print('$s: len= ${data.length}');
  }

}