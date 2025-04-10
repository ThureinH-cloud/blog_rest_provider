import 'package:blog_rest_api/blog_notifier/blog_notifier.dart';
import 'package:blog_rest_api/data/models/post_model.dart';
import 'package:blog_rest_api/static/url_const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostDetailsPage extends StatefulWidget {
  const PostDetailsPage({super.key, required this.id});
  final int id;
  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  bool _isLoading = true;
  bool _isError = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _postDetails(widget.id);
    });
  }

  void _postDetails(int id) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<BlogNotifier>(context, listen: false).getPost(id);
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
        title: const Text('Post Details'),
      ),
      body: Column(
        children: [
          if (_isLoading && !_isError)
            const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          if (_isError)
            const Center(
              child: Text('Something went wrong'),
            ),
          if (!_isLoading && !_isError)
            Consumer<BlogNotifier>(
              builder: (context, notifier, child) {
                PostModel? postModel = notifier.post;
                if (postModel == null) {
                  return SizedBox.shrink();
                }
                return Expanded(
                  child: Column(
                    children: [
                      Text(postModel.title!),
                      Text(postModel.body!),
                      if (postModel.photo != null)
                        CachedNetworkImage(
                          imageUrl: "${UrlConst.baseUrl}/${postModel.photo}",
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator.adaptive(
                                      value: downloadProgress.progress),
                        )
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
