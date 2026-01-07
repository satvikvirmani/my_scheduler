import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/spacing.dart';
import '../../providers/reports_provider.dart';
import '../../models/report.dart';
import 'widgets/subject_report_card.dart';

class DetailedReportScreen extends ConsumerWidget {
  final String semesterId;
  final String category;
  final String categoryKey;

  const DetailedReportScreen({
    super.key,
    required this.semesterId,
    required this.category,
    required this.categoryKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Detailed Report')),
      body: SafeArea(
        child: reportsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (reports) {
            if (reports.isEmpty) {
              return const Center(child: Text('No reports found'));
            }

            final Report semester = reports.firstWhere(
              (r) => r.semesterId == semesterId,
              orElse: () => reports.first,
            );

            final filteredSubjects = semester.subjects
                .where((s) => s.category == categoryKey)
                .toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$category • ${semester.semesterName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (filteredSubjects.isEmpty)
                    const Text('No data available')
                  else
                    ...filteredSubjects.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SubjectReportCard(
                          subject: entry.value,
                          index: entry.key,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
