import 'package:flutter/material.dart';
import 'package:promissorynotemanager/models/card.dart';
import 'package:promissorynotemanager/screens/assets_page.dart';
import 'package:promissorynotemanager/screens/create_note.dart';
import 'package:promissorynotemanager/screens/interest_calculator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _showBottomNavigationBar = true;

  final List<Widget> screens = [
    const HomePageBody(),
    const InterestCalculatorPage(),
    const AssetsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showBottomNavigationBar = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: _showBottomNavigationBar
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
              ],
              onTap: _onItemTapped,
              selectedItemColor: Colors.blue,
              currentIndex: _selectedIndex,
            )
          : null,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    IconButton(
                      onPressed: () {
                        (context as Element).markNeedsBuild();

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => const CreateNotePage(),
                        ).then((value) {
                          (context as Element).markNeedsBuild();
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                    const SizedBox(width: 15),
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
          ],
        ),
      ),
    );
  }
}
