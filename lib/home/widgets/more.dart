import 'package:firebase_app/company/view/add_company.dart';
import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("More"),
        ),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                title: Text("Company List"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddCompany()));
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
