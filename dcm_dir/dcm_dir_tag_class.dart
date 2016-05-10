// DCMiD Project
// Copyright 2014 Johns Hopkins University
// Author: James F Philbin <james.philbin@jhmi.edu>
library odw.sdk.base.io.dcm_dir_tag_class ;

import 'package:base/type.dart';

/// A compile time constant class implementing the DICOM Directory Data Element definitions.
class DcmDirTag {
  //TODO define the class
  final int    tag;
  final String keyword;
  final VR     vr;
  final VM     vm;
  final bool   isRetired;

  const DcmDirTag(this.tag, this.keyword, this.vr, this.vm, this.isRetired);

  static const DcmDirTag FileSetID =
      const DcmDirTag(0x00041130, "FileSetID", VR.kCS, VM.k1, false);
  static const DcmDirTag FileSetDescriptorFileID =
      const DcmDirTag(0x00041141, "FileSetDescriptorFileID", VR.kCS, VM.k1_8, false);
  static const DcmDirTag SpecificCharacterSetOfFileSetDescriptorFile =
      const DcmDirTag(0x00041142, "SpecificCharacterSetOfFileSetDescriptorFile", VR.kCS, VM.k1, false);
  static const DcmDirTag OffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity =
      const DcmDirTag(0x00041200, "OffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity", VR.kUL, VM.k1, false);
  static const DcmDirTag OffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity =
      const DcmDirTag(0x00041202, "OffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity", VR.kUL, VM.k1, false);
  static const DcmDirTag FileSetConsistencyFlag=
      const DcmDirTag(0x00041212, "FileSetConsistencyFlag", VR.kUS, VM.k1, false);
  static const DcmDirTag DirectoryRecordSequence =
      const DcmDirTag(0x00041220, "DirectoryRecordSequence", VR.kSQ, VM.k1, false);
  static const DcmDirTag OffsetOfTheNextDirectoryRecord =
      const DcmDirTag(0x00041400, "OffsetOfTheNextDirectoryRecord", VR.kUL, VM.k1, false);
  static const DcmDirTag RecordInUseFlag =
      const DcmDirTag(0x00041410, "RecordInUseFlag", VR.kUS, VM.k1, false);
  static const DcmDirTag OffsetOfReferencedLowerLevelDirectoryEntity=
      const DcmDirTag(0x00041420, "OffsetOfReferencedLowerLevelDirectoryEntity", VR.kUL, VM.k1, false);
  static const DcmDirTag DirectoryRecordType =
      const DcmDirTag(0x00041430, "DirectoryRecordType", VR.kCS, VM.k1, false);
  static const DcmDirTag PrivateRecordUID =
      const DcmDirTag(0x00041432, "PrivateRecordUID", VR.kUI, VM.k1, false);
  static const DcmDirTag ReferencedFileID =
      const DcmDirTag(0x00041500, "ReferencedFileID", VR.kCS, VM.k1_8, false);
  static const DcmDirTag MRDRDirectoryRecordOffset =
      const DcmDirTag(0x00041504, "MRDRDirectoryRecordOffset", VR.kUL, VM.k1, true);
  static const DcmDirTag ReferencedSOPClassUIDInFile=
      const DcmDirTag(0x00041510, "ReferencedSOPClassUIDInFile", VR.kUI, VM.k1, false);
  static const DcmDirTag ReferencedSOPInstanceUIDInFile =
      const DcmDirTag(0x00041511, "ReferencedSOPInstanceUIDInFile", VR.kUI, VM.k1, false);
  static const DcmDirTag ReferencedTransferSyntaxUIDInFile=
      const DcmDirTag(0x00041512, "ReferencedTransferSyntaxUIDInFile", VR.kUI, VM.k1, false);
  static const DcmDirTag ReferencedRelatedGeneralSOPClassUIDInFile =
      const DcmDirTag(0x0004151A, "ReferencedRelatedGeneralSOPClassUIDInFile", VR.kUI, VM.k1_n, false);
  static const DcmDirTag NumberOfReferences =
      const DcmDirTag(0x00041600, "NumberOfReferences", VR.kUL, VM.k1, true);

  static const List<DcmDirTag> dcmDirTagList = const [
    FileSetID, // (0004,1130)
    FileSetDescriptorFileID, // (0004,1141)
    SpecificCharacterSetOfFileSetDescriptorFile, // (0004,1142)
    OffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity, // (0004,1200)
    OffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity, // (0004,1202)
    FileSetConsistencyFlag, // (0004,1212)
    DirectoryRecordSequence, // (0004,1220)
    OffsetOfTheNextDirectoryRecord, // (0004,1400)
    RecordInUseFlag, // (0004,1410)
    OffsetOfReferencedLowerLevelDirectoryEntity, // (0004,1420)
    DirectoryRecordType, // (0004,1430)
    PrivateRecordUID, // (0004,1432)
    ReferencedFileID, // (0004,1500)
    MRDRDirectoryRecordOffset, // (0004,1504)
    ReferencedSOPClassUIDInFile, // (0004,1510)
    ReferencedSOPInstanceUIDInFile, // (0004,1511)
    ReferencedTransferSyntaxUIDInFile, // (0004,1512)
    ReferencedRelatedGeneralSOPClassUIDInFile, // (0004,151A)
    NumberOfReferences, // (0004,1600)
  ];
}
