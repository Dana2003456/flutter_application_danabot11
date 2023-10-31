import 'package:dio/dio.dart';
import 'package:flutter_application_danabot/com/page.dart';
import 'package:retrofit/retrofit.dart';

part 'retdio.g.dart';

@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class Controlapi {
  factory Controlapi(Dio dio, {String baseUrl}) = _Controlapi;

  @GET('/posts/1/comments')
  Future<List<Comment>> fetchComments();
}
