import 'package:chaty/features/auth/helpers/auth_helper.dart';
import 'package:chaty/features/user/models/user_model.dart';
import 'package:chaty/features/user/pages/user_page.dart';
import 'package:chaty/utils/custom_widgets.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  final UserModel userModel;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeDrawer({
    super.key,
    required this.userModel,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // @ Drawer Header
          SizedBox(
            width: double.infinity,
            child: DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(userModel.photoUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(.8), BlendMode.darken),
              )),
              child: Center(child: Text(userModel.fullName)),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MyRoute(UserPage(
                          isMine: true,
                          scaffoldKey: scaffoldKey,
                          userModel: userModel,
                        )));
                  },
                  leading: Icon(Icons.person),
                  title: Text("Profil"),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    child: MyButton(
                      onPressed: () {
                        AuthHelper.signOut(context);
                      },
                      isPrimary: false,
                      foregroundColor: Colors.red,
                      borderRadius: BorderRadius.zero,
                      backgroundColor: Theme.of(context).colorScheme.error,
                      child: Text(
                        "Log out",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
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
