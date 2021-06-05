import 'package:book_tracker/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Book {
  final String? title;
  final String? author;
  final double? rating;
  final String? notes;
  final String? photoUrl;
  final bool? isFinished;
  final String? publishedDate;
  final String? description;
  final int? pageCount;
  final String? categories;
  final Timestamp? startedReading;
  final Timestamp? finishedReading;
  final String? id;
  final String? userId;

  Book(
      {this.id,
      this.userId,
      required this.title,
      required this.author,
      this.notes,
      this.rating,
      this.photoUrl,
      this.publishedDate,
      this.description,
      this.pageCount,
      this.categories,
      this.startedReading,
      this.finishedReading,
      this.isFinished});

  factory Book.fromDocument(QueryDocumentSnapshot data) {
    Map<String, dynamic> info = data.data() as Map<String, dynamic>;
    return Book(
        id: data.id,
        userId: info['user_id'],
        title: info['title'],
        author: info['author'],
        notes: info['notes'],
        rating: parseDouble(info[
            'rating']), //must use parseDouble() for this to work!!https://stackoverflow.com/questions/56253227/unhandled-exception-type-string-is-not-a-subtype-of-type-double-even-if-a-d
        photoUrl: info['photo_url'],
        publishedDate: info['published_date'],
        description: info['description'],
        pageCount: info['page_count'],
        categories: info['categories'],
        startedReading: info['started_reading_at'],
        finishedReading: info['finished_reading_at'],
        isFinished: info['finished']
        // id: data.id,
        // userId: info['user_id'],
        // title: info['title'],
        // author: info['author'],
        // notes: info['notes'],
        // rating: parseDouble(info['rating']), //must use parseDouble() for this to work!!https://stackoverflow.com/questions/56253227/unhandled-exception-type-string-is-not-a-subtype-of-type-double-even-if-a-d
        // photoUrl: info['photo_url'],
        // publishedDate: info['published_date'],
        // description: info['description'],
        // pageCount: info['page_count'],
        // categories: info['categories'],
        // startedReading: info['started_reading_at'],
        // finishedReading: info['finished_reading_at'],
        // isFinished: info['finished']

        );
  }
  // factory Book.fromMap(Map<String, dynamic> data) {
  //   return Book(
  //       title: data['title'],
  //       author: data['author'],
  //       notes: data['notes'],
  //       photoUrl: data['photo_url'],
  //       isFinished: data['finished']);
  // }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'user_id': userId,
      'author': author,
      'notes': notes,
      'rating': rating,
      'photo_url': photoUrl,
      'published_date': publishedDate,
      'description': description,
      'page_count': pageCount,
      'categories': categories,
      'started_reading_at': startedReading,
      'finished_reading_at': finishedReading,
      'finished': isFinished
    };
  }
}
