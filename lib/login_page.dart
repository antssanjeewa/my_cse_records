import 'package:flutter/material.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home),
        title: const Text("Login Page"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Enter Your Name",
                      hintText: "User Name"),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Enter Your Password",
                      hintText: "Password"),
                ),
              ),
              Container(
                child: ElevatedButton(
                  onPressed: loginButtonClick,
                  child: const Text("Sign In"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loginButtonClick() {
    if (_emailController.text == 'admin' &&
        _passwordController.text == 'password') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      showAlertDialog(context);
    }
  }

  void showAlertDialog(BuildContext contex) {
    Widget okButton = ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("OK"));

    AlertDialog alertDialog = AlertDialog(
      title: const Text("Error"),
      content: const Text("Wrong UserName and Password"),
      actions: [okButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
