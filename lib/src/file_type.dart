// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:core/entity.dart';
import 'package:path/path.dart' as p;

import 'dcm_media_type.dart';

// Flush later.
//int _firstDot(String s) => p.basename(s).indexOf('.');

/* flush later when fully debugged and final.
String _extension(String path) {
 // var base = p.basename(path);
  var ext = p.extension(path);
  print('ext: $ext');
  //return (pos == -1) ? null : base.substring(pos);
  return ext;
}
*/

/// The various [FileType]s and [FileSubtype]s of DICOM objects
///
/// The file extensions are structured from most specific to least specific.
/// The are three types of objects that can be stored:
///     - Entity: contains all data (Metadata & Bulkdata) for the object.
///     - Metadata: contains all Data Elements, but some large values have
///       been moved to a Bulkdata object.
///     - Bulkdata: A set of large values that are referred to by a Metadata object.
///

///
/// The object type, encoding, media type, and file extension for a File.
///

class FileType {
  final int index;
  final EntityType eType; // Object Type
  final FileSubtype subtype;

  //TODO: jfp document this
  const FileType(this.index, this.eType, this.subtype);

  bool get isDicom => true;

  // Entity Type
  EntityType get entityType => eType;
  bool get isPatient => eType.isPatient;
  bool get isStudy => eType.isStudy;
  bool get isSeries => eType.isSeries;
  bool get isInstance => eType.isInstance;
  bool get isFrames => eType.isFrames;
  bool get isDataset => eType.isDataset;

  // Subtype
  /// The file extension for this [FileSubtype].
  String get extension => subtype.extension;

  // Media Type  and associated accessors.
  /// The IANA Media Type of the associated [Filename].
  DcmMediaType get mediaType => subtype.mType;

  /// Returns [true] if the encoding units are bytes.
  bool get isBinary => subtype.mType.isBinary;

  /// Returns [true] if the encoding units are 7-bit US-ASCII.
  bool get isAscii => subtype.mType.isAscii;

  /// Returns [true] if the encoding (code) units are UTF8.
  bool get isUtf8 => subtype.mType.isUtf8;

  /// Returns [true] if the representation encoding is [encoding.part10].
  bool get isPart10 => subtype.mType.encoding == Encoding.part10;

  /// Returns [true] if the representation encoding is [encoding.json].
  bool get isJson => subtype.mType.encoding == Encoding.json;

  /// Returns [true] if the representation encoding is [encoding.xml].
  bool get isXml => subtype.mType.encoding == Encoding.xml;

  /// The DICOM object [Encoding].
  Encoding get encoding => subtype.mType.encoding;

  /// The [Encoding] [Units].
  Units get units => subtype.mType.units;

  /// Returns [true] if the Dataset is [OType.complete], that is, it contains no Bulkdata
  /// References.
  bool get isComplete => subtype.oType == OType.complete;

  /// Returns [true] if the Dataset is [Metadata], that is, it contains Bulkdata References.
  bool get isMetadata => subtype.oType == OType.metadata;

  /// Returns [true] if this is a [Bulkdata] object.
  bool get isBulkdata => subtype.oType == OType.bulkdata;


  static const dcmStudy = const FileType(1, EntityType.study, FileSubtype.part10);
  static const dcmStudyMD = const FileType(2, EntityType.study, FileSubtype.part10MD);
  static const dcmStudyBD = const FileType(2, EntityType.study, FileSubtype.part10BD);

  static const dcmSeries = const FileType(1, EntityType.series, FileSubtype.part10);
  static const dcmSeriesMD = const FileType(2, EntityType.series, FileSubtype.part10MD);
  static const dcmSeriesBD = const FileType(2, EntityType.series, FileSubtype.part10BD);

  static const dcmInstance = const FileType(1, EntityType.instance, FileSubtype.part10);
  static const dcmInstanceMD = const FileType(2, EntityType.instance, FileSubtype.part10MD);
  static const dcmInstanceBD = const FileType(2, EntityType.instance, FileSubtype.part10BD);

  static const dcmFrames = const FileType(1, EntityType.frames, FileSubtype.part10);
  static const dcmFramesMD = const FileType(2, EntityType.frames, FileSubtype.part10MD);
  static const dcmFramesBD = const FileType(2, EntityType.frames, FileSubtype.part10BD);

  static const jsonStudy = const FileType(1, EntityType.study, FileSubtype.json);
  static const jsonStudyMD = const FileType(2, EntityType.study, FileSubtype.jsonMD);
  static const jsonStudyBD = const FileType(2, EntityType.study, FileSubtype.jsonBD);

  static const jsonSeries = const FileType(1, EntityType.series, FileSubtype.json);
  static const jsonSeriesMD = const FileType(2, EntityType.series, FileSubtype.jsonMD);
  static const jsonSeriesBD = const FileType(2, EntityType.series, FileSubtype.jsonBD);

  static const jsonInstance = const FileType(1, EntityType.instance, FileSubtype.json);
  static const jsonInstanceMD = const FileType(2, EntityType.instance, FileSubtype.jsonMD);
  static const jsonInstanceBD = const FileType(2, EntityType.instance, FileSubtype.jsonBD);

  static const jsonFrames = const FileType(1, EntityType.frames, FileSubtype.json);
  static const jsonFramesMD = const FileType(2, EntityType.frames, FileSubtype.jsonMD);
  static const jsonFramesBD = const FileType(2, EntityType.frames, FileSubtype.jsonBD);

  static const xmlStudy = const FileType(1, EntityType.study, FileSubtype.xml);
  static const xmlStudyMD = const FileType(2, EntityType.study, FileSubtype.xmlMD);
  static const xmlStudyBD = const FileType(2, EntityType.study, FileSubtype.xmlBD);

  static const xmlSeries = const FileType(1, EntityType.series, FileSubtype.xml);
  static const xmlSeriesMD = const FileType(2, EntityType.series, FileSubtype.xmlMD);
  static const xmlSeriesBD = const FileType(2, EntityType.series, FileSubtype.xmlBD);

  static const xmlInstance = const FileType(1, EntityType.instance, FileSubtype.xml);
  static const xmlInstanceMD = const FileType(2, EntityType.instance, FileSubtype.xmlMD);
  static const xmlInstanceBD = const FileType(2, EntityType.instance, FileSubtype.xmlBD);

  static const xmlFrames = const FileType(1, EntityType.frames, FileSubtype.xml);
  static const xmlFramesMD = const FileType(2, EntityType.frames, FileSubtype.xmlMD);
  static const xmlFramesBD = const FileType(2, EntityType.frames, FileSubtype.xmlBD);

  FileType lookup(EntityType eType, FileSubtype fSubtype) {
    switch (eType) {
      case EntityType.study:
        switch (fSubtype) {
          case FileSubtype.part10:
            return dcmStudy;
          case FileSubtype.part10MD:
            return dcmStudyMD;
          case FileSubtype.part10BD:
            return dcmStudyBD;
          case FileSubtype.json:
            return jsonStudy;
          case FileSubtype.jsonMD:
            return jsonStudyMD;
          case FileSubtype.xml:
            return xmlStudy;
          case FileSubtype.xmlMD:
            return xmlStudyMD;
        }
        throw "bad study lookup";
      case EntityType.series:
        switch (fSubtype) {
          case FileSubtype.part10:
            return dcmSeries;
          case FileSubtype.part10MD:
            return dcmSeriesMD;
          case FileSubtype.part10BD:
            return dcmSeriesBD;
          case FileSubtype.json:
            return jsonSeries;
          case FileSubtype.jsonMD:
            return jsonSeriesMD;
          case FileSubtype.xml:
            return xmlSeries;
          case FileSubtype.xmlMD:
            return xmlSeriesMD;
        }
        throw "bad series lookup";
      case EntityType.instance:
        switch (fSubtype) {
          case FileSubtype.part10:
            return dcmInstance;
          case FileSubtype.part10MD:
            return dcmInstanceMD;
          case FileSubtype.part10BD:
            return dcmInstanceBD;
          case FileSubtype.json:
            return jsonInstance;
          case FileSubtype.jsonMD:
            return jsonInstanceMD;
          case FileSubtype.xml:
            return xmlInstance;
          case FileSubtype.xmlMD:
            return xmlInstanceMD;
        }
        throw "bad instance lookup";
      case EntityType.frames:
        switch (fSubtype) {
          case FileSubtype.part10:
            return dcmFrames;
          case FileSubtype.part10MD:
            return dcmFramesMD;
          case FileSubtype.part10BD:
            return dcmFramesBD;
          case FileSubtype.json:
            return jsonFrames;
          case FileSubtype.jsonMD:
            return jsonFramesMD;
          case FileSubtype.xml:
            return xmlFrames;
          case FileSubtype.xmlMD:
            return xmlFramesMD;
        }
        throw "bad frames lookup";
    }
    throw "bad Entity lookup";
  }

  toString() => '$eType encoded as $mediaType';
}

/// The DICOM Object Type [OType].
enum OType {
  /// The Complete DICOM object [Dataset].
  ///
  /// A [Dataset] that contains all Data [Element]s along with their values.
  /// In Particular,it contains no Bulkdata References.
  complete,

  /// A Metadata object.
  ///
  /// A [Dataset] that contains all Data [Element]s, but
  /// some of the values are Bulkdata References.
  metadata,

  /// A Bulkdata object.
  ///
  /// An object that contains large binary values that were removed
  /// from, and are referenced by a Metadata object.
  bulkdata
}

class FileSubtype {
  final int index;
  final OType oType;
  final DcmMediaType mType; // SubType
  final String ext; // File Extension

  //TODO: jfp document this
  const FileSubtype(this.index, this.oType, this.mType, this.ext);

  bool get isDicom => true;

  /// The file extension for this [FileSubtype].
  String get extension => ext;

  // Media Type  and associated accessors.
  /// The IANA Media Type of the associated [Filename].
  DcmMediaType get mediaType => mType;

  /// Returns [true] if the encoding units are bytes.
  bool get isBinary => mType.isBinary;

  /// Returns [true] if the encoding units are 7-bit US-ASCII.
  bool get isAscii => mType.isAscii;

  /// Returns [true] if the encoding (code) units are UTF8.
  bool get isUtf8 => mType.isUtf8;

  /// Returns [true] if the representation encoding is [encoding.part10].
  bool get isPart10 => mType.encoding == Encoding.part10;

  /// Returns [true] if the representation encoding is [encoding.json].
  bool get isJson => mType.encoding == Encoding.json;

  /// Returns [true] if the representation encoding is [encoding.xml].
  bool get isXml => mType.encoding == Encoding.xml;

  /// The DICOM object [Encoding].
  Encoding get encoding => mType.encoding;

  /// The [Encoding] [Units].
  Units get units => mType.units;

  /// Returns [true] if the Dataset is [OType.complete], that is, it contains no Bulkdata
  /// References.
  bool get isComplete => oType == OType.complete;

  /// Returns [true] if the Dataset is [Metadata], that is, it contains Bulkdata References.
  bool get isMetadata => oType == OType.metadata;

  /// Returns [true] if this is a [Bulkdata] object.
  bool get isBulkdata => oType == OType.bulkdata;

  static const part10 = const FileSubtype(1, OType.complete, DcmMediaType.part10, ".dcm");
  static const part10MD = const FileSubtype(2, OType.metadata, DcmMediaType.part10, ".mddcm");
  static const part10BD = const FileSubtype(3, OType.bulkdata, DcmMediaType.part10, ".bddcm");

  static const json = const FileSubtype(4, OType.complete, DcmMediaType.json, ".dcmjson");
  static const jsonMD = const FileSubtype(5, OType.metadata, DcmMediaType.json, ".mddcmjson");
  static const jsonBD = const FileSubtype(6, OType.bulkdata, DcmMediaType.json, ".bddcmjson");

  static const xml = const FileSubtype(7, OType.complete, DcmMediaType.xml, ".dcmxml");
  static const xmlMD = const FileSubtype(8, OType.metadata, DcmMediaType.xml, ".mddcm.xml");
  static const xmlBD = const FileSubtype(9, OType.bulkdata, DcmMediaType.xml, ".bddcmxml");

  static parseExt(String ext) => subtypes[ext];
  static parse(String _path) {
  //Flush: print('Extension: ${p.extension(_path)}');
    var s = subtypes[p.extension(_path)];
  //Flush:  print('subtype: $s');
    return s;
  }

  static bool isValidExtension(String ext) => (parseExt(ext) != null);

  static const Map<String, FileSubtype> subtypes = const {
    ".dcm": FileSubtype.part10,
    ".mddcm": FileSubtype.part10MD,
    ".bddcm": FileSubtype.part10BD,
    ".json": FileSubtype.json,
    ".dcmjson": FileSubtype.json,
    ".mddcmjson": FileSubtype.jsonMD,
    ".xml": FileSubtype.xml,
    ".dcmxml": FileSubtype.xml,
    ".mddcmxml": FileSubtype.xmlMD
  };

  toString() => '$oType($ext) encoded as $mediaType';
}
