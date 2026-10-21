import 'card.dart';

List<UnoCard> buildDeck() {
  final deck = <UnoCard>[];
  int idc = 0;
  for (var color in [CardColor.red, CardColor.yellow, CardColor.green, CardColor.blue]) {
    deck.add(UnoCard(color: color, type: CardType.number, number: 0, id: '${idc++}'));
    for (int n = 1; n <= 9; n++) {
      deck.add(UnoCard(color: color, type: CardType.number, number: n, id: '${idc++}'));
      deck.add(UnoCard(color: color, type: CardType.number, number: n, id: '${idc++}'));
    }
    for (var t in [CardType.skip, CardType.reverse, CardType.drawTwo]) {
      deck.add(UnoCard(color: color, type: t, id: '${idc++}'));
      deck.add(UnoCard(color: color, type: t, id: '${idc++}'));
    }
  }
  for (int i = 0; i < 4; i++) {
    deck.add(UnoCard(color: CardColor.wild, type: CardType.wild, id: '${idc++}'));
    deck.add(UnoCard(color: CardColor.wild, type: CardType.wildDrawFour, id: '${idc++}'));
  }
  deck.shuffle();
  return deck;
}
