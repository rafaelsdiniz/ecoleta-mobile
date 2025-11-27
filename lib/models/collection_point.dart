class CollectionPoint {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final List<String> items;
  final double latitude;
  final double longitude;
  final String? imageUrl;

  CollectionPoint({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.items,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
  });
}
