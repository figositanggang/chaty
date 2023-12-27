import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(),
      child: Column(
        children: [
          DrawerHeader(child: Text("Halo")),
        ],
      ),
    );
  }
}