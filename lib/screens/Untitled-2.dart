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
  bool showBottomNavigationBar = true;

  final List<Widget> screens = [
    const HomePageBody(),
    const InterestCalculatorPage(),
    const AssetsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      showBottomNavigationBar = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }
}

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(
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
                        setState(() {});
                        showBottomSheet(
                          context: context,
                          builder: (context) => CreateNotePage(),
                        );
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
