import 'package:flutter/material.dart';
import 'package:time_tracker/Authentication/Models/Record.dart';
import 'package:time_tracker/Services/APIPath.dart';
import 'package:time_tracker/Services/FirestoreService.dart';

abstract class Database {
  Future<void> createRecord(Record recordData);

  Stream<List<Record>> recordsStream();
}
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final service = FirestoreService.instance;

  Future<void> createRecord(Record recordData) async => await service.setData(
      APIPath.record(uid, documentIdFromCurrentDate()), recordData.toMap());

  Stream<List<Record>> recordsStream() => service.collectionStream(
        path: APIPath.records(uid),
        builder: (data, documentId) => Record.fromMap(data, documentId),
      );
}
