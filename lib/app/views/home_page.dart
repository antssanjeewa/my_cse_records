import 'package:firebase_app/app/provider/screenIndexProvider.dart';
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

    final pages = [const HomeScreen(), const RecordScreen(), const MoreScreen()];

    return Scaffold(
      // appBar: AppBar(title: const Text("Home")),
      body: SafeArea(child: pages[currentScreenIndex]),
      backgroundColor: Colors.grey.shade200,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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
        onTap: ((value) => screenIndexProvider.updateScreenIndex(value)),
      ),
    );
  }
}
