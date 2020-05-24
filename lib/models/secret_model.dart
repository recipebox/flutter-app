class Secret {
  final String elsticUrl;
  final String elsticUser;
  final String elsticPass;
  Secret({this.elsticUser, this.elsticPass, this.elsticUrl});
  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return new Secret(
        elsticUrl: jsonMap["elastic_url"],
        elsticUser: jsonMap["elastic_user"],
        elsticPass: jsonMap["elastic_pass"]);
  }
}
