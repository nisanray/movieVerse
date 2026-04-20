import '../../domain/entities/media_details_entities.dart';

class CastModel extends Cast {
  CastModel({
    required super.id,
    required super.name,
    required super.character,
    super.profilePath,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      profilePath: json['profile_path'],
    );
  }
}

class VideoModel extends Video {
  VideoModel({
    required super.id,
    required super.name,
    required super.key,
    required super.site,
    required super.type,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      key: json['key'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
    );
  }

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$key';
}

class WatchProviderModel extends WatchProvider {
  WatchProviderModel({
    required super.providerId,
    required super.providerName,
    super.logoPath,
    required super.displayPriority,
  });

  factory WatchProviderModel.fromJson(Map<String, dynamic> json) {
    return WatchProviderModel(
      providerId: json['provider_id'] ?? 0,
      providerName: json['provider_name'] ?? '',
      logoPath: json['logo_path'],
      displayPriority: json['display_priority'] ?? 0,
    );
  }
}
