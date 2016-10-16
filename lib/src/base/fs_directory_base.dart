// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:io';

import 'package:core/base.dart';
import 'package:io/src/base/fs_entity_base.dart';

enum DirType {patient, study, series}

abstract class FSDirectoryBase extends FSEntityBase {
  Directory directory;
  Uid study;
  Uid series;

/* flush
  FSDirectory(FileSystem fs, Uid study, [Uid series])
      : study = study,
        series = series,
        directory = fs.directory(study, series),
        super(fs);
*/
  String get path => directory.path;

  Directory get root => fs.root;

  String get rootPath => fs.path;

  bool get isRoot => false;

  bool get isStudy => (study != null) && (series == null);

  bool get isSeries => (study != null) && (series != null);

}
