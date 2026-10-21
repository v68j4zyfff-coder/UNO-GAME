import 'package:flutter/material.dart';
import '../models/card.dart';
import '../models/game_state.dart';
import '../widgets/uno_card_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameState g = GameState();

  @override
  void initState() {
    super.initState();
    g.start();
  }

  void _refresh(VoidCallback fn) => setState(fn);

  void _checkWinner() {
    final w = g.winner();
    if (w != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text('🎉 Player ${w + 1} Jeet Gaya!'),
          actions: [
            TextButton(
              onPressed: () => _refresh(() => g.start()),
              child: const Text('Dobara Khelo'),
            ),
          ],
        ),
      );
    }
  }

  void _onCardTap(UnoCard c) {
    _refresh(() { g.playCard(c); });
    _checkWinner();
  }

  void _onDraw() => _refresh(() => g.drawAndPass());

  Future<void> _pickColor() async {
    final c = await showModalBottomSheet<CardColor>(
      context: context,
      builder: (_) => Wrap(
        children: [
          for (var col in [CardColor.red, CardColor.yellow, CardColor.green, CardColor.blue])
            GestureDetector(
              onTap: () => Navigator.pop(context, col),
              child: Container(
                margin: const EdgeInsets.all(12),
                width: 70, height: 70,
                decoration: BoxDecoration(
                  color: UnoCard(color: col, type: CardType.wild, id: 'x').uiColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
    if (c != null) {
      _refresh(() => g.pickColor(c));
      _checkWinner();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (g.awaitingColorPick) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _pickColor());
    }

    return Scaffold(
      backgroundColor: Colors.green.shade900,
      body: SafeArea(
        child: Column(
          children: [
            _opponentRow(),
            const SizedBox(height: 8),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: g.awaitingColorPick ? null : _onDraw,
                        child: Container(
                          width: 70, height: 105,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Center(
                            child: Text('UNO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Draw (${g.deck.length})', style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(width: 30),
                  UnoCardWidget(card: g.topCard, width: 80),
                ],
              ),
            ),
            if (g.message != null)
              Text(g.message!, style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
            Text('Player ${g.currentPlayer + 1} ki turn',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              height: 130,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: g.hands[g.currentPlayer].length,
                itemBuilder: (_, i) {
                  final card = g.hands[g.currentPlayer][i];
                  final playable = card.canPlayOn(g.topCard);
                  return Opacity(
                    opacity: playable ? 1 : 0.5,
                    child: UnoCardWidget(
                      card: card,
                      onTap: g.awaitingColorPick ? null : () => _onCardTap(card),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _opponentRow() {
    final others = [for (int i = 0; i < 4; i++) if (i != g.currentPlayer) i];
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: others.map((i) {
          return Column(
            children: [
              Text('P${i + 1}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('${g.hands[i].length} 🃏', style: const TextStyle(color: Colors.white)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
