import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ad_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/ad.dart'; 
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import '../create_ad/create_ad_screen.dart';
import '../profile/favorites_screen.dart';
import '../my_ads/my_ads_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';

class AdCard extends StatelessWidget {
  final Ad ad;

  const AdCard({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(ad.title),
          Text(ad.price.toString()),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdProvider>().fetchAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adProvider = context.watch<AdProvider>();
    final authProvider = context.watch<AuthProvider>();
    final navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ListyNest'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen())),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(authProvider.user?.displayName ?? 'Guest'),
              accountEmail: Text(authProvider.user?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundImage: authProvider.user?.photoURL != null
                    ? NetworkImage(authProvider.user!.photoURL!)
                    : null,
                child: authProvider.user?.photoURL == null
                    ? const Icon(Icons.person)
                    : null,
              ),
            ),
            if (authProvider.isLoggedIn) ...[
              ListTile(
                leading: const Icon(Icons.add_circle),
                title: const Text('Post Ad'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateAdScreen())),
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('My Ads'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MyAdsScreen())),
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Favorites'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen())),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  await authProvider.logout();
                  navigator.pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
              ),
            ] else ...[
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Login'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
              ),
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Register'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
              ),
            ],
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => adProvider.fetchAds(),
        child: adProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : adProvider.errorMessage != null
                ? Center(child: Text('Error: ${adProvider.errorMessage}'))
                : adProvider.ads.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.inbox, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            const Text('No ads yet', style: TextStyle(fontSize: 18)),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateAdScreen())),
                              child: const Text('Post First Ad'),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: adProvider.ads.length,
                        itemBuilder: (context, index) {
                          return AdCard(ad: adProvider.ads[index]);
                        },
                      ),
      ),
      floatingActionButton: authProvider.isLoggedIn
          ? FloatingActionButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateAdScreen())),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
