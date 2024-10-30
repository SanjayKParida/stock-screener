import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../core/usecase.dart';
import '../entities/transcript.dart';
import '../repositories/earnings_repository.dart';

class GetTranscriptParams {
  final String ticker;
  final int year;
  final int quarter;

  GetTranscriptParams({
    required this.ticker,
    required this.year,
    required this.quarter,
  });
}

class GetTranscript implements UseCase<Transcript, GetTranscriptParams> {
  final EarningsRepository repository;

  GetTranscript(this.repository);

  @override
  Future<Either<Failure, Transcript>> call(GetTranscriptParams params) async {
    return await repository.getTranscript(
      params.ticker,
      params.year,
      params.quarter,
    );
  }
}
