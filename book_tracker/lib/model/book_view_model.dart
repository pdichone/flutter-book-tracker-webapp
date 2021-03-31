import 'package:book_tracker/model/book.dart';
import 'package:book_tracker/services/book_api.dart';
import 'package:book_tracker/services/book_service.dart';
import 'package:flutter/material.dart';

class BookViewModel with ChangeNotifier {
  bool isRequestPending = false;
  bool isBookSearchLoading = false;
  bool isRequestError = false;

  BookService bookService;

  BookViewModel() {
    bookService = BookService(GoogleBookApi());
  }
  Future<List<Book>> getRecentBookSearch(String query) async {
    List<Book> books;
    try {
      await Future.delayed(Duration(seconds: 1), () => {});

      books = await bookService.googleBookApi.fetchBooks(query);
      //.catchError((onError) => this.isRequestError = true);
    } catch (e) {
      this.isRequestError = true;
    }
    notifyListeners();
    return books;
  }
}
