import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/record_model.dart';

class RecordProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Record> _records = [];

  List<Record> get records => _records;

  // Add methods to fetch, add, update, and delete Records
}
