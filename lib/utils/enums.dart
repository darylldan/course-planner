enum Day { mon, tue, wed, thu, fri, sat }

enum Honors { summa, magna, cum, none }

enum ViewEventType { upcoming, past }

enum CourseComponents { lec, lab, both }

enum NumericalGrade {
  g1_00,
  g1_25,
  g1_50,
  g1_75,
  g2_00,
  g2_25,
  g2_50,
  g2_75,
  g3_00,
  g4_00,
  g5_00,
  inc,
  drp
}

enum NonNumericalGrade { s, us }

enum HonorificScholarship {
  university,
  college,
  honorRoll,
  goodStanding,
  ineligibleUnderload,
  ineligibleLowGrade,
}

extension DayMethods on Day {
  static Day fromInt(int dayOfWeek) {
    if (dayOfWeek >= 1 && dayOfWeek <= Day.values.length) {
      return Day.values[dayOfWeek - 1];
    }
    return Day.values[0];
  }

  static String dayToString(Day day) {
    switch (day) {
      case Day.mon:
        return "Monday";
      case Day.tue:
        return "Tuesday";
      case Day.wed:
        return "Wednesday";
      case Day.thu:
        return "Thursday";
      case Day.fri:
        return "Friday";
      case Day.sat:
        return "Saturday";
    }
  }

  static String dayToStringShort(Day day) {
    switch (day) {
      case Day.mon:
        return "Mon";
      case Day.tue:
        return "Tue";
      case Day.wed:
        return "Wed";
      case Day.thu:
        return "Thu";
      case Day.fri:
        return "Fri";
      case Day.sat:
        return "Sat";
    }
  }

  static int dayToInt(Day day) {
    switch (day) {
      case Day.mon:
        return 0;
      case Day.tue:
        return 1;
      case Day.wed:
        return 2;
      case Day.thu:
        return 3;
      case Day.fri:
        return 4;
      case Day.sat:
        return 5;
    }
  }

  static Day? intToDay(int day) {
    switch (day) {
      case 0:
        return Day.mon;
      case 1:
        return Day.tue;
      case 2:
        return Day.wed;
      case 3:
        return Day.thu;
      case 4:
        return Day.fri;
      case 5:
        return Day.sat;
      default:
        return null;
    }
  }
}

extension GradeMethods on NumericalGrade {
  static double? getValue(NumericalGrade grade) {
    switch (grade) {
      case NumericalGrade.g1_00:
        return 1.0;
      case NumericalGrade.g1_25:
        return 1.25;
      case NumericalGrade.g1_50:
        return 1.5;
      case NumericalGrade.g1_75:
        return 1.75;
      case NumericalGrade.g2_00:
        return 2.0;
      case NumericalGrade.g2_25:
        return 2.25;
      case NumericalGrade.g2_50:
        return 2.5;
      case NumericalGrade.g2_75:
        return 2.75;
      case NumericalGrade.g3_00:
        return 3.0;
      case NumericalGrade.g4_00:
        return 4.0; // Conditional failing grade
      case NumericalGrade.g5_00:
        return 5.0; // Failing grade
      default:
        return null;
    }
  }

  static String getStringValue(NumericalGrade grade) {
    switch (grade) {
      case NumericalGrade.g1_00:
        return "1.0";
      case NumericalGrade.g1_25:
        return "1.25";
      case NumericalGrade.g1_50:
        return "1.5";
      case NumericalGrade.g1_75:
        return "1.75";
      case NumericalGrade.g2_00:
        return "2.0";
      case NumericalGrade.g2_25:
        return "2.25";
      case NumericalGrade.g2_50:
        return "2.5";
      case NumericalGrade.g2_75:
        return "2.75";
      case NumericalGrade.g3_00:
        return "3.0";
      case NumericalGrade.g4_00:
        return "4.0"; // Conditional failing grade
      case NumericalGrade.g5_00:
        return "5.0"; // Failing grade
      case NumericalGrade.drp:
        return "Dropped";
      case NumericalGrade.inc:
        return "Incomplete";
    }
  }
}

extension HonorificScholarshipMethods on HonorificScholarship {
  static String? getValue(HonorificScholarship hs) {
    switch (hs) {
      case HonorificScholarship.university:
        return "University Scholar";
      case HonorificScholarship.college:
        return "College Scholar";
      case HonorificScholarship.honorRoll:
        return "Honor Roll";
      case HonorificScholarship.goodStanding:
        return "Good Standing";
      case HonorificScholarship.ineligibleUnderload:
        return "Underload";
      case HonorificScholarship.ineligibleLowGrade:
        return "Low Grade";
      default:
        return null; // or throw an exception if unexpected value
    }
  }
}

extension NonNumGradeMethods on NonNumericalGrade {
  static String getStringValue(NonNumericalGrade ng) {
    if (ng == NonNumericalGrade.s) {
      return "Satisfactory";
    }

    if (ng == NonNumericalGrade.us) {
      return "Unsatisfactory";
    }

    return "";
  }
}
