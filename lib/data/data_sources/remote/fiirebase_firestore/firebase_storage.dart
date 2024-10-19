import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

abstract class FirebaseStoragePost {
  Future<String> uploadFile(
      {required String folderName, required File postFile});
  Future<String> uploadData(
      {required String folderName, required Uint8List data});
  Future<void> deleteImageFromStorage(String previousImageUrl);
}

class FirebaseStoragePostImpl implements FirebaseStoragePost {
  final _firebaseStorage = FirebaseStorage.instance;

  @override
  Future<void> deleteImageFromStorage(String previousImageUrl) async {
    String previousFileUrl = Uri.decodeFull(basename(previousImageUrl))
        .replaceAll(RegExp(r'(\?alt).*'), "");
    final Reference firebaseStorageRef =
        _firebaseStorage.ref().child(previousFileUrl);
    await firebaseStorageRef.delete().then((value) {});
  }

  @override
  Future<String> uploadData(
      {required String folderName, required Uint8List data}) async {
    final fileName = DateTime.now().toString();
    final destination = 'data/$folderName/$fileName';

    final ref = _firebaseStorage.ref(destination);
    UploadTask uploadTask = ref.putData(data);
    String fileOfPostUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return fileOfPostUrl;
  }

  @override
  Future<String> uploadFile(
      {required String folderName, required File postFile}) async {
    final fileName = basename(postFile.path);
    final destination = 'files/$folderName/$fileName';
    final ref = _firebaseStorage.ref(destination);

    UploadTask uploadTask = ref.putFile(postFile);
    String fileOfPostUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return fileOfPostUrl;
  }
}
