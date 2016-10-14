// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import 'file_system.dart';

class FileSystemIndex {
  static const String version = "0.1.0";
  String type = "FileSystemIndex";
  FileSystem fs;
  List<String> _list;

  FileSystemIndex(this.fs) {
    print(fs);
    if (!fs.root.existsSync()) {
      fs.root.createSync();
      //_list = [];
    } else {
      _list = load(fs.root);
    }
  }

  String get filename => '.index.json';

  /*
  // FS Index
  List<FileSystemEntity> load(Directory rootDir) {
    print('loading Root: $rootDir...');
    File iFile = new File(filename);
    if(iFile.existsSync()) {
      _list = JSON.decode(iFile.readAsStringSync());
      /*
      if((data["@version"] == version) &&
          (data["@fsType"] == FileSystem.type) &&
          (data["@fsSubtype"] == FileSystem.subtype)) {
        _list = data["index"];
        */
      return _list;
    } else {
      _list = make();
      store();
    }
    return _list;
  }
  */
  // FS Index
  List<String> load(Directory rootDir) {
    print('loading Root: $rootDir...');
    _list = _walkRoot();
    print('_list: $_list');
    store();
    return _list;
  }

  List<String> _walkRoot() => _walkEntities(fs.root);

  //String sp = "";
  List<String> _walkEntities(Directory dir) {
    print("recur: ${dir.path}");
    List<FileSystemEntity> files = dir.listSync(recursive: false, followLinks: false);
    print('  Files (${files.length}): $files');
    List<String> list = [];
    for (FileSystemEntity e in files) {
      if (e is Directory) {
        list.add(path.basename(e.path));
        list.addAll(_walkEntities(e));
      } else if (e is File) {
        list.add(path.basename(e.path));
      } else {
        throw 'Invalid item $e in File System Entities List';
      }
    }
    return list;
  }

  void printIndentedList(List<FileSystemEntity> list, [int indent = 2, int level = 0]) {
    int limit = 5;
    var sp = ''.padLeft(level * indent, ' ');
    for (int i = 0; i < list.length; i++) {
      //for(e in l) {
      var e = list[i];
      if (e is File) {
        if (i < limit) print('${sp}File: ${e.path}');
        //files.add(e);
      } else if (e is Directory) {
        //List list = e.listSync(recursive: true);
        print('${sp}Dir (${e.path}): length = ${list.length}');
        printIndentedList(e.listSync(), indent, level++);
      }
    }
  }

  void store() {
    String index = toJson();
    // print('Json: $index');
    File oFile = new File(filename);
    print('Storing ${oFile.path}...');
    oFile.writeAsStringSync(index);
  }

  String toJson() => JSON.encode(_list);

  @override
  String toString() => 'FS (${FileSystem.type}) Index rooted at ${fs.root}';
}

