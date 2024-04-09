import 'package:firebase_app/records/screens/add_record_dialog.dart';
import 'package:flutter/material.dart';

showBottomSheetForm(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: const AddRecordDialog(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      );
    },
  );

  // showModalBottomSheet(
  //   context: context,
  //   isScrollControlled: true,
  //   builder: (context) {
  //     return const AddRecord();
  //   },
  // );
}
