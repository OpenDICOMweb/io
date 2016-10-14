// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'sop_entity.dart';
import 'sop_file.dart';
import 'sop_file_system.dart';

enum DirType {patient, study, series}

class SopDirectory extends SopEntity {
  const String ext = '.dcm';
  final SopFileSystem fs;
  final Uid dir;

  SopDirectory._(this.fs, this.dir);

  factory SopDirectory(this.fs, Uid study, [Uid series]) {
    Directory d = new Directory('${fs.root}/$study/$series');
  }

  bool get isStudy => (study != null) && (series == null);

  bool get isSeries => (study != null) && (series != null);

  String get path => '$root/$study/$series$ext';

  //TODO: debug
  Stream<Uint8List> readAsBytes() async* {
    var entities = dir.list(recursive: true, followLinks: false);
    await for(var entity in entities) {
      print('entity: $entity');
      if (entity is File) {
        var bytes = await* entity.readAsBytes();
        yield(bytes);
      }
    }
  }

  List<Uint8List> readAsBytesSync() {
    var entities = dir.list(recursive: true, followLinks: false);
    var list = <Uint8List>[];
    for (var entity in entities) {
      if (entity is SopFile)
        list.add(entity.readAsBytes());
    }
  }

}