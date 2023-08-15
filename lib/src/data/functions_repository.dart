import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'functions_repository.g.dart';

class FunctionRepository {
  final FirebaseFunctions _functions;

  const FunctionRepository({
    required FirebaseFunctions functions,
  }) : _functions = functions;

  Future<void> deleteAllUserJobs() async {
    final callable = _functions.httpsCallable('deleteAllUserJobs');
    final result = await callable();
    debugPrint(result.data.toString());
  }
}

@riverpod
FunctionRepository functionRepository(FunctionRepositoryRef ref) {
  return FunctionRepository(
      functions: FirebaseFunctions.instanceFor(region: 'asia-northeast3'));
}
