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
    } else if (location.startsWith('/companies')) {
      return 1;
    } else if (location.startsWith('/records')) {
      return 2;
    } else {
      return 3;
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
          context.go('/companies');
          break;
        case 2:
          // Pages.productDetails.go(context);
          context.go('/records');
          break;
        default:
          context.go('/profile');
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
          BottomNavigationBarItem(icon: Icon(Icons.local_post_office_outlined), label: 'Company'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: 'Records'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
