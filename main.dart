import 'dart:io';
import 'dart:math';

List<String> board = List.generate(9, (index) => (index + 1).toString());
late String humanMarker;
late String aiMarker;
bool vsAI = true; // Change to false for two human players

void main() {
  print("=== Welcome to Tic-Tac-Toe ===");
  chooseMarkers();
  do {
    startGame();
    print("Do you want to play again? (y/n): ");
  } while (stdin.readLineSync()!.toLowerCase() == 'y');
  print("Thanks for playing!");
}

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

void startGame() {
  board = List.generate(9, (index) => (index + 1).toString());
  String currentPlayer = 'X';
  int moves = 0;

  while (true) {
    displayBoard();
    if (vsAI && currentPlayer == aiMarker) {
      print("AI is thinking...");
      sleep(Duration(seconds: 1));
      int move = getAIMove();
      board[move] = aiMarker;
      print("AI played at position ${move + 1}");
    } else {
      int move = getPlayerMove(currentPlayer);
      board[move] = currentPlayer;
    }

    moves++;

    if (checkWinner(currentPlayer)) {
      displayBoard();
      print("Player $currentPlayer wins!");
      break;
    } else if (moves == 9) {
      displayBoard();
      print("It's a draw!");
      break;
    }

    currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
  }
}

void displayBoard() {
  print('\n');
  print(' ${board[0]} | ${board[1]} | ${board[2]} ');
  print('---+---+---');
  print(' ${board[3]} | ${board[4]} | ${board[5]} ');
  print('---+---+---');
  print(' ${board[6]} | ${board[7]} | ${board[8]} ');
  print('\n');
}

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

int getAIMove() {
  List<int> emptyCells = [];
  for (int i = 0; i < 9; i++) {
    if (board[i] != 'X' && board[i] != 'O') {
      emptyCells.add(i);
    }
  }

  // Simple AI: Random valid move
  return emptyCells[Random().nextInt(emptyCells.length)];
}

bool checkWinner(String player) {
  List<List<int>> winPositions = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    [0, 4, 8], [2, 4, 6]
  ];

  for (var pos in winPositions) {
    if (board[pos[0]] == player && board[pos[1]] == player && board[pos[2]] == player) {
      return true;
    }
  }
  return false;
}
