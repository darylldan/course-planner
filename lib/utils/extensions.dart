// Add a copyWith method to your Note class for cleaner code
import 'package:course_planner/models/CourseTemplate.dart';
import 'package:course_planner/models/Note.dart';
import 'package:course_planner/models/Subject.dart';

extension NoteCopyWith on Note {
  Note copyWith({
    int? courseId,
    int? termId,
    String? title,
    String? content,
    DateTime? created,
    DateTime? updated,
  }) {
    return Note()
      ..id = this.id
      ..courseId = courseId ?? this.courseId
      ..termId = termId ?? this.termId
      ..title = title ?? this.title
      ..content = content ?? this.content
      ..created = created ?? this.created
      ..updated = updated ?? this.updated;
  }
}

extension CourseTemplateMethods on CourseTemplate {
  // Convert JSON to Item
  static CourseTemplate fromJson(Map<String, dynamic> json) {
    return CourseTemplate()
      ..courseCode = json["course_code"] as String
      ..description = json["title"] as String
      ..units = int.tryParse(json["units"])
      ..credited = json["credited"] == null ? true : json["credited"] as bool;
  }
}

extension SubjectMethods on Subject {
  static int getHash(Subject subject) {
    return Object.hash(
        subject.id,
        subject.courseCode,
        subject.units,
        subject.credited,
        subject.startDate,
        subject.endDate,
        subject.description);
  }
}
