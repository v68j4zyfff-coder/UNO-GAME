import 'card.dart';
import 'deck.dart';

class GameState {
  List<UnoCard> deck = [];
  List<UnoCard> discard = [];
  List<List<UnoCard>> hands = [[], [], [], []];
  int currentPlayer = 0;
  int direction = 1;
  bool awaitingColorPick = false;
  UnoCard? pendingWild;
  String? message;

  void start() {
    deck = buildDeck();
    hands = [[], [], [], []];
    discard = [];
    currentPlayer = 0;
    direction = 1;
    awaitingColorPick = false;
    pendingWild = null;
    message = null;

    for (int i = 0; i < 7; i++) {
      for (int p = 0; p < 4; p++) {
        hands[p].add(deck.removeLast());
      }
    }
    UnoCard first;
    do {
      first = deck.removeLast();
      if (first.color == CardColor.wild) deck.insert(0, first);
    } while (first.color == CardColor.wild);
    discard.add(first);
  }

  UnoCard get topCard => discard.last;

  void drawForCurrent({int count = 1}) {
    for (int i = 0; i < count; i++) {
      if (deck.isEmpty) _reshuffle();
      if (deck.isNotEmpty) hands[currentPlayer].add(deck.removeLast());
    }
  }

  void _reshuffle() {
    if (discard.length <= 1) return;
    final top = discard.removeLast();
    deck = discard.where((c) => c.color != CardColor.wild || c.chosenColor == null).toList();
    deck.shuffle();
    discard = [top];
  }

  bool playCard(UnoCard card) {
    if (awaitingColorPick) return false;
    if (!card.canPlayOn(topCard)) {
      message = 'Ye card nahi chal sakta!';
      return false;
    }
    hands[currentPlayer].remove(card);
    discard.add(card);
    message = null;

    if (card.color == CardColor.wild) {
      awaitingColorPick = true;
      pendingWild = card;
      return true;
    }
    _applyEffect(card);
    return true;
  }

  void pickColor(CardColor c) {
    if (!awaitingColorPick || pendingWild == null) return;
    pendingWild!.chosenColor = c;
    awaitingColorPick = false;
    final w = pendingWild!;
    pendingWild = null;
    _applyEffect(w);
  }

  void _applyEffect(UnoCard card) {
    if (hands[currentPlayer].isEmpty) return;
    switch (card.type) {
      case CardType.skip:
        _advance();
        break;
      case CardType.reverse:
        direction *= -1;
        _advance();
        break;
      case CardType.drawTwo:
        _advance();
        drawForCurrent(count: 2);
        break;
      case CardType.wildDrawFour:
        _advance();
        drawForCurrent(count: 4);
        break;
      default:
        break;
    }
    _advance();
  }

  void drawAndPass() {
    drawForCurrent();
    _advance();
  }

  void _advance() {
    currentPlayer = (currentPlayer + direction + 4) % 4;
  }

  int? winner() {
    for (int i = 0; i < 4; i++) {
      if (hands[i].isEmpty) return i;
    }
    return null;
  }
}
