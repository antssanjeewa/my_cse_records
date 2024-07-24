import 'package:firebase_app/app/budget/widgets/item_list.dart';
import 'package:firebase_app/app/budget/widgets/summary_card.dart';
import 'package:flutter/material.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: const [
              HeroCard(),
              ItemList(),
            ],
          ),
        ),
      ),
    );
  }
}

class HeroCard extends StatelessWidget {
  const HeroCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Total balance",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Rs 4,000.00",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 30,
              bottom: 10,
              left: 10,
              right: 10,
            ),
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
            child: Row(
              children: const [
                SummaryCard(
                  color: Colors.green,
                  title: "Credit",
                ),
                SizedBox(width: 10),
                SummaryCard(
                  color: Colors.red,
                  title: "Debit",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
