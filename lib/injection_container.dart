import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/data/data_sources/earnings_remote_data_source.dart';
import 'features/data/repositories/earnings_repository_impl.dart';
import 'features/domain/repositories/earnings_repository.dart';
import 'features/domain/usecases/get_earnings.dart';
import 'features/domain/usecases/get_transcript.dart';
import 'features/presentation/bloc/earnings_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => EarningsBloc(
      getEarnings: sl(),
      getTranscript: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetEarnings(sl()));
  sl.registerLazySingleton(() => GetTranscript(sl()));

  // Repository
  sl.registerLazySingleton<EarningsRepository>(
    () => EarningsRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<EarningsRemoteDataSource>(
    () => EarningsRemoteDataSourceImpl(client: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
}
