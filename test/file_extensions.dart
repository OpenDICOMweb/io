// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:io';

import 'package:io/io.dart';
import 'package:path/path.dart' as p;

//int _firstDot(String s) => p.basename(s).indexOf('.');

//String _extension(String fname) => p.basename(fname).substring(_firstDot(fname));

/// path = root / dir / base
///                   / name /ext

Filename convert(File f) {
String name = f.path;
String dir = p.dirname(name);
String ext = p.extension(name);
FileSubtype subtype = FileSubtype.subtypes[ext];
print('Convert: name: $name, dir: $dir, ext: $ext, subtype: $subtype');
  return new Filename(name);
}

String ext(String s) {
  var base = p.basename(s);
  var i = base.indexOf('.');
  var ext = base.substring(i);
  return ext;
}

List<Filename> getDcmFilesFromDirectory(String source) {
  var dir = new Directory(source);
  List<FileSystemEntity> files = dir.listSync(recursive: true, followLinks: false);
  List<Filename> filenames = [];
  for(File f in files) {
    filenames.add(new Filename(f.path));
  }
  return filenames;
}

String dcmEntity = 'bas/bar/file.dcm';
String dcmMetadata = 'bas/bar/file.mddcm';
String jsonEntity = 'bas/bar/file.dcmjson';
String jsonMetadata = 'bas/json/file.mddcmjson';
String xmlEntity = 'bas/bar/file.dcmxml';
String xmlMetadata = 'bas/bar/file.mddcmxml';
String bulkdata = 'bas/bar/file.bddcm';
var pathList = [
  dcmEntity, dcmMetadata, jsonEntity, jsonMetadata, xmlEntity, xmlMetadata, bulkdata
];

String inRoot = "C:/odw/test_data/sfd/CR";

List flatten(List list) {
  var flat = [];
  for(var l in list)
    if (l is List) {
      flat.addAll(l);
    } else {
      flat.add(l);
    }
  return flat;
}

List getFiles(String path) {
  Directory dir = new Directory(path);
  List<FileSystemEntity> entities = dir.listSync(recursive: true);
  List<File> files = [];
  for(var e in entities) {
    if (e is Directory) continue;
    files.add(e);
  }
  return files;
}

String toAbsolute(String path) {
  var s = (p.isAbsolute(path)) ? path : '${p.current}/$path';
  return s.replaceAll('\\', '/');
}

void main() {

  //var root = 'C:/odw/sdk/io/';
  for (String s in pathList) {
    /*
    String path = toAbsolute(s);
    print('path: $path');
    var dir = p.dirname(path);
    print('dirname: $dir');

    if (dir.indexOf(root) == 0) dir = dir.replaceFirst(root, "");
    print('without root: $dir');
    var dirs = dir.split('/');
    print('dirList: $dirs');

    int length = dirs.length;
    if (length > 2) throw "too many directories: $dir";
    var series;
    var study;
    if (length == 2) {
      //series = Uid.isValid(dirs[1]);
      //study = Uid.isValid(dirs[0]);
      series = dirs[1];
      study = dirs[0];
    } else if (length == 1) {
      var study = dirs[0];
    }
    print('study: $study, series: $series');
*/
    Filename f = new Filename(s);
    print('''
Path: $s
  components:
    rootPrefix:${f.rootPrefix}
    dir: ${f.dir}
    base: ${f.base}
    name: ${f.name}
    ext: ${f.ext}
  subtype:
    mediaType: ${f.mediaType}
    units: ${f.units}
    encoding: ${f.encoding}
    objectType: ${f.objectType}
''');

  }




}
/*
List<DcmFile> getDcmFilesFromDirectory(String source) {
  var dir = new Directory(source);
  List<File> files = dir.listSync(recursive: true, followLinks: false);
  List<Filename> dcmFiles = [];
  for(File f in files) {
    dcmFiles.add(DcmFile.convert(f));
  }
  return dcmFiles;
}

Entity readFilenamesSync(String path) {
  var file = new Filename(path);
  if (file.existsSync()) {
    Uint8List bytes = file.readAsBytesSync();
    DcmDecoder decoder = new DcmDecoder(bytes);
    return decoder.entity;
  }
  return null;
}

Instance writeSopInstance(Instance instance, file) {
  if (file is String) file = new File(file);
  if (file is! File) throw new ArgumentError('file ($file) must be a String or File.');
  DcmEncoder encoder = new DcmEncoder(instance.dataset.lengthInBytes);
  encoder.writeSopInstance(instance);
  Uint8List bytes = file.readAsBytesSync();
  DcmDecoder decoder = new DcmDecoder(bytes);
  return decoder.readSopInstance(file.path);
}
*/