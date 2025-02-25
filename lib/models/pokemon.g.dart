// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PokemonAdapter extends TypeAdapter<Pokemon> {
  @override
  final int typeId = 0;

  @override
  Pokemon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pokemon(
      id: fields[0] as int,
      name: fields[1] as String,
      imageUrl: fields[2] as String,
      types: (fields[3] as List).cast<PokemonType>(),
      stats: fields[4] as Stats,
      category: fields[5] as String,
      isSelected: fields[6] as bool,
      // resistances: (fields[7] as List).cast<String>(),
      // imunes: (fields[8] as List).cast<String>(),
      // weaks: (fields[9] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Pokemon obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.types)
      ..writeByte(4)
      ..write(obj.stats)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.isSelected);
      // ..writeByte(7)
      // ..write(obj.resistances)
      // ..writeByte(8)
      // ..write(obj.imunes)
      // ..writeByte(9)
      // ..write(obj.weaks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StatsAdapter extends TypeAdapter<Stats> {
  @override
  final int typeId = 1;

  @override
  Stats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Stats(
      hp: fields[0] as int,
      attack: fields[1] as int,
      defense: fields[2] as int,
      specialAttack: fields[3] as int,
      specialDefense: fields[4] as int,
      speed: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Stats obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.hp)
      ..writeByte(1)
      ..write(obj.attack)
      ..writeByte(2)
      ..write(obj.defense)
      ..writeByte(3)
      ..write(obj.specialAttack)
      ..writeByte(4)
      ..write(obj.specialDefense)
      ..writeByte(5)
      ..write(obj.speed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
