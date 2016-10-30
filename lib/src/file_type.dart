// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:path/path.dart' as p;

import 'dcm_media_type.dart';

int _firstDot(String s) => p.basename(s).indexOf('.');

String _extension(String path) => p.basename(path).substring(_firstDot(path));

/// The various [FileSubtype]s of DICOM objects
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
enum EType { study, series, instance, frames }

class FileType {
  final int index;
  final EType eType; // Object Type
  final FileSubtype subtype;


  //TODO: jfp document this
  const FileType(this.index, this.eType, this.subtype);

  DcmMediaType get mediaType => subtype.mType;
  EType get objectType => eType;
  String get extension => subtype.ext;
  String get charset => subtype.mType.charset;

  bool get isDicom => true;
  bool get isComplete => subtype == ESubtype.complete;
  bool get isMetadata => subtype == ESubtype.metadata;
  bool get isBulkdata => subtype == ESubtype.bulkdata;

  static const dcmStudy = const FileType(1, EType.study, FileSubtype.dcm);
  static const dcmStudyMD = const FileType(2, EType.study, FileSubtype.dcmMD);
  static const dcmStudyBD = const FileType(2, EType.study, FileSubtype.dcmBD);

  static const dcmSeries = const FileType(1, EType.series, FileSubtype.dcm);
  static const dcmSeriesMD = const FileType(2, EType.series, FileSubtype.dcmMD);
  static const dcmSeriesBD = const FileType(2, EType.series, FileSubtype.dcmBD);

  static const dcmInstance = const FileType(1, EType.instance, FileSubtype.dcm);
  static const dcmInstanceMD = const FileType(2, EType.instance, FileSubtype.dcmMD);
  static const dcmInstanceBD = const FileType(2, EType.instance, FileSubtype.dcmBD);

  static const dcmFrames = const FileType(1, EType.frames, FileSubtype.dcm);
  static const dcmFramesMD = const FileType(2, EType.frames, FileSubtype.dcmMD);
  static const dcmFramesBD = const FileType(2, EType.frames, FileSubtype.dcmBD);

  static const jsonStudy = const FileType(1, EType.study, FileSubtype.json);
  static const jsonStudyMD = const FileType(2, EType.study, FileSubtype.jsonMD);
  static const jsonStudyBD = const FileType(2, EType.study, FileSubtype.jsonBD);

  static const jsonSeries = const FileType(1, EType.series, FileSubtype.json);
  static const jsonSeriesMD = const FileType(2, EType.series, FileSubtype.jsonMD);
  static const jsonSeriesBD = const FileType(2, EType.series, FileSubtype.jsonBD);

  static const jsonInstance = const FileType(1, EType.instance, FileSubtype.json);
  static const jsonInstanceMD = const FileType(2, EType.instance, FileSubtype.jsonMD);
  static const jsonInstanceBD = const FileType(2, EType.instance, FileSubtype.jsonBD);

  static const jsonFrames = const FileType(1, EType.frames, FileSubtype.json);
  static const jsonFramesMD = const FileType(2, EType.frames, FileSubtype.jsonMD);
  static const jsonFramesBD = const FileType(2, EType.frames, FileSubtype.jsonBD);

  static const xmlStudy = const FileType(1, EType.study, FileSubtype.xml);
  static const xmlStudyMD = const FileType(2, EType.study, FileSubtype.xmlMD);
  static const xmlStudyBD = const FileType(2, EType.study, FileSubtype.xmlBD);

  static const xmlSeries = const FileType(1, EType.series, FileSubtype.xml);
  static const xmlSeriesMD = const FileType(2, EType.series, FileSubtype.xmlMD);
  static const xmlSeriesBD = const FileType(2, EType.series, FileSubtype.xmlBD);

  static const xmlInstance = const FileType(1, EType.instance, FileSubtype.xml);
  static const xmlInstanceMD = const FileType(2, EType.instance, FileSubtype.xmlMD);
  static const xmlInstanceBD = const FileType(2, EType.instance, FileSubtype.xmlBD);

  static const xmlFrames = const FileType(1, EType.frames, FileSubtype.xml);
  static const xmlFramesMD = const FileType(2, EType.frames, FileSubtype.xmlMD);
  static const xmlFramesBD = const FileType(2, EType.frames, FileSubtype.xmlBD);


  FileType lookup(EType eType, FileSubtype fSubtype) {
    switch (eType) {
      case EType.study:
        switch (fSubtype) {
          case FileSubtype.dcm:
            return dcmStudy;
          case FileSubtype.dcmMD:
            return dcmStudyMD;
          case FileSubtype.dcmBD:
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
      case EType.series:
        switch (fSubtype) {
          case FileSubtype.dcm:
            return dcmSeries;
          case FileSubtype.dcmMD:
            return dcmSeriesMD;
          case FileSubtype.dcmBD:
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
      case EType.instance:
        switch (fSubtype) {
          case FileSubtype.dcm:
            return dcmInstance;
          case FileSubtype.dcmMD:
            return dcmInstanceMD;
          case FileSubtype.dcmBD:
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
      case EType.frames:
        switch (fSubtype) {
          case FileSubtype.dcm:
            return dcmFrames;
          case FileSubtype.dcmMD:
            return dcmFramesMD;
          case FileSubtype.dcmBD:
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

enum ESubtype { complete, metadata, bulkdata }

class FileSubtype {
  final int index;
  final ESubtype eSubtype;
  final DcmMediaType mType; // SubType
  final String ext; // File Extension

  //TODO: jfp document this
  const FileSubtype(this.index, this.eSubtype, this.mType, this.ext);

  DcmMediaType get mediaType => mType;
  String get extension => ext;
  String get charset => mType.charset;

  bool get isDicom => true;
  bool get isComplete => eSubtype == ESubtype.complete;
  bool get isMetadata => eSubtype == ESubtype.metadata;
  bool get isBulkdata => eSubtype == ESubtype.bulkdata;

  static const dcm =
  const FileSubtype(1, ESubtype.complete, DcmMediaType.dcm, ".dcm");
  static const dcmMD =
  const FileSubtype(2, ESubtype.metadata, DcmMediaType.dcm, ".md.dcm");
  static const dcmBD =
  const FileSubtype(3, ESubtype.bulkdata, DcmMediaType.dcm, ".bd.dcm");

  static const json =
  const FileSubtype(4, ESubtype.complete, DcmMediaType.json, ".dcm.json");
  static const jsonMD =
  const FileSubtype(5, ESubtype.metadata, DcmMediaType.json, ".md.dcm.json");
  static const jsonBD =
  const FileSubtype(6, ESubtype.bulkdata, DcmMediaType.json, ".bd.dcm.json");

  static const xml =
  const FileSubtype(7, ESubtype.complete, DcmMediaType.xml, ".dcm.xml");
  static const xmlMD =
  const FileSubtype(8, ESubtype.metadata, DcmMediaType.xml, ".md.dcm.xml");
  static const xmlBD =
  const FileSubtype(9, ESubtype.bulkdata, DcmMediaType.xml, ".bd.dcm.xml");

  static parseExt(String ext) => subtypes[ext];
  static parse(String _path) => subtypes[_extension(_path)];

  static bool isValidExtentsion(String ext) => (parseExt(ext) != null);

  static const Map<String, FileSubtype> subtypes = const {
    ".dcm": FileSubtype.dcm,
    ".md.dcm": FileSubtype.dcmMD,
    ".bd.dcm": FileSubtype.dcmBD,
    ".dcm.json": FileSubtype.json,
    ".md.dcm.json": FileSubtype.jsonMD,
    ".dcm.xml": FileSubtype.xml,
    ".md.dcm.xml": FileSubtype.xmlMD
  };

  toString() => '$eSubtype($ext) encoded as $mediaType';
}

