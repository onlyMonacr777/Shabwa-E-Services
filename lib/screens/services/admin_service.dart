class AdminService {

  Future<List<Map<String, dynamic>>> getRequests() async {

    await Future.delayed(
      const Duration(seconds: 1),
    );

    return [
      {
        'userName': 'أحمد محمد',
        'serviceName': 'استخراج جواز',
        'status': 'pending',
        'date': '2026/05/07',
      },

      {
        'userName': 'محمد علي',
        'serviceName': 'بطاقة شخصية',
        'status': 'approved',
        'date': '2026/05/06',
      },
    ];
  }
}