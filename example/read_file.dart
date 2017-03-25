// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:convertX/convert.dart';
import 'package:core/core.dart';
import 'package:io/io.dart';

String path0 = 'C:/odw/test_data/IM-0001-0001.dcm';
String path1 = 'C:/odw/test_data/sfd/CR/PID_MINT10/1_DICOM_Original/CR.2.16.840.1.114255'
    '.393386351.1568457295.17895.5.dcm';
String path2 = 'C:/odw/test_data/sfd/CR/PID_MINT10/1_DICOM_Original/CR.2.16.840.1.114255.393386351.1568457295.48879.7.dcm';
String path3 = 'C:/odw/test_data/sfd/CT/Patient_4_3_phase_abd/1_DICOM_Original/IM000002.dcm';
String path4 = 'C:/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/1.2'
    '.392.200036.9125.3.3315591109239.64688154694.35921044/1.2.392.200036.9125.9.0.252688780.254812416.1536946029.dcm';
String path5 = 'C:/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/2.16.840.1.114255.1870665029.949635505.39523.169/2.16.840.1.114255.1870665029.949635505.10220.175.dcm';
String outPath = 'C:/odw/sdk/io/example/output/out.dcm';

void main(List<String> args) {
  final log = new Logger("read_file", watermark: Severity.debug);
  Filename fn = new Filename(path5);
  Uint8List bytes = fn.file.readAsBytesSync();
  Instance instance = DcmDecoder.decode(new DSSource(bytes, fn.path));
  log.debug('Instance: $instance');
  log.debug('dataset length: ${instance.dataset.length} elements');
  log.debug(instance.format(new Formatter(maxDepth: 146)));

}
