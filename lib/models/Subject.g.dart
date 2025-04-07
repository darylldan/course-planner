// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Subject.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSubjectCollection on Isar {
  IsarCollection<Subject> get subjects => this.collection();
}

const SubjectSchema = CollectionSchema(
  name: r'Subject',
  id: 7648000959054204885,
  properties: {
    r'color': PropertySchema(
      id: 0,
      name: r'color',
      type: IsarType.longList,
    ),
    r'courseCode': PropertySchema(
      id: 1,
      name: r'courseCode',
      type: IsarType.string,
    ),
    r'credited': PropertySchema(
      id: 2,
      name: r'credited',
      type: IsarType.bool,
    ),
    r'description': PropertySchema(
      id: 3,
      name: r'description',
      type: IsarType.string,
    ),
    r'endDate': PropertySchema(
      id: 4,
      name: r'endDate',
      type: IsarType.dateTime,
    ),
    r'frequency': PropertySchema(
      id: 5,
      name: r'frequency',
      type: IsarType.stringList,
      enumMap: _SubjectfrequencyEnumValueMap,
    ),
    r'instructor': PropertySchema(
      id: 6,
      name: r'instructor',
      type: IsarType.string,
    ),
    r'isLaboratory': PropertySchema(
      id: 7,
      name: r'isLaboratory',
      type: IsarType.bool,
    ),
    r'locationID': PropertySchema(
      id: 8,
      name: r'locationID',
      type: IsarType.long,
    ),
    r'locationType': PropertySchema(
      id: 9,
      name: r'locationType',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 10,
      name: r'notes',
      type: IsarType.string,
    ),
    r'section': PropertySchema(
      id: 11,
      name: r'section',
      type: IsarType.string,
    ),
    r'startDate': PropertySchema(
      id: 12,
      name: r'startDate',
      type: IsarType.dateTime,
    ),
    r'termID': PropertySchema(
      id: 13,
      name: r'termID',
      type: IsarType.long,
    ),
    r'units': PropertySchema(
      id: 14,
      name: r'units',
      type: IsarType.long,
    )
  },
  estimateSize: _subjectEstimateSize,
  serialize: _subjectSerialize,
  deserialize: _subjectDeserialize,
  deserializeProp: _subjectDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _subjectGetId,
  getLinks: _subjectGetLinks,
  attach: _subjectAttach,
  version: '3.1.8',
);

int _subjectEstimateSize(
  Subject object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.color.length * 8;
  bytesCount += 3 + object.courseCode.length * 3;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.frequency.length * 3;
  {
    for (var i = 0; i < object.frequency.length; i++) {
      final value = object.frequency[i];
      bytesCount += value.name.length * 3;
    }
  }
  {
    final value = object.instructor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.locationType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.section.length * 3;
  return bytesCount;
}

void _subjectSerialize(
  Subject object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.color);
  writer.writeString(offsets[1], object.courseCode);
  writer.writeBool(offsets[2], object.credited);
  writer.writeString(offsets[3], object.description);
  writer.writeDateTime(offsets[4], object.endDate);
  writer.writeStringList(
      offsets[5], object.frequency.map((e) => e.name).toList());
  writer.writeString(offsets[6], object.instructor);
  writer.writeBool(offsets[7], object.isLaboratory);
  writer.writeLong(offsets[8], object.locationID);
  writer.writeString(offsets[9], object.locationType);
  writer.writeString(offsets[10], object.notes);
  writer.writeString(offsets[11], object.section);
  writer.writeDateTime(offsets[12], object.startDate);
  writer.writeLong(offsets[13], object.termID);
  writer.writeLong(offsets[14], object.units);
}

Subject _subjectDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Subject();
  object.color = reader.readLongList(offsets[0]) ?? [];
  object.courseCode = reader.readString(offsets[1]);
  object.credited = reader.readBool(offsets[2]);
  object.description = reader.readStringOrNull(offsets[3]);
  object.endDate = reader.readDateTimeOrNull(offsets[4]);
  object.frequency = reader
          .readStringList(offsets[5])
          ?.map((e) => _SubjectfrequencyValueEnumMap[e] ?? Day.mon)
          .toList() ??
      [];
  object.id = id;
  object.instructor = reader.readStringOrNull(offsets[6]);
  object.isLaboratory = reader.readBool(offsets[7]);
  object.locationID = reader.readLongOrNull(offsets[8]);
  object.locationType = reader.readStringOrNull(offsets[9]);
  object.notes = reader.readStringOrNull(offsets[10]);
  object.section = reader.readString(offsets[11]);
  object.startDate = reader.readDateTimeOrNull(offsets[12]);
  object.termID = reader.readLong(offsets[13]);
  object.units = reader.readLong(offsets[14]);
  return object;
}

P _subjectDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset) ?? []) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader
              .readStringList(offset)
              ?.map((e) => _SubjectfrequencyValueEnumMap[e] ?? Day.mon)
              .toList() ??
          []) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SubjectfrequencyEnumValueMap = {
  r'mon': r'mon',
  r'tue': r'tue',
  r'wed': r'wed',
  r'thu': r'thu',
  r'fri': r'fri',
  r'sat': r'sat',
};
const _SubjectfrequencyValueEnumMap = {
  r'mon': Day.mon,
  r'tue': Day.tue,
  r'wed': Day.wed,
  r'thu': Day.thu,
  r'fri': Day.fri,
  r'sat': Day.sat,
};

Id _subjectGetId(Subject object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _subjectGetLinks(Subject object) {
  return [];
}

void _subjectAttach(IsarCollection<dynamic> col, Id id, Subject object) {
  object.id = id;
}

extension SubjectQueryWhereSort on QueryBuilder<Subject, Subject, QWhere> {
  QueryBuilder<Subject, Subject, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SubjectQueryWhere on QueryBuilder<Subject, Subject, QWhereClause> {
  QueryBuilder<Subject, Subject, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Subject, Subject, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Subject, Subject, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Subject, Subject, QAfterWhereClause> idBetween(
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

extension SubjectQueryFilter
    on QueryBuilder<Subject, Subject, QFilterCondition> {
  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorElementEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'color',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'color',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'color',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'color',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'color',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> colorLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'color',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> courseCodeEqualTo(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> courseCodeGreaterThan(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> courseCodeLessThan(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> courseCodeBetween(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> courseCodeStartsWith(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> courseCodeEndsWith(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> courseCodeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'courseCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> courseCodeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'courseCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> courseCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseCode',
        value: '',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> courseCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'courseCode',
        value: '',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> creditedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'credited',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> endDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endDate',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> endDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endDate',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> endDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> endDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> endDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> endDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> frequencyElementEqualTo(
    Day value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'frequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition>
      frequencyElementGreaterThan(
    Day value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'frequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition>
      frequencyElementLessThan(
    Day value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'frequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> frequencyElementBetween(
    Day lower,
    Day upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'frequency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition>
      frequencyElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'frequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition>
      frequencyElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'frequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition>
      frequencyElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'frequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> frequencyElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'frequency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition>
      frequencyElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'frequency',
        value: '',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition>
      frequencyElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'frequency',
        value: '',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> frequencyLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'frequency',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> frequencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'frequency',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> frequencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'frequency',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> frequencyLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'frequency',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition>
      frequencyLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'frequency',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> frequencyLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'frequency',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> instructorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'instructor',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> instructorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'instructor',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> instructorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'instructor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> instructorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'instructor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> instructorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'instructor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> instructorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'instructor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> instructorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'instructor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> instructorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'instructor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> instructorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'instructor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> instructorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'instructor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> instructorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'instructor',
        value: '',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> instructorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'instructor',
        value: '',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> isLaboratoryEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isLaboratory',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> locationIDIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'locationID',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> locationIDIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'locationID',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> locationIDEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locationID',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> locationIDGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'locationID',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> locationIDLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'locationID',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> locationIDBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'locationID',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> locationTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'locationType',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition>
      locationTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'locationType',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> locationTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> locationTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'locationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> locationTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'locationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> locationTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'locationType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> locationTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'locationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> locationTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'locationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> locationTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'locationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> locationTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'locationType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> locationTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locationType',
        value: '',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition>
      locationTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'locationType',
        value: '',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> notesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> notesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> sectionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'section',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> sectionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'section',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> sectionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'section',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> sectionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'section',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> sectionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'section',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> sectionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'section',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> sectionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'section',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> sectionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'section',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> sectionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'section',
        value: '',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> sectionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'section',
        value: '',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> startDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startDate',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> startDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startDate',
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> startDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> startDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> startDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> startDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> termIDEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'termID',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> termIDGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'termID',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> termIDLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'termID',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> termIDBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'termID',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> unitsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'units',
        value: value,
      ));
    });
  }

  QueryBuilder<Subject, Subject, QAfterFilterCondition> unitsGreaterThan(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> unitsLessThan(
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

  QueryBuilder<Subject, Subject, QAfterFilterCondition> unitsBetween(
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

extension SubjectQueryObject
    on QueryBuilder<Subject, Subject, QFilterCondition> {}

extension SubjectQueryLinks
    on QueryBuilder<Subject, Subject, QFilterCondition> {}

extension SubjectQuerySortBy on QueryBuilder<Subject, Subject, QSortBy> {
  QueryBuilder<Subject, Subject, QAfterSortBy> sortByCourseCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByCourseCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByCredited() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'credited', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByCreditedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'credited', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByInstructor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instructor', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByInstructorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instructor', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByIsLaboratory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLaboratory', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByIsLaboratoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLaboratory', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByLocationID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationID', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByLocationIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationID', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByLocationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationType', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByLocationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationType', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortBySection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'section', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortBySectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'section', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByTermID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termID', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByTermIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termID', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByUnits() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'units', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> sortByUnitsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'units', Sort.desc);
    });
  }
}

extension SubjectQuerySortThenBy
    on QueryBuilder<Subject, Subject, QSortThenBy> {
  QueryBuilder<Subject, Subject, QAfterSortBy> thenByCourseCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByCourseCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseCode', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByCredited() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'credited', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByCreditedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'credited', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByInstructor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instructor', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByInstructorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instructor', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByIsLaboratory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLaboratory', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByIsLaboratoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLaboratory', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByLocationID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationID', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByLocationIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationID', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByLocationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationType', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByLocationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationType', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenBySection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'section', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenBySectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'section', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByTermID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termID', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByTermIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termID', Sort.desc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByUnits() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'units', Sort.asc);
    });
  }

  QueryBuilder<Subject, Subject, QAfterSortBy> thenByUnitsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'units', Sort.desc);
    });
  }
}

extension SubjectQueryWhereDistinct
    on QueryBuilder<Subject, Subject, QDistinct> {
  QueryBuilder<Subject, Subject, QDistinct> distinctByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'color');
    });
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByCourseCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByCredited() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'credited');
    });
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDate');
    });
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'frequency');
    });
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByInstructor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'instructor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByIsLaboratory() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isLaboratory');
    });
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByLocationID() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'locationID');
    });
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByLocationType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'locationType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctBySection(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'section', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByTermID() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'termID');
    });
  }

  QueryBuilder<Subject, Subject, QDistinct> distinctByUnits() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'units');
    });
  }
}

extension SubjectQueryProperty
    on QueryBuilder<Subject, Subject, QQueryProperty> {
  QueryBuilder<Subject, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Subject, List<int>, QQueryOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'color');
    });
  }

  QueryBuilder<Subject, String, QQueryOperations> courseCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseCode');
    });
  }

  QueryBuilder<Subject, bool, QQueryOperations> creditedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'credited');
    });
  }

  QueryBuilder<Subject, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<Subject, DateTime?, QQueryOperations> endDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDate');
    });
  }

  QueryBuilder<Subject, List<Day>, QQueryOperations> frequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'frequency');
    });
  }

  QueryBuilder<Subject, String?, QQueryOperations> instructorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'instructor');
    });
  }

  QueryBuilder<Subject, bool, QQueryOperations> isLaboratoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isLaboratory');
    });
  }

  QueryBuilder<Subject, int?, QQueryOperations> locationIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locationID');
    });
  }

  QueryBuilder<Subject, String?, QQueryOperations> locationTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locationType');
    });
  }

  QueryBuilder<Subject, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<Subject, String, QQueryOperations> sectionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'section');
    });
  }

  QueryBuilder<Subject, DateTime?, QQueryOperations> startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }

  QueryBuilder<Subject, int, QQueryOperations> termIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'termID');
    });
  }

  QueryBuilder<Subject, int, QQueryOperations> unitsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'units');
    });
  }
}
