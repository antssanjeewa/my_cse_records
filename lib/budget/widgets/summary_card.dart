import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final Color color;
  final String title;

  const SummaryCard({
    super.key,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Rs 500",
                      style: TextStyle(fontSize: 30, color: color, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
            Spacer(),
            Icon(
              Icons.arrow_downward,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
