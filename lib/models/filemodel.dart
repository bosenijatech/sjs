class AttachModel {
  String? documentNo;
  String? fileData;
  String? fileType;
  String? fileName;
  String? fileSize;
  AttachModel(
    this.documentNo,
    this.fileData,
    this.fileType,
    this.fileName,
    this.fileSize,
  );

  AttachModel.fromJson(Map<String, dynamic> json) {
    documentNo = json['DocumentNo'];
    fileData = json['FileData'];
    fileType = json['FileType'];
    fileName = json['FileName'];
    fileSize = json['FileSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DocumentNo'] = documentNo;
    data['FileData'] = fileData;
    data['FileType'] = fileType;
    data['FileName'] = fileName;
    data['FileSize'] = fileSize;

    return data;
  }
}
