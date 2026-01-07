import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositories/reports_repostiory.dart';
import '../models/report.dart';

/// Repository provider
final reportsRepositoryProvider =
    Provider<ReportsRepository>((ref) {
  return ReportsRepository(Supabase.instance.client);
});

/// Reports data provider
final reportsProvider =
    FutureProvider<List<Report>>((ref) async {
  return ref.read(reportsRepositoryProvider).getReports();
});