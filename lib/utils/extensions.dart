// Add a copyWith method to your Note class for cleaner code
import 'package:course_planner/models/Note.dart';

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