import 'package:fitness_dashboard_ui/widgets/pie_chart_widget.dart';
import 'package:fitness_dashboard_ui/widgets/scheduled_widget.dart';
import 'package:fitness_dashboard_ui/widgets/summary_details.dart';
import 'package:flutter/material.dart';

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Chart(),
            Text(
              'Summary',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            SizedBox(height: 16),
            SummaryDetails(),
            SizedBox(height: 40),
            Scheduled(),
          ],
        ),
      ),
    );
  }
}
