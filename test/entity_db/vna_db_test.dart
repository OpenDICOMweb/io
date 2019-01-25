// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
import 'package:core/server.dart' hide group;
import 'package:io_extended/io_extended.dart';
import 'package:test/test.dart';

void main() {
  Server.initialize(name: 'entity_db/vna_db_test', level: Level.debug);

  group('VNA DB Tests', () {
    final ptUid0 = Uid();
    final pt0 = Patient('one', ptUid0, null);
    final ptUid1 = Uid();
    final pt1 = Patient('one', ptUid0, null);
    final ptBad = Patient('Bad', ptUid0, null);

    test('PatientDB Test', () {
      global.throwOnError = false;

      final db = PatientDB();
      db[ptUid0] = pt0;
      db[ptUid1] = pt1;

      expect(db[ptUid0] == pt0, true);
      expect(db[ptUid1] == pt1, true);
      expect(db.length == 2, true);
      expect(db.keys.length == 2, true);

      expect(db.add(ptBad), false);

      global.throwOnError = true;
      expect(() => db.add(ptBad),
          throwsA(const TypeMatcher<DuplicateEntityError>()));
    });

    final stUid0 = Uid();
    final st0 = Study(pt0, stUid0, null);
    final stUid1 = Uid();
    final st1 = Study(pt1, stUid1, null);
    final stBad = Study(ptBad, stUid0, null);

    test('StudyDB Test', () {
      global.throwOnError = false;

      final db = StudyDB();
      db[stUid0] = st0;
      db[stUid1] = st1;

      expect(db[stUid0] == st0, true);
      expect(db[stUid1] == st1, true);
      expect(db.length == 2, true);
      expect(db.keys.length == 2, true);

      expect(db.add(stBad), false);

      global.throwOnError = true;
      expect(() => db.add(stBad),
          throwsA(const TypeMatcher<DuplicateEntityError>()));
    });

    final ssUid0 = Uid();
    final ss0 = Series(st0, ssUid0, null);
    final ssUid1 = Uid();
    final ss1 = Series(st1, ssUid1, null);
    final ssBad = Series(stBad, ssUid0, null);

    test('SeriesDB Test', () {
      global.throwOnError = false;

      final db = SeriesDB();
      db[ssUid0] = ss0;
      db[ssUid1] = ss1;

      expect(db[ssUid0] == ss0, true);
      expect(db[ssUid1] == ss1, true);
      expect(db.length == 2, true);
      expect(db.keys.length == 2, true);

      expect(db.add(ssBad), false);

      global.throwOnError = true;
      expect(() => db.add(ssBad),
          throwsA(const TypeMatcher<DuplicateEntityError>()));
    });

    final inUid0 = Uid();
    final in0 = Series(st0, inUid0, null);
    final inUid1 = Uid();
    final in1 = Series(st1, inUid1, null);
    final inBad = Series(stBad, inUid0, null);

    test('SeriesDB Test', () {
      global.throwOnError = false;

      final db = SeriesDB();
      db[inUid0] = in0;
      db[inUid1] = in1;

      expect(db[inUid0] == in0, true);
      expect(db[inUid1] == in1, true);
      expect(db.length == 2, true);
      expect(db.keys.length == 2, true);


      expect(db.add(inBad), false);

      global.throwOnError = true;
      expect(() => db.add(inBad),
          throwsA(const TypeMatcher<DuplicateEntityError>()));
    });
  });
}
