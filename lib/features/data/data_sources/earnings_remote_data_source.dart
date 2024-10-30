import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../../../core/api_constants.dart';
import '../models/earnings_model.dart';
import '../models/transcript_model.dart';

abstract class EarningsRemoteDataSource {
  Future<List<EarningsModel>> getEarnings(String ticker);
  Future<TranscriptModel> getTranscript(String ticker, int year, int quarter);
}

class EarningsRemoteDataSourceImpl implements EarningsRemoteDataSource {
  final http.Client client;

  EarningsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<EarningsModel>> getEarnings(String ticker) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/earningscalendar?ticker=$ticker'),
      headers: {'X-Api-Key': ApiConstants.apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => EarningsModel.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to fetch earnings data');
    }
  }

  @override
  Future<TranscriptModel> getTranscript(
      String ticker, int year, int quarter) async {
    final response = await client.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/earningstranscript?ticker=$ticker&year=$year&quarter=$quarter'),
      headers: {'X-Api-Key': ApiConstants.apiKey},
    );

    if (response.statusCode == 200) {
      return TranscriptModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: 'Failed to fetch transcript');
    }
  }
}
