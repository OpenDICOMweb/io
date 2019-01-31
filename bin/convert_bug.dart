// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:io';

const String path = 'C:/odw/sdk/io_extended/test/vna_db_test/patient_studies_db.json';

Map<String, List<String>> jsonData = {
  'foo': ['foo'],
  'bar': ['bar']
};

void main() {
  final file = File('C:/odw/sdk/io_extended/test/map.json');
  final input = jsonEncode(jsonData);
  file.writeAsStringSync(input);
  final output = file.readAsStringSync();
  print('read s: $output');
  final map = jsonDecode(output) as Map;
  print('map: $map');
}

Map<String, List<String>> map;
void reviver(String key, List<String> value) {
  map[key] = value;

}
