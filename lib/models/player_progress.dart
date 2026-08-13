/// Persistent player progress model.
class PlayerProgress {
  final int highestUnlockedLevel;
  final Map<int, int> levelStars;
  final Map<int, int> levelBestMoves;
  final Map<int, double> levelBestTimes;
  final String equippedSkinId;
  final List<String> unlockedSkinIds;
  final bool removeAdsPurchased;

  const PlayerProgress({
    this.highestUnlockedLevel = 1,
    this.levelStars = const {},
    this.levelBestMoves = const {},
    this.levelBestTimes = const {},
    this.equippedSkinId = 'skin_classic',
    this.unlockedSkinIds = const ['skin_classic'],
    this.removeAdsPurchased = false,
  });

  PlayerProgress copyWith({
    int? highestUnlockedLevel,
    Map<int, int>? levelStars,
    Map<int, int>? levelBestMoves,
    Map<int, double>? levelBestTimes,
    String? equippedSkinId,
    List<String>? unlockedSkinIds,
    bool? removeAdsPurchased,
  }) {
    return PlayerProgress(
      highestUnlockedLevel: highestUnlockedLevel ?? this.highestUnlockedLevel,
      levelStars: levelStars ?? this.levelStars,
      levelBestMoves: levelBestMoves ?? this.levelBestMoves,
      levelBestTimes: levelBestTimes ?? this.levelBestTimes,
      equippedSkinId: equippedSkinId ?? this.equippedSkinId,
      unlockedSkinIds: unlockedSkinIds ?? this.unlockedSkinIds,
      removeAdsPurchased: removeAdsPurchased ?? this.removeAdsPurchased,
    );
  }

  Map<String, dynamic> toJson() => {
        'highestUnlockedLevel': highestUnlockedLevel,
        'levelStars': levelStars.map((k, v) => MapEntry(k.toString(), v)),
        'levelBestMoves': levelBestMoves.map((k, v) => MapEntry(k.toString(), v)),
        'levelBestTimes': levelBestTimes.map((k, v) => MapEntry(k.toString(), v)),
        'equippedSkinId': equippedSkinId,
        'unlockedSkinIds': unlockedSkinIds,
        'removeAdsPurchased': removeAdsPurchased,
      };

  factory PlayerProgress.fromJson(Map<String, dynamic> json) {
    final rawStars = json['levelStars'] as Map<String, dynamic>? ?? {};
    final stars = rawStars.map((k, v) => MapEntry(int.parse(k), v as int));

    final rawMoves = json['levelBestMoves'] as Map<String, dynamic>? ?? {};
    final moves = rawMoves.map((k, v) => MapEntry(int.parse(k), v as int));

    final rawTimes = json['levelBestTimes'] as Map<String, dynamic>? ?? {};
    final times = rawTimes.map((k, v) => MapEntry(int.parse(k), (v as num).toDouble()));

    final skins = (json['unlockedSkinIds'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const ['skin_classic'];

    return PlayerProgress(
      highestUnlockedLevel: json['highestUnlockedLevel'] as int? ?? 1,
      levelStars: stars,
      levelBestMoves: moves,
      levelBestTimes: times,
      equippedSkinId: json['equippedSkinId'] as String? ?? 'skin_classic',
      unlockedSkinIds: skins,
      removeAdsPurchased: json['removeAdsPurchased'] as bool? ?? false,
    );
  }
}
