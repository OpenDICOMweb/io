// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:io';

import 'package:path/path.dart' as p;

import 'dcm_media_type.dart';
import 'file_type.dart';

int _firstDot(String s) => p.basename(s).indexOf('.');

String toAbsolute(String path) {
  return (p.isAbsolute(path)) ? path : '${p.current}/$path';
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

    Filename.fromFile(File file) : _file = file, _path = file.path;

    // Potentially lazy
    File get file => _file ??= new File(_path);

    // Lazy [type] getter.
    FileSubtype get _type => __type ??= FileSubtype.parse(_path);

    DcmMediaType get mediaType => _type.mediaType;
    ESubtype get subtype => _type.eSubtype;
    String get typeExt => _type.ext;

    String get path => _path;
    String get root => p.rootPrefix(_path);
    String get dir => p.dirname(_path);
    String get base => p.basename(_path);
    String get name => base.substring(0, _firstDot(base));
    String get ext => base.substring(_firstDot(base));
    String get charset => _type.charset;

    // These getters are based on the expectation that the file extension is accurate.
    bool get isDicom => _type.isDicom;
    bool get isComplete => _type.isComplete;
    bool get isMetadata => _type.isMetadata;
    bool get isBulkdata => _type.isBulkdata;


    String toString() => _path;
}