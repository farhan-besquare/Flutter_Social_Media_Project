import 'package:flutter/material.dart';

class SettingsAboutPage extends StatelessWidget {
  SettingsAboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('About Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 70, right: 70, top: 20, bottom: 10),
            child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Image.asset('assets/images/besquare_logo.png')),
          ),
          Divider(
            color: Colors.black,
            thickness: 1,
            indent: 15,
            endIndent: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Text(
              'Hi! My name is Farhan and I wrote the code for this App! This is my first mobile app and I would like to sincerely thank you for using this app! This app is part of Besquare Mobile Module individual project, a programme which I am really proud to be a part of, and act as an assessment for Besquare graduates to assess their skills and knowledge for the mobile module. I had a ton of fun writing this code and I hope you will have the same experience when using this app! Forgive me for the errors since I am still a beginner and have a lot to learn.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
