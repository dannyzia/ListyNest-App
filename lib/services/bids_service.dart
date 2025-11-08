import 'dart:convert';

import 'package:listynest/models/bid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class BidsService {
  final WebSocketChannel _channel;

  BidsService() : _channel = WebSocketChannel.connect(Uri.parse('wss://your-websocket-url.com'));

  Stream<Bid> get bids {
    return _channel.stream.map((data) => Bid.fromJson(jsonDecode(data)));
  }

  void dispose() {
    _channel.sink.close();
  }
}
