class RecipePreviewModel {
  final String id;
  final String title;
  final String description;
  final List<String> photos;
  final List<String> ingredientIDs;
  String status;

  RecipePreviewModel(this.id, this.title, this.description, this.photos,
      this.ingredientIDs, this.status);

  factory RecipePreviewModel.fromElasticSearch(
      String id, Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    List photoJson = data['photos'] ?? [];
    final photoArray = photoJson.map((f) => f.toString()).toList();

    List ingredientJson = data['ingredientIDs'] ?? [];
    final ingredientArray = ingredientJson.map((f) => f.toString()).toList();

    final String title = data['title'] ?? '';
    final String description = data['description'] ?? '';
    final List<String> photos = photoArray ?? [];
    final List<String> ingredientIDs = ingredientArray ?? [];
    final String status = data['status'] ?? '';
    return RecipePreviewModel(
        id, title, description, photos, ingredientIDs, status);
  }
}
