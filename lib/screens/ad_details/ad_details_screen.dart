import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:listynest/models/bid.dart';
import 'package:listynest/services/ad_service.dart';
import 'package:listynest/services/api_service.dart';
import 'package:listynest/services/bids_service.dart';
import 'package:listynest/services/favorite_service.dart';
import 'package:listynest/services/feedback_service.dart';

class AdDetailsScreen extends StatefulWidget {
  final String adId;

  const AdDetailsScreen({Key? key, required this.adId}) : super(key: key);

  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  final AdService _adService = AdService();
  final ApiService _apiService = ApiService();
  final _bidController = TextEditingController();
  bool _isLoading = false;
  final BidsService _bidsService = BidsService();
  final FavoriteService _favoriteService = FavoriteService();
  final FeedbackService _feedbackService = FeedbackService();
  final List<Bid> _bids = [];

  @override
  void initState() {
    super.initState();
    _bidsService.bids.listen((bid) {
      if (bid.adId == widget.adId) {
        setState(() {
          _bids.add(bid);
        });
      }
    });
  }

  void _placeBid() async {
    if (_bidController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _apiService.placeBid(widget.adId, double.parse(_bidController.text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bid placed successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place bid.'),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showFeedbackDialog() {
    final _feedbackController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Ad'),
        content: TextField(
          controller: _feedbackController,
          decoration: InputDecoration(hintText: 'Enter your feedback'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _feedbackService.submitFeedback(widget.adId, _feedbackController.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Feedback submitted successfully!')),
              );
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ad Details'),
        actions: [
          StreamBuilder<bool>(
            stream: _favoriteService.isFavorite(widget.adId),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                return IconButton(
                  icon: Icon(Icons.favorite),
                  onPressed: () => _favoriteService.removeFavorite(widget.adId),
                );
              }
              return IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () => _favoriteService.addFavorite(widget.adId),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.report),
            onPressed: _showFeedbackDialog,
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _adService.getAdById(widget.adId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final ad = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ad['imageUrls'] != null && ad['imageUrls'].isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: ad['imageUrls'].length,
                      itemBuilder: (context, index) {
                        return Image.network(ad['imageUrls'][index], fit: BoxFit.cover);
                      },
                    ),
                  ),
                SizedBox(height: 16),
                Text(ad['title'], style: Theme.of(context).textTheme.headline6),
                SizedBox(height: 8),
                Text('\$${ad['price']}', style: Theme.of(context).textTheme.subtitle1),
                SizedBox(height: 8),
                Text(ad['description']),
                SizedBox(height: 16),
                TextField(
                  controller: _bidController,
                  decoration: InputDecoration(
                    labelText: 'Enter your bid',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _placeBid,
                        child: Text('Place Bid'),
                      ),
                SizedBox(height: 16),
                Text('Bids', style: Theme.of(context).textTheme.headline6),
                Expanded(
                  child: ListView.builder(
                    itemCount: _bids.length,
                    itemBuilder: (context, index) {
                      final bid = _bids[index];
                      return ListTile(
                        title: Text('Bid: \$${bid.amount}'),
                        subtitle: Text('User: ${bid.userId}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _bidsService.dispose();
    super.dispose();
  }
}
