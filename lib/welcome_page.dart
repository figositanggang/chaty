import 'package:chaty/features/auth/pages/auth_state_page.dart';
import 'package:chaty/utils/custom_widgets.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  "Chaty",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
              width: MediaQuery.sizeOf(context).width / 1.5,
              child: MyButton(
                onPressed: () {
                  Navigator.push(context, MyRoute(AuthStatePage()));
                },
                child: Text("Mulai"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
