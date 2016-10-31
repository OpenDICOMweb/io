// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';

//TODO: document this file
//TODO: debug and create unit test for this file.

// TODO: debug - allows asynchronous creation of the FS root.
/// Returns the [root] [Directory] of the [MintFileSystem], creating it if it doesn't exist.
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
/// If the filter should return a [File] or null.
typedef File Filter(File f);

/// Returns [true] if the [path] has [ext] as it's file extension.
bool hasExtension(String path, String ext) => extension(path) == ext;

String testExtension(String path, String ext) =>
    (hasExtension(path, ext)) ? ext : null;
/*
/// Returns [true] if [f] has the [sopInstance] file extension.
File isDcmFile(File f) =>
    (hasExtension(f.path, ".dcm")) ? f : null;

/// Returns [true] if [f] has the [metadata] file extension.
bool isMetadataFile(File f) => hasExtension(f.path, FileSubtype.ext);

/// Returns [true] if [f] has the [bulkdate] file extension.
bool isBulkdataFile(File f) => hasExtension(f.path, FileSubtype.ext);
*/
/// Returns the [File] if the [predicate] is [true]; otherwise, null.
File filter(File f, Filter p ) => (p(f) != null) ? f : null;

File isFile(f) => (f is File) ? f : null;

/// Returns the [File] if the [predicate] is [true]; otherwise, null.
//TODO: fix
//File dcmFilter(File f) => filter(f, isDicomFile);

/// Returns a [List] of [File] from the [Directory] specified by [path].
List getFilesSync(directory, [filter = isFile]) {
  if (directory is String) directory = new Directory(directory);
  if (directory is! Directory) throw new ArgumentError('must be String or Directory');
  return walkSync(directory, filter);
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

Stream getFiles(String root, [Filter filter]) => walk(new Directory(root), filter);

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

//**** Binary Utility Functions
//TODO: implement later
//Stream<Uint8List> readDirectory(String path) {}

//TODO: debug, doc, and Test
List<Uint8List> readBinaryDirectorySync(String path) {
  Directory d = new Directory(path);
  return _readBinaryDirectorySync(d, []);
}

List<Uint8List> _readBinaryDirectorySync(Directory d, List<Uint8List> bytesList) {
  List<FileSystemEntity> entities = d.listSync(recursive: true, followLinks: false);
  try {
    for(FileSystemEntity e in entities) {
      if (e is Directory) {
        _readBinaryDirectorySync(e, bytesList);
      } else if (e is File) {
        bytesList.add(e.readAsBytesSync());
      } else {
        throw 'Invalid FileSystem Entity: $e';
      }
    }
  } catch (e) {

  }
  return bytesList;
}

Future<Uint8List> readBinaryFile(String path) async {
  File f = new File(path);
  return await f.readAsBytes();
}

Uint8List readBinaryFileSync(String path)  {
  File f = new File(path);
  Uint8List bytes;
  try {
    bytes = f.readAsBytesSync();
  } catch (e) {
    //TODO: finish
  }
  return bytes;
}

//TODO: implement later
//Stream<Uint8List> writeDirectory(String path) {}

Future<Null> writeBinaryFile(String path, Uint8List bytes) async {
  File f = new File(path);
  try {
    await f.writeAsBytes(bytes);
  } catch (e) {
    //TODO: add code
  }
}

//TODO: implement later
//TODO: add try block
void writeDirectorySync(String path, Map<String, Uint8List> entries) {
  entries.forEach((String path, Uint8List bytes) {
    File f = new File(path);
    try {
      f.writeAsBytesSync(bytes);
    } catch (e) {
      //TODO: finish
    }
  });
}

void writeBinaryFileSync(String path, Uint8List bytes) {
  File f = new File(path);
  try {
    f.writeAsBytes(bytes);
  } catch (e) {
    //TODO: finish
  }
}

//**** [String] based [File] utilities
//TODO: implement later
//Stream<String> readStringDirectory(String path) {}


List<String> readStringDirectorySync(String path) => _readStringDirectorySync(new Directory(path), []);

List<String> _readStringDirectorySync(Directory d, List<String> bytesList) {
  List<FileSystemEntity> entities = d.listSync(recursive: true, followLinks: false);
  try {
    for(FileSystemEntity e in entities) {
      if (e is Directory) {
        _readStringDirectorySync(e, bytesList);
      } else if (e is File) {
        bytesList.add(e.readAsStringSync());
      } else {
        throw 'Invalid FileSystem Entity: $e';
      }
    }
  } catch (e) {

  }
  return bytesList;
}
Future<String> readStringFile(String path) async {
  File f = new File(path);
  return await f.readAsString();
}

String readStringFileSync(String path)  {
  File f = new File(path);
  String s;
  try {
    s = f.readAsStringSync();
  } catch (e) {
    //TODO: finish
  }
  return s;
}

//TODO: implement later
//Stream<String> writeDirectory(String path) {}

//TODO: debug and test
void writeStringDirectorySync(String path, Map<String, String> entries) {
  entries.forEach((String path, String s) {
    File f = new File(path);
    try {
      f.writeAsStringSync(s);
    } catch (e) {
      //TODO: finish
    }
  });
}

Future<Null> writeStringFile(String path, String s) async {
  File f = new File(path);
  try {
    await f.writeAsString(s);
  } catch (e) {
    //TODO: add code
  }
}

void writeStringFileSync(String path, String s) {
  File f = new File(path);
  try {
    f.writeAsString(s);
  } catch (e) {
    //TODO: finish
  }
}

