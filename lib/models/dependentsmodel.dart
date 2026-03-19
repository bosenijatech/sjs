class DependentsModel {
  String? status;
  String? responseCode;
  int? currentPage;
  int? pageSize;
  int? totalRecords;
  List<EmpDocumentList>? empDocumentList;

  DependentsModel(
      {this.status,
      this.responseCode,
      this.currentPage,
      this.pageSize,
      this.totalRecords,
      this.empDocumentList});

  DependentsModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    responseCode = json['ResponseCode'];
    currentPage = json['currentPage'];
    pageSize = json['pageSize'];
    totalRecords = json['totalRecords'];
    if (json['emp_document_list'] != null) {
      empDocumentList = <EmpDocumentList>[];
      json['emp_document_list'].forEach((v) {
        empDocumentList!.add(EmpDocumentList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['ResponseCode'] = responseCode;
    data['currentPage'] = currentPage;
    data['pageSize'] = pageSize;
    data['totalRecords'] = totalRecords;
    if (empDocumentList != null) {
      data['emp_document_list'] =
          empDocumentList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EmpDocumentList {
  String? id;
  String? name;
  bool? inactive;

  EmpDocumentList({this.id, this.name, this.inactive});

  EmpDocumentList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    inactive = json['inactive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['inactive'] = inactive;
    return data;
  }
}
