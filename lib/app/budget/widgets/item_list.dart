import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/app/records/models/record.dart';
import 'package:firebase_app/app/records/services/record_service.dart';
import 'package:flutter/material.dart';

import 'list_item.dart';

class ItemList extends StatelessWidget {
  const ItemList({super.key});

  @override
  Widget build(BuildContext context) {
    RecordService service = RecordService();

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Recent Transactions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("View All"),
            ],
          ),
          SizedBox(height: 15),
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
                      return ListItem(record: record);
                    },
                    separatorBuilder: (context, index) => Divider(),
                  );
                }
                return Text("End");
              },
            ),
          ),
          // ListView.builder(
          //   shrinkWrap: true,
          //   physics: NeverScrollableScrollPhysics(),
          //   itemCount: 10,
          //   itemBuilder: (context, index) {
          //     return const ListItem();
          //   },
          // )
        ],
      ),
    );
  }
}
