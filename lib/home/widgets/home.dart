import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/company/models/company.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  getAllBooks() {
    return FirebaseFirestore.instance.collection('company').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> items = ["A", "B", "C"];

    return StreamBuilder<QuerySnapshot>(
      stream: getAllBooks(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          final List<DocumentSnapshot> companies = snapshot.data!.docs;
          return ListView.separated(
            itemCount: companies.length,
            itemBuilder: (context, index) {
              final company = Company.fromSnapshot(companies[index]);
              return ListTile(
                title: Text(company.companyName.toString()),
                subtitle: Text(company.companyCode.toString()),
                trailing: Text('Date'),
                onTap: () => {},
              );
            },
            separatorBuilder: (context, index) => Divider(),
          );
        }
        return Text("End");
      },
    );

    // Container(
    //   child: Column(
    //     children: [
    //       const Padding(
    //         padding: EdgeInsets.all(8.0),
    //         child: Text(
    //           "CSE Summary",
    //           style: TextStyle(
    //             fontSize: 25,
    //           ),
    //         ),
    //       ),
    //       Expanded(
    //         child:
    //       ),
    //     ],
    //   ),
    // );
  }
}
