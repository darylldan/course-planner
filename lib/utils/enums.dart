enum Day { mon, tue, wed, thu, fri, sat }

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
}
