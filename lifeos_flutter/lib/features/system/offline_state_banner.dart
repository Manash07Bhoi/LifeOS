import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class OfflineStateBanner extends StatelessWidget {
  const OfflineStateBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.neonPink.withValues(alpha: 0.1),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, color: AppTheme.neonPink, size: 16),
          SizedBox(width: 8),
          Text(
            'SYSTEM OFFLINE. LOCAL STORAGE ACTIVE.',
            style: TextStyle(
              color: AppTheme.neonPink,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
