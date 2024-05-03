import 'package:firebase_app/company/models/company.dart';
import 'package:firebase_app/home/screens/company_view.dart';
import 'package:flutter/material.dart';

class CompanyListItem extends StatelessWidget {
  final Company company;
  const CompanyListItem({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),

      //
      title: Text(
        company.companyCode.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      subtitle: Text(company.companyName.toString()),

      //
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            company.quantity.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            'Rs  ${company.averagePrice.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),

      //
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CompanyProfile(company: company),
            ))
      },
    );
  }
}
