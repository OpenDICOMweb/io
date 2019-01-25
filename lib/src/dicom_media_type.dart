// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//
import 'package:core/core.dart';
import 'package:path/path.dart' as pp;

// ignore_for_file: public_member_api_docs

/// The [Units] of the DICOM Media Type.
enum Units {
  /// The encoding units are 8-bit octets (bytes).
  binary,

  /// The encoding units are 7-bit US-ASCII characters.
  ascii,

  /// The encoding units are 8-bit UTF8 code units.
  utf8,

  /// The encoding units are [unknown].
  unknown
}

/// The DICOM object encoding.
enum Encoding {
  /// DICOM File Format.
  ///
  /// The representation (object) is encoded in the DICOM File Format
  /// as specified in
  /// [PS3.10, Section 7](http://dicom.nema.org/medical/dicom/current/output/
  /// html/part10.html#chapter_7).
  part10,

  /// DICOM+JSON File Format.
  ///
  /// The representation (object) is encoded in the DICOM+JSON Format
  /// as specified in
  /// [PS3.18, Annex F](http://dicom.nema.org/medical/dicom/current/output/
  /// html/part18.html#chapter_F).
  json,

  /// DICOM+XML File Format.
  ///
  /// The representation (object) is encoded in the DICOM+XML as specified in
  /// [PS3.19, Annex A.1](http://dicom.nema.org/medical/dicom/current/output
  /// /html/part19.html#sect_A.1).
  xml,

  /// The Encoding is [unknown].
  unknown
}

/// DICOM Media Type.
class DicomMediaType {
  /// The media type subtype [name].
  final String name;

  /// The DICOM object type.
  final Encoding encoding;

  /// The DICOM object is encoded using these [units].
  final Units units;

  /// A DICOM Media Type.
  const DicomMediaType(this.name, this.encoding, this.units);

  factory DicomMediaType.fromPath(String path) {
    var ext = pp.extension(path);
    ext ??= '';
    final mt = extensions[ext];
    return (mt == null) ? badDicomFileExtension(ext) : mt;
  }

  /// The media type [type] of DICOM Media Types
  String get type => 'application';

  bool get isDicom => name != 'Unknown';

  /// Returns _true_ if the representation is encoded in [Units.binary].
  bool get isBinary => units == Units.binary;

  /// Returns _true_ if the representation is encoded in [Units.ascii].
  bool get isAscii => units == Units.ascii;

  /// Returns _true_ if the representation is encoded in [Units.utf8].
  bool get isUtf8 => units == Units.utf8;

  /// Returns _true_ if the representation encoding is [encoding].part10.
  bool get isPart10 => encoding == Encoding.part10;

  /// Returns _true_ if the representation encoding is [encoding].json.
  bool get isJson => encoding == Encoding.json;

  /// Returns _true_ if the representation encoding is [encoding].xml.
  bool get isXml => encoding == Encoding.xml;

  /// Returns information about this DICOM Media Type.
  String get info => '''
$runtimeType:
  name: $name
  encoding: $encoding
  units: $units
  ''';

  /// Returns the IANA media type [String].
  @override
  String toString() => '$type/$name';

  //TODO: finish documenting these
  static const DicomMediaType dicom =
      DicomMediaType('dicom', Encoding.part10, Units.binary);
  static const DicomMediaType part10 = dicom;
  static const DicomMediaType json =
      DicomMediaType('dicom+json', Encoding.json, Units.utf8);
  static const DicomMediaType fastJson =
      DicomMediaType('dicom+json', Encoding.json, Units.utf8);
  static const DicomMediaType pureJson =
      DicomMediaType('json', Encoding.json, Units.utf8);
  static const DicomMediaType xml =
      DicomMediaType('dicom+xml', Encoding.xml, Units.utf8);
  static const DicomMediaType octets =
      DicomMediaType('octet-stream', Encoding.xml, Units.binary);
  static const DicomMediaType unknown =
      DicomMediaType('Unknown', Encoding.unknown, Units.unknown);

  static const Map<String, DicomMediaType> extensions =
  <String, DicomMediaType> {
    '': dicom,
    'dcm': dicom,
    'json': json,
    'dcmjson': json,
    'xml': xml,
    'dcmxml': xml
  };
}

// ignore: prefer_void_to_null
Null badDicomFileExtension(String ext) {
  final msg = 'Bad DICOM file extension: $ext';
  log.error(msg);
  if (throwOnError) throw DicomMediaTypeError(msg);
  return null;
}

// ignore: prefer_void_to_null
Null badDicomMediaType(DicomMediaType mt) {
  final msg = 'Bad DICOM media type: $mt';
  log.error(msg);
  if (throwOnError) throw DicomMediaTypeError(msg);
  return null;
}

class DicomMediaTypeError extends Error {
  final String msg;

  DicomMediaTypeError(this.msg);

  @override
  String toString() => msg;
}


