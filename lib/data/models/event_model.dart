import '../../domain/entities/event.dart';

class EventModel {
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
  final bool isFavorite;

  EventModel({
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

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      venue: json['venue'] ?? '',
      city: json['city'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Event toEntity() {
    return Event(
      id: id,
      title: title,
      description: description,
      date: date,
      time: time,
      venue: venue,
      city: city,
      price: price,
      rating: rating,
      imageUrl: imageUrl,
      category: category,
      isFavorite: isFavorite,
    );
  }
}
