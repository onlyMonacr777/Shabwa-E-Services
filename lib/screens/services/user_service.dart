import 'package:shabwa_e_services/data/mock/users_data.dart';

class UserService {

  Future<List<Map<String, dynamic>>>
  fetchUsers() async {

    await Future.delayed(
      const Duration(seconds: 1),
    );

    return usersData;
  }
}