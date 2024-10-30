import 'package:equatable/equatable.dart';

class Transcript extends Equatable {
  final String transcript;

  const Transcript({
    required this.transcript,
  });

  @override
  List<Object> get props => [transcript];
}
