import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadProductImage({required File imageFile}) async {
    String unixTime = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    final fileName = imageFile.path.split('/').last;
    final fileNameArray = fileName.split('.');
    final fileNameAndTime = '${fileNameArray[0]}${unixTime}${fileNameArray[1]}';

    try {
      final uploadTask = await _firebaseStorage
          .ref('products/$fileNameAndTime')
          .putFile(imageFile);
      final imageUrl = await uploadTask.ref.getDownloadURL();
      return imageUrl;
    } on FirebaseException catch (e) {
      print(e);
    }
  }
  
}
