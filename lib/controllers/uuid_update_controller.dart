import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/uuid.dart';

final uuidUpdateControllerProvider =
    ChangeNotifierProvider((ref) => UuidUpdateController());

class UuidUpdateController extends ChangeNotifier {
  
  Future<void> uuidAdd() async {
    if (kDebugMode) {
      final collectionRef = FirebaseFirestore.instance.collection('itList');
      final querySnapshot = await collectionRef.get();
      final queryDocSnapshot = querySnapshot.docs;
      for (final snapshot in queryDocSnapshot) {
        final data = snapshot.id;
        FirebaseFirestore.instance
            .collection('itList')
            .doc(data)
            .update({'uuid': uuid});
      }
    }
  }
}