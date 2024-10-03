import 'dart:io';

import 'package:blott/viewmodels/news_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'news_view_model_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late NewsViewModel newsViewModel;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    newsViewModel = NewsViewModel();
    newsViewModel.dio = mockDio;
  });

  group('getNews', () {
    test('should fetch news successfully and populate news list', () async {
      final mockResponse = [
        {
          'id': '1',
          'source': 'BBC',
          'image': 'https://image.url',
          'datetime': 1596588232,
          'summary': 'Sample news summary',
          'url': 'https://news.url',
        },
      ];


      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );


      await newsViewModel.getNews();


      expect(newsViewModel.isLoading, false);
      expect(newsViewModel.news.length, 1);
      expect(newsViewModel.news[0].id, '1');
      expect(newsViewModel.news[0].source, 'BBC');
      expect(newsViewModel.news[0].image, 'https://image.url');
      expect(newsViewModel.news[0].summary, 'Sample news summary');
      expect(newsViewModel.news[0].url, 'https://news.url');
      expect(newsViewModel.news[0].formattedDate, '5 August 2020');
    });

    test('should handle SocketException (no internet connection)', () async {
     
      when(mockDio.get(any)).thenThrow(const SocketException('No Internet'));

    
      await newsViewModel.getNews();

      expect(newsViewModel.isLoading, false);
      expect(newsViewModel.errorMessage, 'No Inernet Connection');
      expect(newsViewModel.news.isEmpty, true);
    });

    test('should handle DioError and set appropriate error message', () async {

      when(mockDio.get(any)).thenThrow(DioError(
        requestOptions: RequestOptions(path: ''),
        error: 'Failed to fetch data',
      ));

  
      await newsViewModel.getNews();

      expect(newsViewModel.isLoading, false);
      expect(newsViewModel.errorMessage,
          'An error occurred, please try again later');
      expect(newsViewModel.news.isEmpty, true);
    });

    test('should handle generic exceptions', () async {
      when(mockDio.get(any)).thenThrow(Exception('Generic error'));

      await newsViewModel.getNews();

      expect(newsViewModel.isLoading, false);
      expect(newsViewModel.errorMessage,
          'An error occurred, please try again later');
      expect(newsViewModel.news.isEmpty, true);
    });
  });
}
