// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

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
  /// [PS3.10, Section 7](http://dicom.nema.org/medical/dicom/current/output/html/part10
  /// .html#chapter_7).
  part10,

  /// DICOM+JSON File Format.
  ///
  /// The representation (object) is encoded in the DICOM+JSON Format as specified in
  /// [PS3.18, Annex F](http://dicom.nema.org/medical/dicom/current/output/html/part18
  /// .html#chapter_F).
  json,

  /// DICOM+XML File Format.
  ///
  /// The representation (object) is encoded in the DIas specified in
  /// [PS3.19, Annex A.1](http://dicom.nema.org/medical/dicom/current/output/html/part19
  /// .html#sect_A.1).
  xml,

  /// The Encoding is [unknown].
  unknown
}

/// DICOM Media Type.
class DcmMediaType {
  /// The media type subtype [name].
  final String name;

  /// The DICOM object type.
  final Encoding encoding;

  /// The DICOM object is encoded using these [units].
  final Units units;

  /// A DICOM Media Type.
  const DcmMediaType(this.name, this.encoding, this.units);

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
DcmMediaType:
  name: $name
  encoding: $encoding
  units: $units
  ''';

  /// Returns the IANA media type [String].
  @override
  String toString() => '$type/$name';

  //TODO: finish documenting these
  static const DcmMediaType part10 =
      const DcmMediaType('dicom', Encoding.part10, Units.binary);
  static const DcmMediaType json =
      const DcmMediaType('dicom+json', Encoding.json, Units.utf8);
  static const DcmMediaType fastJson =
      const DcmMediaType('dicom+json', Encoding.json, Units.utf8);
  static const DcmMediaType pureJson = const DcmMediaType('json', Encoding.json, Units.utf8);
  static const DcmMediaType xml = const DcmMediaType('dicom+xml', Encoding.xml, Units.utf8);
  static const DcmMediaType octets =
      const DcmMediaType('octet-stream', Encoding.xml, Units.binary);
  static const DcmMediaType unknown =
      const DcmMediaType('Unknown', Encoding.unknown, Units.unknown);
}
