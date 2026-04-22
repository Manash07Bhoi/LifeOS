import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> safeLaunchUrl(BuildContext context, String urlString) async {
  try {
    final Uri url = Uri.parse(urlString);

    // Strict scheme validation
    final List<String> allowedSchemes = ['https', 'http', 'mailto'];
    if (!allowedSchemes.contains(url.scheme)) {
      _showErrorSnackBar(context, 'Security Policy Violation: Launching this protocol is not permitted.');
      return;
    }

    if (await canLaunchUrl(url)) {
      final success = await launchUrl(url);
      if (!success) {
        if (!context.mounted) return;
        _showErrorSnackBar(context, 'Failed to launch URL.');
      }
    } else {
      if (!context.mounted) return;
      _showErrorSnackBar(context, 'Could not find a suitable application to open this link.');
    }
  } catch (e) {
    if (!context.mounted) return;
    _showErrorSnackBar(context, 'Invalid URL format.');
  }
}

void _showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
      duration: const Duration(seconds: 3),
    ),
  );
}
