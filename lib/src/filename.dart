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
    String _study;
    String _series;
    String _instance;

    Filename(String path) : _path = toAbsolute(path);

    Filename.fromFile(File file) : _file = file, _path = toAbsolute(file.path);

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
    bool get isBinary => (_subtype != null) && _subtype.isBinary;
    bool get isUtf8 => (_subtype != null) && _subtype.isUtf8;

    bool get isJson => (_subtype != null) && _subtype.encoding == Encoding.json;
    bool get isPart10 => (_subtype != null) && _subtype.encoding == Encoding.part10;
    bool get isXml => (_subtype != null) && _subtype.encoding == Encoding.xml;
    bool get isComplete => _subtype.isComplete;
    bool get isMetadata => _subtype.isMetadata;
    bool get isBulkdata => _subtype.isBulkdata;


    Entity get contents {
      if (isBinary) {
        Uint8List bytes = file.readAsBytesSync();
        DcmDecoder decoder = new DcmDecoder(bytes);
        return decoder.entity;
      } else if (isJson) {
        String s = file.readAsStringSync();
        return JsonDecoder.decode(s);
      } else if (isXml) {
        String s = file.readAsStringSync();
        throw "XML Umplemented";
      }
      throw "Shouldn't get here";
    }

    String toString() => _path;
}