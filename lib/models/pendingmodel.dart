class PendingModel {
  bool? status;
  List<Message>? message;

  PendingModel({this.status, this.message});

  PendingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (message != null) {
      data['message'] = message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  int? leavePending;
  int? letterPending;
  int? totalPending;

  Message({this.leavePending, this.letterPending, this.totalPending});

  Message.fromJson(Map<String, dynamic> json) {
    leavePending = json['leavePending'];
    letterPending = json['letterPending'];
    totalPending = json['totalPending'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['leavePending'] = leavePending;
    data['letterPending'] = letterPending;
    data['totalPending'] = totalPending;
    return data;
  }
}
