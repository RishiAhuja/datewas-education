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

  syllabus1(int classText, userMap)
    {
      Firestore.instance.collection("${classText}S1").add(userMap);
    }
  syllabus2(int classText, userMap)
    {
      Firestore.instance.collection("${classText}S2").add(userMap);
    }
    textMaterial(int classText, userMap)
    {
      Firestore.instance.collection("${classText}TM").add(userMap);
    }
    PYQ(int classText, userMap)
    {
      Firestore.instance.collection("${classText}PYQ").add(userMap);
    }




  topicIdentification(String topic, String collection)
  async {
    return await Firestore.instance.collection("$collection").where("topic", isEqualTo: topic).getDocuments();
  }




}