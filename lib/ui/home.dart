import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tictactoe/provider/game_provider.dart';
import 'package:tictactoe/ui/utils/board_builder.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameVm = ref.watch(gameProvider);

    showStatusDialog(String title) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(gameProvider).init();
                },
              ),
            ],
          );
        },
      );
    }

    ref.listen<GameProvider>(gameProvider, (p, gameProvider) {
      if (gameProvider.isGameOver) {
        showStatusDialog('Winner is ${gameProvider.lastMove}');
      }
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text('TicTacToe'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: BoardBuilder.buildBoard(
                gameVm.matrix,
                (index, model) => BuildRow(
                      xIndex: index,
                      gameProvider: gameVm,
                    ))));
  }
}

class BuildRow extends StatelessWidget {
  const BuildRow({Key? key, required this.xIndex, required this.gameProvider})
      : super(key: key);

  final int xIndex;
  final GameProvider gameProvider;

  @override
  Widget build(BuildContext context) {
    final values = gameProvider.matrix[xIndex];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: BoardBuilder.buildBoard(values,
          (yIndex, model) => BuildPlate(xIndex: xIndex, yIndex: yIndex)),
    );
  }
}

class BuildPlate extends HookConsumerWidget {
  const BuildPlate({Key? key, required this.xIndex, required this.yIndex})
      : super(key: key);

  final int xIndex;
  final int yIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameVm = ref.watch(gameProvider);
    final value = gameVm.matrix[xIndex][yIndex];
    return Container(
      margin: const EdgeInsets.all(5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.orange,
          minimumSize: const Size.square(92),
        ),
        onPressed: () =>
            ref.read(gameProvider).plateOnTapped(value, xIndex, yIndex),
        child: Text(value),
      ),
    );
  }
}
