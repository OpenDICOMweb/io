// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:encode/encoder.dart';
import 'package:io/io.dart';

String path0 = 'C:/odw/test_data/IM-0001-0001.dcm';
String path1 = 'C:/odw/test_data/sfd/CR/PID_MINT10/1_DICOM_Original/CR.2.16.840.1.114255'
    '.393386351.1568457295.17895.5.dcm';
String path2 = 'C:/odw/test_data/sfd/CR/PID_MINT10/1_DICOM_Original/CR.2.16.840.1.114255.393386351.1568457295.48879.7.dcm';
String path3 = 'C:/odw/test_data/sfd/CT/Patient_4_3_phase_abd/1_DICOM_Original/IM000002.dcm';

String outPath = 'C:/odw/sdk/io/example/output/out.dcm';

void main(List<String> args) {

  Filename fn = new Filename(path3);
  Uint8List bytes = fn.file.readAsBytesSync();
  Entity e = DcmDecoder.decode(bytes);
  print('e: $e');
  print('dataset length: ${e.dataset.length} elements');
  print(e.format(new Formatter(maxDepth: 146, width: 4)));

}
