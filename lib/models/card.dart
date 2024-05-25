import 'package:flutter/material.dart';
import 'package:promissorynotemanager/screens/details_page.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
            vertical: 8, horizontal: 8), // Add margin for spacing between cards
        child: Card(
          elevation: 2, // Add a subtle shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ), // Rounded corners
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the start
              children: [
                ClipRRect(
                  child: Image.asset(
                    'lib/assets/images/logo.jpg',
                    height: 135,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'R. Naga Srinivasa Rao', // Replace with artist/performer name
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color.fromARGB(255, 30, 30,
                                30), // Lighter color for secondary information
                      ),
                    ),
                    Text(
                      'June 2024', // Replace with a more specific date or time
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
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
