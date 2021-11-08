import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:social_platform_project/new_post.dart';
import 'package:social_platform_project/post_details.dart';
import 'package:social_platform_project/settings_about_page.dart';
import 'dart:io';

import 'package:web_socket_channel/io.dart';

class PostingPage extends StatelessWidget {
  PostingPage({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.teal.shade50,
      ),
      home: MyHomePage(name: name),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
  List post = [];
  bool toggleLike = false;
  final _scrollController = ScrollController();

  void getPost() {
    channel.stream.listen((posting) {
      final decodedMessage = jsonDecode(posting);

      setState(() {
        post = decodedMessage['data']['posts'];
        post.sort((b, a) {
          var aDate = a['date'];
          var bDate = b['date'];
          return aDate.compareTo(bDate);
        });
      });
    });

    channel.sink.add('{"type": "get_posts"}');
  }

  void deletePost(id) {
    channel.sink
        .add('{"type": "sign_in", "data": { "name": "${widget.name}"}}');
    channel.sink.add('{"type": "delete_post", "data": {"postId": "$id"}}');
  }

  @override
  void initState() {
    super.initState();
    getPost();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void scrollDown() {
    final double end = _scrollController.position.maxScrollExtent;

    _scrollController.animateTo(end,
        duration: Duration(seconds: 5), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Posting Page'),
      ),
      body: ListView(
        controller: _scrollController,
        children: [
          Container(
            height: 50,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Icon(Icons.person_outline_rounded, size: 30),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Text(
                          'Username: ${widget.name}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.refresh_outlined),
                        iconSize: 30,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyHomePage(name: widget.name)));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: GestureDetector(
                          onTap: scrollDown,
                          child: Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Text(
                                  'Oldest',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                                Icon(
                                  Icons.arrow_downward_outlined,
                                  size: 30,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.favorite_outline_rounded,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
          Container(
            child: post.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: post.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 150,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostDetails(
                                        title: post[index]['title'],
                                        description: post[index]['description'],
                                        url: post[index]['image'],
                                        author: post[index]['author'],
                                        date: post[index]['date'])),
                              );
                            },
                            child: Card(
                                margin: EdgeInsets.only(bottom: 10),
                                elevation: 0,
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: Card(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Image(
                                          image: NetworkImage(Uri.parse(
                                                          post[index]['image'])
                                                      .isAbsolute &&
                                                  post[index]
                                                      .containsKey('image')
                                              ? '${post[index]['image']}'
                                              : 'https://www.prestashop.com/sites/default/files/styles/blog_750x320/public/blog/2019/10/banner_error_404.jpg?itok=eAS4swln'),
                                          fit: BoxFit.cover,
                                          height: 130,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 10,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, left: 10, right: 15),
                                            child: Text(
                                              '${post[index]["title"]}',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 15),
                                            child: Text(
                                              '${post[index]["description"]}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Row(children: [
                                                    const Icon(
                                                      Icons
                                                          .person_outline_rounded,
                                                      size: 18,
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Text(
                                                          'Author: ${post[index]["author"]}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                Container(
                                                  width: 200,
                                                  padding: EdgeInsets.only(
                                                      left: 10, bottom: 5),
                                                  child: Row(children: [
                                                    const Icon(
                                                      Icons.date_range_outlined,
                                                      size: 18,
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Text(
                                                          'Date: ${post[index]["date"].toString().characters.take(10)}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ))
                                                  ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    toggleLike = !toggleLike;
                                                  });
                                                },
                                                icon: toggleLike
                                                    ? Icon(
                                                        Icons
                                                            .favorite_outline_rounded,
                                                        size: 30,
                                                      )
                                                    : Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                        size: 30,
                                                      )),
                                            IconButton(
                                                icon: Icon(Icons
                                                    .delete_forever_outlined),
                                                iconSize: 30,
                                                onPressed: widget.name ==
                                                        post[index]['author']
                                                    ? () {
                                                        deletePost(
                                                            post[index]['_id']);
                                                        Navigator.push(
                                                            this.context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    PostingPage(
                                                                        name: widget
                                                                            .name)));
                                                      }
                                                    : null)
                                          ],
                                        ))
                                  ],
                                )),
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBarWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewPostPage(name: widget.name)));
        },
        tooltip: 'Create a new post',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void scrollUp() {
    final double start = 0;

    _scrollController.animateTo(start,
        duration: Duration(seconds: 2), curve: Curves.easeIn);
  }

  Widget BottomAppBarWidget() {
    const placeholder = Opacity(
      opacity: 0,
      child: IconButton(
        icon: Icon(Icons.ac_unit),
        onPressed: null,
      ),
    );

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(
              Icons.home_outlined,
              size: 32,
            ),
            onPressed: scrollUp,
          ),
          placeholder,
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              size: 32,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsAboutPage()));
            },
          )
        ],
      ),
    );
  }
}
