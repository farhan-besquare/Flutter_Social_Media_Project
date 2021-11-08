import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:web_socket_channel/io.dart';

final channel = IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
List post = [];

class PostDetails extends StatelessWidget {
  PostDetails(
      {Key? key,
      required this.title,
      required this.description,
      required this.url,
      required this.author,
      required this.date})
      : super(key: key);

  final String title;
  final String description;
  final String url;
  final String author;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: ListView(children: [
        Card(
          margin: EdgeInsets.only(bottom: 10, top: 20),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: Image(
            image: NetworkImage(Uri.parse(url).isAbsolute
                ? url
                : 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const Divider(
          color: Colors.black,
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
          child: Text(
            description,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Divider(
          color: Colors.black,
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        Padding(
          padding: EdgeInsets.only(left: 15, bottom: 10),
          child: Row(children: [
            Icon(Icons.person_outline_rounded),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  'Author: $author',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ]),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15, bottom: 10),
          child: Row(
            children: [
              Icon(Icons.date_range_outlined),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  'Date of creation: ${date.toString().characters.take(10)}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
