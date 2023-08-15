import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'functions_repository.g.dart';

class FunctionRepository {
  final FirebaseFunctions _functions;

  const FunctionRepository({
    required FirebaseFunctions functions,
  }) : _functions = functions;

  Future<void> deleteAllUserJobs() async {}
}

@riverpod
FunctionRepository functionRepository(FunctionRepositoryRef ref) {
  return FunctionRepository(functions: FirebaseFunctions.instance);
}
