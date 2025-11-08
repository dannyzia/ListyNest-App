
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/blog_model.dart';

class BlogDetailScreen extends StatelessWidget {
  final Blog blog;

  const BlogDetailScreen({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share('Check out this article: ${blog.slug}');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (blog.image != null)
              CachedNetworkImage(
                imageUrl: blog.image!.url,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey[300],
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
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
                  Text(
                    'By ${blog.author?.name ?? 'Unknown'} on ${blog.publishDate}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: 16),
                  Html(
                    data: blog.content,
                  ),
                ],
              ),
            ),
            // Related blogs section (to be implemented)
          ],
        ),
      ),
    );
  }
}
