import 'package:book_tracker/model/book_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QueryEntryViewModel with ChangeNotifier {
  String _query;

  QueryEntryViewModel();
  String get query => _query;

  void refreshBooks(String newQuery, BuildContext context) {
    Provider.of<BookViewModel>(context, listen: false)
        .getRecentBookSearch(newQuery);
  }

  void updateQuery(String newQuery) {
    _query = newQuery;
  }
}
