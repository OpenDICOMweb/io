// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.


import 'package:path/path.dart' as p;

import 'dcm_media_type.dart';
import 'ie_level.dart';

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
  final IELevel level; // Object Type
  final FileSubtype subtype;

  //TODO: jfp document this
  const FileType(this.index, this.level, this.subtype);

  bool get isDicom => subtype != FileSubtype.unknown;

  bool get isPatient => level == IELevel.subject;

  bool get isStudy => level  == IELevel.study;

  bool get isSeries => level == IELevel.series;

  bool get isInstance => level == IELevel.instance;

  bool get isDataset => level == IELevel.dataset;

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

  bool get isUnknown => this == unknown;

  //TODO: fix indices
  static const FileType part10Study =
      const FileType(1, IELevel.study, FileSubtype.part10);
  static const FileType part10StudyMD =
      const FileType(2, IELevel.study, FileSubtype.part10MD);
  static const FileType part10StudyBD =
      const FileType(2, IELevel.study, FileSubtype.bulkdata);

  static const FileType part10Series =
      const FileType(1, IELevel.series, FileSubtype.part10);
  static const FileType part10SeriesMD =
      const FileType(2, IELevel.series, FileSubtype.part10MD);
  static const FileType part10SeriesBD =
      const FileType(2, IELevel.series, FileSubtype.bulkdata);

  static const FileType part10Instance =
      const FileType(1, IELevel.instance, FileSubtype.part10);
  static const FileType part10InstanceMD =
      const FileType(2, IELevel.instance, FileSubtype.part10MD);
  static const FileType part10InstanceBD =
      const FileType(2, IELevel.instance, FileSubtype.bulkdata);

  // static const part10Frames = const FileType(1, IELevel.frames, FileSubtype.part10);
  // static const part10FramesMD = const FileType(2, IELevel.frames, FileSubtype.part10MD);
  // static const part10FramesBD = const FileType(2, IELevel.frames, FileSubtype.bulkdata);

  static const FileType jsonStudy = const FileType(1, IELevel.study, FileSubtype.json);
  static const FileType jsonStudyMD =
      const FileType(2, IELevel.study, FileSubtype.jsonMD);
  static const FileType jsonStudyBD =
      const FileType(2, IELevel.study, FileSubtype.jsonBD);

  static const FileType jsonSeries = const FileType(1, IELevel.series, FileSubtype.json);
  static const FileType jsonSeriesMD =
      const FileType(2, IELevel.series, FileSubtype.jsonMD);
  static const FileType jsonSeriesBD =
      const FileType(2, IELevel.series, FileSubtype.jsonBD);

  static const FileType jsonInstance =
      const FileType(1, IELevel.instance, FileSubtype.json);
  static const FileType jsonInstanceMD =
      const FileType(2, IELevel.instance, FileSubtype.jsonMD);
  static const FileType jsonInstanceBD =
      const FileType(2, IELevel.instance, FileSubtype.jsonBD);

//  static const jsonFrames = const FileType(1, IELevel.frames, FileSubtype.json);
//  static const jsonFramesMD = const FileType(2, IELevel.frames, FileSubtype.jsonMD);
//  static const jsonFramesBD = const FileType(2, IELevel.frames, FileSubtype.jsonBD);

  static const FileType xmlStudy = const FileType(1, IELevel.study, FileSubtype.xml);
  static const FileType xmlStudyMD = const FileType(2, IELevel.study, FileSubtype.xmlMD);
  static const FileType xmlStudyBD = const FileType(2, IELevel.study, FileSubtype.xmlBD);

  static const FileType xmlSeries = const FileType(1, IELevel.series, FileSubtype.xml);
  static const FileType xmlSeriesMD =
      const FileType(2, IELevel.series, FileSubtype.xmlMD);
  static const FileType xmlSeriesBD =
      const FileType(2, IELevel.series, FileSubtype.xmlBD);

  static const FileType xmlInstance =
      const FileType(1, IELevel.instance, FileSubtype.xml);
  static const FileType xmlInstanceMD =
      const FileType(2, IELevel.instance, FileSubtype.xmlMD);
  static const FileType xmlInstanceBD =
      const FileType(2, IELevel.instance, FileSubtype.xmlBD);

//  static const xmlFrames = const FileType(1, IELevel.frames, FileSubtype.xml);
//  static const xmlFramesMD = const FileType(2, IELevel.frames, FileSubtype.xmlMD);
//  static const xmlFramesBD = const FileType(2, IELevel.frames, FileSubtype.xmlBD);

  static const FileType unknown = const FileType(2, null, FileSubtype.unknown);

  FileType lookup(IELevel eType, FileSubtype fSubtype) {
    switch (eType) {
      case IELevel.study:
        switch (fSubtype) {
          case FileSubtype.part10:
            return part10Study;
          case FileSubtype.part10MD:
            return part10StudyMD;
          case FileSubtype.bulkdata:
            return part10StudyBD;
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
      case IELevel.series:
        switch (fSubtype) {
          case FileSubtype.part10:
            return part10Series;
          case FileSubtype.part10MD:
            return part10SeriesMD;
          case FileSubtype.bulkdata:
            return part10SeriesBD;
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
      case IELevel.instance:
        switch (fSubtype) {
          case FileSubtype.part10:
            return part10Instance;
          case FileSubtype.part10MD:
            return part10InstanceMD;
          case FileSubtype.bulkdata:
            return part10InstanceBD;
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
/*
      case IELevel.frames:
        switch (fSubtype) {
          case FileSubtype.part10:
            return part10Frames;
          case FileSubtype.part10MD:
            return part10FramesMD;
          case FileSubtype.bulkdata:
            return part10FramesBD;
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
        */
    }
    throw "bad Entity lookup";
  }

  @override
  String toString() => '$level encoded as $mediaType';
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
  bulkdata,

  /// An [unknown] object.
  unknown
}

class FileSubtype {
  final int index;
  final String name;
  final OType oType;
  final DcmMediaType mType; // SubType
  final String ext; // File Extension

  //TODO: jfp document this
  const FileSubtype(this.index, this.name, this.oType, this.mType, this.ext);

  bool get isDicom => mType.isDicom;

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

  /// Returns [true] if the Dataset is [OType.complete],
  /// that is, it contains no Bulkdata References.
  bool get isComplete => oType == OType.complete;

  /// Returns [true] if the Dataset is [Metadata], that is, it contains Bulkdata References.
  bool get isMetadata => oType == OType.metadata;

  /// Returns [true] if this is a [Bulkdata] object.
  bool get isBulkdata => oType == OType.bulkdata;

  bool get isUnknown => mediaType == DcmMediaType.unknown;

  @override
  String toString() => '$runtimeType: $name encoded as $mediaType';

  static const FileSubtype part10 = const FileSubtype(
      1, 'Part10', OType.complete, DcmMediaType.part10, '.dcm');
  static const FileSubtype part10MD = const FileSubtype(
      2, 'Part10 Metadata', OType.metadata, DcmMediaType.part10, '.mddcm');
  static const FileSubtype bulkdata = const FileSubtype(
      3, 'Binary Bulkdata', OType.bulkdata, DcmMediaType.octets, '.bddcm');

  static const FileSubtype json = const FileSubtype(
      4, 'JSON', OType.complete, DcmMediaType.json, '.dcmjson');
  static const FileSubtype jsonMD = const FileSubtype(
      5, 'JSON Metadata', OType.metadata, DcmMediaType.json, '.mddcmjson');
  static const FileSubtype jsonBD = const FileSubtype(
      6, 'JSON Bulkdata', OType.bulkdata, DcmMediaType.json, '.bddcmjson');

  static const FileSubtype xml =
      const FileSubtype(7, 'XML', OType.complete, DcmMediaType.xml, '.dcmxml');
  static const FileSubtype xmlMD = const FileSubtype(
      8, 'XML Metadata', OType.metadata, DcmMediaType.xml, '.mddcm.xml');
  static const FileSubtype xmlBD = const FileSubtype(
      9, 'XML Bulkdata', OType.bulkdata, DcmMediaType.xml, '.bddcmxml');

  static const FileSubtype unknown =
      const FileSubtype(9, 'Unknown', OType.unknown, DcmMediaType.unknown, '');

  static FileSubtype parseExt(String ext) => lookup(ext);

  static FileSubtype parse(String _path) {
    //  print('Extension: ${p.extension(_path)}');
    final s = parseExt(p.extension(_path));
    //  print('subtype: $s');
    return s;
  }

  static bool isValidExtension(String ext) => (parseExt(ext) != null);

  static FileSubtype lookup(String ext) => subtypes[ext] ?? FileSubtype.unknown;

  static const Map<String, FileSubtype> subtypes = const {
    '.dcm': FileSubtype.part10,
    '.mddcm': FileSubtype.part10MD,
    '.bddcm': FileSubtype.bulkdata,
    '.json': FileSubtype.json,
    '.dcmjson': FileSubtype.json,
    '.mddcmjson': FileSubtype.jsonMD,
    '.xml': FileSubtype.xml,
    '.dcmxml': FileSubtype.xml,
    '.mddcmxml': FileSubtype.xmlMD,
    '': FileSubtype.unknown
  };
}
