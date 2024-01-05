import 'package:chaty/features/user/controllers/avatar_controller.dart';
import 'package:chaty/features/user/controllers/user_controller.dart';
import 'package:chaty/features/user/helpers/user_helper.dart';
import 'package:chaty/utils/constants.dart';
import 'package:chaty/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeAvatarPage extends StatefulWidget {
  const ChangeAvatarPage({super.key});

  @override
  State<ChangeAvatarPage> createState() => _ChangeAvatarPageState();
}

class _ChangeAvatarPageState extends State<ChangeAvatarPage> {
  final avatarController = Get.put(AvatarController());
  final userController = Get.put(UserController());

  @override
  void dispose() {
    avatarController.setIndex(0);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubah avatar"),
        actions: [
          MyButton(
            onPressed: () {
              UserHelper.changeUserAvatar(
                context,
                photoUrl: avatarUrls[avatarController.index],
                userController: userController,
              );
            },
            child: Text(
              "Ganti",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            isPrimary: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Theme.of(context).primaryColor,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemCount: avatarUrls.length,
        itemBuilder: (context, index) {
          return Obx(
            () => Ink(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                image: DecorationImage(
                  image: NetworkImage(avatarUrls[index]),
                  colorFilter: avatarController.index == index
                      ? null
                      : ColorFilter.mode(
                          Colors.black.withOpacity(.65),
                          BlendMode.darken,
                        ),
                ),
              ),
              child: InkWell(
                onTap: () {
                  avatarController.setIndex(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
