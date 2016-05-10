library odw.sdk.base.dataset;

import 'dart:core' hide DateTime;
import 'dart:collection';
import 'dart:typed_data';

import '../utils/byte_array.dart';
import '../utils/formatter.dart';
import 'attribute.dart';

/**
 * The DataSet class encapsulates a collection of DICOM Elements and
 * provides various functions to access the type in those attributes
 *
 * Rules for handling padded spaces:
 * DS = Strip leading and trailing spaces
 * DT = Strip trailing spaces
 * IS = Strip leading and trailing spaces
 * PN = Strip trailing spaces
 * TM = Strip trailing spaces
 * AE = Strip leading and trailing spaces
 * CS = Strip leading and trailing spaces
 * SH = Strip leading and trailing spaces
 * LO = Strip leading and trailing spaces
 * LT = Strip trailing spaces
 * ST = Strip trailing spaces
 * UT = Strip trailing spaces
 *
 */

typedef ElementReader([int limit]);

/// A DICOM dataset
class Dataset implements Maps {
  bool isExplicit = true;
  ElementReader attributeReader;
  //Fix: import
  //DcmByteArray buf;
  Map<int, AttributeBase> attributes = {};
  List<String> warnings = [];

  //****  Constructors  ****
  //TODO determine which are really neaded
  Dataset({int length: 8, bool this.isExplicit: true, Endianness endian}) {
    Uint8List bytes = new Uint8List(length);
    _init(bytes, 0, length, isExplicit, endian);
  }

  Dataset.fromByteArray(this.buf, [this.isExplicit = true, Endianness endian]) {
    _init(buf.bytes, buf.start, buf.limit, isExplicit, endian);
  }

  Dataset.fromBuffer(ByteBuffer buffer, [int start = 0, int length, Endianness endian]) {
    _init(buffer.asUint8List(), start, length, isExplicit, endian);
  }

  Dataset.fromUint8List(Uint8List bytes, [int start = 0, int length, Endianness endian]) {
    _init(bytes, start, length, isExplicit, endian);
  }

  Dataset.view(Uint8List bytes, [int start = 0, int length, Endianness endian]) {
    _init(bytes, start, length, isExplicit, endian);
  }

  void _init(Uint8List bytes, int start, int length, bool isExplicit, Endianness endian) {
    if (start == null) start = 0;
    if (length == null) length = bytes.lengthInBytes;
    attributeReader = (isExplicit) ? buf.readElementExplicit : buf.readElementImplicit;
    if (endian == null) endian = Endianness.HOST_ENDIAN;
    buf = new ByteArray.fromUint8List(bytes, start, length, endian);
  }

  //****  Maps primitives  ****
  AttributeBase operator [](int tag) => attributes[tag];

  void operator []=(int tag, AttributeBase value) {
    attributes[tag] = value;
  }

  Iterable<int> get keys => attributes.keys;

  void clear() => attributes.clear();

  AttributeBase remove(int key) => attributes.remove(key);

  //****  Static Entry Point  ****
  /// Reads an explicit type set.
  static Dataset read(ByteArray buf, {isExplicit: true}) {
    var ds = new Dataset.fromByteArray(buf, isExplicit);
    while (buf.isNotEmpty) {
      //print('buf remaining = ${buf.limit - buf.position}');
      var attribute = ds.attributeReader(buf.limit);
      ds[attribute.tag] = attribute;
      //ds.attributes[attribute.tag] = attribute;
    }
    return ds;
  }

  bool isValidIndex(int sizeInBytes, int len, int index) =>
    (len % sizeInBytes != 0) || (index >= len ~/ sizeInBytes) ? false : true;

  dynamic getElementValues(int tag, [int index]) {
    AttributeBase attribute = attributes[tag];
    if (attribute == null) return null;
    var values = attribute.values;
    if (values == null) values = attribute.values;
    return (index == null) ? values : values[index];
  }

  /// Returns the [int] number of string values contained in the attribute
  /// or null if the attribute is not present or has zero length value.
  int numStringValues(tag) {
    //final backslash = new RegExp(r'\\');
    Attribute attribute = attributes[tag];
    if(attribute != null) {
      List<String> values = attribute.values;
      if(values != null) return values.length;
    }
    return null;
  }

  /// Add a warning string to the [List<String>] of [warnings] associated with the [Dataset].
  void warning(String s) {
    print(s);
    warnings.add(s);
  }

  /// Formats the [Dataset] into a nested structure for [Sequences] and [Items].
  void format(Formatter fmt) {
    fmt.writeLn('Dataset:[');
    fmt.in1;
    attributes.forEach((int tag, AttributeBase e) {
      e.regexpString(fmt);
    });
    fmt.out1;
    fmt.writeLn(']');
  }
}
