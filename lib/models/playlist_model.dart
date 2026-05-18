
class PlaylistModel {
  final String id;
  final String name;
  final List<int> songIds; // Store song IDs for reference
  final int createdAt;
  final int updatedAt;

  PlaylistModel({
    required this.id,
    required this.name,
    required this.songIds,
    required this.createdAt,
    required this.updatedAt,
  });

  PlaylistModel copyWith({
    String? id,
    String? name,
    List<int>? songIds,
    int? createdAt,
    int? updatedAt,
  }) {
    return PlaylistModel(
      id: id ?? this.id,
      name: name ?? this.name,
      songIds: songIds ?? this.songIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'songIds': songIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id'] as String,
      name: json['name'] as String,
      songIds: List<int>.from(json['songIds'] as List),
      createdAt: json['createdAt'] as int,
      updatedAt: json['updatedAt'] as int,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
