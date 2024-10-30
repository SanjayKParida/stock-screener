// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:stock_screener/core/theme.dart';
import 'package:stock_screener/features/presentation/pages/earnings_page.dart';

import 'features/data/data_sources/earnings_remote_data_source.dart';
import 'features/data/repositories/earnings_repository_impl.dart';
import 'features/domain/usecases/get_earnings.dart';
import 'features/domain/usecases/get_transcript.dart';
import 'features/presentation/bloc/earnings_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a single http client instance
    final httpClient = http.Client();

    return BlocProvider(
      create: (context) => EarningsBloc(
        getEarnings: GetEarnings(
          EarningsRepositoryImpl(
            remoteDataSource: EarningsRemoteDataSourceImpl(
              client: httpClient, // Pass the client instance
            ),
          ),
        ),
        getTranscript: GetTranscript(
          EarningsRepositoryImpl(
            remoteDataSource: EarningsRemoteDataSourceImpl(
              client: httpClient, // Pass the same client instance
            ),
          ),
        ),
      ),
      child: MaterialApp(
        title: 'Earnings Tracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const EarningsPage(),
      ),
    );
  }
}
