// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:core/core.dart';
import 'package:path/path.dart' as p;

import 'package:io_extended/src/dicom_media_type.dart';

// ignore_for_file: public_member_api_docs
// ignore_for_file: only_throw_errors, avoid_catches_without_on_clauses

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
///     - Bulkdata: A set of large values that are referred to
///       by a Metadata object.
///

///
/// The object type, encoding, media type, and file extension for a File.
///

class FileType {
  final int index;
  final IELevel level; // Object Type
  final FileSubtype subtype;

  const FileType(this.index, this.level, this.subtype);

  bool get isDicom => subtype != FileSubtype.unknown;

  bool get isPatient => level == IELevel.subject;

  bool get isStudy => level == IELevel.study;

  bool get isSeries => level == IELevel.series;

  bool get isInstance => level == IELevel.instance;

  bool get isDataset => level == IELevel.dataset;

  // Subtype
  /// The file extension for this [FileSubtype].
  String get extension => subtype.extension;

  // Media Type  and associated accessors.
  /// The IANA Media Type of the associated FileName.
  DicomMediaType get mediaType => subtype.mType;

  /// Returns _true_ if the encoding units are bytes.
  bool get isBinary => subtype.mType.isBinary;

  /// Returns _true_ if the encoding units are 7-bit US-ASCII.
  bool get isAscii => subtype.mType.isAscii;

  /// Returns _true_ if the encoding (code) units are UTF8.
  bool get isUtf8 => subtype.mType.isUtf8;

  /// Returns _true_ if the representation encoding is [encoding].part10.
  bool get isPart10 => subtype.mType.encoding == Encoding.part10;

  /// Returns _true_ if the representation encoding is [encoding].json.
  bool get isJson => subtype.mType.encoding == Encoding.json;

  /// Returns _true_ if the representation encoding is [encoding].xml.
  bool get isXml => subtype.mType.encoding == Encoding.xml;

  /// The DICOM object [Encoding].
  Encoding get encoding => subtype.mType.encoding;

  /// The [Encoding] [Units].
  Units get units => subtype.mType.units;

  /// Returns _true_ if the Dataset is [OType.complete], that is,
  /// it contains no Bulkdata References.
  bool get isComplete => subtype.oType == OType.complete;

  /// Returns _true_ if the Dataset is Metadata, that is, it contains
  /// Bulkdata References.
  bool get isMetadata => subtype.oType == OType.metadata;

  /// Returns _true_ if this is a Bulkdata object.
  bool get isBulkdata => subtype.oType == OType.bulkdata;

  bool get isUnknown => this == unknown;

  //TODO: fix indices
  static const FileType part10Study =
      FileType(1, IELevel.study, FileSubtype.part10);
  static const FileType part10StudyMD =
      FileType(2, IELevel.study, FileSubtype.part10MD);
  static const FileType part10StudyBD =
      FileType(2, IELevel.study, FileSubtype.bulkdata);

  static const FileType part10Series =
      FileType(1, IELevel.series, FileSubtype.part10);
  static const FileType part10SeriesMD =
      FileType(2, IELevel.series, FileSubtype.part10MD);
  static const FileType part10SeriesBD =
      FileType(2, IELevel.series, FileSubtype.bulkdata);

  static const FileType part10Instance =
      FileType(1, IELevel.instance, FileSubtype.part10);
  static const FileType part10InstanceMD =
      FileType(2, IELevel.instance, FileSubtype.part10MD);
  static const FileType part10InstanceBD =
      FileType(2, IELevel.instance, FileSubtype.bulkdata);

  // static const part10Frames =
  //     const FileType(1, IELevel.frames, FileSubtype.part10);
  // static const part10FramesMD =
  //     const FileType(2, IELevel.frames, FileSubtype.part10MD);
  // static const part10FramesBD =
  //     const FileType(2, IELevel.frames, FileSubtype.bulkdata);

  static const FileType jsonStudy =
      FileType(1, IELevel.study, FileSubtype.json);
  static const FileType jsonStudyMD =
      FileType(2, IELevel.study, FileSubtype.jsonMD);
  static const FileType jsonStudyBD =
      FileType(2, IELevel.study, FileSubtype.jsonBD);

  static const FileType jsonSeries =
      FileType(1, IELevel.series, FileSubtype.json);
  static const FileType jsonSeriesMD =
      FileType(2, IELevel.series, FileSubtype.jsonMD);
  static const FileType jsonSeriesBD =
      FileType(2, IELevel.series, FileSubtype.jsonBD);

  static const FileType jsonInstance =
      FileType(1, IELevel.instance, FileSubtype.json);
  static const FileType jsonInstanceMD =
      FileType(2, IELevel.instance, FileSubtype.jsonMD);
  static const FileType jsonInstanceBD =
      FileType(2, IELevel.instance, FileSubtype.jsonBD);

//  static const jsonFrames =
//      FileType(1, IELevel.frames, FileSubtype.json);
//  static const jsonFramesMD =
//      FileType(2, IELevel.frames, FileSubtype.jsonMD);
//  static const jsonFramesBD =
//      FileType(2, IELevel.frames, FileSubtype.jsonBD);

  static const FileType xmlStudy = FileType(1, IELevel.study, FileSubtype.xml);
  static const FileType xmlStudyMD =
      FileType(2, IELevel.study, FileSubtype.xmlMD);
  static const FileType xmlStudyBD =
      FileType(2, IELevel.study, FileSubtype.xmlBD);

  static const FileType xmlSeries =
      FileType(1, IELevel.series, FileSubtype.xml);
  static const FileType xmlSeriesMD =
      FileType(2, IELevel.series, FileSubtype.xmlMD);
  static const FileType xmlSeriesBD =
      FileType(2, IELevel.series, FileSubtype.xmlBD);

  static const FileType xmlInstance =
      FileType(1, IELevel.instance, FileSubtype.xml);
  static const FileType xmlInstanceMD =
      FileType(2, IELevel.instance, FileSubtype.xmlMD);
  static const FileType xmlInstanceBD =
      FileType(2, IELevel.instance, FileSubtype.xmlBD);

//  static const xmlFrames =  FileType(1, IELevel.frames, FileSubtype.xml);
//  static const xmlFramesMD =  FileType(2, IELevel.frames, FileSubtype.xmlMD);
//  static const xmlFramesBD =  FileType(2, IELevel.frames, FileSubtype.xmlBD);

  static const FileType unknown = FileType(2, null, FileSubtype.unknown);

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
        throw 'bad study lookup';
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
        throw 'bad series lookup';
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
        throw 'bad instance lookup';
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
        throw 'bad frames lookup';
        */
    }
    throw 'bad Entity lookup';
  }

  @override
  String toString() => '$level encoded as $mediaType';
}

/// The DICOM Object Type [OType].
enum OType {
  /// The Complete DICOM object Dataset.
  ///
  /// A Dataset that contains all Data Elements along with their values.
  /// In Particular,it contains no Bulkdata References.
  complete,

  /// A Metadata object.
  ///
  /// A Dataset that contains all Data Elements, but
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
  final DicomMediaType mType; // SubType
  final String ext; // File Extension

  //TODO: jfp document this
  const FileSubtype(this.index, this.name, this.oType, this.mType, this.ext);

  bool get isDicom => mType.isDicom;

  /// The file extension for this [FileSubtype].
  String get extension => ext;

  // Media Type  and associated accessors.
  /// The IANA Media Type of the associated FileName.
  DicomMediaType get mediaType => mType;

  /// Returns _true_ if the encoding units are bytes.
  bool get isBinary => mType.isBinary;

  /// Returns _true_ if the encoding units are 7-bit US-ASCII.
  bool get isAscii => mType.isAscii;

  /// Returns _true_ if the encoding (code) units are UTF8.
  bool get isUtf8 => mType.isUtf8;

  /// Returns _true_ if the representation encoding is [encoding].part10.
  bool get isPart10 => mType.encoding == Encoding.part10;

  /// Returns _true_ if the representation encoding is [encoding].json.
  bool get isJson => mType.encoding == Encoding.json;

  /// Returns _true_ if the representation encoding is [encoding].xml.
  bool get isXml => mType.encoding == Encoding.xml;

  /// The DICOM object [Encoding].
  Encoding get encoding => mType.encoding;

  /// The [Encoding] [Units].
  Units get units => mType.units;

  /// Returns _true_ if the Dataset is [OType.complete],
  /// that is, it contains no Bulkdata References.
  bool get isComplete => oType == OType.complete;

  /// Returns _true_ if the Dataset is Metadata,
  /// that is, it contains Bulkdata References.
  bool get isMetadata => oType == OType.metadata;

  /// Returns _true_ if this is a Bulkdata object.
  bool get isBulkdata => oType == OType.bulkdata;

  bool get isUnknown => mediaType == DicomMediaType.unknown;

  @override
  String toString() => '$runtimeType: $name encoded as $mediaType';

  static const FileSubtype part10 =
      FileSubtype(1, 'Part10', OType.complete, DicomMediaType.dicom, '.dcm');
  static const FileSubtype part10MD = FileSubtype(
      2, 'Part10 Metadata', OType.metadata, DicomMediaType.dicom, '.mddcm');
  static const FileSubtype bulkdata = FileSubtype(
      3, 'Binary Bulkdata', OType.bulkdata, DicomMediaType.octets, '.bddcm');

  static const FileSubtype json =
      FileSubtype(4, 'JSON', OType.complete, DicomMediaType.json, '.dcmjson');
  static const FileSubtype jsonMD = FileSubtype(
      5, 'JSON Metadata', OType.metadata, DicomMediaType.json, '.mddcmjson');
  static const FileSubtype jsonBD = FileSubtype(
      6, 'JSON Bulkdata', OType.bulkdata, DicomMediaType.json, '.bddcmjson');

  static const FileSubtype xml =
      FileSubtype(7, 'XML', OType.complete, DicomMediaType.xml, '.dcmxml');
  static const FileSubtype xmlMD = FileSubtype(
      8, 'XML Metadata', OType.metadata, DicomMediaType.xml, '.mddcm.xml');
  static const FileSubtype xmlBD = FileSubtype(
      9, 'XML Bulkdata', OType.bulkdata, DicomMediaType.xml, '.bddcmxml');

  static const FileSubtype unknown =
      FileSubtype(9, 'Unknown', OType.unknown, DicomMediaType.unknown, '');

  static FileSubtype parseExt(String ext) => lookup(ext);

  static FileSubtype parse(String _path) => parseExt(p.extension(_path));

  static bool isValidExtension(String ext) => parseExt(ext) != null;

  static FileSubtype lookup(String ext) => subtypes[ext] ?? FileSubtype.unknown;

  static const Map<String, FileSubtype> subtypes = {
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
