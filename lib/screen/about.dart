import 'package:ahadu/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'About',
          style: TextStyle(fontFamily: 'AbrilFatface'),
        ),
        centerTitle: true,
        backgroundColor: PrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 200,
                child: Image.asset(
                  "assets/images/logo.jpg",
                  fit: BoxFit.cover,
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Text(
                  "As the best job application, with over 1500+ unique visitors every day, Ahadu-vacancy has become the catalyst for putting candidates to work",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins',
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "You can contact us any way that is convenient for you. We are available 24/7 via fax, email or telephone.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: InkWell(
                      onTap: () {
                        launchUrl(Uri(
                          scheme: 'tel',
                          path: '+251979322838',
                        ));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.phone),
                          SizedBox(
                            width: 10,
                          ),
                          Text(": +251979322838",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins',
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      var url = 'https://ahaduvacancy.com';
                      final uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.mail),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                            "office@ahaduvacancy.com \nsupport@ahaduvacancy.com \ninfo@ahaduvacancy.com",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Poppins',
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.bottomCenter,
              child: Text(
                'Privacy and legal',
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        ),
      ),
    );
  }
}
