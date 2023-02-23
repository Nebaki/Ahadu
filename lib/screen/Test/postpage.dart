import 'package:ahadu/screen/Test/test.dart';
import 'package:flutter/material.dart';

class PostsPage extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinite Posts'),
      ),
      body: Posts(),
    );
  }
}