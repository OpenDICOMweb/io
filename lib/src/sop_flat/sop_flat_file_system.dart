// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

//TODO: make everything async
import 'dart:async';
import 'dart:typed_data';

import 'package:core/dicom.dart';
import 'package:io/src/file_system.dart';
import 'package:io/src/fs_type.dart';

/// A DICOM File System containing SOP Instances organized in the following
/// structure:
///     /{study}/{series}/{instance}.dcm
class FlatSopFileSystem extends FileSystem {
  static const FSType type = FSType.sopFlat;

  static const String version = "0.1.0";
  static const String extension = ".dcm";

  FlatSopFileSystem(String root) : super(root);


  // *** Read Async  ***
  /* TODO: finish async later
  @override
  Stream<Uint8List> read(Uid study, [Uid series, Uid instance]){}

  @override
  Stream<Uint8List> readStudy(Uid study){}

  @override
  Stream<Uint8List> readSeries(Uid study, Uid series){}

  @override
  Future<Uint8List> readInstance(Uid study, Uid series, Uid instance){}
  */

  // *** Read Sync  ***

  List<Uint8List> readSync(Uid study, [Uid series, Uid instance]){}

  @override
  List<Uint8List> readStudySync(Uid study){}

  @override
  List<Uint8List> readSeriesSync(Uid study, Uid series){}

  @override
  Uint8List readInstanceSync(Uid study, Uid series, Uid instance){

    return new Uint8List(0);
  }

  // *** Write Async  ***

  /* TODO: implement async later
  @override
  Sink<Uint8List> write(Uid study, [Uid series, Uid instance]){}

  @override
  Sink<Uint8List> writeStudy(Uid study){}

  @override
  Sink<Uint8List> writeSeries(Uid study, Uid series){}

  @override
  Future<Uint8List> writeInstance(Uid study, Uid series, Uid instance){}
  */

  // *** Write Sync  ***

  @override
  void writeSync(Uid study, [Uid series, Uid instance]){}

  @override
  void writeStudySync(Uid study){}

  @override
  void writeSeriesSync(Uid study, Uid series){}

  void writeInstanceSync(Uid study, Uid series, Uid instance, Uint8List bytes){}


}

