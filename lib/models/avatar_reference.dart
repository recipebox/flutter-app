class AvatarReference {
  AvatarReference(this.photoUrl);
  final String photoUrl;

  factory AvatarReference.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String photoUrl = data['photoUrl'];
    if (photoUrl == null) {
      return null;
    }
    return AvatarReference(photoUrl);
  }

  Map<String, dynamic> toMap() {
    return {
      'photoUrl': photoUrl,
    };
  }
}
