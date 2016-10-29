// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:io';

import 'package:io/io.dart';
import 'package:path/path.dart' as p;

int _firstDot(String s) => p.basename(s).indexOf('.');

String _extension(String fname) => p.basename(fname).substring(_firstDot(fname));

/// path = root / dir / base
///                   / name /ext
class Filename {
  final String _path;
  FileSubtype _type;

  Filename(this._path);

  bool get isDicom => _type.isDicom;
  bool get isComplete => _type.isComplete;
  bool get isMetadata => _type.isMetadata;
  bool get isBulkdata => _type.isBulkdata;

  String get path => _path;
  String get root => p.rootPrefix(_path);
  String get dir => p.dirname(_path);
  String get base => p.basename(_path);
  String get name => base.substring(0, _firstDot(base));
  String get ext => base.substring(_firstDot(base));
  String get charset => _type.charset;

  FileSubtype get type => _type ??= FileSubtype.parse(_path);
  DcmMediaType get mType => type.mediaType;
  ESubtype get subtype => type.eSubtype;
  String get ext1 => type.ext;

  String toString() => _path;
}


Filename convert(File f) {
String name = f.path;
String dir = p.dirname(name);
String ext = _extension(name);
FileSubtype subtype = FileSubtype.types[ext];
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
String dcmMetadata = 'bas/bar/file.md.dcm';
String jsonEntity = 'bas/bar/file.dcm.json';
String jsonMetadata = 'bas/json/file.md.dcm.json';
String xmlEntity = 'bas/bar/file.dcm.xml';
String xmlMetadata = 'bas/bar/file.md.dcm.xml';
String bulkdata = 'bas/bar/file.bd.dcm';
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
main() {

  for (String s in pathList) {
    Filename f = new Filename(s);
    print('Path: $s');
    print('  fname: $f');
    print('  type: ${f.type}');
    print('  components:\n    root:${f.root}\n    dir: ${f.dir}\n    base: ${f.base}\n'
              '    name: ${f.name}\n    ext: ${f.ext}');
    print('  mType: ${f.mType}');
    print('  subtype: ${f.subtype}');
    print('  charset: ${f.charset}');
  }

  List<FileSystemEntity> files = getFiles(inRoot);
  //files = flatten(files);
  print(files);

  for(var f in files)
    print('File: $f');
  List<Filename> fnames = [];
  for(File f in files) {
    var fn = new Filename(f.path);
    fnames.add(fn);
  }


  for(Filename f in fnames)
    print(f);



}
