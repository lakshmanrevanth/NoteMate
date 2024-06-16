import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class TestWidget extends StatelessWidget {
  TestWidget({super.key});
  final Uri url = Uri(
    scheme: 'mailto',
    path: "revanth3527@gmail.com",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
              onPressed: () async {
                try {
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                } catch (e) {
                  // Handle
                }
              },
              child: const Text("LAUNCH"))),
    );
  }
}
