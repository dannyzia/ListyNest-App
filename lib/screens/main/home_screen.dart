import 'package:flutter/material.dart';
import 'package:listynest/widgets/blog_hero_section.dart';
import 'package:listynest/widgets/ad_card.dart';
import 'package:listynest/widgets/category_chips.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListyNest'),
      ),
      body: Column(
        children: [
          BlogHeroSection(),
          CategoryChips(),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return AdCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}
