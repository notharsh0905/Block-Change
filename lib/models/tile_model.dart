/// Special tile behavior classifications.
enum TileType { normal, bomb, freeze, lock }

/// Authored special tile placement metadata.
class TileDefinition {
  final int row;
  final int column;
  final TileType type;
  final double lockDuration;

  const TileDefinition({
    required this.row,
    required this.column,
    required this.type,
    this.lockDuration = 5.0,
  });

  Map<String, dynamic> toJson() => {
        'row': row,
        'column': column,
        'type': type.name,
        'lockDuration': lockDuration,
      };

  factory TileDefinition.fromJson(Map<String, dynamic> json) {
    return TileDefinition(
      row: json['row'] as int,
      column: json['column'] as int,
      type: TileType.values.byName(json['type'] as String),
      lockDuration: (json['lockDuration'] as num?)?.toDouble() ?? 5.0,
    );
  }
}

/// Immutable grid tile state model.
class TileModel {
  final int row;
  final int col;
  final int colorIndex;
  final TileType type;
  final double lockRemainingSeconds;

  const TileModel({
    required this.row,
    required this.col,
    required this.colorIndex,
    this.type = TileType.normal,
    this.lockRemainingSeconds = 0.0,
  });

  bool get isLocked => type == TileType.lock && lockRemainingSeconds > 0.0;

  TileModel copyWith({
    int? row,
    int? col,
    int? colorIndex,
    TileType? type,
    double? lockRemainingSeconds,
  }) {
    return TileModel(
      row: row ?? this.row,
      col: col ?? this.col,
      colorIndex: colorIndex ?? this.colorIndex,
      type: type ?? this.type,
      lockRemainingSeconds: lockRemainingSeconds ?? this.lockRemainingSeconds,
    );
  }

  Map<String, dynamic> toJson() => {
        'row': row,
        'col': col,
        'colorIndex': colorIndex,
        'type': type.name,
        'lockRemainingSeconds': lockRemainingSeconds,
      };

  factory TileModel.fromJson(Map<String, dynamic> json) {
    return TileModel(
      row: json['row'] as int,
      col: json['col'] as int,
      colorIndex: json['colorIndex'] as int,
      type: TileType.values.byName(json['type'] as String),
      lockRemainingSeconds:
          (json['lockRemainingSeconds'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
