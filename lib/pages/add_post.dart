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
  final bool _isError = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: Padding(
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
                    XFile? xfile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (xfile != null) {
                      _isLoading = true;

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
                          content: Text('Please enter title and description'),
                        ),
                      );
                    }
                    print(_photo?.path);
                    await notifier.createPost(
                        title: title, body: description, photo: _photo);
                  },
                  child: const Text('Add Post'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
