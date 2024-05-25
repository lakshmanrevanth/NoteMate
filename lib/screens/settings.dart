import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:promissorynotemanager/main.dart'; // Import your ThemeProvider

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<ThemeProvider>(
                // Use Consumer to rebuild when theme changes
                builder: (context, themeProvider, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Dark Mode",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Switch(
                        value: themeProvider
                            .isDarkMode, // Directly use isDarkMode from ThemeProvider
                        onChanged: (value) {
                          themeProvider.toggleTheme(); // Update the theme
                        },
                      ),
                    ],
                  );
                },
              ),
              // ... other settings (if any)
            ],
          ),
        ),
      ),
    );
  }
}
