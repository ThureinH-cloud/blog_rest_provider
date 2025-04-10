import 'package:blog_rest_api/blog_notifier/blog_notifier.dart';
import 'package:blog_rest_api/data/models/post_model.dart';
import 'package:blog_rest_api/pages/add_post.dart';
import 'package:blog_rest_api/pages/edit_post.dart';
import 'package:blog_rest_api/pages/post_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlogListPage extends StatefulWidget {
  const BlogListPage({super.key});

  @override
  State<BlogListPage> createState() => _BlogListPageState();
}

class _BlogListPageState extends State<BlogListPage> {
  bool _isLoading = true;
  bool _isError = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getAllPost();
    });
  }

  Future<void> _getAllPost() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<BlogNotifier>(context, listen: false).getPostList();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog List'),
      ),
      body: Column(
        children: [
          if (_isLoading == true && !_isError)
            const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          if (_isError == true)
            const Center(
              child: Text('Something went wrong'),
            ),
          if (!_isLoading && !_isError)
            Expanded(
              child: Consumer<BlogNotifier>(
                builder: (context, notifier, child) {
                  return RefreshIndicator.adaptive(
                    onRefresh: () async {
                      _getAllPost();
                    },
                    child: ListView.builder(
                      itemCount: notifier.posts.length,
                      itemBuilder: (context, index) {
                        if (notifier.posts.isEmpty) {
                          return const Center(
                            child: Text('No data'),
                          );
                        }
                        PostModel postModel = notifier.posts[index];
                        return Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PostDetailsPage(id: postModel.id!),
                                ),
                              );
                            },
                            title: Text(postModel.title ?? ""),
                            subtitle: Text(
                              postModel.id.toString(),
                            ),
                            trailing: SizedBox(
                              width: 96,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditPost(
                                            id: postModel.id!,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await notifier.deletePost(postModel.id!);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text(notifier.message!.result),
                                          ),
                                        );
                                      }
                                      _getAllPost();
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddPost();
              },
            ),
          );
        },
      ),
    );
  }
}
