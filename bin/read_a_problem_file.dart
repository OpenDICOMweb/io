// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

import 'dart:io';
import 'dart:typed_data';

import 'package:common/format.dart';
import 'package:common/logger.dart';
import 'package:convertX/convert.dart';
import 'package:core/core.dart';


const String inputDir = "C:/odw/test_data/problems/";

String p1 = inputDir + "16deca3c-8305-4d83-85e8-97a50dfba46e.dcm";
String p2 = inputDir + "19023b32-31c9-4592-99db-d28b488c101e.dcm";
String p3 = inputDir + "324072af-172d-420f-b0d9-6025e758797d.dcm";
String p4 = inputDir + "d1faaaaa-edf8-450e-8f62-35ebe592ca1b.dcm";

List<String> filesList = [p2];

void main() {
  Logger log = new Logger("read_a_problem_file", watermark: Severity.debug);

  for (String path in filesList) {
    print('Reading file: $path');
    log.config('Reading file: $path');

    Instance instance = readInstance(path);
    print('***patient:\n${instance.patient.format(new Formatter(maxDepth:5))}');
  }

  print('Active Patients: ${activeStudies.stats}');
}

Instance readInstance(String path) {
  var file = new File(path);
  Uint8List bytes = file.readAsBytesSync();

  DcmDecoder decoder = new DcmDecoder(new DSSource(bytes, path));
  return decoder.readInstance();
}
