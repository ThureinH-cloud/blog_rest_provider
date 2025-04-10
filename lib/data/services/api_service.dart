import 'dart:io';

import 'package:blog_rest_api/data/models/message_model.dart';
import 'package:blog_rest_api/data/models/post_model.dart';
import 'package:blog_rest_api/static/url_const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BlogApiService extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: UrlConst.baseUrl),
  );
  Future<List<PostModel>> getPostList() async {
    final response = await _dio.get(UrlConst.posts);
    List<dynamic> data = response.data as List;
    return data.map((e) => PostModel.fromJson(e)).toList();
  }

  Future<PostModel> getPostById(int id) async {
    final response = await _dio.get('${UrlConst.post}?id=$id');
    List<dynamic> data = response.data as List;
    return PostModel.fromJson(data.first);
  }

  Future<MessageModel> createPost(
      {required String title, required String body, File? photo}) async {
    FormData? formData;
    if (photo != null) {
      formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(photo.path),
      });
    }
    final response = await _dio.post(
      '${UrlConst.post}?title=$title&body=$body',
      data: formData,
    );
    return MessageModel.fromJson(response.data);
  }

  Future<MessageModel> updatePost({
    required int id,
    String? title,
    String? body,
    File? photo,
  }) async {
    FormData? formData;
    if (photo != null) {
      formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(photo.path),
      });
    }
    final response = await _dio.put(
      '${UrlConst.post}?id=$id&title=$title&body=$body',
      data: formData,
    );
    return MessageModel.fromJson(response.data);
  }

  Future<MessageModel> deletePost(int id) async {
    final response = await _dio.delete('${UrlConst.post}?id=$id');

    return MessageModel.fromJson(response.data);
  }
}
