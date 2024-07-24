import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/app/records/models/record.dart';
import 'package:firebase_app/app/records/screens/add_record.dart';
import 'package:firebase_app/app/records/services/record_service.dart';
import 'package:firebase_app/app/records/widgets/record_list_item.dart';
import 'package:flutter/material.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RecordService service = RecordService();

    return Container(
      child: Column(
        children: [
          SizedBox(height: 20),
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
                      return RecordItem(
                        record: record,
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                  );
                }
                return Text("End");
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddRecord()));
            },
            child: Text('Add New'),
          ),
        ],
      ),
    );
  }
}
