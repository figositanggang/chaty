import 'package:chaty/features/user/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserPage extends StatefulWidget {
  final UserModel userModel;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const UserPage({
    super.key,
    required this.userModel,
    required this.scaffoldKey,
  });

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late UserModel userModel;

  final format = DateFormat("EEEE, d/M/y");

  @override
  void initState() {
    super.initState();

    userModel = widget.userModel;

    closeDrawer();
  }

  void closeDrawer() async {
    try {
      widget.scaffoldKey.currentState!.closeDrawer();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final createdAt = format.format(userModel.createdAt.toDate());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // @ Close Button
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.all(20),
                child: IconButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.all(10),
                  icon: Icon(Icons.close),
                ),
              ),
            ),

            // @ User Avatar
            Stack(
              children: [
                InkWell(
                  onTap: () {},
                  child: Ink(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.userModel.photoUrl),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.edit),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(.9),
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // @ User Name
            Text(
              userModel.fullName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            // @ username
            Text(userModel.username),

            SizedBox(height: 40),
            // @ User Data
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: MediaQuery.sizeOf(context).width,
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark.withOpacity(.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // @ User Email
                  ListTile(
                    title: Text("Email"),
                    subtitle: Text(userModel.email),
                  ),

                  // @ User Created At
                  ListTile(
                    title: Text("Bergabung pada"),
                    subtitle: Text(createdAt),
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
