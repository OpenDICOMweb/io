// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:core/base.dart';
import 'fs.dart';

String toPath(SopFileSystem fs, Uid study, [Uid series, Uid instance]) {
  String part4 = (series == null) ? "" : '/$instance.dcm';
  String part3 = (series == null) ? "" : '/$series';
  return '${fs.path}/$study$part3/part4';
}