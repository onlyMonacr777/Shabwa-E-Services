import '../enums/request_status.dart';

extension StatusExtension on RequestStatus {
  String get label {
    switch (this) {
      case RequestStatus.approved:
        return 'مقبول';
      case RequestStatus.rejected:
        return 'مرفوض';
      case RequestStatus.pending:
        return 'قيد المراجعة';
    }
  }
}