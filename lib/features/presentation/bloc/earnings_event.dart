import 'package:equatable/equatable.dart';

abstract class EarningsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchEarnings extends EarningsEvent {
  final String ticker;

  FetchEarnings({required this.ticker});

  @override
  List<Object> get props => [ticker];
}

class FetchTranscript extends EarningsEvent {
  final String ticker;
  final int year;
  final int quarter;

  FetchTranscript({
    required this.ticker,
    required this.year,
    required this.quarter,
  });

  @override
  List<Object> get props => [ticker, year, quarter];
}
