import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:social_platform_project/posting_page.dart';
import 'package:web_socket_channel/io.dart';

final channel = IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
List post = [];

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
  List post = [];

  final _formKey = GlobalKey<FormState>();

  String title = '';
  String description = '';
  String url = '';
  String Username = '';

  void newPost(title, description, url) {
    channel.stream.listen((posts) {
      final decodedMessage = jsonDecode(posts);
    });
    channel.sink
        .add('{"type": "sign_in", "data": { "name": "${widget.name}"}}');
    channel.sink.add(
        '{"type": "create_post", "data": {"title": "$title", "description": "$description", "image": "$url"}}');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Create A New Post'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid url for an image';
                  }
                  return null;
                },
                onChanged: (String? value) {
                  setState(() {
                    url = value!;
                  });
                },
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(),
                    labelText: 'Image URL',
                    hintText: 'Any cool image URL to share?'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title for your post';
                  }
                  return null;
                },
                onChanged: (String? value) {
                  setState(() {
                    title = value!;
                  });
                },
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    border: OutlineInputBorder(),
                    labelText: 'Post Title',
                    hintText: 'What should we call your post?'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description for your post';
                  }
                  return null;
                },
                onChanged: (String? value) {
                  setState(() {
                    description = value!;
                  });
                },
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    border: OutlineInputBorder(),
                    labelText: 'Post Description',
                    hintText: 'Share your thoughts about this post!'),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, right: 30, left: 35),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                        child: const Text('Share your post!'),
                        onPressed: _formKey.currentState?.validate() ?? false
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: const Text(
                                        'Your post have been uploaded!'),
                                    action: SnackBarAction(
                                      label: 'OK',
                                      onPressed: () {},
                                    ),
                                  ));
                                  newPost(title, description, url);
                                  Navigator.pop(context);
                                }
                              }
                            : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20)))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel')),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
