import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/neon_text.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const NeonText('ABOUT LIFEOS', color: AppTheme.textPrimary, glow: false),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.surfaceElevated,
                  border: Border.all(color: AppTheme.neonCyan, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.neonCyan.withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: const Icon(Icons.architecture, size: 60, color: AppTheme.neonCyan),
              ),
              const SizedBox(height: 24),
              const NeonText('LIFE OS', color: AppTheme.textPrimary, fontSize: 32),
              const SizedBox(height: 8),
              const Text('VERSION 1.0.0 (OFFLINE CORE)', style: TextStyle(color: AppTheme.textSecondary, letterSpacing: 2)),
              const SizedBox(height: 48),
              const GlassCard(
                child: Text(
                  'LifeOS is a highly specialized, local-first operating environment designed to maintain optimal focus and construct a rigid protocol for daily operations. It requires zero external network connections to function, preserving strict data sovereignty.',
                  style: TextStyle(color: AppTheme.textPrimary, height: 1.6, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              const Text('DESIGNED BY ROSHAN', style: TextStyle(color: AppTheme.primaryPurple, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.surfaceElevated,
                  foregroundColor: AppTheme.textPrimary,
                ),
                onPressed: () async {
                  final Uri url = Uri.parse('https://github.com/roshan');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                icon: const Icon(Icons.code),
                label: const Text('VIEW SOURCE'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
