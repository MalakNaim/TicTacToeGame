import 'dart:io';
import 'dart:math';

// يمثل اللوحة كمصفوفة من 9 خانات
List<String> board = List.generate(9, (index) => (index + 1).toString());

// المتغيرات العامة للاعبين
late String humanMarker;
late String aiMarker;
bool vsAI = true; // يتم تغييره بناءً على اختيار المستخدم

void main() {
  print("=== Welcome to Tic-Tac-Toe ===");
  chooseMarkers(); // استدعاء وظيفة اختيار الرموز
  do {
    startGame(); // تشغيل اللعبة
    print("Do you want to play again? (y/n): ");
  } while (stdin.readLineSync()!.toLowerCase() == 'y');
  print("Thanks for playing!");
}

// يسمح للاعب باختيار X أو O، وتحديد إذا كان يريد اللعب ضد AI
void chooseMarkers() {
  stdout.write("Choose your marker (X or O): ");
  String? choice = stdin.readLineSync();
  if (choice != null && choice.toUpperCase() == 'O') {
    humanMarker = 'O';
    aiMarker = 'X';
  } else {
    humanMarker = 'X';
    aiMarker = 'O';
  }

  stdout.write("Do you want to play vs AI? (y/n): ");
  vsAI = stdin.readLineSync()!.toLowerCase() == 'y';
}

// يبدأ اللعبة ويعيد تعيين اللوحة
void startGame() {
  board = List.generate(9, (index) => (index + 1).toString());
  String currentPlayer = 'X';
  int moves = 0;

  while (true) {
    displayBoard(); // عرض اللوحة

    if (vsAI && currentPlayer == aiMarker) {
      // AI يلعب دوره
      print("AI is thinking...");
      sleep(Duration(seconds: 1));
      int move = getAIMove(); // اختيار حركة AI
      board[move] = aiMarker;
      print("AI played at position ${move + 1}");
    } else {
      // اللاعب البشري يلعب دوره
      int move = getPlayerMove(currentPlayer);
      board[move] = currentPlayer;
    }

    moves++;

    // التحقق إذا كان هناك فائز
    if (checkWinner(currentPlayer)) {
      displayBoard();
      print("Player $currentPlayer wins!");
      break;
    } else if (moves == 9) {
      // تعادل
      displayBoard();
      print("It's a draw!");
      break;
    }

    // تبديل الأدوار
    currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
  }
}

// يعرض اللوحة بشكل بصري في الطرفية
void displayBoard() {
  print('\n');
  print(' ${board[0]} | ${board[1]} | ${board[2]} ');
  print('---+---+---');
  print(' ${board[3]} | ${board[4]} | ${board[5]} ');
  print('---+---+---');
  print(' ${board[6]} | ${board[7]} | ${board[8]} ');
  print('\n');
}

// يأخذ إدخال اللاعب ويتحقق من صحته
int getPlayerMove(String player) {
  while (true) {
    stdout.write("Player $player, enter your move (1-9): ");
    String? input = stdin.readLineSync();
    if (input == null) continue;

    int? pos = int.tryParse(input);
    if (pos != null && pos >= 1 && pos <= 9 && board[pos - 1] != 'X' && board[pos - 1] != 'O') {
      return pos - 1;
    } else {
      print("Invalid move. Try again.");
    }
  }
}

// AI يختار خانة فارغة عشوائياً
int getAIMove() {
  List<int> emptyCells = [];
  for (int i = 0; i < 9; i++) {
    if (board[i] != 'X' && board[i] != 'O') {
      emptyCells.add(i);
    }
  }

  return emptyCells[Random().nextInt(emptyCells.length)];
}

// يتحقق من وجود فائز
bool checkWinner(String player) {
  List<List<int>> winPositions = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // الصفوف
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // الأعمدة
    [0, 4, 8], [2, 4, 6]             // القطرين
  ];

  for (var pos in winPositions) {
    if (board[pos[0]] == player && board[pos[1]] == player && board[pos[2]] == player) {
      return true;
    }
  }
  return false;
}
