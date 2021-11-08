import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_platform_project/cubit/cubit.dart';
import 'package:social_platform_project/posting_page.dart';
import 'dart:io';

import 'package:web_socket_channel/io.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: BlocProvider(
        create: (context) => SocialCubit(),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
  String username = '';

  // void login(Username) {
  //   channel.stream.listen((posting) {
  //     final decodedMessage = jsonDecode(posting);
  //   });
  //   channel.sink.add('{"type": "sign_in", "data": { "name": "$Username"}}');
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('PixPost'),
      ),
      body: BlocBuilder<SocialCubit, String>(
          bloc: context.read<SocialCubit>(),
          builder: (context, state) {
            return ListView(children: [
              Image.asset('assets/images/camera-resize.png'),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                    onChanged: (String? value) {
                      setState(() {
                        username = value!;
                      });
                    },
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_rounded),
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                        hintText: 'Enter a username'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    child: const Text('Enter the app'),
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(240, 50),
                        primary: Colors.teal.shade300),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PostingPage(name: username)));
                        context.read<SocialCubit>().openConnection();
                        context.read<SocialCubit>().login(username);
                      }
                    },
                  ),
                ),
              )
            ]);
          }),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// class PostingPage extends StatelessWidget {
//   PostingPage({Key? key}) : super(key: key);

  
//   List posts = [];

//   void getPosts() {
//     channel.stream.listen((posting) {
//       final decodedMessage = jsonDecode(posting);
//       final posts = decodedMessage['data']['posts'];

//       print(posts);
//       channel.sink.close();
//     });
//     channel.sink.add('{"type": "get_posts"}');
//   }

//   void main(List<String> args) {
//     getPosts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Posting Feed"),
//         automaticallyImplyLeading: false,
//       ),
//       body: ListView(
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('Go back!'),
//           ),
//         ],
//       ),
//     );
//   }
// }
