// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:encode/encoder.dart';
import 'package:path/path.dart' as p;

import 'dcm_media_type.dart';
import 'file_type.dart';
//import 'dart:convert';


int _firstDot(String s) => p.basename(s).indexOf('.');

String toAbsolute(String path) {
    var s = (p.isAbsolute(path)) ? path : '${p.current}/$path';
    return s.replaceAll('\\', '/');
}

// flushString _extension(String fname) => p.basename(fname).substring(_firstDot(fname));

/// path = root / dir / base
///                   / name /ext

/// A hopefully DICOM Filename, but not guaranteed.
///
/// This is a file from a non-DICOM File System.
class Filename {
  final String _path;
  FileSubtype __type;
  File _file;

  //   String _study;
  //   String _series;
  //   String _instance;

  Filename(String path) : _path = toAbsolute(path);

  Filename.fromFile(File file)
      : _file = file,
        _path = toAbsolute(file.path);

  // Potentially lazy
  File get file => _file ??= new File(_path);

  // Lazy [type] getter.
  FileSubtype get _subtype => __type ??= FileSubtype.parse(_path);

  DcmMediaType get mediaType => _subtype.mediaType;
  ESubtype get subtype => _subtype.eSubtype;
  String get typeExt => _subtype.ext;

  String get path => _path;
  String get root => p.rootPrefix(_path);
  String get dir => p.dirname(_path);
  String get base => p.basename(_path);
  String get name => base.substring(0, _firstDot(base));
  String get ext => base.substring(_firstDot(base));
  Encoding get encoding => _subtype.encoding;
  Units get units => _subtype.units;

  // These getters are based on the expectation that the file extension is accurate.
  bool get isDicom => (_subtype != null) && _subtype.isDicom;
  bool get isAscii => (_subtype != null) && _subtype.isAscii;
  bool get isBinary => (_subtype != null) && mediaType.isBinary;
  bool get isUtf8 => (_subtype != null) && _subtype.isUtf8;

  bool get isJson => (_subtype != null) && _subtype.encoding == Encoding.json;
  bool get isPart10 => (_subtype != null) && _subtype.encoding == Encoding.part10;
  bool get isXml => (_subtype != null) && _subtype.encoding == Encoding.xml;
  bool get isComplete => _subtype.isComplete;
  bool get isMetadata => _subtype.isMetadata;
  bool get isBulkdata => _subtype.isBulkdata;

  Entity get contents => read();

  Entity read() {
    print(this);
    print('subtype: $subtype');
    print('isBinary: $isBinary');
    if (isBinary) {
      Uint8List bytes = file.readAsBytesSync();
      return DcmDecoder.decode(bytes);
    } else if (isJson) {
      Uint8List bytes = file.readAsBytesSync();
      return JsonDecoder.decode(bytes);
    } else if (isXml) {
      // Uint8List bytes = file.readAsBytesSync();
      throw "XML Umplemented";
    }
    throw "Shouldn't get here";
  }

  bool write(Entity entity) {
    if (isBinary) {
      Uint8List bytes = DcmEncoder.encode(entity);
      file.writeAsBytesSync(bytes);
      return true;
    } else if (isJson) {
      //Uint8List bytes = JsonEncoder.encode(entity);
      //file.writeAsBytesSync(bytes);
      throw "JSON Umplemented";
    } else if (isXml) {
      throw "XML Umplemented";
    }
    throw "Shouldn't get here";
  }

  String get info => '''
Filename: $_path;
Subtype: ${FileSubtype.parse(_path)};
    ''';

  String toString() => _path;

  //TODO move to utilities
  static List<Filename> getFilesFromDirectory(String source, [String ext = ".dcm"]) {
    var dir = new Directory(source);
    List<FileSystemEntity> entities = dir.listSync(recursive: true, followLinks: false);
    List<Filename> filenames = [];
    for (FileSystemEntity e in entities) {
      if (e is File) {
        filenames.add(new Filename(e.path));
      } else {
        print('Skipipng ${e.runtimeType}: ${e.path}');
      }
    }
    print('Filenames(${filenames.length}): $filenames');
    return filenames;
  }
}