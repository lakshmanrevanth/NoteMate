import 'package:flutter/material.dart';
import 'package:promissorynotemanager/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:promissorynotemanager/dataprovider/authprovider.dart'
    as authprovider;
import 'package:provider/provider.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<authprovider.AuthProvider>(context);

// Now you can access:

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).primaryColorDark
          : const Color.fromRGBO(249, 249, 249, 1),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).primaryColorLight
                        : const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(30),
                  child: const Icon(
                    Icons.description_outlined,
                    size: 80,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  "Get Started,",
                  style: TextStyle(
                    fontSize: screenSize.width * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Securely Manage Your Financial Agreements.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.05,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).primaryColorLight
                        : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: TextStyle(fontSize: screenSize.width * 0.045),
                    ),
                    onPressed: () async {
                      UserCredential? userCredential =
                          await authProvider.signInWithGoogle();
                      if (userCredential != null) {
                        Navigator.pushReplacement(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      } else {
                        print("Sign-in failed, not navigating.");
                      }
                    },
                    child: const Text("Continue with Google",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Made with Flutter"),
                    const SizedBox(width: 5),
                    Icon(Icons.favorite,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).primaryColorLight
                            : Colors.black,
                        size: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
