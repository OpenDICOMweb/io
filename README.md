# DICOM I/O Library

A library for reading and writing DICOM objects.

## Usage

A simple usage example:

    import 'package:io3/io3.dart';

    main() {
      var awesome = new Awesome();
    }

## Design

The libary is designed to support different file organizations:

- SOP_Flat: All the files are in one directory specified by the 
[_StudyInstanceUID].  Each file contains a single SOP Instance

- Structured: All the files are


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[StudyInstanceUID]
[tracker]: http://example.com/issues/replaceme
