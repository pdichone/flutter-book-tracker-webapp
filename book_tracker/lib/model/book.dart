import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Book {
  final String title;
  final String author;
  final String notes;
  final String photoUrl;
  final bool isFinished;
  final String publishedDate;
  final String description;
  final int pageCount;
  final String categories;
  final Timestamp startedReading;
  final Timestamp finishedReading;
  final String id;

  Book(
      {this.id,
      @required this.title,
      @required this.author,
      this.notes,
      this.photoUrl,
      this.publishedDate,
      this.description,
      this.pageCount,
      this.categories,
      this.startedReading,
      this.finishedReading,
      this.isFinished});

  factory Book.fromDocument(QueryDocumentSnapshot data) {
    return Book(
        id: data.id,
        title: data.data()['title'],
        author: data.data()['author'],
        notes: data.data()['notes'],
        photoUrl: data.data()['photo_url'],
        publishedDate: data.data()['published_date'],
        description: data.data()['description'],
        pageCount: data.data()['page_count'],
        categories: data.data()['categories'],
        startedReading: data.data()['started_reading_at'],
        finishedReading: data.data()['finished_reading_at'],
        isFinished: data.data()['finished']);
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
      'author': author,
      'notes': notes,
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
