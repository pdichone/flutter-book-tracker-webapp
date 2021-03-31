import 'dart:convert';

import 'package:book_tracker/constants/constants.dart';
import 'package:book_tracker/model/book.dart';
import 'package:http/http.dart' as http;

class GoogleBookApi extends BookApi {
  List<Book> books = [];
  @override
  Future<List<Book>> fetchBooks(String query) async {
    http.Response response = await http.get(Uri.parse(searchQuery(query)));

    if (response.statusCode != 200) {
      throw Exception(
          'error retrieving books for the search term ${response.statusCode}');
    } else {
      var body = jsonDecode(response.body);
      final Iterable list = body['items'];

      for (var item in list) {
        String title = item['volumeInfo']['title'];
        String author = item['volumeInfo']['authors'][0];
        String thumbNail = item['volumeInfo']['imageLinks']['thumbnail'];
        Book searchBook = new Book(title: title, author: author, photoUrl: thumbNail);

        books.add(searchBook);
      }

      return books;
    }
  }
}

abstract class BookApi {
  Future<List<Book>> fetchBooks(String query);
}
