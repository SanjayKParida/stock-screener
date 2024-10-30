import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_screener/features/presentation/bloc/earnings_event.dart';
import '../bloc/earnings_bloc.dart';

class CompanySearchField extends StatefulWidget {
  const CompanySearchField({super.key});

  @override
  State<CompanySearchField> createState() => _CompanySearchFieldState();
}

class _CompanySearchFieldState extends State<CompanySearchField> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  String? _selectedTicker;

  final List<String> _tickers = [
    'AAPL - Apple Inc.',
    'MSFT - Microsoft Corporation',
    'GOOGL - Alphabet Inc.',
    'AMZN - Amazon.com Inc.',
    'META - Meta Platforms Inc.',
    'TSLA - Tesla Inc.',
    'NVDA - NVIDIA Corporation',
    'JPM - JPMorgan Chase & Co.',
    'BAC - Bank of America Corp.',
    'WMT - Walmart Inc.',
    'V - Visa Inc.',
    'MA - Mastercard Inc.',
    'PFE - Pfizer Inc.',
    'KO - Coca-Cola Company',
    'PEP - PepsiCo Inc.',
    'DIS - Walt Disney Co.',
    'NFLX - Netflix Inc.',
    'ADBE - Adobe Inc.',
    'CSCO - Cisco Systems Inc.',
    'INTC - Intel Corporation',
    'AMD - Advanced Micro Devices Inc.',
    'CRM - Salesforce Inc.',
    'PYPL - PayPal Holdings Inc.',
    'UBER - Uber Technologies Inc.',
    'ABNB - Airbnb Inc.',
    'SPOT - Spotify Technology SA',
    'SBUX - Starbucks Corporation',
    'NKE - Nike Inc.',
    'MCDM - McDonald\'s Corporation',
    'IBM - International Business Machines',
    'ORCL - Oracle Corporation',
    'QCOM - Qualcomm Inc.',
    'GM - General Motors Company',
    'F - Ford Motor Company',
    'BA - Boeing Company',
    'GE - General Electric Company',
    'XOM - Exxon Mobil Corporation',
    'CVX - Chevron Corporation',
    'JNJ - Johnson & Johnson',
    'UNH - UnitedHealth Group Inc.'
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void _handleSearch() {
    String searchText = _controller.text.trim();

    // If no suggestion was selected, try to match the input with available tickers
    if (_selectedTicker == null) {
      final matchingTickers = _tickers
          .where((ticker) =>
              ticker.toLowerCase().contains(searchText.toLowerCase()))
          .toList();

      if (matchingTickers.isNotEmpty) {
        searchText = matchingTickers.first;
      }
    } else {
      searchText = _selectedTicker!;
    }

    // Extract ticker symbol from the full company name
    final ticker = searchText.split(' - ').first.trim().toUpperCase();

    if (ticker.isNotEmpty) {
      // Reset the selected ticker
      _selectedTicker = null;

      // Update the UI and fetch data
      setState(() {
        _controller.text = searchText;
      });

      context.read<EarningsBloc>().add(FetchEarnings(ticker: ticker));
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Autocomplete<String>(
              initialValue: TextEditingValue(text: _controller.text),
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted,
              ) {
                _controller = fieldTextEditingController;
                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'Enter Company Ticker',
                    hintText: 'e.g., MSFT',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) {
                    _handleSearch();
                    FocusScope.of(context).unfocus();
                  },
                );
              },
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return _tickers.where((ticker) => ticker
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
              },
              optionsViewBuilder: (
                BuildContext context,
                AutocompleteOnSelected<String> onSelected,
                Iterable<String> options,
              ) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      width: MediaQuery.of(context).size.width - 80,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final option = options.elementAt(index);
                          return ListTile(
                            title: Text(option),
                            onTap: () {
                              onSelected(option);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              onSelected: (String selection) {
                _selectedTicker = selection;
                _controller.text = selection;
                _handleSearch();
              },
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              _handleSearch();
              FocusScope.of(context).unfocus();
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}
