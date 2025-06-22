# 🎯 AI Career Navigator — Day 1

An intelligent mobile app that helps students discover their ideal career path through an interactive AI-powered quiz.

---

## ✅ Day 1 Progress: Quiz System UI

### 📱 Features Implemented:
- Clean folder architecture using **Flutter**
- Custom UI for career quiz using `RadioListTile`
- **3 multiple-choice questions** pulled from static data
- Stores selected answers in a `Map`
- Navigates to a result screen on successful quiz submission
- Shows quiz responses on result screen (AI analysis coming next)
- Modern theming with **custom colors** and **components**

---

### 🗂️ Folder Structure

```bash
lib/
├── main.dart                  # App entry point
├── core/
│   └── constants.dart         # App-wide colors and styles
├── models/
│   └── question_model.dart    # Question model class
├── screens/
│   ├── quiz/
│   │   └── quiz_screen.dart   # Quiz UI with radio buttons
│   └── result/
│       └── result_screen.dart # Placeholder result page
├── widgets/
│   └── custom_radio_tile.dart # Styled reusable radio tile
├── data/
│   └── questions.dart         # Static quiz questions

```

# 🎯 AI Career Navigator — Day 2

An AI-powered career guidance app built with Flutter.  
Day 2 adds logic to intelligently suggest careers based on a user’s personality, preferences, and quiz answers.

---

## ✅ Day 2 Progress: Smart Career Analysis with AI Logic

### 📌 What's New
- Tags like `tech`, `creative`, `social`, etc., added to quiz answers
- An AI scoring system that tallies up user preferences
- A rule-based engine recommends careers based on highest scoring traits
- Clean & beautiful result UI with suggested career cards
- Modular, extensible code structure

---

### 📊 How AI Logic Works

1. **Tag Matching**  
   Each answer is tagged (e.g., “Math” → `tech`, “Art” → `creative`).

2. **Scoring**  
   The system counts how many times each tag appears in selected answers.

3. **Career Mapping**  
   Top tags are mapped to relevant careers like:

   | Tag       | Suggested Careers                  |
      |-----------|------------------------------------|
   | `tech`    | Software Developer, Data Scientist |
   | `creative`| UI/UX Designer, Animator           |
   | `social`  | Teacher, Psychologist              |
   | `literary`| Writer, Editor                     |
   | `practical`| Engineer, Technician              |

4. **Result Screen**  
   Displays top 2–4 suggested careers using clean UI cards.

---

### 🧠 Folder Additions

```bash
lib/
├── utils/
│   └── ai_engine.dart          # AI logic: scoring + recommendation
├── data/
│   └── questions.dart          # Updated with tags
├── models/
│   └── question_model.dart     # Now includes tag list
└── screens/
    └── result/
        └── result_screen.dart  # Intelligent suggestions + new UI
```