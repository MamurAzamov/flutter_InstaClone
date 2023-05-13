
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:insta_clone/services/auth_service.dart';

class FileService {
  static final _storage = FirebaseStorage.instance.ref();
  static final folder_user = "User_images";

  static Future<String> uploadUserImage(File _image) async {
    String uid = AuthService.currentUserId();
    String img_name = uid;
    var firebaseStoragwRef = _storage.child(folder_user).child(img_name);
    var uploadTask = firebaseStoragwRef.putFile(_image);
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
    final String downloadUrl = await firebaseStoragwRef.getDownloadURL();
    print(downloadUrl);
    return downloadUrl;
  }
}