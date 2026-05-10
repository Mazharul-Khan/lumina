import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lumina/core/entity/vault_item.dart';
import 'package:lumina/main.dart';
import 'package:lumina/screens/item_details_screen.dart';
import 'package:lumina/screens/quick_note_screen.dart';
import 'package:lumina/widgets/animated_slidable_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<int> _deletingIds = {};

  Future<void> _deleteItem(VaultItem item) async {
    setState(() {
      _deletingIds.add(item.id);
    });
    await Future.delayed(Duration(milliseconds: 900));
    objectBox.vaultBox.remove(item.id);
    if (!mounted) return;
    setState(() {
      _deletingIds.remove(item.id);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final items = objectBox.vaultBox.getAll();
    final summaryIds = <int>{};
    for(final s in objectBox.summaryBox.getAll()){
        if(s.item.targetId!=0){
          summaryIds.add(s.item.targetId);
        }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Lumina")),
      body: items.isEmpty
          ? Center(child: Text("No Notes Yet"))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, i) {
                final item = items[i];
                final isDeleting = _deletingIds.contains(item.id);
                final hasSummary = summaryIds.contains(item.id);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AnimatedOpacity(
                    opacity: isDeleting ? 0.0 : 1.0,
                    duration: Duration(milliseconds: 850),
                    curve: Curves.easeIn,
                    child: AnimatedScale(
                      scale: isDeleting ? 0.7 : 1.0,
                      duration: const Duration(milliseconds: 850),
                      curve: Curves.easeInBack,
                      child: AnimatedSlide(
                        offset: isDeleting ? Offset(1.5, 0) : Offset.zero,
                        duration: Duration(milliseconds: 850),
                        curve: Curves.easeInBack,
                        child: Slidable(
                          key: ValueKey(item.id),
                          startActionPane: ActionPane(
                            motion: BehindMotion(),
                            extentRatio: 0.32,
                            children: [
                              CustomSlidableAction(
                                onPressed: (_) {
                                  _deleteItem(item);
                                },
                                padding: EdgeInsets.zero,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFFFF5F5),
                                        Color(0xFFFF2D2D),
                                        Color(0xFFB30000),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x55FF0000),
                                        blurRadius: 8,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),

                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          ),
                                          size: 30,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Delete",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              255,
                                              255,
                                              255,
                                            ),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const BehindMotion(),
                            extentRatio: 0.34,
                            children: [
                              CustomSlidableAction(
                                onPressed: (_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("AI Action coming soon!"),
                                    ),
                                  );
                                },
                                padding: EdgeInsets.zero,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4A148C),
                                        Color(0xFF1565C0),
                                        Color(0xFFEAF2FF),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x554A148C),
                                        blurRadius: 18,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.auto_awesome,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "AI",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          child: Builder(
                            
                            builder: (context) {
                              return AnimatedSlidableCard(
                                item: item,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ItemDetailsScreen(item: item),
                                    ),
                                  );
                                },
                                hasSummary: hasSummary
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: GestureDetector(
        onLongPress: () async {
          final res = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QuickNoteScreen()),
          );

          if (res == true) {
            setState(() {});
          }
          ;
        },
        child: FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
      ),
    );
  }
}
