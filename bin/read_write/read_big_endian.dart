// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:converter/converter.dart';
import 'package:core/server.dart';
import 'package:path/path.dart' as path;

const String bePath =
    'C:/acr/odw/test_data/mweb/ASPERA/DICOM files only'
    '/613a63c7-6c0e-4fd9-b4cb-66322a48524b.dcm';

//Urgent: bug with path20
Future main() async {
  Server.initialize(name: 'ReadFile', level: Level.debug3, throwOnError: true);

  final fPath = bePath;

  print('path: $fPath');
  print(' out: ${getTempFile(fPath, 'dcmout')}');
  final url = new Uri.file(fPath);
  stdout.writeln('Reading(byte): $url');

  final reader = new ByteReader.fromPath(fPath, doLogging: true);
  final rds = reader.readRootDataset();

  if (rds == null) {
    log.warn('Invalid DICOM file: $fPath');
  } else if (reader.pInfo != null) {
    final infoPath = '${path.withoutExtension(fPath)}.info';
    log.info('infoPath: $infoPath');
    final sb = new StringBuffer('${reader.pInfo.summary(rds)}\n')
      ..write('Bytes Dataset: ${rds.summary}');
    new File(infoPath)..writeAsStringSync(sb.toString());
    log.debug(sb.toString());

    final z = new Formatter.withIndenter(-1, Prefixer.basic);
    final fmtPath = '${path.withoutExtension(fPath)}.fmt';
    log.info('fmtPath: $fmtPath');
    final fmtOut = rds.format(z);
    new File(fmtPath)..writeAsStringSync(sb.toString());
    log.debug(fmtOut);

//        print(rds.format(z));
  } else {
    print('${rds.summary}');
  }
}

Future<Uint8List> readFileAsync(File file) async => await file.readAsBytes();

String getTempFile(String infile, String extension) {
  final name = path.basenameWithoutExtension(infile);
  final dir = Directory.systemTemp.path;
  return '$dir/$name.$extension';
}

const String x00 = 'c:/odw/test_data/mweb/ASPERA/Clean_Pixel_test_data/Sop/'
    '1.2.392.200036.9123.100.12.11.3.dcm';
const String x01 = 'C:/acr/odw/test_data/mweb/ASPERA/Clean_Pixel_test_data/Sop/'
    '1.2.840.10008.5.1.4.1.1.66.dcm';
const String x02 = 'C:/acr/odw/test_data/mweb/ASPERA/Clean_Pixel_test_data/'
    'Sop (user 349383158)/1.2.392.200036.9123.100.12.11.3.dcm';
const String x03 =
    'c:/odw/test_data/mweb/ASPERA/Clean_Pixel_test_data/Sop (user 349383158)/1.2'
    '.840.10008.5.1.4.1.1.66.dcm';
const String x04 = 'c:/odw/test_data/mweb/ASPERA/DICOM files '
    'only/22c82bd4-6926-46e1-b055-c6b788388014.dcm';
const String x05 = 'c:/odw/test_data/mweb/ASPERA/DICOM files '
    'only/4cf05f57-4893-4453-b540-4070ac1a9ffb.dcm';
const String x06 = 'c:/odw/test_data/mweb/ASPERA/DICOM files '
    'only/523a693d-94fa-4143-babb-be8a847a38cd.dcm';
const String x07 = 'c:/odw/test_data/mweb/ASPERA/DICOM files '
    'only/613a63c7-6c0e-4fd9-b4cb-66322a48524b.dcm';
const String x08 =
    'c:/odw/test_data/mweb/Different_SOP_Class_UIDs/Anonymized.dcm';
const String x09 =
    'c:/odw/test_data/mweb/Different_SOP_Class_UIDs/Anonymized1.2.826.0.1'
    '.3680043.2.93.1.0.1.dcm';
const String x10 =
    'c:/odw/test_data/mweb/Different_SOP_Class_UIDs/Anonymized1.2.826.0.1'
    '.3680043.2.93.1.0.2.dcm';
const String x11 =
    'c:/odw/test_data/mweb/Different_SOP_Class_UIDs/Anonymized1.2.840.10008.3.1'
    '.2.5.5.dcm';
const String x12 =
    'c:/odw/test_data/mweb/Different_SOP_Class_UIDs/Anonymized1.2.840.10008.3.1'
    '.2.6.1.dcm';
const String x13 =
    'C:/acr/odw/test_data/mweb/Different_SOP_Class_UIDs/Anonymized1.2.840'
    '.10008.5.1.4.1.1.20.dcm';
const String x14 =
    'C:/acr/odw/test_data/mweb/Different_SOP_Class_UIDs/Anonymized1.2.840'
    '.10008.5.1.4.1.1.7.dcm';
const String x15 =
    'C:/acr/odw/test_data/mweb/Different_SOP_Class_UIDs/Anonymized1.2.840'
    '.10008.5.1.4.1.1.88.22.dcm';
const String x16 =
    'C:/acr/odw/test_data/mweb/Different_SOP_Class_UIDs/Anonymized1.2.840'
    '.10008.5.1.4.1.1.88.67.dcm';
const String x17 =
    'C:/acr/odw/test_data/mweb/Sop-selected/1.2.840.10008.5.1.4.1.1.66.dcm';

const List<String> badFiles = const <String>[
  x00,
  x01,
  x02,
  x03,
  // x04, Big Endian
  // x05, Big Endian
  // x06, Big E
  // x07, Big E
  x08,
  x09,
  x10,
//  x11, Bad data @1878
  x12,
//  x13, //132 chars with DICM\
//  x14, Big E
//  x15, 132 chars
//  x16, Big E
  x17
];
