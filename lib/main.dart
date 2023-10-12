import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: _Login(),
    );
  }
}

class _Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<_Login> {
  bool validatePasswordPattern(String? value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (value is String) {
      return regExp.hasMatch(value);
    }
    return false;
  }
  // var _usernameController = TextEditingController();
  // String _usernameError = "Wrong username";
  // String _passwordError = "Wrong password";

  // validate(){
  //       if(!validateStructure(_usernameController.text)){
  //           setState(() {
  //               _usernameError = _usernameError;
  //               _passwordError = passwordError;
  //           });
  //           // show dialog/snackbar to get user attention.
  //           return;
  //       }
  //       // Continue
  //   }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text("Login Screen"),
            ),
            body: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: Container(
                    height: 300,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                          height: 150,
                          width: 150,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/logo-mini.png"),
                                  fit: BoxFit.fill))),
                    ),
                  ))),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                      color: Colors.indigoAccent,
                      child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            hintText: 'Enter username',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          }))),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                      color: Colors.deepPurpleAccent,
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Password', hintText: 'Enter password'),
                        validator: (value) {
                          // if (value == null || value.isEmpty) {
                          //   return 'Please enter some text';
                          // }
                          // return null;

                          if (!validatePasswordPattern(value)) {
                            return 'Please enter strong password';
                          }
                          return null;
                        },
                      ))),
              Container(
                  height: 90,
                  width: 250,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
                            }
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.amber),
                          ))))
            ])));
  }
}
