import 'package:firebase_app/records/models/record.dart';
import 'package:flutter/material.dart';

class RecordItem extends StatelessWidget {
  final Record record;
  const RecordItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(record.companyId.toString()),
      subtitle: Text(record.date.toString()),
      tileColor: Theme.of(context).backgroundColor,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            (record.price ?? 0).toString(),
            style: const TextStyle(
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            record.amount.toString(),
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
      onTap: () => {},
    );
  }
}
