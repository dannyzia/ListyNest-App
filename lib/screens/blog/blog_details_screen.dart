import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../models/blog_model.dart';
import '../services/blog_service.dart';

class BlogDetailsScreen extends StatelessWidget {
  final String slug;

  const BlogDetailsScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final blogService = Provider.of<BlogService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<Blog>(
        future: blogService.getBlog(slug),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Blog not found'));
          }

          final blog = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(blog.coverImage),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        blog.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(blog.author.avatar),
                            radius: 15,
                          ),
                          SizedBox(width: 8),
                          Text(blog.author.name),
                          Spacer(),
                          Text(blog.publishedAt.toLocal().toString().split(' ')[0]),
                        ],
                      ),
                      Divider(height: 32),
                      MarkdownBody(
                        data: blog.content,
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
