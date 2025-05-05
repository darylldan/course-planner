// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TermGrade.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTermGradeCollection on Isar {
  IsarCollection<TermGrade> get termGrades => this.collection();
}

const TermGradeSchema = CollectionSchema(
  name: r'TermGrade',
  id: 3733994225082538138,
  properties: {
    r'academicYear': PropertySchema(
      id: 0,
      name: r'academicYear',
      type: IsarType.string,
    ),
    r'grade': PropertySchema(
      id: 1,
      name: r'grade',
      type: IsarType.double,
    ),
    r'semester': PropertySchema(
      id: 2,
      name: r'semester',
      type: IsarType.string,
    ),
    r'units': PropertySchema(
      id: 3,
      name: r'units',
      type: IsarType.long,
    )
  },
  estimateSize: _termGradeEstimateSize,
  serialize: _termGradeSerialize,
  deserialize: _termGradeDeserialize,
  deserializeProp: _termGradeDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _termGradeGetId,
  getLinks: _termGradeGetLinks,
  attach: _termGradeAttach,
  version: '3.1.8',
);

int _termGradeEstimateSize(
  TermGrade object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.academicYear.length * 3;
  bytesCount += 3 + object.semester.length * 3;
  return bytesCount;
}

void _termGradeSerialize(
  TermGrade object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.academicYear);
  writer.writeDouble(offsets[1], object.grade);
  writer.writeString(offsets[2], object.semester);
  writer.writeLong(offsets[3], object.units);
}

TermGrade _termGradeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TermGrade();
  object.academicYear = reader.readString(offsets[0]);
  object.grade = reader.readDouble(offsets[1]);
  object.id = id;
  object.semester = reader.readString(offsets[2]);
  object.units = reader.readLong(offsets[3]);
  return object;
}

P _termGradeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _termGradeGetId(TermGrade object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _termGradeGetLinks(TermGrade object) {
  return [];
}

void _termGradeAttach(IsarCollection<dynamic> col, Id id, TermGrade object) {
  object.id = id;
}

extension TermGradeQueryWhereSort
    on QueryBuilder<TermGrade, TermGrade, QWhere> {
  QueryBuilder<TermGrade, TermGrade, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TermGradeQueryWhere
    on QueryBuilder<TermGrade, TermGrade, QWhereClause> {
  QueryBuilder<TermGrade, TermGrade, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TermGradeQueryFilter
    on QueryBuilder<TermGrade, TermGrade, QFilterCondition> {
  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> academicYearEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'academicYear',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition>
      academicYearGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'academicYear',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition>
      academicYearLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'academicYear',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> academicYearBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'academicYear',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition>
      academicYearStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'academicYear',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition>
      academicYearEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'academicYear',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition>
      academicYearContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'academicYear',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> academicYearMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'academicYear',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition>
      academicYearIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'academicYear',
        value: '',
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition>
      academicYearIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'academicYear',
        value: '',
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> gradeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'grade',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> gradeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'grade',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> gradeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'grade',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> gradeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'grade',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> semesterEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'semester',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> semesterGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'semester',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> semesterLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'semester',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> semesterBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'semester',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> semesterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'semester',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> semesterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'semester',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> semesterContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'semester',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> semesterMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'semester',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> semesterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'semester',
        value: '',
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition>
      semesterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'semester',
        value: '',
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> unitsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'units',
        value: value,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> unitsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'units',
        value: value,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> unitsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'units',
        value: value,
      ));
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterFilterCondition> unitsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'units',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TermGradeQueryObject
    on QueryBuilder<TermGrade, TermGrade, QFilterCondition> {}

extension TermGradeQueryLinks
    on QueryBuilder<TermGrade, TermGrade, QFilterCondition> {}

extension TermGradeQuerySortBy on QueryBuilder<TermGrade, TermGrade, QSortBy> {
  QueryBuilder<TermGrade, TermGrade, QAfterSortBy> sortByAcademicYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'academicYear', Sort.asc);
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterSortBy> sortByAcademicYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'academicYear', Sort.desc);
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterSortBy> sortByGrade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.asc);
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterSortBy> sortByGradeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.desc);
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterSortBy> sortBySemester() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'semester', Sort.asc);
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterSortBy> sortBySemesterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'semester', Sort.desc);
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterSortBy> sortByUnits() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'units', Sort.asc);
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterSortBy> sortByUnitsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'units', Sort.desc);
    });
  }
}

extension TermGradeQuerySortThenBy
    on QueryBuilder<TermGrade, TermGrade, QSortThenBy> {
  QueryBuilder<TermGrade, TermGrade, QAfterSortBy> thenByAcademicYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'academicYear', Sort.asc);
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterSortBy> thenByAcademicYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'academicYear', Sort.desc);
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterSortBy> thenByGrade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.asc);
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterSortBy> thenByGradeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.desc);
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterSortBy> thenBySemester() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'semester', Sort.asc);
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterSortBy> thenBySemesterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'semester', Sort.desc);
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterSortBy> thenByUnits() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'units', Sort.asc);
    });
  }

  QueryBuilder<TermGrade, TermGrade, QAfterSortBy> thenByUnitsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'units', Sort.desc);
    });
  }
}

extension TermGradeQueryWhereDistinct
    on QueryBuilder<TermGrade, TermGrade, QDistinct> {
  QueryBuilder<TermGrade, TermGrade, QDistinct> distinctByAcademicYear(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'academicYear', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TermGrade, TermGrade, QDistinct> distinctByGrade() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'grade');
    });
  }

  QueryBuilder<TermGrade, TermGrade, QDistinct> distinctBySemester(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'semester', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TermGrade, TermGrade, QDistinct> distinctByUnits() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'units');
    });
  }
}

extension TermGradeQueryProperty
    on QueryBuilder<TermGrade, TermGrade, QQueryProperty> {
  QueryBuilder<TermGrade, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TermGrade, String, QQueryOperations> academicYearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'academicYear');
    });
  }

  QueryBuilder<TermGrade, double, QQueryOperations> gradeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'grade');
    });
  }

  QueryBuilder<TermGrade, String, QQueryOperations> semesterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'semester');
    });
  }

  QueryBuilder<TermGrade, int, QQueryOperations> unitsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'units');
    });
  }
}
