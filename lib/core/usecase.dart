import 'package:dartz/dartz.dart';
import 'package:stock_screener/core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
