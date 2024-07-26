// lib/models/company_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  String id;
  String name;
  String symbol;
  String color;
  double totalBuyShares;
  double totalSellShares;
  double availableShares;
  double avgSharePrice;
  double currentShareValue;

  Company({
    required this.id,
    required this.name,
    required this.symbol,
    required this.color,
    this.totalBuyShares = 0,
    this.totalSellShares = 0,
    this.availableShares = 0,
    this.avgSharePrice = 0,
    this.currentShareValue = 0,
  });

  // From Firestore document to model
  factory Company.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Company(
      id: doc.id,
      name: data['name'] ?? '',
      symbol: data['symbol'] ?? '',
      color: data['color'] ?? '',
      totalBuyShares: data['totalBuyShares'] ?? 0,
      totalSellShares: data['totalSellShares'] ?? 0,
      availableShares: data['availableShares'] ?? 0,
      avgSharePrice: data['avgSharePrice'] ?? 0,
      currentShareValue: data['currentShareValue'] ?? 0,
    );
  }

  // To Firestore document
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'symbol': symbol,
      'color': color,
      'totalBuyShares': totalBuyShares,
      'totalSellShares': totalSellShares,
      'availableShares': availableShares,
      'avgSharePrice': avgSharePrice,
      'currentShareValue': currentShareValue,
    };
  }
}
