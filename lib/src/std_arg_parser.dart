// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//
import 'package:args/args.dart';

// ignore_for_file: public_member_api_docs

ArgResults parse(List<String> args) {
  final parser = getArgParser();
  return parser.parse(args);
}

ArgParser getArgParser() {
  final parser = ArgParser()
    ..addOption('source',
        abbr: 's', defaultsTo: '.', help: 'Specifies the source directory.')
    ..addOption('target',
        abbr: 't',
        defaultsTo: './output',
        help: 'Specifies the root directory of the target SOP File System.')
    ..addFlag('validate',
        abbr: 'v',
        defaultsTo: true,
        help: 'Specifies whether the source files should be cheched that '
            'they contain valid DICOM as they are copied');

  return parser;
}
