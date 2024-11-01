import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/earnings_bloc.dart';
import '../bloc/earnings_state.dart';
import '../widgets/company_search_field.dart';
import '../widgets/earnings_graph.dart';
import 'transcript_page.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Earnings Tracker')),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const CompanySearchField(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocBuilder<EarningsBloc, EarningsState>(
                  builder: (context, state) {
                    if (state is EarningsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is EarningsLoaded) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 400,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: EarningsGraph(
                                earnings: state.earnings,
                                onDateSelected: (ticker, year, quarter) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TranscriptPage(
                                        ticker: ticker,
                                        year: year,
                                        quarter: quarter,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _LegendItem(
                                  color: Colors.blue,
                                  label: 'Actual EPS',
                                ),
                                SizedBox(width: 24),
                                _LegendItem(
                                  color: Colors.red,
                                  label: 'Estimated EPS',
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (state is EarningsError) {
                      return Center(child: Text(state.message));
                    }
                    return const Center(
                      child:
                          Text('Enter a company ticker to see earnings data'),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
