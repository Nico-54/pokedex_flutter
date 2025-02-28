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
      sprites: fields[2] as String,
      shinySprites: fields[3] as String,
      gmaxSprites: fields[4] as String?,
      types: (fields[5] as List).cast<PokemonType>(),
      stats: fields[6] as Stats,
      category: fields[7] as String,
      generation: fields[8] as int,
      isSelected: fields[10] as bool,
      evolution: fields[9] as Evolution?,
    );
  }

  @override
  void write(BinaryWriter writer, Pokemon obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.sprites)
      ..writeByte(3)
      ..write(obj.shinySprites)
      ..writeByte(4)
      ..write(obj.gmaxSprites)
      ..writeByte(5)
      ..write(obj.types)
      ..writeByte(6)
      ..write(obj.stats)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.generation)
      ..writeByte(9)
      ..write(obj.evolution)
      ..writeByte(10)
      ..write(obj.isSelected);
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

class PokemonTypeAdapter extends TypeAdapter<PokemonType> {
  @override
  final int typeId = 2;

  @override
  PokemonType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonType(
      name: fields[0] as String,
      imageUrl: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PokemonType obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EvolutionAdapter extends TypeAdapter<Evolution> {
  @override
  final int typeId = 3;

  @override
  Evolution read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Evolution(
      pre: (fields[0] as List?)?.cast<EvolutionStep>(),
      next: (fields[1] as List?)?.cast<EvolutionStep>(),
    );
  }

  @override
  void write(BinaryWriter writer, Evolution obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.pre)
      ..writeByte(1)
      ..write(obj.next);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvolutionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EvolutionStepAdapter extends TypeAdapter<EvolutionStep> {
  @override
  final int typeId = 4;

  @override
  EvolutionStep read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EvolutionStep(
      pokedexId: fields[0] as int,
      name: fields[1] as String,
      condition: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EvolutionStep obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.pokedexId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.condition);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvolutionStepAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
