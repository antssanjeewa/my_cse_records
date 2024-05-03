import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/company/models/company.dart';
import 'package:firebase_app/company/services/companyService.dart';
import 'package:firebase_app/home/widgets/company_list_item.dart';
import 'package:firebase_app/home/widgets/summary_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CompanyService service = CompanyService();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SummaryCard(),

          //
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: service.getAllBooks(),
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
                      return CompanyListItem(company: company);
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  );
                }
                return const Text("End");
              },
            ),
          ),
        ],
      ),
    );
  }
}
