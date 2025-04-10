import 'dart:io';

import 'package:blog_rest_api/blog_notifier/blog_notifier.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool _isLoading = false;
  bool _isError = false;
  bool _isCreated = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: Column(
        children: [
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          if (_isCreated)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Post Created"),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Go Back'),
                ),
              ],
            ),
          if (!_isLoading && !_isCreated && !_isError)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<BlogNotifier>(
                builder: (context, notifier, child) {
                  return Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          ImagePicker picker = ImagePicker();
                          XFile? xfile = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (xfile != null) {
                            setState(() {
                              _photo = File(xfile.path);
                            });
                          }
                        },
                        child: Text("Choose Image (Optional)"),
                      ),
                      _photo != null
                          ? Image.file(
                              _photo!,
                              height: 100,
                              width: 100,
                            )
                          : SizedBox.shrink(),
                      SizedBox(
                        height: 12,
                      ),
                      FilledButton(
                        onPressed: () async {
                          final String title = _titleController.text.trim();
                          final String description =
                              _descriptionController.text.trim();
                          if (title.isEmpty || description.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please enter title and description'),
                              ),
                            );
                          } else {
                            print(_photo?.path);
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await notifier.createPost(
                                title: title,
                                body: description,
                                photo: _photo,
                              );
                            } catch (e) {
                              setState(() {
                                _isError = true;
                                _isLoading = false;
                              });
                            }
                            setState(() {
                              _isLoading = false;
                              _isError = false;
                              _isCreated = true;
                            });
                          }
                        },
                        child: const Text('Add Post'),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _photo = null;
  }
}
