class Links {
  // Define the properties for Links based on your API response
  // For example:
  // final String self;
  // final String canonical;

  Links(
    // {
    // required this.self,
    // required this.canonical,
  // }
  );

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      // self: json['self'],
      // canonical: json['canonical'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'self': self,
      // 'canonical': canonical,
    };
  }
}
