import 'package:equatable/equatable.dart';

class Earnings extends Equatable {
  final double actualEPS;
  final double estimatedEPS;
  final String pricedate;
  final String ticker;
  final int actualRevenue;
  final int estimatedRevenue;

  const Earnings({
    required this.actualEPS,
    required this.estimatedEPS,
    required this.pricedate,
    required this.ticker,
    required this.actualRevenue,
    required this.estimatedRevenue,
  });

  @override
  List<Object> get props => [
        actualEPS,
        estimatedEPS,
        pricedate,
        ticker,
        actualRevenue,
        estimatedRevenue,
      ];
}
