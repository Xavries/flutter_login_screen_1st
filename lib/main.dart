import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

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
  late Future<Album> futureAlbum;

  bool validatePasswordPattern(String? value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (value is String) {
      return regExp.hasMatch(value);
    }
    return false;
  }

  // NOTE this will fetch album on app launch
  // @override
  // void initState() {
  //   super.initState();
  //   futureAlbum = fetchAlbum();
  // }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Colors.purple.shade900,
                  Colors.orange.shade400,
                ])),
            child: Scaffold(
                backgroundColor: Colors.transparent,
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
                          // color: Colors.orangeAccent,
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.orange.shade400,
                                Colors.purple.shade900
                              ]),
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
                                      image: AssetImage(
                                          "assets/images/logo-mini.png"),
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
                                labelText: 'Password',
                                hintText: 'Enter password'),
                            validator: (value) {
                              if (!validatePasswordPattern(value)) {
                                return 'Please enter strong password';
                              }
                              return null;
                            },
                          ))),
                  Container(
                      color: Colors.green,
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
                                } else {}
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(color: Colors.black),
                              )))),
                  Container(
                      height: 90,
                      width: 250,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ElevatedButton(
                              onPressed: () async {
                                print(fetchAlbum());
                                var jwt = await attemptLogIn('admin', 'admin');
                                print('jwt: ${jwt}');
                              },
                              //child: FutureBuilder<Album>(
                              //     future: futureAlbum,
                              //     builder: (context, snapshot) {
                              //       if (snapshot.hasData) {
                              //         print(snapshot.data!.title);
                              //         return Text(snapshot.data!.title);
                              //       } else if (snapshot.hasError) {
                              //         print('${snapshot.error}');
                              //         return Text('${snapshot.error}');
                              //       }

                              //       // By default, show a loading spinner.
                              //       print('spinnnnning');
                              //       return const CircularProgressIndicator();
                              //     },
                              //   );
                              child: const Text(
                                "Get Album",
                                style: TextStyle(color: Colors.black),
                              ))))
                ]))));
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

Future<Album> fetchAlbum() async {
  print('sending request');
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    headers: {
      HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
    },
  );
  print('request sent');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<String> attemptLogIn(String username, String password) async {
  var res = await http.post(
      Uri.parse("https://api.flutter.simple2b.net/api/auth/token"),
      body: jsonEncode({"username": username, "password": password}),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      });
  // if (res.statusCode == 200)
  return res.body;
  // return 'Failed to login';
}
