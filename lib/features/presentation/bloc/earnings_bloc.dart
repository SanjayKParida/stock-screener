import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_earnings.dart';
import '../../domain/usecases/get_transcript.dart';
import 'earnings_event.dart';
import 'earnings_state.dart';

class EarningsBloc extends Bloc<EarningsEvent, EarningsState> {
  final GetEarnings getEarnings;
  final GetTranscript getTranscript;

  EarningsBloc({
    required this.getEarnings,
    required this.getTranscript,
  }) : super(EarningsInitial()) {
    on<FetchEarnings>(_onFetchEarnings);
    on<FetchTranscript>(_onFetchTranscript);
  }

  Future<void> _onFetchEarnings(
    FetchEarnings event,
    Emitter<EarningsState> emit,
  ) async {
    emit(EarningsLoading());
    final result = await getEarnings(GetEarningsParams(ticker: event.ticker));
    result.fold(
      (failure) => emit(EarningsError(message: failure.message)),
      (earnings) => emit(EarningsLoaded(earnings: earnings)),
    );
  }

  Future<void> _onFetchTranscript(
    FetchTranscript event,
    Emitter<EarningsState> emit,
  ) async {
    emit(TranscriptLoading());
    final result = await getTranscript(GetTranscriptParams(
      ticker: event.ticker,
      year: event.year,
      quarter: event.quarter,
    ));
    result.fold(
      (failure) => emit(TranscriptError(message: failure.message)),
      (transcript) => emit(TranscriptLoaded(transcript: transcript)),
    );
  }
}
