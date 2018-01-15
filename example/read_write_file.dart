// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:convert/convert.dart';
import 'package:io/io.dart';
import 'package:io/src/tools/compare_files.dart';

//String inPath = 'C:/acr/odw/test_data/IM-0001-0001.dcm';
String inPath =
    'C:/acr/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/'
    '2.16.840.1.114255.1870665029.949635505.39523.169/2.16.840.1.114255.1870665029.949635505.10220.175.dcm';
String outPath =
    'C:/acr/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/'
    '2.16.840.1.114255.1870665029.949635505.39523.169/output.dcm';

String in1 =
    'C:/acr/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/'
    '2.16.840.1.114255.1870665029.949635505.39523.169/'
    '2.16.840.1.114255.1870665029.949635505.25169.170.dcm';

String in2 =
    'C:/acr/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/2.16.840'
    '.1.114255.1870665029.949635505.39523.169/2.16.840.1.114255.1870665029.949635505.10220.175.dcm';

String in3 =
    'C:/acr/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/2.16.840.1.114255.1870665029.949635505.39523.169/2.16.840.1.114255.1870665029.949635505.25169.170.dcm';

String in4 = 'C:/dicom/6688/12/0B009D38/0B009D3D/9E163B22';

String in5 =
    'C:/acr/odw/test_data/sfd/CT/Patient_8_Non_ossifying_fibroma/1_DICOM_Original/IM002102.dcm';

String in6 = 'C:/dicom/6688/12/0B009D38/DC418F0F/0691E2EF';

String in7 =
    'C:/acr/odw/test_data/sfd/CT/Patient_16_CT_Maxillofacial_-_Wegners/1_DICOM_Original'
    '/IM000001.dcm';

String in8 = 'C:/dicom/6688/21/21/02CB05C5/04B82189/04B821C5';

String in9 =
    'C:/acr/odw/test_data/sfd/CT/Patient_8_Non_ossifying_fibroma/1_DICOM_Original/IM002102'
    '.dcm';

String in10 = 'C:/acr/odw/test_data/sfd/CT/PID_TESTCT1/1_DICOM_Original/0034C9BE.dcm';

String in11 =
    'C:/acr/odw/test_data/sfd/CT/Patient_3_Cardiac_CTA/1_DICOM_Original/IM008679.dcm';

String out1 =
    'C:/acr/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/'
    '2.16.840.1.114255.1870665029.949635505.39523.169/'
    'output.dcm';

String out3 =
    'C:/acr/odw/sdk/io/example/output/2.16.840.1.114255.1870665029.949635505.25169.170.dcm';

String outX = 'C:/acr/odw/sdk/io/example/output/foo.dcm';

void main() {
  Server.initialize(name: 'read_write_file.dart', level: Level.debug);

  final fn = new Filename(in10);
  log.info0('Reading: $fn');
  final rds0 = TagReader.readFile(fn.file);
  log.info0('Decoded: $rds0');
  if (rds0 == null) return null;
  log
    ..debug(rds0.format(new Formatter(maxDepth: -1)))
    ..info0('${rds0[kFileMetaInformationGroupLength].info}')
    ..info0('${rds0[kFileMetaInformationVersion].info}');
  // Write a File
  final fnOut = new Filename.withType(outX, FileSubtype.part10)..writeSync(rds0);

  log.info0('Re-reading: $fnOut');
  final rds1 = TagReader.readFile(fn.file);
  log
    ..info0(rds1)
    ..debug(rds1.format(new Formatter(maxDepth: -1)));

  // Compare [Dataset]s
  final comparitor = new DatasetComparitor(rds0, rds1)..run;
  if (comparitor.hasDifference) {
    log.fatal('Result: ${comparitor.info}');
  }
  // Compare input and output
  log..info0('Comparing Bytes:')
  ..down
  ..info0('Original: ${fn.path}')
  ..info0('Result: ${fnOut.path}');
  final out = compareFiles(fn.path, fnOut.path);
  if (out == null) {
    log.info0('Files are identical.');
  } else {
    log..info0('Files are different!')
    ..fatal('$out');
  }
  log.up;
}
