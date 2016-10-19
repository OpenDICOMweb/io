// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'package:io/src/mint/file_system.dart';


abstract class FSEntity {
  FileSystem fs;

  FSEntity(this.fs);

}
