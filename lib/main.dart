import 'package:flutter/material.dart';
import 'package:teste_final/views/home_page.dart';

void main() {
  runApp(const MyApp());
}

//https://medium.com/@thekingoftech/como-fazer-um-crud-com-flutter-bloc-api-rest-483ecf9c276
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
