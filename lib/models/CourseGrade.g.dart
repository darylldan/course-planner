// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CourseGrade.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCourseGradeCollection on Isar {
  IsarCollection<CourseGrade> get courseGrades => this.collection();
}

const CourseGradeSchema = CollectionSchema(
  name: r'CourseGrade',
  id: -7371834491385575366,
  properties: {
    r'courseCode': PropertySchema(
      id: 0,
      name: r'courseCode',
      type: IsarType.string,
    ),
    r'grade': PropertySchema(
      id: 1,
      name: r'grade',
      type: IsarType.string,
      enumMap: _CourseGradegradeEnumValueMap,
    ),
    r'isCredited': PropertySchema(
      id: 2,
      name: r'isCredited',
      type: IsarType.bool,
    ),
    r'nonNumericalGrade': PropertySchema(
      id: 3,
      name: r'nonNumericalGrade',
      type: IsarType.string,
      enumMap: _CourseGradenonNumericalGradeEnumValueMap,
    ),
    r'termId': PropertySchema(
      id: 4,
      name: r'termId',
      type: IsarType.long,
    ),
    r'units': PropertySchema(
      id: 5,
      name: r'units',
      type: IsarType.long,
    )
  },
  estimateSize: _courseGradeEstimateSize,
  serialize: _courseGradeSerialize,
  deserialize: _courseGradeDeserialize,
  deserializeProp: _courseGradeDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _courseGradeGetId,
  getLinks: _courseGradeGetLinks,
  attach: _courseGradeAttach,
  version: '3.1.8',
);

int _courseGradeEstimateSize(
  CourseGrade object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.courseCode.length * 3;
  {
    final value = object.grade;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  {
    final value = object.nonNumericalGrade;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  return bytesCount;
}

void _courseGradeSerialize(
  CourseGrade object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.courseCode);
  writer.writeString(offsets[1], object.grade?.name);
  writer.writeBool(offsets[2], object.isCredited);
  writer.writeString(offsets[3], object.nonNumericalGrade?.name);
  writer.writeLong(offsets[4], object.termId);
  writer.writeLong(offsets[5], object.units);
}

CourseGrade _courseGradeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CourseGrade();
  object.courseCode = reader.readString(offsets[0]);
  object.grade =
      _CourseGradegradeValueEnumMap[reader.readStringOrNull(offsets[1])];
  object.id = id;
  object.isCredited = reader.readBool(offsets[2]);
  object.nonNumericalGrade = _CourseGradenonNumericalGradeValueEnumMap[
      reader.readStringOrNull(offsets[3])];
  object.termId = reader.readLong(offsets[4]);
  object.units = reader.readLong(offsets[5]);
  return object;
}

P _courseGradeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (_CourseGradegradeValueEnumMap[reader.readStringOrNull(offset)])
          as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (_CourseGradenonNumericalGradeValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CourseGradegradeEnumValueMap = {
  r'g1_00': r'g1_00',
  r'g1_25': r'g1_25',
  r'g1_50': r'g1_50',
  r'g1_75': r'g1_75',
  r'g2_00': r'g2_00',
  r'g2_25': r'g2_25',
  r'g2_50': r'g2_50',
  r'g2_75': r'g2_75',
  r'g3_00': r'g3_00',
  r'g4_00': r'g4_00',
  r'g5_00': r'g5_00',
  r'inc': r'inc',
  r'drp': r'drp',
};
const _CourseGradegradeValueEnumMap = {
  r'g1_00': NumericalGrade.g1_00,
  r'g1_25': NumericalGrade.g1_25,
  r'g1_50': NumericalGrade.g1_50,
  r'g1_75': NumericalGrade.g1_75,
  r'g2_00': NumericalGrade.g2_00,
  r'g2_25': NumericalGrade.g2_25,
  r'g2_50': NumericalGrade.g2_50,
  r'g2_75': NumericalGrade.g2_75,
  r'g3_00': NumericalGrade.g3_00,
  r'g4_00': NumericalGrade.g4_00,
  r'g5_00': NumericalGrade.g5_00,
  r'inc': NumericalGrade.inc,
  r'drp': NumericalGrade.drp,
};
const _CourseGradenonNumericalGradeEnumValueMap = {
  r's': r's',
  r'us': r'us',
};
const _CourseGradenonNumericalGradeValueEnumMap = {
  r's': NonNumericalGrade.s,
  r'us': NonNumericalGrade.us,
};

Id _courseGradeGetId(CourseGrade object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _courseGradeGetLinks(CourseGrade object) {
  return [];
}

void _courseGradeAttach(
    IsarCollection<dynamic> col, Id id, CourseGrade object) {
  object.id = id;
}

extension CourseGradeQueryWhereSort
    on QueryBuilder<CourseGrade, CourseGrade, QWhere> {
  QueryBuilder<CourseGrade, CourseGrade, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CourseGradeQueryWhere
    on QueryBuilder<CourseGrade, CourseGrade, QWhereClause> {
  QueryBuilder<CourseGrade, CourseGrade, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<CourseGrade, CourseGrade, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterWhereClause> idBetween(
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

extension CourseGradeQueryFilter
    on QueryBuilder<CourseGrade, CourseGrade, QFilterCondition> {
  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      courseCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      courseCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      courseCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      courseCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'courseCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      courseCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      courseCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      courseCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      courseCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'courseCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      courseCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseCode',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      courseCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'courseCode',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> gradeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'grade',
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      gradeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'grade',
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> gradeEqualTo(
    NumericalGrade? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'grade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      gradeGreaterThan(
    NumericalGrade? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'grade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> gradeLessThan(
    NumericalGrade? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'grade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> gradeBetween(
    NumericalGrade? lower,
    NumericalGrade? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'grade',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> gradeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'grade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> gradeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'grade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> gradeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'grade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> gradeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'grade',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> gradeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'grade',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      gradeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'grade',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      isCreditedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCredited',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      nonNumericalGradeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nonNumericalGrade',
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      nonNumericalGradeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nonNumericalGrade',
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      nonNumericalGradeEqualTo(
    NonNumericalGrade? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nonNumericalGrade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      nonNumericalGradeGreaterThan(
    NonNumericalGrade? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nonNumericalGrade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      nonNumericalGradeLessThan(
    NonNumericalGrade? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nonNumericalGrade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      nonNumericalGradeBetween(
    NonNumericalGrade? lower,
    NonNumericalGrade? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nonNumericalGrade',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      nonNumericalGradeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nonNumericalGrade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      nonNumericalGradeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nonNumericalGrade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      nonNumericalGradeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nonNumericalGrade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      nonNumericalGradeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nonNumericalGrade',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      nonNumericalGradeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nonNumericalGrade',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      nonNumericalGradeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nonNumericalGrade',
        value: '',
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> termIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'termId',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      termIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'termId',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> termIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'termId',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> termIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'termId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> unitsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'units',
        value: value,
      ));
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition>
      unitsGreaterThan(
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

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> unitsLessThan(
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

  QueryBuilder<CourseGrade, CourseGrade, QAfterFilterCondition> unitsBetween(
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

extension CourseGradeQueryObject
    on QueryBuilder<CourseGrade, CourseGrade, QFilterCondition> {}

extension CourseGradeQueryLinks
    on QueryBuilder<CourseGrade, CourseGrade, QFilterCondition> {}

extension CourseGradeQuerySortBy
    on QueryBuilder<CourseGrade, CourseGrade, QSortBy> {
  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> sortByCourseCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.asc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> sortByCourseCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.desc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> sortByGrade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.asc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> sortByGradeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.desc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> sortByIsCredited() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCredited', Sort.asc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> sortByIsCreditedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCredited', Sort.desc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy>
      sortByNonNumericalGrade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nonNumericalGrade', Sort.asc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy>
      sortByNonNumericalGradeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nonNumericalGrade', Sort.desc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> sortByTermId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termId', Sort.asc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> sortByTermIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termId', Sort.desc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> sortByUnits() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'units', Sort.asc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> sortByUnitsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'units', Sort.desc);
    });
  }
}

extension CourseGradeQuerySortThenBy
    on QueryBuilder<CourseGrade, CourseGrade, QSortThenBy> {
  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> thenByCourseCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.asc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> thenByCourseCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.desc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> thenByGrade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.asc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> thenByGradeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.desc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> thenByIsCredited() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCredited', Sort.asc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> thenByIsCreditedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCredited', Sort.desc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy>
      thenByNonNumericalGrade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nonNumericalGrade', Sort.asc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy>
      thenByNonNumericalGradeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nonNumericalGrade', Sort.desc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> thenByTermId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termId', Sort.asc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> thenByTermIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termId', Sort.desc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> thenByUnits() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'units', Sort.asc);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QAfterSortBy> thenByUnitsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'units', Sort.desc);
    });
  }
}

extension CourseGradeQueryWhereDistinct
    on QueryBuilder<CourseGrade, CourseGrade, QDistinct> {
  QueryBuilder<CourseGrade, CourseGrade, QDistinct> distinctByCourseCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QDistinct> distinctByGrade(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'grade', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QDistinct> distinctByIsCredited() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCredited');
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QDistinct> distinctByNonNumericalGrade(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nonNumericalGrade',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QDistinct> distinctByTermId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'termId');
    });
  }

  QueryBuilder<CourseGrade, CourseGrade, QDistinct> distinctByUnits() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'units');
    });
  }
}

extension CourseGradeQueryProperty
    on QueryBuilder<CourseGrade, CourseGrade, QQueryProperty> {
  QueryBuilder<CourseGrade, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CourseGrade, String, QQueryOperations> courseCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseCode');
    });
  }

  QueryBuilder<CourseGrade, NumericalGrade?, QQueryOperations> gradeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'grade');
    });
  }

  QueryBuilder<CourseGrade, bool, QQueryOperations> isCreditedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCredited');
    });
  }

  QueryBuilder<CourseGrade, NonNumericalGrade?, QQueryOperations>
      nonNumericalGradeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nonNumericalGrade');
    });
  }

  QueryBuilder<CourseGrade, int, QQueryOperations> termIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'termId');
    });
  }

  QueryBuilder<CourseGrade, int, QQueryOperations> unitsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'units');
    });
  }
}
