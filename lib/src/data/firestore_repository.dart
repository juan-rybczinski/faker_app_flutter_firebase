import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker_app_flutter_firebase/src/data/job.dart';
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
  }) =>
      _firestore.collection('jobs').add({
        'uid': uid,
        'title': title,
        'company': company,
      });

  Query<Job> jobsQuery({
    required String uid,
  }) =>
      _firestore
          .collection('jobs')
          .withConverter(
            fromFirestore: (snapshot, _) => Job.fromMap(snapshot.data()!),
            toFirestore: (job, _) => job.toMap(),
          )
          .where('uid', isEqualTo: uid);

  Future<void> updateJob({
    required String uid,
    required String jobId,
    required String title,
    required String company,
  }) =>
      _firestore.doc('jobs/$jobId').update({
        'uid': uid,
        'title': title,
        'company': company,
      });

  Future<void> deleteJob({
    required String uid,
    required String jobId,
  }) =>
      _firestore.doc('jobs/$jobId').delete();
}

@riverpod
FirestoreRepository firestoreRepository(FirestoreRepositoryRef ref) {
  return FirestoreRepository(firestore: FirebaseFirestore.instance);
}
