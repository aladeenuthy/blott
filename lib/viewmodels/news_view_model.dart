import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/news_model.dart';

class NewsViewModel extends ChangeNotifier {
  final String apiKey = "crals9pr01qhk4bqotb0crals9pr01qhk4bqotbg";
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String errorMessage = "";
  Dio dio = Dio();
  List<NewsModel> news = [];

  Future<void> getNews() async {
    errorMessage = "";
    isLoading = true;
    final url = "https://finnhub.io/api/v1/news?category=general&token=$apiKey";
    try {
      final response = await dio.get(url);

      List responseData = List.from(response.data);
      news = responseData.map((element) {
        return NewsModel.fromJson(element);
      }).toList();
    } on SocketException catch (_) {
      errorMessage = "No Inernet Connection";
    } on DioError catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "An error occurred, please try again later";
    }
    isLoading = false;
  }
}
