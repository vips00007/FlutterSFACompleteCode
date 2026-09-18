import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  @override
  Future<List<Event>> getTrendingEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Event(
        id: '1',
        title: 'Arijit Singh Live',
        description: 'Experience the magic of Arijit Singh live in concert.',
        date: 'Sat, 25 May',
        time: '7:00 PM',
        venue: 'Brilliant Convention Centre, Indore',
        city: 'Indore',
        price: 1499,
        rating: 4.8,
        imageUrl:
            'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?q=80&w=800&auto=format&fit=crop',
        category: 'MUSIC',
      ),
      Event(
        id: '2',
        title: 'India vs Australia',
        description: 'High intensity cricket match between rivals.',
        date: 'Sun, 02 Jun',
        time: '3:00 PM',
        venue: 'Holkar Stadium, Indore',
        city: 'Indore',
        price: 999,
        rating: 4.7,
        imageUrl:
            'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?q=80&w=800&auto=format&fit=crop',
        category: 'SPORTS',
      ),
      Event(
        id: '3',
        title: 'Standup Comedy Night',
        description: 'Laugh out loud with top comedians.',
        date: 'Fri, 07 Jun',
        time: '8:00 PM',
        venue: 'Malhar Mega Mall, Indore',
        city: 'Indore',
        price: 499,
        rating: 4.6,
        imageUrl:
            'https://images.unsplash.com/photo-1585699324551-f6c309eedee6?q=80&w=800&auto=format&fit=crop',
        category: 'COMEDY',
      ),
    ];
  }

  @override
  Future<List<Event>> getPopularNearYou() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Event(
        id: '4',
        title: 'Sunburn Arena',
        description: 'Biggest EDM festival.',
        date: '15 Jun',
        time: '6:00 PM',
        venue: 'Indore',
        city: 'Indore',
        price: 2199,
        rating: 4.9,
        imageUrl:
            'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=800&auto=format&fit=crop',
        category: 'MUSIC',
      ),
      Event(
        id: '5',
        title: 'Food & Music Fest',
        description: 'Delicious food and great tunes.',
        date: '21 Jun',
        time: '5:00 PM',
        venue: 'Indore',
        city: 'Indore',
        price: 0,
        rating: 4.5,
        imageUrl:
            'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=800&auto=format&fit=crop',
        category: 'FOOD',
      ),
      Event(
        id: '6',
        title: 'Art & Craft Expo',
        description: 'Local artisans showcase.',
        date: '28 Jun',
        time: '11:00 AM',
        venue: 'Indore',
        city: 'Indore',
        price: 0,
        rating: 4.6,
        imageUrl:
            'https://images.unsplash.com/photo-1460661419201-fd4ce18a8024?q=80&w=800&auto=format&fit=crop',
        category: 'ART',
      ),
    ];
  }

  @override
  Future<List<Event>> getRecommendedEvents() async {
    return [
      Event(
        id: '7',
        title: 'Dance Workshop',
        description: 'Learn from the best.',
        date: '05 Jul',
        time: '4:00 PM',
        venue: 'Indore',
        city: 'Indore',
        price: 299,
        rating: 4.4,
        imageUrl:
            'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?q=80&w=800&auto=format&fit=crop',
        category: 'DANCE',
      ),
    ];
  }
}
