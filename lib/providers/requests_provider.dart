import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestsProvider extends ChangeNotifier {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  List<Map<String, dynamic>> requests = [];

  bool isLoading = false;


  Future<void> fetchRequests() async {

    try {

      isLoading = true;

      notifyListeners();

      final snapshot =
      await _firestore
          .collection('requests')
          .get();

      requests =
          snapshot.docs
              .map((doc) => doc.data())
              .toList();

    } catch (e) {

      debugPrint(
        'Error Fetch Requests: $e',
      );

    } finally {

      isLoading = false;

      notifyListeners();
    }
  }

  int get totalRequests {

    return requests.length;
  }


  int get completedRequests {

    return requests
        .where(
          (request) =>
      request['status'] ==
          'completed',
    )
        .length;
  }


  int get pendingRequests {

    return requests
        .where(
          (request) =>
      request['status'] ==
          'pending',
    )
        .length;
  }
}