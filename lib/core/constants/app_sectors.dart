import 'package:flutter/material.dart';

class Sector {
  final String name;
  final IconData icon;

  const Sector({required this.name, required this.icon});
}

const List<Sector> appSectors = [
  Sector(name: "Automobiles & Components", icon: Icons.directions_car),
  Sector(name: "Banks", icon: Icons.account_balance),
  Sector(name: "Capital Goods", icon: Icons.construction),
  Sector(
      name: "Commercial & Professional Services", icon: Icons.business_center),
  Sector(name: "Consumer Durables & Apparel", icon: Icons.checkroom),
  Sector(name: "Consumer Services", icon: Icons.room_service),
  Sector(name: "Diversified Financials", icon: Icons.pie_chart),
  Sector(name: "Energy", icon: Icons.bolt),
  Sector(name: "Food & Staples Retailing", icon: Icons.shopping_cart),
  Sector(name: "Food, Beverage & Tobacco", icon: Icons.bakery_dining),
  Sector(
      name: "Health Care Equipment & Services", icon: Icons.medical_services),
  Sector(name: "Household & Personal Products", icon: Icons.clean_hands),
  Sector(name: "Insurance", icon: Icons.shield),
  Sector(name: "Materials", icon: Icons.layers),
  Sector(name: "Real Estate Management & Development", icon: Icons.domain),
  Sector(name: "Retailing", icon: Icons.shopping_bag),
  Sector(name: "Software & Services", icon: Icons.code),
  Sector(name: "Telecommunication Services", icon: Icons.cell_tower),
  Sector(name: "Transportation", icon: Icons.local_shipping),
  Sector(name: "Utilities", icon: Icons.water_drop),
];

// Helper to get icon by sector name
IconData getSectorIcon(String? sectorName) {
  if (sectorName == null) return Icons.business; // Default icon

  try {
    return appSectors
        .firstWhere(
          (s) => s.name.toLowerCase() == sectorName.toLowerCase(),
          orElse: () => const Sector(name: "Default", icon: Icons.business),
        )
        .icon;
  } catch (e) {
    return Icons.business;
  }
}
