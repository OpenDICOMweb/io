//  Copyright (c) 2016, 2017, 2018
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:collection';
import 'dart:convert' as cvt;
import 'dart:io';

import 'package:core/core.dart';

/// Returns a [Map] that is read from [path]. [path] must
/// contain a JSON object corresponding to [Map<K, Entity>].
Map<K, Entity> _readMap<K>(String path) {
  final s = File(path).readAsStringSync();
  return cvt.json.decode(s);
}

/// Writes a [Map<K, Entity] to [path] as a JSON object
/// corresponding to [Map<K, Entity>].
void _writeMap<K>(Map<K, Entity> map, String path) {
  final s = cvt.json.encode(map);
  File(path).writeAsStringSync(s);
}

/// A Database that maps [Uid]s to [Entity]s.
class EntityDB extends MapBase<Uid, Entity> {
  /// The default path where _this_ is stored.
  static const String defaultFile = 'entity_db.json';

  /// The [path] where this database is stored.
  final String path;

  /// The [Map<Uid, Entity>].
  final Map<Uid, Entity> dbMap;

  /// Creates an empty [EntityDB].
  EntityDB(this.path) : dbMap = <Uid, Entity>{};

  /// Creates a [EntityDB] from [dbMap].
  /// If written, the path will default to [path];
  EntityDB.from(this.dbMap, this.path);

  /// Read and return an [EntityDB] from [dirPath].
  factory EntityDB.read(String dirPath) {
    final path = '$dirPath/$defaultFile';
    return EntityDB.from(_readMap<Uid>(path), path);
  }

  /// Return the [Entity] with [Uid] if present; otherwise, _null_.
  @override
  Entity operator [](Object v) => dbMap[v];

  /// Sets the element with [Uid] to have a value of [Entity].
  @override
  void operator []=(Uid v, Entity e) => dbMap[v] = e;

  @override
  Iterable<Uid> get keys => dbMap.keys;

  @override
  void clear() => unsupportedError();

  @override
  Entity remove(Object key) => unsupportedError();

  /// Add [e] to _this_.
  bool add(Entity e) {
    final old = dbMap[e.uid];
    if (old != null) return invalidDuplicateEntityError(old, e);
    dbMap[e.uid] = e;
    return true;
  }

  /// Write a [EntityDB] to [path] as a JSON object corresponding to
  /// [Map<Uid, Entity>].
  static void write(EntityDB edb, String path) =>
      _writeMap<Uid>(edb.dbMap, path);
}

/// A database that maps [Uid]s to [Patient]s.
class PatientDB extends EntityDB {
  /// The default path where _this_ is stored.
  static const String defaultFile = 'patient_db.json';

  /// Creates an empty [PatientDB].
  PatientDB([String path = defaultFile]) : super.from(<Uid, Patient>{}, path);

  /// Creates a [PatientDB] from [dbMap]. If written, it will be written
  /// to [path], which defaults to [defaultFile];
  PatientDB.from(Map<Uid, Patient> dbMap, [String path = defaultFile])
      : super.from(dbMap, path);

  /// Returns a [PatientDB] that is read from [path]. [path] must
  /// contain a JSON object corresponding to [Map<Uid, Patient>].
  factory PatientDB.read(String dirPath) {
    final path = '$dirPath/$defaultFile';
    return PatientDB.from(_readMap<Uid>(path), path);
  }

  /// Write a [PatientDB] to [path] as a JSON object corresponding to
  /// [Map<Uid, Patient>].
  static void write(PatientDB db, [String path = defaultFile]) =>
      _writeMap<Uid>(db.dbMap, path);
}

/// A database that maps [Uid]s to [Study]s.
class StudyDB extends EntityDB {
  /// The default path where _this_ is stored.
  static const String defaultFile = 'patient_db.json';

  /// Creates an empty [StudyDB].
  StudyDB([String path = defaultFile]) : super.from(<Uid, Study>{}, path);

  /// Creates a [StudyDB] from [dbMap]. If written, it will be written
  /// to [path], which defaults to [defaultFile];
  StudyDB.from(Map<Uid, Study> db, [String path = defaultFile])
      : super.from(db, path);

  /// Returns a [StudyDB] that is read from [path]. [path] must
  /// contain a JSON object corresponding to [Map<Uid, Study>].
  factory StudyDB.read(String dirPath) {
    final path = '$dirPath/$defaultFile';
    return StudyDB.from(_readMap<Uid>(path), path);
  }

  /// Write a [StudyDB] to [path] as a JSON object corresponding to
  /// [Map<Uid, Study>].
  static void write(StudyDB db, [String path = defaultFile]) =>
      _writeMap<Uid>(db.dbMap, path);
}

/// A database that maps [Uid]s to [Series]s.
class SeriesDB extends EntityDB {
  /// The default path where _this_ is stored.
  static const String defaultFile = 'series_db.json';

  /// Creates an empty [SeriesDB].
  SeriesDB([String path = defaultFile]) : super.from(<Uid, Series>{}, path);

  /// Creates a [SeriesDB] from [map]. If written, it will be written
  /// to [path], which defaults to [defaultFile];
  SeriesDB.from(Map<Uid, Series> map, [String path = defaultFile])
      : super.from(map, path);

  /// Returns a [SeriesDB] that is read from [path]. [path] must
  /// contain a JSON object corresponding to [Map<Uid, Series>].
  factory SeriesDB.read(String dirPath) {
    final path = '$dirPath/$defaultFile';
    return SeriesDB.from(_readMap<Uid>(path), path);
  }

  /// Write a [SeriesDB] to [path] as a JSON object corresponding to
  /// [Map<Uid, Series>].
  static void write(SeriesDB db, [String path = defaultFile]) =>
      _writeMap<Uid>(db.dbMap, path);
}

/// A database that maps [Uid]s to [Instance]s.
class InstanceDB extends EntityDB {
  /// The default path where _this_ is stored.
  static const String defaultFile = 'study_db.json';

  /// Creates an empty [InstanceDB].
  InstanceDB([String path = defaultFile]) : super.from(<Uid, Instance>{}, path);

  /// Creates a [InstanceDB] from [map]. If written, it will be written
  /// to [path], which defaults to [defaultFile];
  InstanceDB.from(Map<Uid, Instance> map, [String path = defaultFile])
      : super.from(map, path);

  /// Returns a [InstanceDB] that is read from [path]. [path] must
  /// contain a JSON object corresponding to [Map<Uid, Instance>].
  factory InstanceDB.read(String dirPath) {
    final path = '$dirPath/$defaultFile';
    return InstanceDB.from(_readMap<Uid>(path), path);
  }

  /// Write a [InstanceDB] to [path] as a JSON object corresponding to
  /// [Map<Uid, Instance>].
  static void write(InstanceDB db, [String path = defaultFile]) =>
      _writeMap<Uid>(db.dbMap, path);
}

/// A database containing the [Uid]s of all [Entity]s known to a VNA.
class VnaUidDB {
  /// All [Entity] [Uid]s and the corresponding Entities known to this VNA.
  final EntityDB entities;

  /// All [Patient] [Uid]s and the corresponding [Patient]s known to this VNA.
  final PatientDB patients;

  /// All [Study] [Uid]s and the corresponding [Study]s known to this VNA.
  final StudyDB studies;

  /// All [Series] [Uid]s and the corresponding [Series]s known to this VNA.
  final SeriesDB series;

  /// All [Instance] [Uid]s and the corresponding [Instance]s known to this VNA.
  final InstanceDB instances;

  /// Constructor
  VnaUidDB(
      this.entities, this.patients, this.studies, this.series, this.instances);

  /// Creates an empty VnaUidDB.
  VnaUidDB.empty(String dirPath)
      : entities = EntityDB(dirPath),
        patients = PatientDB(dirPath),
        studies = StudyDB(dirPath),
        series = SeriesDB(dirPath),
        instances = InstanceDB(dirPath);

  /// Creates a [VnaUidDB] from files in the directory at [dirPath].
  factory VnaUidDB.load(String dirPath) {
    final entities = EntityDB.read(dirPath);
    final patients = PatientDB.read(dirPath);
    final studies = StudyDB.read(dirPath);
    final series = SeriesDB.read(dirPath);
    final instances = InstanceDB.read(dirPath);

    return VnaUidDB(entities, patients, studies, series, instances);
  }
}
