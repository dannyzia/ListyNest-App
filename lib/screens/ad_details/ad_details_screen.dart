import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listynest/models/ad.dart';
import 'package:listynest/models/bid.dart';
import 'package:listynest/services/ad_service.dart';
import 'package:listynest/services/bidding_service.dart';
import 'package:listynest/services/chat_service.dart';

class AdDetailsScreen extends StatefulWidget {
  final String adId;

  AdDetailsScreen({required this.adId});

  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  final AdService _adService = AdService();
  final BiddingService _biddingService = BiddingService();
  final ChatService _chatService = ChatService();
  final _bidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ad Details'),
      ),
      body: FutureBuilder<Ad?>(
        future: _adService.getAdById(widget.adId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final ad = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                if (ad.imageUrls.isNotEmpty)
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      itemCount: ad.imageUrls.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          ad.imageUrls[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ad.title,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '\$${ad.price}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 16),
                      Text(ad.description),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          final conversationId = await _chatService.createConversation(ad.userId);
                          context.go('/chat/$conversationId');
                        },
                        child: Text('Contact Seller'),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Bids',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      StreamBuilder<List<Bid>>(
                        stream: _biddingService.getBids(widget.adId),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          final bids = snapshot.data!;

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: bids.length,
                            itemBuilder: (context, index) {
                              final bid = bids[index];
                              return ListTile(
                                title: Text('\$${bid.amount}'),
                                subtitle: Text(bid.userId),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _bidController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Enter your bid',
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _biddingService.placeBid(
                                widget.adId,
                                double.parse(_bidController.text),
                              );
                              _bidController.clear();
                            },
                            child: Text('Place Bid'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
