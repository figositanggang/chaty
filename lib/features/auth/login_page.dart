import 'package:chaty/features/auth/auth_helper.dart';
import 'package:chaty/features/auth/daftar_page.dart';
import 'package:chaty/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                        if (formKey.currentState!.validate()) {
                          AuthHelper.loginWithEmail(
                            context,
                            email: email.text.trim(),
                            password: password.text.trim(),
                          );
                        }
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
                      onPressed: () {
                        Navigator.push(context, MyRoute(DaftarPage()));
                      },
                      child: Text("Daftar"),
                    ),
                  ),
                  // SizedBox(height: 30),

                  // Text("Atau login dengan"),

                  // SizedBox(height: 20),

                  // @ Login with...
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: MyButton(
                  //     onPressed: () {
                  //       AuthHelper.loginWithGoogle(context);
                  //     },
                  //     child: Text("Google"),
                  //     backgroundColor: Color.fromARGB(255, 246, 103, 74),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
