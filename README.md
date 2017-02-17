bbbbbbbbbbb# DICOM I/O Library

A library for reading and writing DICOM objects encoded in a
DICOM Media Type. See PS3.18, Section 6.1.1.8.

## Usage

A simple usage exampl

    TODO: validate code
    import 'package:io/io.dart';
    
    String inPath = '/2.25.2094332409/2.25123456789/2.25.987654321.dcm';

    main() {
      var fs = new FileSystem();
      DcmFile file = fs.toFile(inPath);
      Entity entity = file.readSync();
      print('entity: $entity');
    }
   TODO: non-FileSystem read.
## Examples

## Studies Service Information Entities

A DICOM Study contains four different Information Entities:

- Patient
- Study
- Series
- Instance

Any Entity can be stored as either a complete entity or as a  Metadata file and a Bulkdata file.

## DICOM Object Representations

A DICOM Information Object is contained in a Dataset.  A Dataset can either be Complete, or it 
can be separated into Metadata and Bulkdata. 

A Complete Dataset contains all of the Data Elements of an Information Entity.

A Metadata Dataset contains the same Data Elements as a corresponding Complete Dataset, however, one
 or more Data Elements with large values have had their values moved to a Bulkdata object and 
 replaced with a Bulkdata Reference.

A Bulkdata object contains one or more values that have been removed from the corresponding
Metadata object. Bulkdata objects currently only have one media type, which is 
'application/octet-stream' (i.e. an array of 8-bit bytes). 
 
A Bulkdata Reference is a URL that references one or more Bulkdata values in a Bulkdata object.

### Types of Files and their Extensions

| Type       | Media Type   |    Extension |
| :---       |  :----:      |         ---: |
| Complete   | dicom        |         .dcm |
| Metadata   | dicom        |      .md.dcm |
| Bulkdata   | octet-stream |      .bd.dcm |
| Complete   | dicom+json   |    .dcm.json |
| Metadata   | dicom+json   | .md.dcm.json |
| Complete   | dicom+xml    |     .dcm.xml |
| Metadata   | dicom+xml    |  .md.dcm.xml |


### Media Types and File Extentions

There are three DICOM Media Types:
    - dicom: A traditional binary encoding as specified in PS3.10.
    - dicom+json: A JSON encoding specified in PS3.18.
    - dicom+xml: An XML encoding specified in PS3.19

Each of these Media Types has an associated file extension:

| Media Type | Object   | Encoding   | Extension    |
|:----       | :----:   |  :----     |        ----: |
| Binary     | Instance | dicom      | .dcm         |
| Binary     | Metadata | dicom      | .md.dcm      |
| Binary     | Bulkdata | dicom      | .bd.dcm      |
| JSON       | Instance | dicom+json | .dcm.json    |
| JSON       | Metadata | dicom+json | .md.dcm.json |
| XML        | Instance | dicom+xml  | .dcm.xml     |
| XML        | Metadata | dicom+xml  | .md.dcm.xml  |


### Entity Files

An Entity File contains all of the data associated with a Study, Series, or Instance.

### SOP Instance Tre

    path format = / study / series / instance.dcm ; Sop Instance
                  / study / series / instance.md ; instance Metadata
                  / study / series / bulkdata.bd ; instance Bulkdata

Where, root, study, and SeriesUid are strings naming directories, and instance is a string
naming a file. The study, series and instancUid are strings containing UIDs.

### SOP Instance Flat

path format = root / study / instance.dcm

Where, root, and study are strings naming directories, and instance is a string
naming a file. The study and instancUid are strings containing UIDs.



### File Path Format

The following table shows the path structure for study, series, or instance objects.  The '*' in 
the file extensions in this table can be replaced by: "dcm", "json", or "xml".

The *root* path component contains the root of the File System. The studyUid, seriesUid, and 
instanceUid are the UIDs of the objects stored on that path.

| **Object Type**   | **File Path Format** |
| :----             | :----            |
| Study             | root/studyUid.* |
| Study Metadata    | root/studyUid.md.* |
| Study Bulkdata    | root/studyUid.bd.dcm |
| Series            | root/studyUid/seriesUid.*  |
| Series Metadata   | root/studyUid/seriesUid.md.*  |
| Series Bulkdata   | root/studyUid/seriesUid.bd.dcm  |
| Instance          | root/studyUid/seriesUidUid/instanceUid.*  |
| Instance Metadata | root/studyUid/seriesUid/instanceUid.md.* |
| Instance Bulkdata | root/studyUid/seriesUid/instanceUid.bd.dcm  |


A DICOM File System can contain Study, Series, or Instance object in any DICOM Media Type.


#### Study Paths
     
     root/study.dcm
     root/study.md.dcm
     root/study.bd.dcm
     root/study.json
     root/study.md.json
     root/study.xml
     root/study.md.xml
                
#### Series Paths

     root/study/series.dcm
     root/study/series.md.dcm
     root/study/series.bd.dcm
     root/study/series.json
     root/study/series.md.json
     root/study/series.xml
     root/study/series.md.xml
     
#### Instance Paths

     root/study/series/instance.dcm  
     root/study/series/instance.md.dcm
     root/study/series/instance.bd.dcm
     root/study/series/instance.json  
     root/study/series/instance.md.json
     root/study/series/instance.xml
     root/study/series/instance.md.xml 

#### Root Directory

The Root Directory is the path to the root of the File
System.

#### Study File or Directory

A Study file contains the data for an entire Study. The file name is composed of the Study UID 
and the appropriate extension for the contained media type.

A Study directory contains one or more Series files or Series Directories. The directory name is 
composed of the Study UID.

#### Series File or Directory

A Series file contains the data for an entire Series. The file name is composed of the Series UID 
and the appropriate extension for the contained media type.

A Series directory that contains one or more Instance files, where each file contains an instance
that belongs to the Series. The directory name is the Series UID of the Series it contains.

#### Instance File

A file that contains a single Instance object, encoded in the [media type][MediaType] specified by
the file extension. The file name is the Instance UID of the Instance it contains.


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[MediaType]:
    http://dicom.nema.org/medical/dicom/current/output/html/part18.html#sect_6.1.1
[tracker]: http://example.com/issues/replaceme
