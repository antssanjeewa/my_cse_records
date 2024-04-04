import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/company/models/company.dart';
import 'package:firebase_app/records/models/record.dart';
import 'package:firebase_app/records/services/record_service.dart';
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
        child: StreamBuilder<QuerySnapshot>(
          stream: service.getCompanyRecords(company.documentId.toString()),
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
                  return ListTile(
                    title: Text(record.date.toString()),
                    subtitle: Text(record.amount.toString()),
                    trailing: Text('Date'),
                    onTap: () => {},
                  );
                },
                separatorBuilder: (context, index) => Divider(),
              );
            }
            return Text("End");
          },
        ),
      ),
    );
  }
}
