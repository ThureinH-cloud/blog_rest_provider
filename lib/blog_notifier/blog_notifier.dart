import 'dart:io';

import 'package:blog_rest_api/data/models/message_model.dart';
import 'package:blog_rest_api/data/models/post_model.dart';
import 'package:blog_rest_api/data/services/api_service.dart';
import 'package:flutter/material.dart';

class BlogNotifier extends ChangeNotifier {
  PostModel? post;
  List<PostModel> posts = [];
  final BlogApiService _blogApiService = BlogApiService();
  MessageModel? message;
  Future<void> getPostList() async {
    try {
      posts = await _blogApiService.getPostList();
      notifyListeners();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> getPost(int id) async {
    try {
      post = await _blogApiService.getPostById(id);
      notifyListeners();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> createPost(
      {required String title, required String body, File? photo}) async {
    try {
      await _blogApiService.createPost(title: title, body: body, photo: photo);
      notifyListeners();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> updatePost(
      {required int id, String? title, String? body, File? photo}) async {
    try {
      message = await _blogApiService.updatePost(
        id: id,
        title: title,
        body: body,
        photo: photo,
      );
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> deletePost(int id) async {
    try {
      message = await _blogApiService.deletePost(id);
      notifyListeners();
    } catch (e) {
      return Future.error(e);
    }
  }
}
