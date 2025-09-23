import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAM1j45-OJfRnY5UOFZS2gGhYmjOdbXVtc",
            authDomain: "opt2-n5y3g4.firebaseapp.com",
            projectId: "opt2-n5y3g4",
            storageBucket: "opt2-n5y3g4.appspot.com",
            messagingSenderId: "528920830753",
            appId: "1:528920830753:web:842eab3bbe7232e5e55460",
            measurementId: "G-NRGM7BS10H"));
  } else {
    await Firebase.initializeApp();
  }
}
