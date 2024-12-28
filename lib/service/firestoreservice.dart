import 'package:cloud_firestore/cloud_firestore.dart';
class firestoreService{
  //ref
  final CollectionReference notes = FirebaseFirestore.instance.collection("notes");
  //add
  Future<void> addNote(String note){
    return notes.add({
      "note": note,
      "timestamp": Timestamp.now(),
    });
  }
  //read
  Stream<QuerySnapshot> readNote(){
    final notesStream = notes.orderBy('timestamp',descending: true).snapshots();

    return notesStream;
  }
  //update
  Future<void> updateNote(String docID,String newnote){
    return notes.doc(docID).update({
      'note': newnote,
      'timestamp':Timestamp.now(),
    });
  }
  //delete
  Future<void> deleteNote(String docID){
    return notes.doc(docID).delete();
  }
}