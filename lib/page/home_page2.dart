import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/service/firestoreservice2.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  final firestoreService2 ff = firestoreService2();
  final TextEditingController noteController = TextEditingController();

  // Dialog for delete
  void showDailogdel(String docID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: const Text(
          "Are you sure you want to delete\nthe note?",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(90, 40),
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () {
              ff.deleteNote(docID); // Delete the note using the docID
              Navigator.pop(context); // Close the dialog
            },
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(90, 40),
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text(
              "No",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }

  void showdialog({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: noteController,
          decoration: InputDecoration(
            hintText: docID == null ? "Enter note" : "Update note",
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              if (noteController.text.isNotEmpty) {
                if (docID == null) {
                  // Adding a new note
                  ff.addNote(noteController.text);
                } else {
                  // Updating an existing note
                  ff.updateNote(docID, noteController.text);
                }
                noteController.clear();
              }
              Navigator.pop(context);
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Center(
          child: Text(
            "Short Note",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        onPressed: () {
          showdialog(); // Correctly call showdialog with no parameters for a new note
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ff.readNote(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 90,
                    width: 380,
                    child: Card(
                      color: Colors.redAccent.shade200,
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          noteText,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => showdialog(docID: docID),
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () => showDailogdel(docID),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No data"));
          }
        },
      ),
    );
  }
}
