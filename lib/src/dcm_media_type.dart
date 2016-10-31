// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

enum Units { binary, ascii, utf8 }

enum Encoding { part10, json, xml }

class DcmMediaType {
  final String subType;
  final Encoding encoding;
  final Units units;

  const DcmMediaType(this.subType, this.encoding, this.units);

  String get type => "application";

  bool get isDicom => true;

  bool get isBinary => encoding == Units.binary;
  bool get isAscii => encoding == Units.ascii;
  bool get isUtf8 => encoding == Units.utf8;

  bool get isPart10 => encoding == Encoding.part10;
  bool get isJson => encoding == Encoding.json;
  bool get isXml => encoding == Encoding.xml;

  static const dcm = const DcmMediaType("dicom", Encoding.part10, Units.binary);
  static const json = const DcmMediaType("dicom+json", Encoding.json, Units.utf8);
  static const fastJson = const DcmMediaType("dicom+json", Encoding.json, Units.utf8);
  static const pureJson = const DcmMediaType("json", Encoding.json, Units.utf8);
  static const xml = const DcmMediaType("dicom+xml", Encoding.xml, Units.utf8);
  static const bytes = const DcmMediaType("octet-stream", Encoding.xml, Units.binary);

  String toString() => "$type/$subType";
}
