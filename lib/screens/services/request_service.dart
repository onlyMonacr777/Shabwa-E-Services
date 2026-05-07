import 'package:shabwa_e_services/data/mock/requests_data.dart';

class RequestService {

  Future<List<Map<String, dynamic>>>
  fetchRequests() async {

    await Future.delayed(
      const Duration(seconds: 1),
    );

    return requestsData;
  }
}