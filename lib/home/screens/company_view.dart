import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/company/models/company.dart';
import 'package:firebase_app/records/models/record.dart';
import 'package:firebase_app/records/services/record_service.dart';
import 'package:firebase_app/records/widgets/record_list_item.dart';
import 'package:flutter/material.dart';

class CompanyProfile extends StatelessWidget {
  final Company company;

  const CompanyProfile({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    RecordService service = RecordService();

    return Scaffold(
      appBar: AppBar(
        title: Text(company.companyName.toString()),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: StreamBuilder<QuerySnapshot>(
          stream: service.getCompanyRecords(company.companyCode.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              final List<DocumentSnapshot> records = snapshot.data!.docs;
              return ListView.separated(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = Record.fromSnapshot(records[index]);
                  return RecordItem(
                    record: record,
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              );
            }
            return const Text("End");
          },
        ),
      ),
    );
  }
}
