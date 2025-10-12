// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lang.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LangAdapter extends TypeAdapter<Lang> {
  @override
  final int typeId = 1;

  @override
  Lang read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lang(
      responseData: fields[1] as ResponseData,
      quotaFinished: fields[2] as bool,
      mtLangSupported: fields[3] as dynamic,
      responseDetails: fields[4] as String,
      responseStatus: fields[5] as int,
      responderId: fields[6] as dynamic,
      exceptionCode: fields[7] as dynamic,
      matches: (fields[8] as List).cast<Match>(),
    );
  }

  @override
  void write(BinaryWriter writer, Lang obj) {
    writer
      ..writeByte(8)
      ..writeByte(1)
      ..write(obj.responseData)
      ..writeByte(2)
      ..write(obj.quotaFinished)
      ..writeByte(3)
      ..write(obj.mtLangSupported)
      ..writeByte(4)
      ..write(obj.responseDetails)
      ..writeByte(5)
      ..write(obj.responseStatus)
      ..writeByte(6)
      ..write(obj.responderId)
      ..writeByte(7)
      ..write(obj.exceptionCode)
      ..writeByte(8)
      ..write(obj.matches);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LangAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MatchAdapter extends TypeAdapter<Match> {
  @override
  final int typeId = 2;

  @override
  Match read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Match(
      id: fields[1] as String,
      segment: fields[2] as String,
      translation: fields[3] as String,
      source: fields[4] as String,
      target: fields[5] as String,
      quality: fields[6] as double,
      reference: fields[7] as dynamic,
      usageCount: fields[8] as int,
      subject: fields[9] as String,
      createdBy: fields[10] as String,
      lastUpdatedBy: fields[11] as String,
      createDate: fields[12] as DateTime,
      lastUpdateDate: fields[13] as DateTime,
      match: fields[14] as double,
      penalty: fields[15] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Match obj) {
    writer
      ..writeByte(15)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.segment)
      ..writeByte(3)
      ..write(obj.translation)
      ..writeByte(4)
      ..write(obj.source)
      ..writeByte(5)
      ..write(obj.target)
      ..writeByte(6)
      ..write(obj.quality)
      ..writeByte(7)
      ..write(obj.reference)
      ..writeByte(8)
      ..write(obj.usageCount)
      ..writeByte(9)
      ..write(obj.subject)
      ..writeByte(10)
      ..write(obj.createdBy)
      ..writeByte(11)
      ..write(obj.lastUpdatedBy)
      ..writeByte(12)
      ..write(obj.createDate)
      ..writeByte(13)
      ..write(obj.lastUpdateDate)
      ..writeByte(14)
      ..write(obj.match)
      ..writeByte(15)
      ..write(obj.penalty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ResponseDataAdapter extends TypeAdapter<ResponseData> {
  @override
  final int typeId = 3;

  @override
  ResponseData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResponseData(
      translatedText: fields[1] as String,
      match: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ResponseData obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.translatedText)
      ..writeByte(2)
      ..write(obj.match);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponseDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
