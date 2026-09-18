import '../entities/event.dart';

abstract class EventRepository {
  Future<List<Event>> getTrendingEvents();
  Future<List<Event>> getPopularNearYou();
  Future<List<Event>> getRecommendedEvents();
}
