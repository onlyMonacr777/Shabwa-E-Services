import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../data/mock/service_data.dart';

class ServicesProvider extends ChangeNotifier {
  final List<ServiceModel> _services =
      servicesData.map((e) => ServiceModel.fromMap(e)).toList();

  List<ServiceModel> get services => _services;

  void refresh() {
    notifyListeners();
  }
}
