class Event {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String venue;
  final String city;
  final double price;
  final double rating;
  final String imageUrl;
  final String category;
  bool isFavorite;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.venue,
    required this.city,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.category,
    this.isFavorite = false,
  });
}
