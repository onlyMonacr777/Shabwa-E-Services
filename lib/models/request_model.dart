class RequestModel {
  final String userName;
  final String serviceName;
  final String status;
  final String date;

  RequestModel({
    required this.userName,
    required this.serviceName,
    required this.status,
    required this.date,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      userName: map['userName'] ?? '',
      serviceName: map['serviceName'] ?? '',
      status: map['status'] ?? 'pending',
      date: map['date'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'serviceName': serviceName,
      'status': status,
      'date': date,
    };
  }}
