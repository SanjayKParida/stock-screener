import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '../bloc/earnings_bloc.dart';
import '../bloc/earnings_event.dart';
import '../bloc/earnings_state.dart';

class TranscriptPage extends StatefulWidget {
  final String ticker;
  final int year;
  final int quarter;

  const TranscriptPage({
    super.key,
    required this.ticker,
    required this.year,
    required this.quarter,
  });

  @override
  State<TranscriptPage> createState() => _TranscriptPageState();
}

class _TranscriptPageState extends State<TranscriptPage> {
  @override
  void initState() {
    super.initState();

    context.read<EarningsBloc>().add(
          FetchTranscript(
            ticker: widget.ticker,
            year: widget.year,
            quarter: widget.quarter,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Earnings Call Transcript',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(
              IconlyLight.arrow_left_2,
              color: Colors.blue,
            )),
      ),
      body: BlocBuilder<EarningsBloc, EarningsState>(
        builder: (context, state) {
          if (state is TranscriptLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TranscriptLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _formatTranscript(state.transcript.transcript),
              ),
            );
          } else if (state is TranscriptError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No transcript available'));
        },
      ),
    );
  }

  List<Widget> _formatTranscript(String transcript) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final paragraphs = transcript.trim().split('\n');

    return paragraphs.map((paragraph) {
      paragraph = paragraph.trim();
      if (paragraph.isEmpty) {
        return const SizedBox(height: 8);
      } 
      final colonIndex = paragraph.indexOf(':');
      if (colonIndex > 0) {
        final speaker = paragraph.substring(0, colonIndex).trim();
        final content = paragraph.substring(colonIndex + 1).trim();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: "$speaker: ",
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: content, style: TextStyle(color: textColor)),
              ],
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            paragraph,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        );
      }
    }).toList();
  }
}
