import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBiiwMzRvWa94zYMrQk67rcaXrVrL8Csbk",
            authDomain: "swarmify-16a5a.firebaseapp.com",
            projectId: "swarmify-16a5a",
            storageBucket: "swarmify-16a5a.firebasestorage.app",
            messagingSenderId: "585338785973",
            appId: "1:585338785973:web:e2ea4aafe876f1caaa2efc",
            measurementId: "G-ZD14Z1MMYP"));
  } else {
    await Firebase.initializeApp();
  }
}
