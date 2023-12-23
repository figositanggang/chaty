import 'package:chaty/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DaftarPage extends StatefulWidget {
  const DaftarPage({super.key});

  @override
  State<DaftarPage> createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  late TextEditingController email;
  late TextEditingController password;
  late GlobalKey<FormState> formKey;

  bool obscureText = true;

  @override
  void initState() {
    super.initState();

    email = TextEditingController();
    password = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.sizeOf(context).width - 100,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  MyText("Login", fontSize: 30),
                  SizedBox(height: 40),

                  // @ Email Field
                  MyTextField(
                    controller: email,
                    hintText: "Email",
                    autofillHints: [AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r"/^\S*$/"))
                    ],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: 10),

                  // @ Password Field
                  MyTextField(
                    controller: password,
                    hintText: "Password",
                    autofillHints: [AutofillHints.password],
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: obscureText,
                    textInputAction: TextInputAction.go,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: Icon(obscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r"/^\S*$/"))
                    ],
                  ),
                  SizedBox(height: 10),

                  // @ Login Button
                  SizedBox(
                    width: double.infinity,
                    child: MyButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {}
                      },
                      child: Text("Login"),
                    ),
                  ),
                  SizedBox(height: 10),

                  // @ Daftar Button
                  SizedBox(
                    width: double.infinity,
                    child: MyButton(
                      isPrimary: false,
                      onPressed: () {},
                      child: Text("Daftar"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
