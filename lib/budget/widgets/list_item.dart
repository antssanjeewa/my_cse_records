import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              color: Colors.grey.withOpacity(0.09),
              blurRadius: 10.0,
              spreadRadius: 4.0,
            ),
          ],
        ),
        child: ListTile(
          title: const Text(
            'Expense Name',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Balance",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              Text(
                "2021 12 04",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          trailing: Column(
            children: const [
              Text(
                "Rs 100",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Text(
                "Rs 1200",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
