import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';

class SocialCubit extends Cubit<String> {
  SocialCubit() : super('');
  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');

  void openConnection() {
    channel.stream.listen((messages) {
      final decodeMessage = jsonDecode(messages);

      channel.sink.close();
    });
  }

  void login(username) {
    channel.sink.add('{"type": "sign_in", "data": { "name": "$username"}}');
    emit(username);
  }
}
