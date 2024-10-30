import 'package:stock_screener/features/domain/entities/earnings.dart';

class EarningsModel extends Earnings {
  const EarningsModel({
    required super.actualEPS,
    required super.estimatedEPS,
    required super.pricedate,
    required super.ticker,
    required super.actualRevenue,
    required super.estimatedRevenue,
  });

  factory EarningsModel.fromJson(Map<String, dynamic> json) {
    return EarningsModel(
      actualEPS: json['actual_eps']?.toDouble() ?? 0.0,
      estimatedEPS: json['estimated_eps']?.toDouble() ?? 0.0,
      pricedate: json['pricedate'] ?? '',
      ticker: json['ticker'] ?? '',
      actualRevenue: json['actual_revenue'] ?? 0,
      estimatedRevenue: json['estimated_revenue'] ?? 0,
    );
  }
}
