import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:promissorynotemanager/data/note_data.dart';
import 'package:promissorynotemanager/dataprovider/authprovider.dart'
    as authprovider;
import 'package:promissorynotemanager/models/card.dart';
import 'package:promissorynotemanager/screens/create_note.dart';
import 'package:promissorynotemanager/screens/drawer_page.dart';
import 'package:promissorynotemanager/screens/interest_calculator.dart';
import 'package:promissorynotemanager/screens/notification_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _showBottomNavigationBar = true;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showBottomNavigationBar = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => CreateNotePage(
                  onAddNote: (NoteData note) {
                    setState(() {});
                  },
                ),
              ).then((value) {
                setState(() {});
              });
            },
            icon: const Icon(Icons.add),
          ),
          const SizedBox(width: 15),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              );
            },
            icon: const Icon(Icons.notification_add),
          ),
        ],
      ),
      drawer: const Drawer(
        child: DrawerPage(),
      ),
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
              ],
              onTap: _onItemTapped,
              selectedItemColor: Colors.blue,
              currentIndex: _selectedIndex,
            )
          : null,
    );
  }

  List<Widget> get screens => [
        ChangeNotifierProvider(
          // Wrap HomePageBody with Provider
          create: (_) => NoteProvider(),
          child: const HomePageBody(),
        ),
        const InterestCalculatorPage(),
      ];
}

class NoteProvider extends ChangeNotifier {
  List<NoteData> _notes = []; // Private list to store notes
  bool _isLoading = false; // To track loading state

  List<NoteData> get notes => _notes;
  bool get isLoading => _isLoading;

  Future<void> fetchNotes(String? userId) async {
    if (userId == null) return; // Handle null user ID

    _isLoading = true; // Start loading
    notifyListeners(); // Notify listeners to show loading state

    try {
      final userNotesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notes');

      final querySnapshot = await userNotesCollection.get();

      _notes = querySnapshot.docs.map((DocumentSnapshot document) {
        return NoteData.fromMap(document.data() as Map<String, dynamic>)
          ..noteId = document.id;
      }).toList();
    } catch (e) {
      // Handle errors appropriately
      print('Error fetching notes: $e');
    } finally {
      _isLoading = false; // Stop loading
      notifyListeners(); // Notify listeners about updated data
    }
  }
}

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});
  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  @override
  void initState() {
    super.initState();
    // Fetch notes when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      final authProvider =
          Provider.of<authprovider.AuthProvider>(context, listen: false);
      noteProvider.fetchNotes(authProvider.user?.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, _) {
        if (noteProvider.isLoading) {
          // Show a loading indicator while fetching notes
          return const Center(child: CircularProgressIndicator());
        }

        // return FutureBuilder<void>(
        //   future: Future.delayed(Duration(seconds: 2)), // 2-second delay
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(child: CircularProgressIndicator());
        //     } else {
        //       return StreamBuilder<QuerySnapshot<Object>?>(
        //         stream: (authProvider.user != null)
        //             ? FirebaseFirestore.instance
        //                 .collection('users')
        //                 .doc(authProvider.user!.uid)
        //                 .collection('notes')
        //                 .snapshots()
        //             : Stream.value(null),
        //         builder: (context, snapshot) {
        //           if (snapshot.hasError) {
        //             // Handle the error in a more user-friendly way
        //             return const Center(
        //                 child: Text(
        //                     "Error loading notes. Please try again later.")); // Custom error message
        //           }

        //           if (snapshot.connectionState == ConnectionState.waiting) {
        //             return const Center(child: CircularProgressIndicator());
        //           }

        //           // Check if data is available and not empty
        //           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        //             return const Center(child: Text("No notes available"));
        //           }

        //           final notes =
        //               snapshot.data!.docs.map((DocumentSnapshot document) {
        //             return NoteData.fromMap(
        //                 document.data() as Map<String, dynamic>)
        //               ..noteId = document.id;
        //           }).toList();

        return RefreshIndicator(
          onRefresh: () async => noteProvider.fetchNotes(
              Provider.of<authprovider.AuthProvider>(context, listen: false)
                  .user
                  ?.uid),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Theme.of(context).primaryColorDark
                                  : Colors.grey[200],
                        ),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final noteData = noteProvider.notes[index];
                    final noteId = noteData.noteId;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8.0),
                      child: NewCard(noteId: noteId),
                    );
                  },
                  childCount: noteProvider.notes.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
