// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:grinder/grinder.dart';

main(args) => grind(args);

@Task('Initializing...')
init() {
  log("Initializing stuff...");
}

@Task('Cleaning...')
clean() {
  log("Cleaning...");
}

@DefaultTask('Build the project.')
build() {
  log("Building...");
}

@Task('Testing JavaScript...')
@Depends(build)
testJavaScript() {
  new PubApp.local('test').run([]);
}

@Task('Testing JavaScript...')
test() {
  new PubApp.local('test').run([]);
}

@Task('Formating Source...')
format() {
  DartFmt.dryRun('lib', lineLength: 100);
  log("Formatting Source...");
}

@Task('Compiling...')
@Depends(init)
compile() {
  log("Compiling...");
}



@Task('DartDoc')
dartdoc() {
  log('Generating Documentation...');
}

@Task('Clean Deployment stuff.')
@Depends(clean, compile, build, test)
deploy() {
  log("Deploying...");
}