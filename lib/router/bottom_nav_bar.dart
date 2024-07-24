import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages.dart';

class BottomNavigationPage extends StatefulWidget {
  final Widget child;
  const BottomNavigationPage({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int getCurrentIndex() {
    final location = GoRouter.of(context).location;
    // print(location);
    if (location.startsWith(Pages.home.toPath())) {
      return 0;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    void changeTab(int index) {
      switch (index) {
        case 0:
          Pages.home.go(context);
          break;
        case 1:
          // Pages.productDetails.go(context);
          context.go('/chat');
          break;
        default:
          // Pages.home.go(context);
          break;
      }
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        type: BottomNavigationBarType.fixed,
        elevation: 1,
        onTap: changeTab,
        currentIndex: getCurrentIndex(),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'Locations'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: 'Records'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
