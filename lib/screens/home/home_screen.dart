import 'package:flutter/material.dart';
import './widgets/scroll_down_hint.dart';
import './widgets/ad_browsing_section.dart';
import './widgets/todays_top_picks_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ListyNest')),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          ScrollDownHint(),
          SizedBox(height: 20),
          AdBrowsingSection(),
          SizedBox(height: 20),
          TodaysTopPicksSection(),
        ],
      ),
    );
  }
}
