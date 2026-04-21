import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> safeLaunchUrl(BuildContext context, String urlString) async {
  final Uri? uri = Uri.tryParse(urlString);

  void showError() {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid or unsafe link'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  if (uri == null) {
    showError();
    return;
  }

  final validSchemes = ['https', 'http', 'mailto'];
  if (!validSchemes.contains(uri.scheme.toLowerCase())) {
    showError();
    return;
  }

  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showError();
    }
  } catch (e) {
    showError();
  }
}
