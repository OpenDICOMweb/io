// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:convertX/convert.dart';
import 'package:core/core.dart';
import 'package:io/io.dart';
import 'package:io/src/test/compare_files.dart';

//String inPath = 'C:/odw/test_data/IM-0001-0001.dcm';
String inPath = 'C:/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/'
    '2.16.840.1.114255.1870665029.949635505.39523.169/2.16.840.1.114255.1870665029.949635505.10220.175.dcm';
String outPath = 'C:/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/'
    '2.16.840.1.114255.1870665029.949635505.39523.169/output.dcm';

String in1 = "C:/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/"
    "2.16.840.1.114255.1870665029.949635505.39523.169/"
    "2.16.840.1.114255.1870665029.949635505.25169.170.dcm";

String in2 = 'C:/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/2.16.840'
    '.1.114255.1870665029.949635505.39523.169/2.16.840.1.114255.1870665029.949635505.10220.175.dcm';

String in3 = "C:/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/2.16.840.1.114255.1870665029.949635505.39523.169/2.16.840.1.114255.1870665029.949635505.25169.170.dcm";

String in4 = 'C:/dicom/6688/12/0B009D38/0B009D3D/9E163B22';

String in5 = 'C:/odw/test_data/sfd/CT/Patient_8_Non_ossifying_fibroma/1_DICOM_Original/IM002102.dcm';

String in6 = 'C:/dicom/6688/12/0B009D38/DC418F0F/0691E2EF';

String in7 = 'C:/odw/test_data/sfd/CT/Patient_16_CT_Maxillofacial_-_Wegners/1_DICOM_Original'
    '/IM000001.dcm';

String in8 = 'C:/dicom/6688/21/21/02CB05C5/04B82189/04B821C5';

String in9 = 'C:/odw/test_data/sfd/CT/Patient_8_Non_ossifying_fibroma/1_DICOM_Original/IM002102'
    '.dcm';

String in10 = 'C:/odw/test_data/sfd/CT/PID_TESTCT1/1_DICOM_Original/0034C9BE.dcm';

String in11 = 'C:/odw/test_data/sfd/CT/Patient_3_Cardiac_CTA/1_DICOM_Original/IM008679.dcm';

String out1 = "C:/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/"
    "2.16.840.1.114255.1870665029.949635505.39523.169/"
    "output.dcm";

String out3 = "C:/odw/sdk/io/example/output/2.16.840.1.114255.1870665029.949635505.25169.170.dcm";

String outX = "C:/odw/sdk/io/example/output/foo.dcm";

final log = new Logger("read_write_file", watermark: Severity.debug);

void main(List<String> args) {
  Filename fn = new Filename(in10);
  log.info('Reading: $fn');
  Uint8List bytes0 = fn.file.readAsBytesSync();
  log.info('  ${bytes0.length} bytes');
  Instance instance0 = DcmDecoder.decode(new DSSource(bytes0, fn.path));
  log.info('Decoded: $instance0');
  if (instance0 == null) return null;
  log.debug(instance0.format(new Formatter(maxDepth: -1)));
  log.info('${instance0[Tag.kFileMetaInformationGroupLength].info}');
  log.info('${instance0[Tag.kFileMetaInformationVersion].info}');
  // Write a File
  Filename fnOut = new Filename.withType(outX, FileSubtype.part10);
  fnOut.writeSync(instance0);

  log.info('Re-reading: $fnOut');
  Uint8List bytes1 = fnOut.readAsBytesSync();
  log.info('read ${bytes1.length} bytes');
  Instance instance1 = DcmDecoder.decode(new DSSource(bytes1, fn.path));
  log.info(instance1);
  log.debug(instance1.format(new Formatter(maxDepth: -1)));

  // Compare [Dataset]s
  var comparitor = new DatasetComparitor(instance0.dataset, instance1.dataset);
  comparitor.run;
  if (comparitor.hasDifference) {
    log.fatal('Result: ${comparitor.info}');

  }
  // Compare input and output
  log.info('Comparing Bytes:');
  log.down;
  log.info('Original: ${fn.path}');
  log.info('Result: ${fnOut.path}');
  FileCompareResult out = compareFiles(fn.path, fnOut.path, log);
  if (out == null) {
    log.info('Files are identical.');
  } else {
    log.info('Files are different!');
    log.fatal('$out');
  }
  log.up;
}
