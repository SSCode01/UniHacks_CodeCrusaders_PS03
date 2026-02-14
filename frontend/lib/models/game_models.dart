// Game data models for mini-games

class GameMember {
  final String id;
  final String name;
  final String avatar;
  int points;

  GameMember({
    required this.id,
    required this.name,
    required this.avatar,
    this.points = 0,
  });
}

class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String category;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.category,
  });
}

class Answer {
  final String userId;
  final String userName;
  final String userAvatar;
  final String answer;
  int votes;

  Answer({
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.answer,
    this.votes = 0,
  });
}

class WouldYouRatherQuestion {
  final String id;
  final String question;
  final String optionA;
  final String optionB;
  final String emoji;

  WouldYouRatherQuestion({
    required this.id,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.emoji,
  });
}

class MemeTemplate {
  final String id;
  final String emoji;
  final String description;

  MemeTemplate({
    required this.id,
    required this.emoji,
    required this.description,
  });
}

class Caption {
  final String userId;
  final String userName;
  final String userAvatar;
  final String caption;
  int votes;

  Caption({
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.caption,
    this.votes = 0,
  });
}

// Mock data
class GameData {
  static final List<GameMember> mockMembers = [
    GameMember(id: '1', name: 'You', avatar: '😎'),
    GameMember(id: '2', name: 'Alex', avatar: '🤪'),
    GameMember(id: '3', name: 'Sam', avatar: '🔥'),
    GameMember(id: '4', name: 'Jordan', avatar: '✨'),
  ];

  static final List<String> truths = [
    'What\'s your most embarrassing moment?',
    'Who was your first crush?',
    'What\'s the biggest lie you\'ve ever told?',
    'What\'s your guilty pleasure?',
    'What\'s the weirdest dream you\'ve had?',
    'What\'s something you\'ve never told anyone?',
    'Who in this group would you trust with a secret?',
    'What\'s your biggest fear?',
    'What\'s the most trouble you\'ve been in?',
    'What\'s your most unpopular opinion?',
  ];

  static final List<String> dares = [
    'Send a voice message singing your favorite song',
    'Change your profile picture to a meme for 24 hours',
    'Text your crush right now',
    'Do 20 pushups and send a video',
    'Post an embarrassing photo from your camera roll',
    'Call a random contact and sing happy birthday',
    'Let the group send a message from your account',
    'Share your most recent screenshot',
    'Dance to a song chosen by the group',
    'Speak in an accent for the next 10 minutes',
  ];

  static final List<WouldYouRatherQuestion> wouldYouRatherQuestions = [
    WouldYouRatherQuestion(
      id: '1',
      question: 'Would you rather...',
      optionA: 'Have the ability to fly',
      optionB: 'Have the ability to be invisible',
      emoji: '✈️',
    ),
    WouldYouRatherQuestion(
      id: '2',
      question: 'Would you rather...',
      optionA: 'Always be 10 minutes late',
      optionB: 'Always be 20 minutes early',
      emoji: '⏰',
    ),
    WouldYouRatherQuestion(
      id: '3',
      question: 'Would you rather...',
      optionA: 'Live without music',
      optionB: 'Live without movies',
      emoji: '🎵',
    ),
    WouldYouRatherQuestion(
      id: '4',
      question: 'Would you rather...',
      optionA: 'Be able to read minds',
      optionB: 'Be able to see the future',
      emoji: '🔮',
    ),
    WouldYouRatherQuestion(
      id: '5',
      question: 'Would you rather...',
      optionA: 'Have unlimited money',
      optionB: 'Have unlimited free time',
      emoji: '💰',
    ),
    WouldYouRatherQuestion(
      id: '6',
      question: 'Would you rather...',
      optionA: 'Never use social media again',
      optionB: 'Never watch another movie/TV show',
      emoji: '📱',
    ),
    WouldYouRatherQuestion(
      id: '7',
      question: 'Would you rather...',
      optionA: 'Be famous but poor',
      optionB: 'Be rich but unknown',
      emoji: '⭐',
    ),
    WouldYouRatherQuestion(
      id: '8',
      question: 'Would you rather...',
      optionA: 'Live in the past',
      optionB: 'Live in the future',
      emoji: '🕰️',
    ),
  ];

  static final List<MemeTemplate> memeTemplates = [
    MemeTemplate(id: '1', emoji: '😂', description: 'Crying laughing'),
    MemeTemplate(id: '2', emoji: '🤔', description: 'Thinking hard'),
    MemeTemplate(id: '3', emoji: '😱', description: 'Shocked face'),
    MemeTemplate(id: '4', emoji: '🔥', description: 'This is fine'),
    MemeTemplate(id: '5', emoji: '💀', description: 'Dead inside'),
    MemeTemplate(id: '6', emoji: '🤡', description: 'Clown moment'),
    MemeTemplate(id: '7', emoji: '👁️👄👁️', description: 'Surprised'),
    MemeTemplate(id: '8', emoji: '😎', description: 'Cool guy'),
  ];

  static final List<Question> triviaQuestions = [
    Question(
      id: '1',
      question: 'What is the capital of France?',
      options: ['London', 'Paris', 'Berlin', 'Madrid'],
      correctAnswer: 1,
      category: 'Geography',
    ),
    Question(
      id: '2',
      question: 'Which planet is known as the Red Planet?',
      options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      correctAnswer: 1,
      category: 'Science',
    ),
    Question(
      id: '3',
      question: 'Who painted the Mona Lisa?',
      options: ['Van Gogh', 'Picasso', 'Da Vinci', 'Monet'],
      correctAnswer: 2,
      category: 'Art',
    ),
    Question(
      id: '4',
      question: 'What is 7 × 8?',
      options: ['54', '56', '58', '60'],
      correctAnswer: 1,
      category: 'Math',
    ),
    Question(
      id: '5',
      question: 'Which is the largest ocean?',
      options: ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
      correctAnswer: 3,
      category: 'Geography',
    ),
    Question(
      id: '6',
      question: 'How many continents are there?',
      options: ['5', '6', '7', '8'],
      correctAnswer: 2,
      category: 'Geography',
    ),
    Question(
      id: '7',
      question: 'What year did World War II end?',
      options: ['1943', '1944', '1945', '1946'],
      correctAnswer: 2,
      category: 'History',
    ),
    Question(
      id: '8',
      question: 'What is the chemical symbol for gold?',
      options: ['Go', 'Gd', 'Au', 'Ag'],
      correctAnswer: 2,
      category: 'Science',
    ),
    Question(
      id: '9',
      question: 'Which programming language is known for web development?',
      options: ['Python', 'JavaScript', 'C++', 'Swift'],
      correctAnswer: 1,
      category: 'Technology',
    ),
    Question(
      id: '10',
      question: 'What is the smallest prime number?',
      options: ['0', '1', '2', '3'],
      correctAnswer: 2,
      category: 'Math',
    ),
  ];
}
