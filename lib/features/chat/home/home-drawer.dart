import 'package:chaty/features/auth/helpers/auth_helper.dart';
import 'package:chaty/utils/custom_widgets.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: DrawerHeader(child: Text("Halo")),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("AW"),
                Align(
                  alignment: Alignment.center,
                  child: MyButton(
                    onPressed: () {
                      AuthHelper.signOut(context);
                    },
                    backgroundColor: Theme.of(context).colorScheme.error,
                    child: Text("Log out"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
