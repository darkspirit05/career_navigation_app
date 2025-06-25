import '../models/question_model.dart';

/// List of sample career quiz questions.
final List<Question> sampleQuestions = [
  Question(
    question: 'What subjects do you enjoy most?',
    options: ['Math', 'Science', 'Art', 'Literature'],
    tags: ['tech', 'tech', 'creative', 'literary'],
  ),
  Question(
    question: 'What kind of work do you prefer?',
    options: ['Creative', 'Analytical', 'Practical', 'Helping others'],
    tags: ['creative', 'tech', 'practical', 'social'],
  ),
  Question(
    question: 'How do you solve problems?',
    options: ['Logically', 'Creatively', 'Emotionally', 'Physically'],
    tags: ['tech', 'creative', 'social', 'practical'],
  ),
  Question(
    question: 'What type of activities do you enjoy?',
    options: ['Writing', 'Building things', 'Designing', 'Counseling'],
    tags: ['literary', 'practical', 'creative', 'social'],
  ),
  Question(
    question: 'Which tool would you prefer to use?',
    options: ['Computer', 'Paintbrush', 'Blueprint', 'Notebook'],
    tags: ['tech', 'creative', 'practical', 'literary'],
  ),
  Question(
    question: 'What kind of challenges excite you?',
    options: ['Technical', 'Emotional', 'Creative', 'Organizational'],
    tags: ['tech', 'social', 'creative', 'literary'],
  ),
];
