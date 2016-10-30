// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:convert/aux.dart';

import 'filename.dart';
import 'file_type.dart';

bool isDicomFile(String path) {
  var fname = new Filename(path);
  var subtype = FileSubtype.parse(fname.ext);
  if (subtype == null) return false;

  if (fname.isDicom) {
    if (isBinaryDicom(fname)) return true;
  }
}

bool isBinaryDicom(String path) {
  var decoder = new DcmDecoder()
}