import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/earnings.dart';

class EarningsGraph extends StatelessWidget {
  final List<Earnings> earnings;
  final Function(String ticker, int year, int quarter) onDateSelected;

  const EarningsGraph({
    super.key,
    required this.earnings,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white;
    final sortedEarnings = List<Earnings>.from(earnings)
      ..sort((a, b) =>
          DateTime.parse(a.pricedate).compareTo(DateTime.parse(b.pricedate)));

    return Padding(
      padding: const EdgeInsets.all(0.05),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.all(8),
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  final isEstimated = spot.barIndex == 1;
                  return LineTooltipItem(
                    '${isEstimated ? "Estimated" : "Actual"} EPS\n\$${spot.y.toStringAsFixed(2)}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
            touchCallback:
                (FlTouchEvent event, LineTouchResponse? touchResponse) {
              if (event is FlTapUpEvent &&
                  touchResponse?.lineBarSpots != null) {
                final index = touchResponse!.lineBarSpots!.first.x.toInt();
                final date = DateTime.parse(sortedEarnings[index].pricedate);
                final quarter = ((date.month - 1) ~/ 3) + 1;
                onDateSelected(
                    sortedEarnings[index].ticker, date.year, quarter);
              }
            },
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 0.05,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          titlesData: FlTitlesData(
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  if (value.toInt() >= 0 &&
                      value.toInt() < sortedEarnings.length) {
                    final date =
                        DateTime.parse(sortedEarnings[value.toInt()].pricedate);
                    return Transform.rotate(
                      angle: -0.5,
                      child: Text(
                        '${_getMonthName(date.month)} ${date.year}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 0.1,
                reservedSize: 45,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '\$${value.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                sortedEarnings.length,
                (index) => FlSpot(
                  index.toDouble(),
                  sortedEarnings[index].actualEPS,
                ),
              ),
              isCurved: true,
              color: Colors.blue,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: Colors.white,
                    strokeWidth: 3,
                    strokeColor: Colors.blue,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
            LineChartBarData(
              spots: List.generate(
                sortedEarnings.length,
                (index) => FlSpot(
                  index.toDouble(),
                  sortedEarnings[index].estimatedEPS,
                ),
              ),
              isCurved: true,
              color: Colors.red,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: Colors.white,
                    strokeWidth: 3,
                    strokeColor: Colors.red,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.red.withOpacity(0.1),
              ),
            ),
          ],
          minX: 0,
          maxX: (sortedEarnings.length - 1).toDouble(),
          minY: _getMinY(sortedEarnings) * 0.98,
          maxY: _getMaxY(sortedEarnings) * 1.02,
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return monthNames[month - 1];
  }

  double _getMinY(List<Earnings> sortedEarnings) {
    double minEPS = double.infinity;
    for (var earning in sortedEarnings) {
      minEPS = min(minEPS, min(earning.actualEPS, earning.estimatedEPS));
    }
    return minEPS;
  }

  double _getMaxY(List<Earnings> sortedEarnings) {
    double maxEPS = double.negativeInfinity;
    for (var earning in sortedEarnings) {
      maxEPS = max(maxEPS, max(earning.actualEPS, earning.estimatedEPS));
    }
    return maxEPS;
  }
}
