import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/earnings.dart';
import '../entities/transcript.dart';

abstract class EarningsRepository {
  Future<Either<Failure, List<Earnings>>> getEarnings(String ticker);
  Future<Either<Failure, Transcript>> getTranscript(
      String ticker, int year, int quarter);
}
