//  Copyright (c) 2016, 2017, 2018
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/core.dart';

// ignore_for_file: public_member_api_docs

abstract class Cache<K, V>{
  int maxEntries;
  Map<K, V> cache;

  Cache([int maxEntries]) : cache = <K, V>{};

  Cache.open(String path) : cache = _open(path);

  void add(K key, V value) {

  }

  static Map _open(String path) {

  }
}

class PatientCache extends Cache<Uuid, Patient> {


  PatientCache(int maxEntries) : super(maxEntries);

  PatientCache.open(String path) : super.open(path);


}
