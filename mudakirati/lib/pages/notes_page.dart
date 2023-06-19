import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import '../db/notes_database.dart';
import '../widgets/note_card_widget.dart';
import './note_detail_page.dart';
import '../model/note.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late List<Note> notes = [];
  late TextEditingController searchController;

  bool isLoading = false;
  bool isSearching = false;
  bool isVisible = true;
  late List<int> selectedItems = [];
  late List<String> deletedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isVisible
          ? Transform.translate(
              offset: const Offset(0, -5),
              child: FloatingActionButton(
                backgroundColor: Colors.orange,
                child: const Icon(Icons.add),
                onPressed: () async {
                  final res = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              const NoteDetailPage(gnote: Note.c())));
                  if (res != null) {
                    refreshNotes();
                  }
                },
              ),
            )
          : null,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SafeArea(
              child: SizedBox(
                height: 80,
                width: double.infinity,
                child: isSearching
                    ? Row(children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            isSearching = false;
                            refreshNotes();
                          },
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: TextField(
                              controller: searchController,
                              onChanged: (text) async {
                                setState(() =>
                                    {isLoading = true, isSearching = true});
                                notes = await NotesDatabase()
                                    .searchNotes(searchController.text);
                                setState(() => isLoading = false);
                              },
                              decoration: InputDecoration(
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'search ...',
                                suffixIcon: const Icon(Icons.search),
                                suffixIconColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ])
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: selectedItems.isEmpty
                                ? Container()
                                : IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        selectedItems.clear();
                                      });
                                    },
                                  ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                selectedItems.isEmpty
                                    ? 'Notes'
                                    : '${selectedItems.length.toString()} item selected',
                                style: const TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: selectedItems.isEmpty
                                ? IconButton(
                                    onPressed: () {
                                      setState(() => isSearching = true);
                                      // print('select item ${isSearching}');
                                    },
                                    icon: const Icon(Icons.search),
                                  )
                                : Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          fillDeletedItems();
                                          final res = await NotesDatabase()
                                              .deleteall(deletedItems);
                                          if (res == 0) {
                                            selectedItems.clear();
                                            refreshNotes();
                                          }

                                          // print('select item ${selectedItems}');
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (selectedItems.length ==
                                                notes.length) {
                                              selectedItems.clear();
                                            } else {
                                              selectedItems.clear();
                                              for (int i = 0;
                                                  i < notes.length;
                                                  i++) {
                                                selectedItems.add(i);
                                              }
                                            }
                                          });
                                          // print('select item ${selectedItems}');
                                        },
                                        icon: const Icon(Icons.select_all),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
              ),
            ),
            Expanded(
              child: Center(
                child: LiquidPullToRefresh(
                  onRefresh: refreshNotes,
                  animSpeedFactor: 2,
                  showChildOpacityTransition: false,
                  color: Colors.orange,
                  child: StreamBuilder(
                      stream: Connectivity().onConnectivityChanged,
                      builder: (context,
                          AsyncSnapshot<ConnectivityResult> snapshot) {
                        if (snapshot.hasData &&
                            // snapshot != null &&
                            snapshot.data != ConnectivityResult.none) {
                          return isLoading
                              ? buildEffects()
                              : notes.isEmpty
                                  ? Text('No Notes ${notes.length}')
                                  : NotificationListener<
                                          UserScrollNotification>(
                                      onNotification: (notification) {
                                        if (notification.direction ==
                                            ScrollDirection.forward) {
                                          setState(() => isVisible = true);
                                        } else if (notification.direction ==
                                            ScrollDirection.reverse) {
                                          setState(() => isVisible = false);
                                        }
                                        return true;
                                      },
                                      child: buildNotes());
                        } else {
                          return const Icon(
                            Icons.wifi_off,
                            //color: Colors.orange,
                            size: 50,
                          );
                        }
                      }),
                ),
              ),
            ),
          ]),
    );
  }

  Widget buildEffects() => StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8),
        itemCount: 10,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (BuildContext context, int index) {
          double a = 150.0 + Random().nextInt(200 - 150);
          return Shimmer.fromColors(
            baseColor: Colors.black12,
            highlightColor: Colors.black26,
            child: Card(
              child: Container(
                height: a,
                width: 150,
                padding: const EdgeInsets.all(10),
              ),
            ),
          );
        },
      );
  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (BuildContext context, int index) {
          final notee = notes[index];
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(gnote: notee),
              ));

              refreshNotes();
            },
            onLongPress: () {
              doMultiSelect(index);
              //todo sort periority+add colors+cache+login+reminder+vocal_Note
            },
            child: NoteCardWidget(
              note: notee,
              index: index,
              isSelected: selectedItems.contains(index),
            ),
          );
        },
      );
  Future refreshNotes() async {
    setState(() => isLoading = true);
    notes = await NotesDatabase().readAllNotes();
    notes.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    refreshNotes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool doMultiSelect(int index) {
    bool isSelected = selectedItems.contains(index);
    setState(() {
      if (selectedItems.contains(index)) {
        selectedItems.remove(index);
      } else {
        selectedItems.add(index);
      }
    });

    return isSelected;
  }

  void fillDeletedItems() {
    for (int i = 0; i < selectedItems.length; i++) {
      deletedItems.add(notes[selectedItems[i]].id);
    }
  }
}
