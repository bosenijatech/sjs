class AnnouncementData {
  final String message;
  final String startDate;
  final String endDate;
  final String attachmentURL;

  AnnouncementData({
    required this.message,
    required this.startDate,
    required this.endDate,
    required this.attachmentURL,
  });

  factory AnnouncementData.fromJson(Map<String, dynamic> json) {
    return AnnouncementData(
      message: json['message'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      attachmentURL: json['attachmentURL'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'start_date': startDate,
      'end_date': endDate,
      'attachmentURL': attachmentURL,
    };
  }
}
