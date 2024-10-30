import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../core/usecase.dart';
import '../entities/earnings.dart';
import '../repositories/earnings_repository.dart';

class GetEarningsParams {
  final String ticker;

  GetEarningsParams({required this.ticker});
}

class GetEarnings implements UseCase<List<Earnings>, GetEarningsParams> {
  final EarningsRepository repository;

  GetEarnings(this.repository);

  @override
  Future<Either<Failure, List<Earnings>>> call(GetEarningsParams params) async {
    return await repository.getEarnings(params.ticker);
  }
}
