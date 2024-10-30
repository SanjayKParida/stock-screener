import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/earnings.dart';
import '../../domain/entities/transcript.dart';
import '../../domain/repositories/earnings_repository.dart';
import '../data_sources/earnings_remote_data_source.dart';

class EarningsRepositoryImpl implements EarningsRepository {
  final EarningsRemoteDataSource remoteDataSource;

  EarningsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Earnings>>> getEarnings(String ticker) async {
    try {
      final remoteEarnings = await remoteDataSource.getEarnings(ticker);
      return Right(remoteEarnings);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Transcript>> getTranscript(
    String ticker,
    int year,
    int quarter,
  ) async {
    try {
      final remoteTranscript = await remoteDataSource.getTranscript(
        ticker,
        year,
        quarter,
      );
      return Right(remoteTranscript);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
