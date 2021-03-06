// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:io';

import 'package:core/base.dart';
import 'package:io/src/mint/other/fs_entity.dart';
import 'package:io/src/mint/file_system.dart';

enum DirType {patient, study, series}

class FSDirectory extends FSEntity {
  final Directory directory;
  final Uid study;
  final Uid series;


  FSDirectory(FileSystem fs, Uid study, [Uid series])
      : study = study,
        series = series,
        directory = fs.directory(study, series),
        super(fs);

  String get path => directory.path;

  Directory get root => fs.root;

  String get rootPath => fs.path;

  bool get isStudy => (study != null) && (series == null);

  bool get isSeries => (study != null) && (series != null);



/*
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
 */
}
