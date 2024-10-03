import 'package:intl/intl.dart';

class NewsModel {
  final String id;
  final String source;

  final String image;
  final DateTime date;
  final String summary;
  final String url;
  NewsModel({
    required this.id,
    required this.source,
    required this.image,
    required this.date,
    required this.summary,
    required this.url,
  });
  String get formattedDate {
    return DateFormat('d MMMM y').format(date);
  }

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'].toString(),
      source: json['source'],
      image: json['image'],
      date: DateTime.fromMillisecondsSinceEpoch(json['datetime'] * 1000),
      summary: json['summary'],
      url: json['url'],
    );
  }
}