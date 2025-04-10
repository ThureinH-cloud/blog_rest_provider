import 'dart:io';

import 'package:blog_rest_api/blog_notifier/blog_notifier.dart';
import 'package:blog_rest_api/data/models/post_model.dart';
import 'package:blog_rest_api/static/url_const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditPost extends StatefulWidget {
  const EditPost({super.key, required this.id});
  final int id;
  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  bool _isLoading = true;
  bool _isError = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  File? file;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      postDetails(widget.id);
    });
  }

  void postDetails(int id) async {
    try {
      setState(() {
        _isLoading = true;
      });
      print("loading");
      await Provider.of<BlogNotifier>(context, listen: false).getPost(id);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
      ),
      body: Column(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator.adaptive()),
          if (_isError) const Center(child: Text('Error')),
          if (!_isLoading && !_isError)
            Consumer<BlogNotifier>(
              builder: (context, notifier, child) {
                PostModel? postModel = notifier.post!;
                _titleController.text = postModel.title ?? "";
                _bodyController.text = postModel.body ?? "";
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextField(
                        controller: _bodyController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Body',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          ImagePicker picker = ImagePicker();
                          XFile? xfile = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (xfile != null) {
                            setState(() {
                              file = File(xfile.path);
                              postModel.photo = null;
                            });
                          }
                        },
                        child: Text("Choose Image (Optional)"),
                      ),
                      if (postModel.photo != null)
                        CachedNetworkImage(
                          imageUrl: "${UrlConst.baseUrl}/${postModel.photo}",
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator.adaptive(
                                      value: downloadProgress.progress),
                        ),
                      if (file != null)
                        Image.file(
                          file!,
                          width: 150,
                          height: 150,
                        ),
                      ElevatedButton(
                        onPressed: () async {
                          final title = _titleController.text.trim();
                          final body = _bodyController.text.trim();
                          if (title.isEmpty || body.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please enter completely."),
                              ),
                            );
                          }
                          await notifier.updatePost(
                            id: postModel.id!,
                            title: title,
                            body: body,
                            photo: file,
                          );
                        },
                        child: const Text('Update'),
                      ),
                    ],
                  ),
                );
              },
            )
        ],
      ),
    );
  }
}
