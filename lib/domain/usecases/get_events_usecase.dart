import '../entities/event.dart';
import '../repositories/event_repository.dart';

enum EventFetchType { trending, popular, recommended }

class GetEventsUseCase {
  final EventRepository repository;

  GetEventsUseCase(this.repository);

  Future<List<Event>> execute(EventFetchType type) {
    switch (type) {
      case EventFetchType.trending:
        return repository.getTrendingEvents();
      case EventFetchType.popular:
        return repository.getPopularNearYou();
      case EventFetchType.recommended:
        return repository.getRecommendedEvents();
    }
  }
}
