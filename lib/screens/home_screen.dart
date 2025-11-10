import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:listynest/providers/ad_provider.dart';
import 'package:listynest/providers/category_provider.dart';
import 'package:listynest/screens/search/search_screen.dart';
import 'package:listynest/widgets/ad_card.dart';
import 'package:listynest/widgets/category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch ads and categories when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdProvider>(context, listen: false).fetchAds();
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListyNest'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Categories',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Consumer<CategoryProvider>(
              builder: (context, categoryProvider, child) {
                if (categoryProvider.state == CategoryState.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (categoryProvider.state == CategoryState.error) {
                  return Center(child: Text('Error: ${categoryProvider.errorMessage}'));
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: categoryProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryProvider.categories[index];
                    return CategoryCard(category: category);
                  },
                );
              },
            ),

            // Featured Ads Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Featured Ads',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Consumer<AdProvider>(
              builder: (context, adProvider, child) {
                if (adProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (adProvider.errorMessage != null) {
                  return Center(child: Text('Error: ${adProvider.errorMessage}'));
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: adProvider.ads.length,
                  itemBuilder: (context, index) {
                    final ad = adProvider.ads[index];
                    return AdCard(ad: ad);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
