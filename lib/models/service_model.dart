class ServiceModel {
  final String title;
  final String category;
  final String description;
  final String price;
  final String currency;
  final String time;
  final List<String> requiredDocs;

  const ServiceModel({
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.currency,
    required this.time,
    required this.requiredDocs,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      title: (map['title'] ?? '').toString(),
      category: (map['category'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      price: (map['price'] ?? '').toString(),
      currency: (map['currency'] ?? '').toString(),
      time: (map['time'] ?? '').toString(),
      requiredDocs: List<String>.from(map['requiredDocs'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'description': description,
      'price': price,
      'currency': currency,
      'time': time,
      'requiredDocs': requiredDocs,
    };
  }
}