// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
import 'package:io_extended/src/vna/vna_db.dart';
import 'package:io_extended/src/vna/path_db.dart';

/// A DICOM Vendor Neutral Archive.
class Vna {
  /// The path to the root directory of this VNA.
  final String rootPath;

  /// The UID database for _this_;
  final VnaUidDB uidDB;

  /// The path database for _this_;
  final PathDB pathDB;

  /// Constructor
  Vna(this.rootPath)
  : uidDB = VnaUidDB.empty(rootPath),
    pathDB = PathDB.empty(rootPath);
}
