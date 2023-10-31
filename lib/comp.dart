import 'package:dio/dio.dart';
import 'package:flutter_application_danabot/com/page.dart';
import 'package:flutter_application_danabot/retdio/retdio.dart';

final dio = Dio();
final apiService = Controlapi(dio);

Future<List<Comment>> fetchComments() async {
  return apiService.fetchComments();
}
