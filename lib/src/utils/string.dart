// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

/// Returns the number of characters (sign + digits) in an integer.
int getIntWidth(int n) => '$n'.length;

/*
String getPaddedInt(int n, int width) =>
    (n == null) ? '' : '${"$n".padLeft(width, '0')}';

*/
