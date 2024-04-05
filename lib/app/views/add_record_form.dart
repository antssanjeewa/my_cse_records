import 'package:firebase_app/records/screens/add_record.dart';
import 'package:flutter/material.dart';

void showBottomSheetForm(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return const AddRecord();
    },
  );
}
