import 'package:flutter/material.dart';
import '../db/notes_database.dart';
import '../model/custom_datetime_converter.dart';
import '../model/note.dart';

class NoteDetailPage extends StatefulWidget {
  const NoteDetailPage({
    Key? key,
    required this.gnote,
  }) : super(key: key);

  final Note gnote;
  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  var titleController = TextEditingController();
  var contentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    if (widget.gnote.id != null) {
      note = widget.gnote;
      titleController = TextEditingController(text: note.title);
      contentController = TextEditingController(text: note.content);
    } else {
      note = const Note(title: 'title', content: 'content');
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [saveButton(), deleteButton()],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    if (note.createdAt != null)
                      Text(
                        CustomDateTimeConverter()
                            .calculateDifference(note.createdAt!),
                        style: const TextStyle(color: Colors.white38),
                      ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                        hintStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: contentController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Note',
                        hintStyle:
                            TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ],
                ),
              ),
      );

  Widget saveButton() => IconButton(
        icon: const Icon(Icons.save_outlined),
        onPressed: () async {
          if (isLoading) return;

          setState(() {
            setState(() => isLoading = true);
          });

          if (note.id != null) {
            await NotesDatabase()
                .update(note, titleController.text, contentController.text);
          } else {
            await NotesDatabase()
                .create(titleController.text, contentController.text);
          }

          setState(() {
            setState(() => isLoading = false);
          });

          // await Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const NotePage()),
          // );
          // Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pop(context, 'done');
        },
      );
  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          setState(() {
            setState(() => isLoading = true);
          });

          await NotesDatabase().delete(note.id);

          setState(() {
            setState(() => isLoading = false);
          });

          Navigator.pop(context, 'done');
        },
      );
}
