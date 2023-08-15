import 'package:faker/faker.dart';
import 'package:faker_app_flutter_firebase/src/data/firestore_repository.dart';
import 'package:faker_app_flutter_firebase/src/data/functions_repository.dart';
import 'package:faker_app_flutter_firebase/src/routing/app_router.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wirtwirt_common/wirtwirt_common.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Jobs'),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await ref.read(functionRepositoryProvider).deleteAllUserJobs();
              } catch (e) {
                showAlertDialog(
                  context: context,
                  title: 'An error occured',
                  content: e.toString(),
                );
              }
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.goNamed(AppRoute.profile.name),
          ),
        ],
      ),
      body: const JobsListView(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final user = ref.read(firebaseAuthProvider).currentUser;
          final faker = Faker();
          ref.read(firestoreRepositoryProvider).addJob(
                uid: user!.uid,
                title: faker.job.title(),
                company: faker.company.name(),
              );
        },
      ),
    );
  }
}

class JobsListView extends ConsumerWidget {
  const JobsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestoreRepository = ref.watch(firestoreRepositoryProvider);
    final user = ref.watch(firebaseAuthProvider).currentUser;

    return FirestoreListView(
      query: firestoreRepository.jobsQuery(uid: user!.uid),
      itemBuilder: (context, doc) {
        final job = doc.data();
        return Dismissible(
          key: Key(doc.id),
          background: const ColoredBox(color: Colors.red),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            final user = ref.read(firebaseAuthProvider).currentUser;
            ref
                .read(firestoreRepositoryProvider)
                .deleteJob(uid: user!.uid, jobId: doc.id);
          },
          child: ListTile(
            title: Text(job.title),
            subtitle: Text(job.company),
            trailing: job.createdAt != null
                ? Text(
                    job.createdAt.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                : null,
            onTap: () {
              final user = ref.read(firebaseAuthProvider).currentUser;
              final faker = Faker();
              ref.read(firestoreRepositoryProvider).updateJob(
                    uid: user!.uid,
                    jobId: doc.id,
                    title: faker.job.title(),
                    company: faker.company.name(),
                  );
            },
          ),
        );
      },
    );
  }
}
