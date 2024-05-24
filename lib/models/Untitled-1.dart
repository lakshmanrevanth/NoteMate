import 'package:flutter/material.dart';
import 'package:promissorynotemanager/screens/assets_page.dart';
import 'package:promissorynotemanager/screens/create_note.dart';
import 'package:promissorynotemanager/screens/interest_calculator.dart';
// ... (your other imports: EventCard, InterestCalculatorPage, AssetsPage, CreateNotePage)

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _showBottomNavigationBar = true; // Track bottom nav bar visibility

  final List<Widget> screens = [
    const HomePageBody(),
    const InterestCalculatorPage(),
    const AssetsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showBottomNavigationBar = true; // Show when switching tabs
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: _showBottomNavigationBar // Conditional rendering
          ? BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Interest',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Assets',
          ),
                // ... (Your existing BottomNavigationBarItem code) ...
              ],
              onTap: _onItemTapped,
              selectedItemColor: Colors.blue,
              currentIndex: _selectedIndex,
            )
          : null, // Hide when _showBottomNavigationBar is false
    );
  }
}

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
                  child: Image.asset(
                    'lib/assets/images/logo.jpg',
                    width: 44,
                    height: 46,
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  children: [
                    IconButton( // "Add" button
              onPressed: () {
                // Hide the bottom navigation bar
                (context as Element).markNeedsBuild(); // Trigger rebuild to hide bottom bar

                // Show the bottom sheet
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true, // Allow the sheet to cover the nav bar
                  builder: (context) => const CreateNotePage(),
                ).then((value) { // Restore bottom bar after closing
                  (context as Element).markNeedsBuild();
                });
              },
              icon: const Icon(Icons.add),
            ),
                    
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notification_add),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: 25),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => const EventCard(),
              ),
            ),
          
            // ... (Your existing header, search bar, and ListView.builder code)

            
          ],
        ),
      ),
    );
  }
}

// ... (Your other widget classes: InterestCalculatorPage, AssetsPage, CreateNotePage, EventCard) ...
