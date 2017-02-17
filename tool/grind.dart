// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:io';

import 'package:grinder/grinder.dart';

Future main(args) => grind(args);

/// The dartdoc [Directory].
Directory dartdocDir = new Directory('doc/api');

@DefaultTask('Running Default Tasks...')
void myDefault() {
  log('Running Grind Defaults...');
  log('  Running Tests...');
  test();
  log('  Running format...');
  format();
}

@Task('Testing Dart...')
void test() {
  log('Running Unit Tests');
  new PubApp.local('test').run([]);
}

@Task('Cleaning...')
void clean() {
  log("Cleaning...");
}

@Task('Dry Run of Formating Source...')
void testformat() {
  log("Test Formatting Source...");
  DartFmt.dryRun('lib', lineLength: 80);
  // DartFmt.dryRun('bin', lineLength: 80);
  DartFmt.dryRun('example', lineLength: 80);
  DartFmt.dryRun('test', lineLength: 80);
  DartFmt.dryRun('tool', lineLength: 80);
}

@Task('Formating Source...')
void format() {
  log("Formatting Source...");
  DartFmt.format('lib', lineLength: 80);
  // DartFmt.format('bin', lineLength: 80);
  DartFmt.format('example', lineLength: 80);
  DartFmt.format('test', lineLength: 80);
  DartFmt.format('tool', lineLength: 80);
}

@Task('Compiling...')
void compile() {
  log("Compiling...");
}

@Task('DartDoc')
void dartdoc() {
  log('Generating Documentation...');
  DartDoc.doc();
}

@Task('Build the project.')
void build() {
  log("Building(debug)...");
  Pub.get();
  Pub.build(mode: "debug");
}

@Task('Testing JavaScript...')
@Depends(build)
void testJavaScript() {
  new PubApp.local('test').run([]);
}

@Task('Clean Deployment stuff.')
@Depends(clean, compile, build, test)
void deploy() {
  log("Deploying...");
}
