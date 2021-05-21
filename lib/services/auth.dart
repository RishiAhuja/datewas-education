import 'package:datewas_education/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User _userFromFirebase(FirebaseUser user)
  // {
  //   return user != null ? User(userId: user.uid) : null;
  // }
  //
  // Future signInWithEmailAndPassword(String email, String password) async{
  //   try{
  //     UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
  //     FirebaseUser firebaseUser = result.user;
  //     print("Yes Sir!");
  //     return _userFromFirebase(firebaseUser);
  //   }catch(e) {
  //     print("No Sir! -> $e");
  //   }
  // }
  //
  // Future signUpWithEmailAndPassword(String email, String password) async{
  //   try{
  //     UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
  //     FirebaseUser firebaseUser = result.user;
  //     print("Yes Sir!");
  //     return _userFromFirebase(firebaseUser);
  //   }catch(e) {
  //     print("No Sir! -> $e");
  //   }
  // }
  //
  // Future resetPassword(String email) async{
  //   try{
  //     return await _auth.sendPasswordResetEmail(email: email);
  //   }catch(e) {
  //     print("No Sir! -> $e");
  //   }
  // }
  //
  // Future signOut() async{
  //   try{
  //     return await _auth.signOut();
  //   }catch(e) {
  //     print("No Sir! -> $e");
  //   }
  // }
  //
  // void sendOTP(String phoneNumber, PhoneCodeSent codeSent, PhoneVerificationFailed verificationFailed) {
  //   if (!phoneNumber.contains('+')) phoneNumber = '+91' + phoneNumber;
  //   _auth.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       timeout: Duration(seconds: 30),
  //       verificationCompleted: null,
  //       verificationFailed: verificationFailed,
  //       codeSent: codeSent,
  //       codeAutoRetrievalTimeout: null);
  // }






}