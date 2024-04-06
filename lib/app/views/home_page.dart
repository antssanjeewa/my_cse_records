import 'package:firebase_app/app/provider/screenIndexProvider.dart';
import 'package:firebase_app/app/views/add_record_form.dart';
import 'package:firebase_app/budget/screens/main_screen.dart';
import 'package:firebase_app/home/screens/home.dart';
import 'package:firebase_app/more/screens/more.dart';
import 'package:firebase_app/records/screens/record_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenIndexProvider = Provider.of<ScreenIndexProvider>(context);

    int currentScreenIndex = screenIndexProvider.currentScreenIndex;

    final pages = [
      const HomeScreen(),
      const BudgetScreen(),
      const RecordScreen(),
      const MoreScreen(),
    ];

    return Scaffold(
      // appBar: AppBar(title: const Text("Home")),
      // resizeToAvoidBottomInset: true,
      body: SafeArea(child: pages[currentScreenIndex]),
      // backgroundColor: Colors.grey.shade200,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_vert),
            label: 'More',
          ),
        ],
        currentIndex: currentScreenIndex,
        // type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: ((value) => screenIndexProvider.updateScreenIndex(value)),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showBottomSheetForm(context),
      ),
    );
  }
}
