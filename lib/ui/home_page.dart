import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';

// ================= SPLASH PAGE =================
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  bool isClosing = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnim = Tween(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  void goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }

  void handleTap() async {
    setState(() => isClosing = true);
    await Future.delayed(Duration(milliseconds: 500));
    goHome();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleTap,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 146, 74, 255),
                    Color.fromARGB(255, 153, 98, 255),
                    Color.fromARGB(255, 153, 98, 255),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, _) {
                  return Opacity(
                    opacity: _fadeAnim.value,
                    child: Transform.scale(
                      scale: _scaleAnim.value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              // ignore: deprecated_member_use
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 15,
                                )
                              ],
                            ),
                            child: Icon(
                              Icons.auto_stories_rounded,
                              size: 70,
                              color: Color(0xFF5e35b1),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Hoşgeldiniz",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Devam etmek için dokun",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            AnimatedOpacity(
              opacity: isClosing ? 1 : 0,
              duration: Duration(milliseconds: 500),
              child: Container(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= HOME PAGE =================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late Future<List<Note>> _notesFuture;

  late AnimationController _fabController;
  late Animation<double> _fabAnim;

  String _searchQuery = '';
  bool _sortAsc = false; // false: yeni önce, true: eski önce
  List<Note> _allNotes = [];
  late TextEditingController _searchController;

  List<Note> get _filteredNotes {
    List<Note> filtered = _allNotes.where((note) =>
      note.title.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
    filtered.sort((a, b) => _sortAsc ? a.date.compareTo(b.date) : b.date.compareTo(a.date));
    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _notesFuture = NoteService.getNotes();
    _searchController = TextEditingController();

    _fabController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Daha hızlı animasyon
    );

    _fabAnim = CurvedAnimation(
      parent: _fabController,
      curve: Curves.elasticOut,
    );

    _fabController.forward();
  }

  void refreshNotes() {
    setState(() {
      _notesFuture = NoteService.getNotes();
    });
  }

  // ➕ ADD NOTE
  void addNote() {
    final title = TextEditingController();
    final content = TextEditingController();
    DateTime? selectedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return Container(
              decoration: BoxDecoration(
                color: Color(0xFFEDE7F6),
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Color(0xFFAB47BC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Yeni Not",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E004F),
                    ),
                  ),

                  SizedBox(height: 15),

                  TextField(
                    controller: title,
                    decoration: InputDecoration(
                      labelText: "Başlık",
                      filled: true,
                      fillColor: Color.fromARGB(255, 237, 206, 255),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  TextField(
                    controller: content,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "İçerik",
                      filled: true,
                      fillColor: Color.fromARGB(255, 237, 206, 255),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  InkWell(
                    onTap: () async {
                      selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      setStateSB(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 237, 206, 255),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month,
                              color: Color.fromARGB(255, 120, 1, 175)),
                          SizedBox(width: 10),
                          Text(
                            selectedDate == null
                                ? "Tarih seç"
                                : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7B1FA2),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      final note = Note()
                        ..title = title.text
                        ..content = content.text
                        ..date = selectedDate ?? DateTime.now();

                      await NoteService.addNote(note);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      refreshNotes();
                    },
                    child: Text("Kaydet", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 🗑 LONG PRESS DELETE
  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xFFEDE7F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text("Notu silmek istiyor musun?", style: TextStyle(color: Color(0xFF2E004F))),
        content: Text("Bu işlem geri alınamaz.", style: TextStyle(color: Color(0xFF4A148C))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("İptal", style: TextStyle(color: Color(0xFF7B1FA2))),
          ),
          TextButton(
            onPressed: () async {
              await NoteService.deleteNote(id);
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              refreshNotes();
            },
            child: Text("Sil", style: TextStyle(color: Color(0xFF7B1FA2))),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showSearchDialog() {
    _searchController.text = _searchQuery; // Mevcut arama metnini göster
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xFFEDE7F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text("Başlığa Göre Ara", style: TextStyle(color: Color(0xFF2E004F))),
        content: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
          decoration: InputDecoration(
            hintText: "Başlık ara...",
            filled: true,
            fillColor: Color(0xFFF3E5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              setState(() => _searchQuery = '');
            },
            child: Text("Temizle", style: TextStyle(color: Color(0xFF7B1FA2))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Kapat", style: TextStyle(color: Color(0xFF7B1FA2))),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xFFEDE7F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text("Tarih Sıralaması", style: TextStyle(color: Color(0xFF2E004F))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<bool>(
              title: Text("Yeni Notlar Önce"),
              value: false,
              // ignore: deprecated_member_use
              groupValue: _sortAsc,
              // ignore: deprecated_member_use
              onChanged: (value) {
                setState(() => _sortAsc = value!);
                Navigator.pop(context);
              },
              activeColor: Color(0xFF7B1FA2),
            ),
            RadioListTile<bool>(
              title: Text("Eski Notlar Önce"),
              value: true,
              // ignore: deprecated_member_use
              groupValue: _sortAsc,
              // ignore: deprecated_member_use
              onChanged: (value) {
                setState(() => _sortAsc = value!);
                Navigator.pop(context);
              },
              activeColor: Color(0xFF7B1FA2),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDE7F6), // Daha koyu pastel mor arka plan

      appBar: AppBar(
        title: Text("Notlarım", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 165, 56, 255), // Daha koyu mor app bar
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: _showFilterDialog,
          ),
        ],
      ),

      body: FutureBuilder<List<Note>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B1FA2)),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Notlar yüklenirken hata oluştu: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            final notes = snapshot.data ?? [];
            if (_allNotes != notes) {
              _allNotes = notes;
            }
            final filteredNotes = _filteredNotes;
            return filteredNotes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notes,
                            size: 80, color: Color.fromARGB(255, 120, 1, 175)),
                        SizedBox(height: 10),
                        Text(
                          _searchQuery.isNotEmpty ? "Arama sonucu bulunamadı" : "Henüz not yok",
                          style: TextStyle(color: Color(0xFF4A148C)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: filteredNotes.length,
                    itemBuilder: (_, i) {
                      final n = filteredNotes[i];

                      return GestureDetector(
                        onLongPress: () => confirmDelete(n.id),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFE1BEE7),
                                Color(0xFFBA68C8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Color(0xFF7B1FA2).withOpacity(0.1),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              n.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E004F),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Text(n.content),
                                SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    n.date.toString().split(' ')[0],
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
          }
        },
      ),

      floatingActionButton: ScaleTransition(
        scale: _fabAnim,
        child: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 153, 0, 255),
          onPressed: addNote,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}