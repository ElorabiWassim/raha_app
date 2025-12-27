
import 'package:ra7a/l10n/app_localizations.dart';

class PlanLocalizer {
  final AppLocalizations l10n;

  PlanLocalizer(this.l10n);

  String getName(String planId) {
    switch (planId.toLowerCase()) {
      case 'free': return l10n.planFreeName;
      case 'pro': return l10n.planProName;
      case 'elite': return l10n.planEliteName;
      default: return l10n.unknownPlan;
    }
  }

  List<String> getFeatures(String planId) {
    String rawFeatures;
    switch (planId.toLowerCase()) {
      case 'free': rawFeatures = l10n.planFreeFeatures; break;
      case 'pro': rawFeatures = l10n.planProFeatures; break;
      case 'elite': rawFeatures = l10n.planEliteFeatures; break;
      default: return [];
    }
    
    return rawFeatures.split('|');
  }
}