import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestsProvider extends ChangeNotifier {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  List<Map<String, dynamic>> requests = [];

  bool isLoading = false;

  // ==============================
  // Fetch Requests
  // ==============================
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

  // ==============================
  // Total Requests
  // ==============================
  int get totalRequests {

    return requests.length;
  }

  // ==============================
  // Completed Requests
  // ==============================
  int get completedRequests {

    return requests
        .where(
          (request) =>
      request['status'] ==
          'completed',
    )
        .length;
  }

  // ==============================
  // Pending Requests
  // ==============================
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