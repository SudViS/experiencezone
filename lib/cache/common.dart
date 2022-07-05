import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/quiz_screen.dart';


class Common {

  List<Questionz> quizList = [

    Questionz(
      false,
      "Q1. What is the purpose of Life insurances ?",
      "Secure healthcare cover",
      "Secure Vehicles damage cover",
      "Secure Life cover",
      "Secure travel cover",
      "Yes",
      "No",
      "No",
      "No",
    ),
    Questionz(
        false,
        "Q2. What is the average duration of Term Life Insurance policy ?",
        "1 Year",
        "Between 5 years to 40 years or till age 99",
        "1-3 Year",
        "Less than 1 year (180 days limit) ",
        "No",
        "Yes",
        "No",
        "No"),
    Questionz(
        false,
        "Q3. Which of the following insurance policies are correctly matched with their purpose",
        "Health Insurance - Hospital Bills Payment",
        "Motor Insurance - Repair car dent",
        "Travel Insurance - Luggage Misplace",
        "All of the above",
        "No",
        "No",
        "No",
        "Yes"),
    Questionz(
        false,
        "Q4. Which of the following insurance policies are correctly categorized",
        "Term Life Insurance - Endowment Plans",
        "Education Insurance - Study related plans",
        "Financial Insurance - Business loss",
        "All of the above",
        "No",
        "No",
        "No",
        "Yes"),
    Questionz(
      false,
      "Q5. Choose Insurance plans you expect to have maximum coverage amount ",
      "Term Life Insurance",
      "Health Insurance",
      "Motor Insurance",
      "Fire Insurance",
      "Yes",
      "No",
      "No",
      "No",
    ),
    Questionz(
      false,
      "Q6. Which Insurance plan that is most important to buy",
      "Travel Insurance",
      "Health Insurance",
      "Motor Insurance",
      "Fire Insurance",
      "No",
      "Yes",
      "No",
      "No",
    ),
    Questionz(
        false,
        "Q7. What is the purpose of cyber insurances",
        "Online Frauds or privacy breach",
        "Pregnancy based complications",
        "Business loss cover",
        "Domestic Animals cover	",
        "Yes",
        "No",
        "No",
        "No"),
    Questionz(
      false,
      "Q8. The main purpose of life insurance is to:",
      "Meet an insured person’s debts and other financial commitments in the event of death.",
      "Make up for loss of earnings if an insured person is unable to ever work again.",
      "Pay for urgent medical expenses to save the life of an insured person if that is needed.",
      "Provide a lump sum if an insured person is diagnosed with a life-threatening illness.",
      "Yes",
      "No",
      "No",
      "No",
    ),
    Questionz(
      false,
      "Q9. The best time to apply for life insurance is:",
      "Tomorrow, because you shouldn’t do now what you can put off until then.",
      "Today, because you don’t know what might happen to you tomorrow.",
      "As soon as you have any dependants, whenever in the future that might be.",
      "As soon as you develop a serious medical condition, so you can be covered for it.",
      "No",
      "Yes",
      "No",
      "No",
    ),
    Questionz(
      false,
      "Q10. __________ insurance is a contract where an insurance company provides medical coverage. It covers medical expenses incurred on hospitalization, surgeries, day care procedures, etc.",
      "Term Life",
      "Motor",
      "Health",
      "Travel",
      "No",
      "No",
      "Yes",
      "No",
    ),

    // Questionz(
    //     true,
    //     "Q1. What is the purpose of these insurances ?",
    //     "Health Insurance",
    //     "Motor Insurance",
    //     "Life Insurance",
    //     "Travel Insurance",
    //     "Secure healthcare cover",
    //     "Secure Vehicles damage cover",
    //     "Secure Life cover",
    //     "Secure travel cover"),
    // Questionz(
    //     true,
    //     "Q2. What is the average duration of these types of Insurance policies ?",
    //     "Health Insurance",
    //     "Term Insurance",
    //     "Car Insurance",
    //     "Travel Insurance",
    //     "1 Year",
    //     "Between 5 years to 40 years or till age 99",
    //     "1-3 Year",
    //     "Less than 1 year (180 days limit) "),
    // Questionz(
    //     true,
    //     "Q3. Help Anuj to get right insurance for each problem",
    //     "Hospital Bills Payment",
    //     "Repair car dent",
    //     "Luggage Misplace",
    //     "Damage due to fire",
    //     "Health Insurance",
    //     "Motor Insurance",
    //     "Travel Insurance",
    //     "Fire Insurance"),
    // Questionz(
    //     true,
    //     "Q4. Categorize Insurance accordingly",
    //     "Health Insurance",
    //     "Endowment Plans",
    //     "Study related plans",
    //     "Business loss",
    //     "General Insurance",
    //     "Term Life Insurance",
    //     "Education Insurance",
    //     "Financial Insurance"),
    // Questionz(
    //   true,
    //   "Q5. Arrange Insurance plans you expect to have maximum coverage amount ",
    //   "Term Life Insurance",
    //   "Health Insurance",
    //   "Motor Insurance",
    //   "Fire Insurance",
    //   "1st",
    //   "2nd",
    //   "3rd",
    //   "4th",
    // ),
    // Questionz(
    //   true,
    //   "Q6. Arrange Insurance plans that are most important to buy",
    //   "Term Life Insurance",
    //   "Health Insurance",
    //   "Motor Insurance",
    //   "Fire Insurance",
    //   "1st",
    //   "2nd",
    //   "3rd",
    //   "4th",
    // ),
    // Questionz(
    //   true,
    //   "Q7. What is the purpose of these insurances",
    //   "Cyber Insurance",
    //   "Maternity Insurance",
    //   "Financial Insurance",
    //   "Pet Insurance",
    //   "Online Frauds or privacy breach",
    //   "Pregnancy based complications",
    //   "Business loss cover",
    //   "Domestic Animals cover	",
    // ),
    // Questionz(
    //   false,
    //   "Q8. The main purpose of life insurance is to:",
    //   "Meet an insured person’s debts and other financial commitments in the event of death.",
    //   "Make up for loss of earnings if an insured person is unable to ever work again.",
    //   "Pay for urgent medical expenses to save the life of an insured person if that is needed.",
    //   "Provide a lump sum if an insured person is diagnosed with a life-threatening illness.",
    //   "Yes",
    //   "No",
    //   "No",
    //   "No",
    // ),
    // Questionz(
    //   false,
    //   "Q9. The best time to apply for life insurance is:",
    //   "Tomorrow, because you shouldn’t do now what you can put off until then.",
    //   "Today, because you don’t know what might happen to you tomorrow.",
    //   "As soon as you have any dependants, whenever in the future that might be.",
    //   "As soon as you develop a serious medical condition, so you can be covered for it.",
    //   "No",
    //   "Yes",
    //   "No",
    //   "No",
    // ),
    // Questionz(
    //   false,
    //   "Q10. __________ insurance is a contract where an insurance company provides medical coverage. It covers medical expenses incurred on hospitalization, surgeries, day care procedures, etc.",
    //   "Term Life",
    //   "Motor",
    //   "Health",
    //   "Travel",
    //   "No",
    //   "No",
    //   "Yes",
    //   "No",
    // ),

  ];

  // ///  Question 1
  // static Future<bool> setQuestion0AnswerA(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('0answerA', answer);
  // }
  //
  // static Future<String?> getQuestion0AnswerA( ) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('0answerA');
  // }
  //
  // static Future<bool> setQuestion0AnswerB(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('0answerB', answer);
  // }
  //
  // static Future<String?> getQuestion0AnswerB() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('0answerB');
  // }
  //
  // static Future<bool> setQuestion0AnswerC(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('0answerC', answer);
  // }
  //
  // static Future<String?> getQuestion0AnswerC() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('0answerC');
  // }
  //
  // static Future<bool> setQuestion0AnswerD(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('0answerD', answer);
  // }
  //
  // static Future<String?> getQuestion0AnswerD() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('0answerD');
  // }
  //
  //
  // ///  Question 2
  // ///
  // static Future<bool> setQuestion1AnswerA(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('1answerA', answer);
  // }
  //
  // static Future<String?> getQuestion1AnswerA() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('1answerA');
  // }
  //
  // static Future<bool> setQuestion1AnswerB(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('1answerB', answer);
  // }
  //
  // static Future<String?> getQuestion1AnswerB() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('1answerB');
  // }
  //
  // static Future<bool> setQuestion1AnswerC(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('1answerC', answer);
  // }
  //
  // static Future<String?> getQuestion1AnswerC() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('1answerC');
  // }
  //
  // static Future<bool> setQuestion1AnswerD(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('1answerD', answer);
  // }
  //
  // static Future<String?> getQuestion1AnswerD() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('1answerD');
  // }
  //
  // ///  Question 3
  // ///
  // static Future<bool> setQuestion2AnswerA(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('2answerA', answer);
  // }
  //
  // static Future<String?> getQuestion2AnswerA() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('2answerA');
  // }
  //
  // static Future<bool> setQuestion2AnswerB(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('2answerB', answer);
  // }
  //
  // static Future<String?> getQuestion2AnswerB() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('2answerB');
  // }
  //
  // static Future<bool> setQuestion2AnswerC(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('2answerC', answer);
  // }
  //
  // static Future<String?> getQuestion2AnswerC() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('2answerC');
  // }
  //
  // static Future<bool> setQuestion2AnswerD(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('2answerD', answer);
  // }
  //
  // static Future<String?> getQuestion2AnswerD() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('2answerD');
  // }
  //
  // ///  Question 3
  // ///
  // static Future<bool> setQuestion3AnswerA(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('3answerA', answer);
  // }
  //
  // static Future<String?> getQuestion3AnswerA() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('3answerA');
  // }
  //
  // static Future<bool> setQuestion3AnswerB(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('3answerB', answer);
  // }
  //
  // static Future<String?> getQuestion3AnswerB() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('3answerB');
  // }
  //
  // static Future<bool> setQuestion3AnswerC(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('3answerC', answer);
  // }
  //
  // static Future<String?> getQuestion3AnswerC() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('3answerC');
  // }
  //
  // static Future<bool> setQuestion3AnswerD(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('3answerD', answer);
  // }
  //
  // static Future<String?> getQuestion3AnswerD() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('3answerD');
  // }
  //
  // ///  Question 4
  // ///
  // static Future<bool> setQuestion4AnswerA(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('4answerA', answer);
  // }
  //
  // static Future<String?> getQuestion4AnswerA() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('4answerA');
  // }
  //
  // static Future<bool> setQuestion4AnswerB(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('4answerB', answer);
  // }
  //
  // static Future<String?> getQuestion4AnswerB() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('4answerB');
  // }
  //
  // static Future<bool> setQuestion4AnswerC(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('4answerC', answer);
  // }
  //
  // static Future<String?> getQuestion4AnswerC() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('4answerC');
  // }
  //
  // static Future<bool> setQuestion4AnswerD(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('4answerD', answer);
  // }
  //
  // static Future<String?> getQuestion4AnswerD() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('4answerD');
  // }
  //
  // ///  Question 5
  // ///
  // static Future<bool> setQuestion5AnswerA(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('5answerA', answer);
  // }
  //
  // static Future<String?> getQuestion5AnswerA() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('5answerA');
  // }
  //
  // static Future<bool> setQuestion5AnswerB(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('5answerB', answer);
  // }
  //
  // static Future<String?> getQuestion5AnswerB() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('5answerB');
  // }
  //
  // static Future<bool> setQuestion5AnswerC(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('5answerC', answer);
  // }
  //
  // static Future<String?> getQuestion5AnswerC() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('5answerC');
  // }
  //
  // static Future<bool> setQuestion5AnswerD(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('5answerD', answer);
  // }
  //
  // static Future<String?> getQuestion5AnswerD() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('5answerD');
  // }
  //
  // ///  Question 6
  // ///
  // static Future<bool> setQuestion6AnswerA(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('6answerA', answer);
  // }
  //
  // static Future<String?> getQuestion6AnswerA() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('6answerA');
  // }
  //
  // static Future<bool> setQuestion6AnswerB(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('6answerB', answer);
  // }
  //
  // static Future<String?> getQuestion6AnswerB() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('6answerB');
  // }
  //
  // static Future<bool> setQuestion6AnswerC(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('6answerC', answer);
  // }
  //
  // static Future<String?> getQuestion6AnswerC() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('6answerC');
  // }
  //
  // static Future<bool> setQuestion6AnswerD(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('6answerD', answer);
  // }
  //
  // static Future<String?> getQuestion6AnswerD() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('6answerD');
  // }


  ///  Question 0

  static Future<bool> setQuestion0CorrectedA(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('0correctA', answer);
  }

  static Future<bool?> getQuestion0CorrectedA() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('0correctA');
  }

  static Future<bool> setQuestion0CorrectedB(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('0correctB', answer);
  }

  static Future<bool?> getQuestion0CorrectedB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('0correctB');
  }

  static Future<bool> setQuestion0CorrectedC(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('0correctC', answer);
  }

  static Future<bool?> getQuestion0CorrectedC() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('0correctC');
  }

  static Future<bool> setQuestion0CorrectedD(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('0correctD', answer);
  }

  static Future<bool?> getQuestion0CorrectedD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('0correctD');
  }

  static Future<bool> setQuestion0Pressed(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('0pressed', answer);
  }

  static Future<String?> getQuestion0Pressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('0pressed');
  }


  ///  Question 1

  static Future<bool> setQuestion1CorrectedA(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('1correctA', answer);
  }

  static Future<bool?> getQuestion1CorrectedA() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('1correctA');
  }

  static Future<bool> setQuestion1CorrectedB(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('1correctB', answer);
  }

  static Future<bool?> getQuestion1CorrectedB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('1correctB');
  }

  static Future<bool> setQuestion1CorrectedC(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('1correctC', answer);
  }

  static Future<bool?> getQuestion1CorrectedC() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('1correctC');
  }

  static Future<bool> setQuestion1CorrectedD(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('1correctD', answer);
  }

  static Future<bool?> getQuestion1CorrectedD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('1correctD');
  }

  static Future<bool> setQuestion1Pressed(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('1pressed', answer);
  }

  static Future<String?> getQuestion1Pressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('1pressed');
  }

  ///  Question 2

  static Future<bool> setQuestion2CorrectedA(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('2correctA', answer);
  }

  static Future<bool?> getQuestion2CorrectedA() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('2correctA');
  }

  static Future<bool> setQuestion2CorrectedB(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('2correctB', answer);
  }

  static Future<bool?> getQuestion2CorrectedB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('2correctB');
  }

  static Future<bool> setQuestion2CorrectedC(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('2correctC', answer);
  }

  static Future<bool?> getQuestion2CorrectedC() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('2correctC');
  }

  static Future<bool> setQuestion2CorrectedD(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('2correctD', answer);
  }

  static Future<bool?> getQuestion2CorrectedD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('2correctD');
  }

  static Future<bool> setQuestion2Pressed(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('2pressed', answer);
  }

  static Future<String?> getQuestion2Pressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('2pressed');
  }


  ///  Question 3

  static Future<bool> setQuestion3CorrectedA(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('3correctA', answer);
  }

  static Future<bool?> getQuestion3CorrectedA() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('3correctA');
  }

  static Future<bool> setQuestion3CorrectedB(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('3correctB', answer);
  }

  static Future<bool?> getQuestion3CorrectedB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('3correctB');
  }

  static Future<bool> setQuestion3CorrectedC(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('3correctC', answer);
  }

  static Future<bool?> getQuestion3CorrectedC() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('3correctC');
  }

  static Future<bool> setQuestion3CorrectedD(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('3correctD', answer);
  }

  static Future<bool?> getQuestion3CorrectedD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('3correctD');
  }

  static Future<bool> setQuestion3Pressed(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('3pressed', answer);
  }

  static Future<String?> getQuestion3Pressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('3pressed');
  }

  ///  Question 4

  static Future<bool> setQuestion4CorrectedA(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('4correctA', answer);
  }

  static Future<bool?> getQuestion4CorrectedA() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('4correctA');
  }

  static Future<bool> setQuestion4CorrectedB(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('4correctB', answer);
  }

  static Future<bool?> getQuestion4CorrectedB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('4correctB');
  }

  static Future<bool> setQuestion4CorrectedC(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('4correctC', answer);
  }

  static Future<bool?> getQuestion4CorrectedC() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('4correctC');
  }

  static Future<bool> setQuestion4CorrectedD(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('4correctD', answer);
  }

  static Future<bool?> getQuestion4CorrectedD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('4correctD');
  }

  static Future<bool> setQuestion4Pressed(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('4pressed', answer);
  }

  static Future<String?> getQuestion4Pressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('4pressed');
  }

  ///  Question 5

  static Future<bool> setQuestion5CorrectedA(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('5correctA', answer);
  }

  static Future<bool?> getQuestion5CorrectedA() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('5correctA');
  }

  static Future<bool> setQuestion5CorrectedB(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('5correctB', answer);
  }

  static Future<bool?> getQuestion5CorrectedB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('5correctB');
  }

  static Future<bool> setQuestion5CorrectedC(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('5correctC', answer);
  }

  static Future<bool?> getQuestion5CorrectedC() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('5correctC');
  }

  static Future<bool> setQuestion5CorrectedD(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('5correctD', answer);
  }

  static Future<bool?> getQuestion5CorrectedD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('5correctD');
  }

  static Future<bool> setQuestion5Pressed(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('5pressed', answer);
  }

  static Future<String?> getQuestion5Pressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('5pressed');
  }

  ///  Question 6

  static Future<bool> setQuestion6CorrectedA(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('6correctA', answer);
  }

  static Future<bool?> getQuestion6CorrectedA() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('6correctA');
  }

  static Future<bool> setQuestion6CorrectedB(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('6correctB', answer);
  }

  static Future<bool?> getQuestion6CorrectedB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('6correctB');
  }

  static Future<bool> setQuestion6CorrectedC(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('6correctC', answer);
  }

  static Future<bool?> getQuestion6CorrectedC() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('6correctC');
  }

  static Future<bool> setQuestion6CorrectedD(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('6correctD', answer);
  }

  static Future<bool?> getQuestion6CorrectedD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('6correctD');
  }

  static Future<bool> setQuestion6Pressed(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('6pressed', answer);
  }

  static Future<String?> getQuestion6Pressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('6pressed');
  }

  ///  Question 7

  static Future<bool> setQuestion7CorrectedA(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('7correctA', answer);
  }

  static Future<bool?> getQuestion7CorrectedA() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('7correctA');
  }

  static Future<bool> setQuestion7CorrectedB(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('7correctB', answer);
  }

  static Future<bool?> getQuestion7CorrectedB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('7correctB');
  }

  static Future<bool> setQuestion7CorrectedC(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('7correctC', answer);
  }

  static Future<bool?> getQuestion7CorrectedC() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('7correctC');
  }

  static Future<bool> setQuestion7CorrectedD(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('7correctD', answer);
  }

  static Future<bool?> getQuestion7CorrectedD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('7correctD');
  }

  static Future<bool> setQuestion7Pressed(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('7pressed', answer);
  }

  static Future<String?> getQuestion7Pressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('7pressed');
  }

  // static Future<bool> setQuestion7AnswerA(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('7answerA', answer);
  // }
  //
  // static Future<String?> getQuestion7AnswerA() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('7answerA');
  // }
  //
  // static Future<bool> setQuestion7AnswerB(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('7answerB', answer);
  // }
  //
  // static Future<String?> getQuestion7AnswerB() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('7answerB');
  // }
  //
  // static Future<bool> setQuestion7AnswerC(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('7answerC', answer);
  // }
  //
  // static Future<String?> getQuestion7AnswerC() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('7answerC');
  // }
  //
  // static Future<bool> setQuestion7AnswerD(String answer) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('7answerD', answer);
  // }
  //
  // static Future<String?> getQuestion7AnswerD() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('7answerD');
  // }

  ///  Question 8
  ///

  static Future<bool> setQuestion8CorrectedA(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('8correctA', answer);
  }

  static Future<bool?> getQuestion8CorrectedA() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('8correctA');
  }

  static Future<bool> setQuestion8CorrectedB(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('8correctB', answer);
  }

  static Future<bool?> getQuestion8CorrectedB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('8correctB');
  }

  static Future<bool> setQuestion8CorrectedC(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('8correctC', answer);
  }

  static Future<bool?> getQuestion8CorrectedC() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('8correctC');
  }

  static Future<bool> setQuestion8CorrectedD(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('8correctD', answer);
  }

  static Future<bool?> getQuestion8CorrectedD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('8correctD');
  }

  static Future<bool> setQuestion8Pressed(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('8pressed', answer);
  }

  static Future<String?> getQuestion8Pressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('8pressed');
  }


  ///  Question 9
  ///

  static Future<bool> setQuestion9CorrectedA(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('9correctA', answer);
  }

  static Future<bool?> getQuestion9CorrectedA() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('9correctA');
  }

  static Future<bool> setQuestion9CorrectedB(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('9correctB', answer);
  }

  static Future<bool?> getQuestion9CorrectedB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('9correctB');
  }

  static Future<bool> setQuestion9CorrectedC(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('9correctC', answer);
  }

  static Future<bool?> getQuestion9CorrectedC() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('9correctC');
  }

  static Future<bool> setQuestion9CorrectedD(bool answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('9correctD', answer);
  }

  static Future<bool?> getQuestion9CorrectedD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('9correctD');
  }

  static Future<bool> setQuestion9Pressed(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('9pressed', answer);
  }

  static Future<String?> getQuestion9Pressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('9pressed');
  }

  ///  Question 10
  ///
  static Future<bool> setQuestion10AnswerA(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('10answerA', answer);
  }

  static Future<String?> getQuestion10AnswerA() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('10answerA');
  }

  static Future<bool> setQuestion10AnswerB(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('10answerB', answer);
  }

  static Future<String?> getQuestion10AnswerB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('10answerB');
  }

  static Future<bool> setQuestion10AnswerC(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('10answerC', answer);
  }

  static Future<String?> getQuestion10AnswerC() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('10answerC');
  }

  static Future<bool> setQuestion10AnswerD(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('10answerD', answer);
  }

  static Future<String?> getQuestion10AnswerD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('10answerD');
  }

  ///  Question 11
  ///
  static Future<bool> setQuestion11AnswerA(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('11answerA', answer);
  }

  static Future<String?> getQuestion11AnswerA() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('11answerA');
  }

  static Future<bool> setQuestion11AnswerB(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('11answerB', answer);
  }

  static Future<String?> getQuestion11AnswerB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('11answerB');
  }

  static Future<bool> setQuestion11AnswerC(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('11answerC', answer);
  }

  static Future<String?> getQuestion11AnswerC() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('11answerC');
  }

  static Future<bool> setQuestion11AnswerD(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('11answerD', answer);
  }

  static Future<String?> getQuestion11AnswerD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('11answerD');
  }


















  static Future<bool> setComplete(bool area) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('complete', area);
  }

  static Future<bool?> getComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('complete');
  }


  //
  // /// User Profile Data
  // static Future<bool?> setAllUserData(Map<String, dynamic> data) async {
  //   try{
  //    // print(data);
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     return prefs.setString('allData', json.encode(data));
  //   }catch(e){
  //     print(e.toString());
  //   }
  //
  // }
  //
  // static Future<Map<String, dynamic>?> getAllUserData() async {
  //
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? info = prefs.getString('allData');
  //    // print(info);
  //     return json.decode(info!) as Map<String, dynamic>;
  //   } catch (err) {
  //
  //   }
  // }
  //
  // static Future<bool?> setNationdData(Map<String, dynamic> data) async {
  //   try{
  //    // print(data);
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     return prefs.setString('NationData', json.encode(data));
  //   }catch(e){
  //     print(e.toString());
  //   }
  //
  // }
  //
  // static Future<Map<String, dynamic>?> getNationData() async {
  //
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? info = prefs.getString('NationData');
  //    // print(info);
  //     return json.decode(info!) as Map<String, dynamic>;
  //   } catch (err) {
  //     return Future(() => null);
  //   }
  // }
  //
  // /// State
  // static Future<bool?> setStateData(Map<String, dynamic> data) async {
  //   try{
  //    // print(data);
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     return prefs.setString('StateData', json.encode(data));
  //   }catch(e){
  //     return Future(() => null);
  //     print(e.toString());
  //   }
  //
  // }
  //
  // static Future<Map<String, dynamic>?> getStateData() async {
  //
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? info = prefs.getString('StateData');
  //    // print(info);
  //     return json.decode(info!) as Map<String, dynamic>;
  //   } catch (err) {
  //     return Future(() => null);
  //   }
  // }
  //
  // static Future<bool?> setDistrictData(Map<String, dynamic> data) async {
  //   try{
  //   //  print(data);
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     return prefs.setString('DistrictData', json.encode(data));
  //   }catch(e){
  //     print(e.toString());
  //   }
  //
  // }
  //
  // static Future<Map<String, dynamic>?> getDistrictData() async {
  //
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? info = prefs.getString('DistrictData');
  //   //  print(info);
  //     return json.decode(info!) as Map<String, dynamic>;
  //   } catch (err) {
  //     return Future(() => null);
  //   }
  // }


}
