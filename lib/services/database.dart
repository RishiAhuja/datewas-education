import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods
{
  getUsersByUsername()
  async {
    QuerySnapshot snap = await
    Firestore.instance.collection('users').getDocuments();
  }

  uploadUserInfo(userMap)
  {
    Firestore.instance.collection("users").add(userMap);
  }




  videoMaterialUpload(int classText, userMap)
  {
    Firestore.instance.collection("${classText}thVideoMaterial").add(userMap);
  }

  questionUpload(int classText, userMap)
  {
    Firestore.instance.collection("${classText}thQuestionBank").add(userMap);
  }

  solutionUpload(int classText, userMap)
  {
    Firestore.instance.collection("${classText}thSolution").add(userMap);
  }

  zoomUpload(int classText, userMap)
  {
    Firestore.instance.collection("${classText}thZoomLink").add(userMap);
  }

  questionSubmission(int classText, userMap)
  {
    Firestore.instance.collection("${classText}thQuestionBankSub").add(userMap);
  }

  solutionSubmission(int classText, userMap)
  {
    Firestore.instance.collection("${classText}thSolutionSub").add(userMap);
  }

}