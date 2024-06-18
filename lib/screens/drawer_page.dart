import 'package:flutter/material.dart';
import 'package:promissorynotemanager/dataprovider/authprovider.dart'
    as authprovider;
import 'package:promissorynotemanager/screens/assets_page.dart';
import 'package:promissorynotemanager/screens/login_page.dart';
import 'package:promissorynotemanager/screens/test.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:promissorynotemanager/screens/interest_calculator.dart';
import 'package:promissorynotemanager/screens/settings.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});
  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<authprovider.AuthProvider>(context);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 250,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).primaryColorLight
                        : const Color.fromARGB(255, 225, 225, 225),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: authProvider.profilePictureUrl != null
                            ? NetworkImage(authProvider.profilePictureUrl!)
                            : null, // Use NetworkImage with the URL
                        child: authProvider.profilePictureUrl == null
                            ? const Icon(Icons.person) // Placeholder icon
                            : null,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${authProvider.user?.displayName}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${authProvider.user?.email}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calculate),
                title: const Text('Interest Calculator'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InterestCalculatorPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.wallet),
                title: const Text('My Assets'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AssetsPage(),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                onTap: () => openDialog(),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout', style: TextStyle(color: Colors.red)),
          onTap: () async {
            // Show a confirmation dialog
            bool? confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to log out?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false), // Cancel
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true), // Confirm
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );

            if (confirm ?? false) {
              // Check if the user confirmed logout
              await authProvider.signOut();

              // After sign-out, navigate back to LoginPage
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LogInPage()),
                (route) => false,
              );
            }
          },
        ),
      ],
    );
  }

  Future<void> _launchUrl(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        // Fallback option: show a snackbar with the URL to copy
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch URL: $url')),
        );
      }
    } catch (e) {
      // Show a general error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while launching the URL.')),
      );
    }
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "About",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Make column as small as possible
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Promissory Note Manager",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Version 1.0.0",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              const Text(
                "Developed by:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text("R Lakshman Revanth"),
              const SizedBox(height: 10),
              InkWell(
                // Make GitHub link tappable
                onTap: () async {
                  final url = Uri.parse('https://github.com/lakshmanrevanth');
                  await _launchUrl(url); // Use _launchUrl here
                },
                child: const Text(
                  'GitHub Profile',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Open Source Contributions:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text("List your open source contributions here"),
              const SizedBox(height: 20),
              const Text(
                "Contact:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              InkWell(
                // Make email tappable
                onTap: () async {
                  final url = Uri(
                      scheme: 'mailto',
                      path:
                          'lakshman6668@gmail.com'); // Replace with your email
                  await _launchUrl(url); // Use _launchUrl here
                },
                child: const Text(
                  'lakshman6668@gmail.com',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Need Help?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                  "Visit our Help Center"), // Replace with your help link
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
}
