import 'package:equatable/equatable.dart';
import '../../domain/entities/earnings.dart';
import '../../domain/entities/transcript.dart';

abstract class EarningsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EarningsInitial extends EarningsState {}

class EarningsLoading extends EarningsState {}

class TranscriptLoading extends EarningsState {}

class EarningsLoaded extends EarningsState {
  final List<Earnings> earnings;

  EarningsLoaded({required this.earnings});

  @override
  List<Object> get props => [earnings];
}

class TranscriptLoaded extends EarningsState {
  final Transcript transcript;

  TranscriptLoaded({required this.transcript});

  @override
  List<Object> get props => [transcript];
}

class EarningsError extends EarningsState {
  final String message;

  EarningsError({required this.message});

  @override
  List<Object> get props => [message];
}

class TranscriptError extends EarningsState {
  final String message;

  TranscriptError({required this.message});

  @override
  List<Object> get props => [message];
}
