// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:encode/encoder.dart';
import 'package:path/path.dart' as p;

import 'dcm_media_type.dart';
import 'file_type.dart';
import 'utils.dart';

//TODO: make everything async

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
//TODO: change this so it is based on [File] rather than [path].
class Filename {
  static final log = new Logger('Filename');
  final String _path;
  FileSubtype _subtype;
  File _file;

  Filename(String path)
      : _path = toAbsolute(path);

  Filename.withType(String path, this._subtype)
      : _path = toAbsolute(path);

  Filename.fromFile(File file)
      : _file = file,
        _path = toAbsolute(file.path);

  factory Filename.withExt(Filename fn, [String ext = 'out']) {
    var path = p.basenameWithoutExtension(fn.path) + '.$ext';
    return new Filename(path);
  }

  // lazy if created with [Filename].
  File get file => _file ??= new File(_path);

  // Lazy [type] getter.
  FileSubtype get subtype => _subtype ??= FileSubtype.parse(_path);

  OType get objectType => subtype.oType;
  String get typeExt => subtype.ext;

  // Path component accessors.
  String get path => _path;
  String get rootPrefix => p.rootPrefix(_path);
  String get dir => p.dirname(_path);
  String get base => p.basename(_path);
  String get name => base.substring(0, _firstDot(base));
  String get ext => p.extension(_path);

  bool get isDirectory => FileSystemEntity.isDirectorySync(_path);

  bool get isFile => FileSystemEntity.isFileSync(_path);
  //*** These getters are based on the expectation that the file extension is accurate.

  /// Returns [true] if a DICOM file type.
  bool get isDicom => subtype.isDicom;

  bool get isNotDicom => ! isDicom;

  /// The file extension for this [FileSubtype].
  String get extension => ext;

  /// The IANA Media Type of the associated this [Filename].
  DcmMediaType get mediaType => subtype.mediaType;

  /// Returns [true] if the encoding units are bytes.
  bool get isBinary => subtype.mType?.isBinary ?? null;

  /// Returns [true] if the encoding units are 7-bit US-ASCII.
  bool get isAscii => subtype.mType?.isAscii;

  /// Returns [true] if the encoding (code) units are UTF8.
  bool get isUtf8 => subtype.mType?.isUtf8;

  /// Returns [true] if the representation encoding is [encoding.part10].
  bool get isPart10 => subtype.mType?.encoding == Encoding.part10;

  /// Returns [true] if the representation encoding is [encoding.json].
  bool get isJson => subtype.mType?.encoding == Encoding.json;

  /// Returns [true] if the representation encoding is [encoding.xml].
  bool get isXml => subtype.mType?.encoding == Encoding.xml;

  /// The DICOM object [Encoding].
  Encoding get encoding => subtype.mType?.encoding;

  /// The [Encoding] [Units].
  Units get units => subtype.mType.units;

  /// Returns [true] if the Dataset is [OType.complete], that is, it contains no Bulkdata
  /// References.
  bool get isComplete => subtype.oType == OType.complete;

  /// Returns [true] if the Dataset is [Metadata], that is, it contains Bulkdata References.
  bool get isMetadata => subtype.oType == OType.metadata;

  /// Returns [true] if this is a [Bulkdata] object.
  bool get isBulkdata => subtype.oType == OType.bulkdata;

  Future<Entity> get contents => read();

  //TODO: should this return the bytes or a parsed Entity
  Entity readSync() {
   // print('subtype: $subtype');
    if (isPart10) {
      Uint8List bytes = file.readAsBytesSync();
      return DcmDecoder.decode(new DSSource(bytes, path));
    } else if (isJson) {
      Uint8List bytes = file.readAsBytesSync();
      return JsonDecoder.decode(bytes);
    } else if (isXml) {
      // Uint8List bytes = file.readAsBytesSync();
      throw "XML Umplemented";
    }
    throw "Shouldn't get here";
  }

  //TODO: should this return the bytes or a parsed Entity
  Uint8List readAsBytesSync() => file.readAsBytesSync();

  Future<Entity> read() async {
    if (isBinary) {
      Uint8List bytes = await file.readAsBytesSync();
      return await DcmDecoder.decode(new DSSource(bytes, path));
    } else if (isJson) {
      Uint8List bytes = await file.readAsBytesSync();
      return await JsonDecoder.decode(bytes);
    } else if (isXml) {
      // Uint8List bytes = file.readAsBytesSync();
      throw "XML Umplemented";
    } else if (subtype.isUnknown) {
      throw "Unknown FileType: $path";
    }
    throw "Shouldn't get here";
  }

  bool writeSync(Entity entity) {
    if (isBinary) {
      Uint8List bytes = DcmEncoder.encode(entity);
      log.debug('Writing ${bytes.lengthInBytes} bytes.');
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

  bool writeAsBytesSync(Uint8List bytes) {
    log.debug('Writing ${bytes.lengthInBytes} bytes.');
    file.writeAsBytesSync(bytes);
    return true;
  }

  bool write(Entity entity) {
    //TODO: finish
    throw "Unimplemented";
  }

  String get info => '''
Filename: $_path;
Subtype: ${FileSubtype.parse(_path)};
    ''';

  @override
  String toString() => _path;

  static Filename toFilename(obj) {
    if (obj is Filename) return obj;
    if (obj is String) return new Filename(obj);
    if (obj is File) return new Filename.fromFile(obj);
    return null;
  }

  //TODO move to utilities
  static List<Filename> listFromDirectory(String source, [String ext = ".dcm"]) {
    List<File> files = getFilesFromDirectory(source, ext);
    print('Total FSEntities: ${files.length}');
    List<Filename> fNames = new List(files.length);
    for (int i = 0; i < files.length; i++)
      fNames[i] = new Filename(files[i].path);
    return fNames;
  }
}
