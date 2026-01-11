import 'package:flutter/material.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import '../screens/add_demand.dart';

class HomeDemand extends StatelessWidget {
  const HomeDemand({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      // ❌ REMOVED fixed width and height
      decoration: BoxDecoration(
        color: const Color(0xFFECFDE8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start, // align top
        children: [
          // ✅ Use Flexible with constrained child
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // 👈 key: don't expand unnecessarily
              children: [
                Text(
                  l10n.cantFindService,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // slightly smaller for safety
                    color: Color(0xFF8DC285),
                  ),
                  softWrap: true,
                  overflow: TextOverflow.clip,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.letUsKnowWhatYouNeed,
                  style: const TextStyle(
                    color: Color(0xFFBED7B3),
                    fontSize: 14,
                    height: 1.3,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12), // small gap before button
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddDemand()),
              );
            },
            borderRadius: BorderRadius.circular(25),
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF53B538),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}