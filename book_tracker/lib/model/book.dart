import 'package:flutter/material.dart';

class Book {
  final String title;
  final String author;
  final String notes;
  final String photoUrl;
  final bool isFinished;

  Book(
      {@required this.title,
      @required this.author,
      this.notes,
      this.photoUrl,
      this.isFinished});

  factory Book.fromMap(Map<String, dynamic> data) {
    return Book(
        title: data['title'],
        author: data['author'],
        notes: data['notes'],
        photoUrl: data['photo_url'],
        isFinished: data['finished']);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'notes': notes,
      'photo_url': photoUrl,
      'finished': isFinished
    };
  }
}
