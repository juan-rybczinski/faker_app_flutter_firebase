import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_repository.g.dart';

class FirestoreRepository {
  final FirebaseFirestore _firestore;

  const FirestoreRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  Future<void> addJob({
    required String uid,
    required String title,
    required String company,
  }) async {
    final docRef = await _firestore.collection('jobs').add({
      'uid': uid,
      'title': title,
      'company': company,
    });
    debugPrint(docRef.id);
  }
}

@riverpod
FirestoreRepository firestoreRepository(FirestoreRepositoryRef ref) {
  return FirestoreRepository(firestore: FirebaseFirestore.instance);
}
