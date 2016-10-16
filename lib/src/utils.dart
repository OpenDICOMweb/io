// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

// TODO: move Uid out of Core/base maybe to core/utils?
import 'dart:async';
import 'dart:io';

// TODO: replace with core/uid
import 'package:core/base.dart';
import 'package:path/path.dart';

import 'file_system.dart';

//TODO
String toPath(FileSystem fs, Uid study, [Uid series, Uid instance]) {
  String part4 = (series == null) ? "" : '/$instance.dcm';
  String part3 = (series == null) ? "" : '/$series';
  return '${fs.path}/$study$part3/$part4';
}


// TODO: debug - allows asynchronous creation of the FS root.
Future<Directory> createRoot(String rootPath, bool createIfAbsent) async {
    var root = new Directory(rootPath);
    bool exists = await root.exists();
    if (! exists && createIfAbsent)
        await root.create(recursive: true);
    return root;
}

/// Returns a [List] of [Uint8List]s containing all the SOP [Instances] of the [Study]
/// specified by the [Directory].
String getFilename(File f) =>   basenameWithoutExtension(f.path);
String getFileExt(File f) => extension(f.path);

bool hasExtension(String path, String ext) => extension(path) == ext;

String testExtension(String path, String ext) =>
    (hasExtension(path, ext)) ? ext : null;

bool isDcmFile(File f) => hasExtension(f.path, ".dcm");

String filterDcm(File f) => (isDcmFile(f)) ? f.path : null;


List getDcmFilesSync(String path) {
  var d = new Directory(path);
  return walkSync(d, filterDcm);
}

List walkSync(Directory d, Function func) {
  var entries = d.listSync(followLinks: false);
 // print('Length: ${entries.length}');
  List list = [];
  try {
    for (FileSystemEntity e in entries) {
      if (e is File) {
       // print('Found file ${e.path}');
        var v = func(e);
        if (v == null) continue;
        list.add(v);
      } else if (e is Directory) {
     //   print('Found dir ${e.path}');
        list.add(walk(e, func));
      }
    }
  } catch (e) {
    print(e.toString());
  }
  return list;
}

Stream getDcmFiles(String path) => walk(new Directory(path), filterDcm);

/* TODO: flush or use
Stream walk(Directory d) async* {
  Stream stream = d.list(followLinks: false);
  await for (FileSystemEntity f in stream) {
    if (f is Directory) walk(f);
    if (f is File)
    var s = filterDcm(f);
    if (s == null) continue;
    list.add(s);
  }
  return list;
}
*/

Stream walk(Directory d, Function func) async* {
  var stream = d.list(followLinks: false);
  // print('Length: ${entries.length}');
  try {
    await for (FileSystemEntity e in stream) {
      if (e is File) {
        // print('Found file ${e.path}');
        var v = func(e);
        if (v == null) continue;
        yield v;
      } else if (e is Directory) {
        //   print('Found dir ${e.path}');
        walk(e, func);
      }
    }
  } catch (e) {
    print(e.toString());
  }
}

class Formatter {
  int level = 0;
  int count = 0;
  int indent;

  Formatter({this.indent: 2});

  String get sp => "".padRight(indent * level, " ");

  String call(List tree, [String output = ""]) {
    print('Level: $level');
    output += '${sp}Level: $level\n';
    for (var v in tree) {
      if (v is String) {
        count++;
        output += '$sp$v\n';
      } else if (v is List) {
        level++;
        output = call(v, output);
        level--;
      } else {
        throw "invalid object: $v";
      }
    }
    print('loops: $level');
    print('count: $count');
    return output;
  }
}