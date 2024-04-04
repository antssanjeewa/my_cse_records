import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/records/models/record.dart';
import 'package:firebase_app/records/screens/add_record.dart';
import 'package:firebase_app/records/services/record_service.dart';
import 'package:flutter/material.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RecordService service = RecordService();

    return Container(
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddRecord()));
            },
            child: Text('Add New'),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: service.getRecords(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
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
        ],
      ),
    );
  }
}
