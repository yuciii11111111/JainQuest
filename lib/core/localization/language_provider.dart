import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import 'app_language.dart';

final appLanguageProvider = Provider<AppLanguage>((ref) {
  final user = ref.watch(userProfileProvider);
  return AppLanguage.fromCode(user.preferredLanguageCode);
});
