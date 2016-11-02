// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.

// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:core/core.dart';
import 'package:encode/dicom.dart';
import 'package:io/io.dart';

String inputDir = "C:/odw/test_data/sfd/CR/PID_MINT10/1_DICOM_Original/";
String outputDir = "C:/odw/sdk/convert/test_output/";

String crf1 = "CR.2.16.840.1.114255.393386351.1568457295.17895.5.dcm";
String crf2 = "CR.2.16.840.1.114255.393386351.1568457295.48879.7.dcm";

void main() {
  // Read a File
  Filename fnIn = new Filename(crf1);
  Instance instance = fnIn.readSync();
  print(instance.info);

  // Write a File
  Filename fnOut = new Filename.withType(crf1, FileType.dcmInstance);
  fnOut.writeSync(instance);

}