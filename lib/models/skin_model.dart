/// Cosmetic skin unlock requirement categories.
enum SkinUnlockMethod { free, rewardedAd, premiumPurchase, starMilestone }

/// Cosmetic theme definition for block artwork rendering.
class SkinModel {
  final String id;
  final String displayName;
  final SkinUnlockMethod unlockMethod;
  final String? productId;
  final int requiredStars;
  final bool isUnlockedByDefault;
  final List<String> colorAssetPaths;

  const SkinModel({
    required this.id,
    required this.displayName,
    required this.unlockMethod,
    this.productId,
    this.requiredStars = 0,
    this.isUnlockedByDefault = false,
    required this.colorAssetPaths,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'displayName': displayName,
    'unlockMethod': unlockMethod.name,
    'productId': productId,
    'requiredStars': requiredStars,
    'isUnlockedByDefault': isUnlockedByDefault,
    'colorAssetPaths': colorAssetPaths,
  };

  factory SkinModel.fromJson(Map<String, dynamic> json) {
    return SkinModel(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      unlockMethod: SkinUnlockMethod.values.byName(
        json['unlockMethod'] as String,
      ),
      productId: json['productId'] as String?,
      requiredStars: json['requiredStars'] as int? ?? 0,
      isUnlockedByDefault: json['isUnlockedByDefault'] as bool? ?? false,
      colorAssetPaths: (json['colorAssetPaths'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }
}
