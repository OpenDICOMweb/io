// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
import 'package:core/server.dart' hide group;
import 'package:io_extended/io_extended.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'entity_db/entity_db_test', level: Level.debug);

  group('Entity DB Tests', () {
    const dirPath = 'C:/odw/sdk/io_extended/test/entity_db';
    final vnaDB = VnaUidDB.empty(dirPath);
    final entities = vnaDB.entities;

    final ptUid0 = Uid();
    final pt0 = Patient('zero', ptUid0, null);
    final ptUid1 = Uid();
    final pt1 = Patient('one', ptUid1, null);
    final ptBad = Patient('Bad', ptUid0, null);

    test('PatientDB Test add(Patient)', () {
      global.throwOnError = false;

      final patients = PatientDB(dirPath);
      expect(entities.add(pt0), true);
      expect(patients.add(pt0), true);
      expect(entities.add(pt1), true);
      expect(patients.add(pt1), true);

      expect(entities.add(pt0), false);
      expect(patients.add(pt0), false);
      expect(entities.add(pt1), false);
      expect(patients.add(pt1), false);

      print('length: ${entities.length}');
      expect(entities.length == 2, true);
      expect(patients.length == 2, true);
      expect(entities.keys.length == 2, true);
      expect(patients.keys.length == 2, true);

      expect(entities.add(ptBad), false);
      expect(patients.add(ptBad), false);

      global.throwOnError = true;
      expect(() => patients.add(ptBad),
          throwsA(const TypeMatcher<DuplicateEntityError>()));
    });

    test('PatientDB Test []=', () {
      global.throwOnError = false;

      final patients = vnaDB.patients;

      patients[ptUid0] = pt0;
      patients[ptUid1] = pt1;

      expect(entities.add(pt0), false);
      expect(patients.add(pt0), false);
      expect(entities.add(pt1), false);
      expect(patients.add(pt1), false);
      expect(entities.length == 2, true);
      expect(patients.length == 2, true);
      expect(entities.keys.length == 2, true);
      expect(patients.keys.length == 2, true);

      expect(entities.add(ptBad), false);
      expect(patients.add(ptBad), false);

      global.throwOnError = true;
      expect(() => patients.add(ptBad),
          throwsA(const TypeMatcher<DuplicateEntityError>()));
    });

    final stUid0 = Uid();
    final st0 = Study(pt0, stUid0, null);
    final stUid1 = Uid();
    final st1 = Study(pt1, stUid1, null);
    final stBad = Study(ptBad, stUid0, null);

    test('Study Test add(Study)', () {
      global.throwOnError = false;

      final studies = StudyDB(dirPath);
      final eLength = entities.length;

      expect(entities.add(st0), true);
      expect(studies.add(st0), true);

      expect(entities.add(st1), true);
      expect(studies.add(st1), true);

      expect(entities.add(st0), false);
      expect(studies.add(st0), false);
      expect(entities.add(st1), false);
      expect(studies.add(st1), false);

      print('length: ${entities.length}');
      expect(entities.length == eLength + 2, true);
      expect(studies.length == 2, true);
      expect(entities.keys.length == eLength + 2, true);
      expect(studies.keys.length == 2, true);

      expect(entities.add(stBad), false);
      expect(studies.add(stBad), false);

      global.throwOnError = true;
      expect(() => studies.add(stBad),
          throwsA(const TypeMatcher<DuplicateEntityError>()));
    });

    // [entities] not used in this test.
    test('StudyDB Test []=', () {
      global.throwOnError = false;

      final studies = vnaDB.studies;

      studies[stUid0] = st0;
      studies[stUid1] = st1;

      expect(studies.add(st0), false);
      expect(studies.add(st1), false);

      expect(studies.length == 2, true);
      expect(studies.keys.length == 2, true);

      expect(studies.add(stBad), false);

      global.throwOnError = true;
      expect(() => studies.add(stBad),
          throwsA(const TypeMatcher<DuplicateEntityError>()));
    });

    final seUid0 = Uid();
    final se0 = Series(st0, seUid0, null);
    final seUid1 = Uid();
    final se1 = Series(st1, seUid1, null);
    final seBad = Series(stBad, seUid0, null);

    test('Series Test add(Study)', () {
      global.throwOnError = false;

      final series = SeriesDB(dirPath);
      final eLength = entities.length;

      expect(entities.add(se0), true);
      expect(series.add(se0), true);
      expect(entities.add(se1), true);
      expect(series.add(se1), true);

      expect(entities.add(se0), false);
      expect(series.add(se0), false);
      expect(entities.add(se1), false);
      expect(series.add(se1), false);

      print('length: ${entities.length}');
      expect(entities.length == eLength + 2, true);
      expect(series.length == 2, true);
      expect(entities.keys.length == eLength + 2, true);
      expect(series.keys.length == 2, true);

      expect(entities.add(seBad), false);
      expect(series.add(seBad), false);

      global.throwOnError = true;
      expect(() => series.add(seBad),
          throwsA(const TypeMatcher<DuplicateEntityError>()));
    });

    // [entities] not used in this test.
    test('SeriesDB Test []=', () {
      global.throwOnError = false;

      final series = vnaDB.series;

      series[seUid0] = se0;
      series[seUid1] = se1;

      expect(series.add(se0), false);
      expect(series.add(se1), false);
      expect(series.length == 2, true);
      expect(series.keys.length == 2, true);

      expect(series.add(seBad), false);

      global.throwOnError = true;
      expect(() => series.add(seBad),
          throwsA(const TypeMatcher<DuplicateEntityError>()));
    });

    final inUid0 = Uid();
    final in0 = Instance(se0, inUid0, null);
    final inUid1 = Uid();
    final in1 = Instance(se1, inUid1, null);
    final inBad = Instance(seBad, inUid0, null);

    test('Instance Test add(Instance)', () {
      global.throwOnError = false;

      final instances = InstanceDB(dirPath);
      final eLength = entities.length;

      expect(entities.add(in0), true);
      expect(instances.add(in0), true);
      expect(entities.add(in1), true);
      expect(instances.add(in1), true);

      expect(entities.add(in0), false);
      expect(instances.add(in0), false);
      expect(entities.add(in1), false);
      expect(instances.add(in1), false);

      print('length: ${entities.length}');
      expect(entities.length == eLength + 2, true);
      expect(instances.length == 2, true);
      expect(entities.keys.length == eLength + 2, true);
      expect(instances.keys.length == 2, true);

      expect(entities.add(inBad), false);
      expect(instances.add(inBad), false);

      global.throwOnError = true;
      expect(() => instances.add(inBad),
          throwsA(const TypeMatcher<DuplicateEntityError>()));
    });

    // [entities] not used in this test.
    test('InstanceDB Test []=', () {
      global.throwOnError = false;

      final instances = vnaDB.instances;

      instances[inUid0] = in0;
      instances[inUid1] = in1;

      expect(instances.add(in0), false);
      expect(instances.add(in1), false);
      expect(instances.length == 2, true);
      expect(instances.keys.length == 2, true);

      expect(instances.add(inBad), false);

      global.throwOnError = true;
      expect(() => instances.add(inBad),
          throwsA(const TypeMatcher<DuplicateEntityError>()));
    });
  });
}
