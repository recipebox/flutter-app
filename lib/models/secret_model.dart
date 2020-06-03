class Secret {
  final String elsticUrl;
  final String elsticKey;
  final String elsticSecret;
  Secret({this.elsticKey, this.elsticSecret, this.elsticUrl});
  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return new Secret(
        elsticUrl: jsonMap["elastic_url"],
        elsticKey: jsonMap["elastic_key"],
        elsticSecret: jsonMap["elastic_secret"]);
  }
}
