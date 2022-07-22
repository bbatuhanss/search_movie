
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

final url = "https://api.themoviedb.org/3";

Future<Response> get(String uri) async {
  return await http.get(Uri.parse(url + uri));
}