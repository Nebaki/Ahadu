import 'package:ahadu/screen/Test/postpage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinite Posts'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Show Posts'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostsPage()),
            );
          },
        ),
      ),
    );
  }
}
