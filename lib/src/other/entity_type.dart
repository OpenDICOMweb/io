// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.



enum EType {study, series, instance, frames}
enum ESubtype {complete, metadata, bulkdata}

class EntityType {
  final EType type;
  final ESubtype subtype;
  final int nParts;

  const EntityType(this.type, this.subtype, this.nParts);

  bool get isStudy => subtype == EType.study;
  bool get isSeries => subtype == EType.series;
  bool get isInstance => subtype == EType.instance;
  bool get isFrames => subtype == EType.frames;

  bool get isComplete => subtype == ESubtype.complete;
  bool get isMetadata => subtype == ESubtype.metadata;
  bool get isBulkdata => subtype == ESubtype.bulkdata;

  static const study = const EntityType(EType.study, ESubtype.complete, 1);
  static const studyMD = const EntityType(EType.study, ESubtype.metadata, 1);
  static const studyBD = const EntityType(EType.study, ESubtype.bulkdata, 1);

  static const series = const EntityType(EType.series, ESubtype.complete, 2);
  static const seriesMD = const EntityType(EType.series, ESubtype.metadata, 2);
  static const seriesBD = const EntityType(EType.series, ESubtype.bulkdata, 2);

  static const instance = const EntityType(EType.instance, ESubtype.complete, 3);
  static const instanceMD = const EntityType(EType.instance, ESubtype.metadata, 3);
  static const instanceBD = const EntityType(EType.instance, ESubtype.bulkdata, 3);

  static const frames = const EntityType(EType.frames, ESubtype.complete, 4);
  static const framesMD = const EntityType(EType.frames, ESubtype.metadata, 4);
  static const framesBD = const EntityType(EType.frames, ESubtype.bulkdata, 4);

}