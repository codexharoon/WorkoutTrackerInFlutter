import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final DateTime? startDate;
  final Map<DateTime, int>? datasets;
  
  const MyHeatMap({
    Key? key,
    required this.startDate,
    required this.datasets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: HeatMap(
        startDate: startDate,
        endDate: DateTime.now().add(const Duration(days: 0)),
        datasets: datasets,
        colorMode: ColorMode.color,
        showText: true,
        scrollable: true,
        colorsets: const {
          0: Colors.red,
          1: Colors.green,
        },
        size: 30,
        onClick: (value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString())));
        },
      ),
    );
  }
}
