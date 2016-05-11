// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
//library odw.sdk.base.io.fs_entity;

import 'package:path/path.dart' as path;

abstract class FSEntity {

  //FSEntity(this.entity);

  String get name;
  String get file => path.basenameWithoutExtension(name);
  String get basename => path.basename(name);
  String get extension => path.extension(name);
  String get dirname => path.dirname(name);
  String get absolute => path.absolute(name);
  String get root => path.rootPrefix(name);


  @override
  String toString() => '''
  dir: $dirname
  file: $file
  ext: $extension
  base: $basename
  root: $root
  ''';

}
