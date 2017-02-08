// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:async';

import 'package:grinder/grinder.dart';

Future main(args) => grind(args);

@Task('Initializing...')
void init() {
  log("Initializing stuff...");
}

@DefaultTask('Running Default Tasks...')
void myDefault() {
  log('Running Defaults...');
  test();
  // testformat();
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

@Task('Build the project.')
void build() {
  log("Building...");
  log('TODO unimplemented');
}

@Task('Testing JavaScript...')
@Depends(build)
void testJavaScript() {
  new PubApp.local('test').run([]);
}

@Task('Formating Source...')
void format() {
  DartFmt.dryRun('lib', lineLength: 100);
  log("Formatting Source...");
}

@Task('Compiling...')
@Depends(init)
void compile() {
  log("Compiling...");
}

@Task('DartDoc')
void dartdoc() {
  log('Generating Documentation...');
}

@Task('Clean Deployment stuff.')
@Depends(clean, compile, build, test)
void deploy() {
  log("Deploying...");
}
