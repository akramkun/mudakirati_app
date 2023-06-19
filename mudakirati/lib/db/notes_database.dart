import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/note.dart';

class NotesDatabase {
  final url = '192.168.8.107:4000';
  Future<List<Note>> getData() async {
    var response = await http.get(Uri.http(url, 'todo'));
    var jsonData = jsonDecode(response.body)["data"];
    List<Note> dataList = [];
    for (var u in jsonData) {
      Note data = Note(
          id: u["_id"],
          title: u["title"],
          content: u["content"],
          createdAt: u["createdAt"],
          updatedAt: u["updatedAt"],
          completed: u["completed"]);
      dataList.add(data);
    }
    return dataList;
  }

  Future<int> create(String title, String content) async {
    await http.post(
      Uri.parse('http://${url}/todo/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'content': content,
      }),
    );
    return 0;
  }

  Future<List<Note>> readAllNotes() async {
    return await getData();
  }

  Future<int> update(Note note, String title, String content) async {
    await http.put(
      Uri.parse('http://${url}/todo/${note.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'content': content,
      }),
    );
    return 0;
  }

  Future<int> delete(dynamic id) async {
    await http.delete(Uri.parse('http://${url}/todo/$id'));
    return 0;
  }

  Future<int> deleteall(List<String> deletedItems) async {
    await http.post(
      Uri.parse('http://${url}/todo/deletemany'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, List<String>>{
        'todoIds': deletedItems,
      }),
    );
    return 0;
  }

  Future close() async {
    /*final db = await instance.database;

    db.close();*/
  }

  Future<List<Note>> searchNotes(String query) async {
    var response = await http.get(
      Uri.parse('http://${url}/todo/search?q=$query'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var jsonData = jsonDecode(response.body)["data"];
    List<Note> dataList = [];
    for (var u in jsonData) {
      Note data = Note(
          id: u["_id"],
          title: u["title"],
          content: u["content"],
          createdAt: u["createdAt"],
          updatedAt: u["updatedAt"],
          completed: u["completed"]);
      dataList.add(data);
    }

    return dataList;
  }
}
