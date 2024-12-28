import 'package:cloud_firestore/cloud_firestore.dart';

class firestoreService2 {
  //ref
  final CollectionReference notes2 =
      FirebaseFirestore.instance.collection("notes2");
  //add
  Future<void> addNote(String note) {
    return notes2.add({
      "note": note,
      "timestamp": Timestamp.now(),
    });
  }

  //read
  Stream<QuerySnapshot> readNote() {
    final notesStream =
        notes2.orderBy('timestamp', descending: true).snapshots();

    return notesStream;
  }

  //update
  Future<void> updateNote(String docID, String newnote) async {
    notes2.doc(docID).update({
      'note': newnote,
      'timestamp': Timestamp.now(),
    });
  }

  //delete
  Future<void> deleteNote(String docID) async {
    notes2.doc(docID).delete();
  }
}
