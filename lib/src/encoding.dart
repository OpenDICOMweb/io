// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

/// The various Encodings of DICOM objects
///
/// The file extensions are structured from most specific to least specific.

/// The File Encoding and Media Type
class Encoding {
  static const ssType = "dicom";
  static const type = "application";

  final int index;
  final String oType;  // Object Type
  final String sType;  // SubType
  final String ext;    // File Extension
  final String bType;  // Base Encoding Type

  //TODO: jfp document this
  const Encoding(this.index, this.oType, this.sType,  this.ext, this.bType);

  String get subType => '$ssType+$sType';
  String get mediaType => 'application/$subType';
  String get objectType => oType;
  String get baseType => bType;
  String get extension => ext;

  static const instance = const Encoding(1, "Instance",   "", "dcm", "octet");
  static const metadata = const Encoding(2, "Descriptor", "", "desc.dcm", "octet");
  static const bulkdata = const Encoding(3, "Bulkdata",   "", "bd.dcm", "octet");

  static const jsonInstance = const Encoding(4, "Instance",   "json", ".dcm.json",  "utf8");
  static const jsonMetadata = const Encoding(5, "Descriptor", "json", ".desc.dcm.json", "utf8");
  static const jsonBulkdata = const Encoding(6, "Bulkdata",   "json", ".bd.dcm.json", "utf8");

  static const xmlInstance = const Encoding(7, "Instance", "xml", ".dcm.xml", "utf8");
  static const xmlDescriptor = const Encoding(8, "Descriptor", "xml", "desc.dcm.xml", "utf8");
  static const xmlBulkdata = const Encoding(9, "Bulkdata", "xml", "md.dcm.json", "utf8");

  static const pureJsonInstance = const Encoding(10, "Instance", "json", ".json",  "utf8");
  static const pureJsonMetadata = const Encoding(11, "Descriptor", "json", "desc.json", "utf8");
  static const pureJsonBulkdata = const Encoding(12, "Bulkdata", "json", "bd.json", "utf8");

  toString() => '$oType encoded as $mediaType';
}
