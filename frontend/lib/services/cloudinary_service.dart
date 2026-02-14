

class CloudinaryService {
  // Simulating fetching memories from Cloudinary based on date
  Future<List<Map<String, dynamic>>> getMemories(DateTime date) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock data - In a real app, this would query your backend which returns Cloudinary URLs
    return [
      {
        'id': '1',
        'imageUrl': 'https://res.cloudinary.com/demo/image/upload/v1688625463/cld-sample-2.jpg',
        'title': 'Beach Day with Squad',
        'year': 2023,
        'caption': 'Best day ever! 🌊',
      },
      {
        'id': '2',
        'imageUrl': 'https://res.cloudinary.com/demo/image/upload/v1688625464/cld-sample-5.jpg',
        'title': 'Hiking Adventure',
        'year': 2022,
        'caption': 'Top of the world 🏔️',
      },
      {
        'id': '3',
        'imageUrl': 'https://res.cloudinary.com/demo/image/upload/v1688625462/cld-sample.jpg',
        'title': 'Random Chaos',
        'year': 2024,
        'caption': 'Just vibes ✨',
      },
    ];
  }
}
