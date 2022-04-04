// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HivePackAdapter extends TypeAdapter<HivePack> {
  @override
  final int typeId = 10;

  @override
  HivePack read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePack(
      title: fields[11] as String,
      questions: (fields[12] as List).cast<HiveQuestion>(),
      enabled: fields[13] as bool,
      frequency: fields[14] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HivePack obj) {
    writer
      ..writeByte(4)
      ..writeByte(11)
      ..write(obj.title)
      ..writeByte(12)
      ..write(obj.questions)
      ..writeByte(13)
      ..write(obj.enabled)
      ..writeByte(14)
      ..write(obj.frequency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HivePackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveQuestionAdapter extends TypeAdapter<HiveQuestion> {
  @override
  final int typeId = 20;

  @override
  HiveQuestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveQuestion(
      cardNo: fields[21] as int,
      question: fields[22] as String,
      answers: (fields[23] as List).cast<HiveAnswer>(),
      attempted: fields[24] as int,
      correct: fields[25] as int,
      pastAnswers: (fields[26] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveQuestion obj) {
    writer
      ..writeByte(6)
      ..writeByte(21)
      ..write(obj.cardNo)
      ..writeByte(22)
      ..write(obj.question)
      ..writeByte(23)
      ..write(obj.answers)
      ..writeByte(24)
      ..write(obj.attempted)
      ..writeByte(25)
      ..write(obj.correct)
      ..writeByte(26)
      ..write(obj.pastAnswers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveQuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveAnswerAdapter extends TypeAdapter<HiveAnswer> {
  @override
  final int typeId = 30;

  @override
  HiveAnswer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveAnswer(
      text: fields[31] as String,
      correct: fields[32] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HiveAnswer obj) {
    writer
      ..writeByte(2)
      ..writeByte(31)
      ..write(obj.text)
      ..writeByte(32)
      ..write(obj.correct);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveAnswerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
