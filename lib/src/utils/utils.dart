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

import 'package:io/src/file_type.dart';

//TODO: debug and create unit test for this file.


/// Return a path to a file in the [FileSystem]
String toPath(String root, Uid study, [Uid series, Uid instance, String extension]) {
  String part5 = (extension == null) ? "" : ".dcm";
  String part4 = (series == null) ? "" : '/$instance';
  String part3 = (series == null) ? "" : '/$series';
  return '$root/$study$part3$part4$part5';
}


// TODO: debug - allows asynchronous creation of the FS root.
/// Returns the [root] [Directory] of the [FileSystem], creating it if it doesn't exist.
Future<Directory> createRoot(String path) async {
    var root = new Directory(path);
    if (! await root.exists()) await root.create(recursive: true);
    return root;
}

/// Returns a [List] of [Uint8List]s containing all the SOP [Instances] of the [Study]
/// specified by the [Directory].
String getFilename(File f) =>   basenameWithoutExtension(f.path);
String getFileExt(File f) => extension(f.path);

/// A predicate for testing properties of [File]s.
typedef bool Filter(File f);

/// Returns [true] if the [path] has [ext] as it's file extension.
bool hasExtension(String path, String ext) => extension(path) == ext;

String testExtension(String path, String ext) =>
    (hasExtension(path, ext)) ? ext : null;

/// Returns [true] if [f] has the [sopInstance] file extension.
bool isDcmFile(File f) => hasExtension(f.path, FileType.sopInstance);

/// Returns [true] if [f] has the [metadata] file extension.
bool isMetadataFile(File f) => hasExtension(f.path, FileType.metadata);


/// Returns [true] if [f] has the [bulkdate] file extension.
bool isBulkdataFile(File f) => hasExtension(f.path, FileType.bulkdata);

/// Returns the [File] if the [predicate] is [true]; otherwise, null.
String filter(File f, Filter p ) => (p(f)) ? f.path : null;

/// Returns the [File] if the [predicate] is [true]; otherwise, null.
String dcmFilter(File f) => filter(f, isDcmFile);

/// Returns a [List] of [File] from the [Directory] specified by [path].
List getFilesSync(String path, [Filter filter]) {
  var d = new Directory(path);
  return walkSync(d, filter);
}

//TODO: debug and create unit test
/// Returns a [List] of values that result from walking the [Directory] tree, and applying [func]
/// to each [File] in the tree.
List walkSync(Directory d, Function func) => _walkSync(d, func, []);

List _walkSync(Directory d, Function func, List list) {
  var entries = d.listSync(followLinks: false);
  try {
    for (FileSystemEntity e in entries) {
      if (e is File) {
       // print('Found file ${e.path}');
        var v = func(e);
        if (v == null) continue;
        list.add(v);
      } else if (e is Directory) {
        list.add(_walkSync(e, func, list));
      }
    }
  } catch (e) {
    print(e.toString());
  }
  return list;
}

Stream getFiles(String path, [Filter filter]) => walk(new Directory(path), filter);

//TODO: debug and create unit test
/// Returns a [List] of values that result from walking the [Directory] tree, and applying [filter]
/// to each [File] in the tree.
Stream walk(Directory d, Filter filter) => _walk(d, filter);


Stream _walk(Directory d, Filter filter) async* {
  var stream = d.list(followLinks: false);
  // print('Length: ${entries.length}');
  try {
    await for (FileSystemEntity e in stream) {
      if (e is File) {
        // print('Found file ${e.path}');
        var v = filter(e);
        if (v == null) continue;
        yield v;
      } else if (e is Directory) {
        //   print('Found dir ${e.path}');
        walk(e, filter);
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