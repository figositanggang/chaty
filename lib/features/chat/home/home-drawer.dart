import 'package:chaty/features/auth/helpers/auth_helper.dart';
import 'package:chaty/features/user/controllers/user_controller.dart';
import 'package:chaty/features/user/pages/user_page.dart';
import 'package:chaty/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HomeDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  HomeDrawer({
    super.key,
    required this.scaffoldKey,
  });

  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // @ Drawer Header
            SizedBox(
              width: double.infinity,
              child: DrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(userController.currentUser.photoUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(.8), BlendMode.darken),
                )),
                child: Center(child: Text(userController.currentUser.fullName)),
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
                            userModel: userController.currentUser,
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
      ),
    );
  }
}
