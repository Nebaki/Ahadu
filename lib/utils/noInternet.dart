import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: EmptyFailureNoInternetView(
                  image: 'assets/lotties/no_internet_lottie.json',
                  title: 'Network Error',
                  description: 'Internet not found !!',
                ),
              ),
      )
    );
  }
}




class EmptyFailureNoInternetView extends StatelessWidget {
  EmptyFailureNoInternetView(
      { required this.image,
      required this.title,
      required this.description,});

   final String title, description, image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset(
                image,
                height: 250,
                width: 250,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                title,
               style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                description,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
