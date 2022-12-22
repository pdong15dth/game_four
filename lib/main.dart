// ignore_for_file: avoid_print

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/input.dart';

void main() {
  runApp(GameWidget(game: Mygame()));
}

class Mygame extends FlameGame with HasTappables {
  SpriteComponent girl = SpriteComponent();
  SpriteComponent boy = SpriteComponent();
  SpriteComponent background = SpriteComponent();
  SpriteComponent background2 = SpriteComponent();

  TextPaint dialogTextPaint = TextPaint(style: const TextStyle(fontSize: 36));
  DialogButton dialogButton = DialogButton();
  Vector2 buttonSize = Vector2(50, 50);
  int dialogLevel = 0;
  final double characterSize = 200;
  final double textBoxHeight = 100;
  final double speed = 50;
  bool turnAway = false;
  int screenLevel = 1;
  @override
  Future<void> onLoad() async {
    super.onLoad();

    final screenWitdh = size[0];
    final screenHeight = size[1];

    background
      ..sprite = await loadSprite('background.png')
      ..size = Vector2(size[0], size[1] - textBoxHeight);
    add(background);

    background2
      ..sprite = await loadSprite('castle.jpg')
      ..size = Vector2(size[0], size[1] - textBoxHeight);

    girl
      ..sprite = await loadSprite('girl.png')
      ..size = Vector2(characterSize, characterSize)
      ..y = screenHeight - characterSize - textBoxHeight
      ..anchor = Anchor.topCenter;
    add(girl);

    boy
      ..sprite = await loadSprite('boy.png')
      ..size = Vector2(characterSize, characterSize)
      ..y = screenHeight - characterSize - textBoxHeight
      ..x = screenWitdh - characterSize
      ..anchor = Anchor.topCenter
      ..flipHorizontally();

    add(boy);

    dialogButton
      ..sprite = await loadSprite('next_button.png')
      ..size = buttonSize
      ..position = Vector2(size.x - 75, size.y - 75);
    print("Starting");
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (girl.x < size[0] / 2 - characterSize / 2) {
      girl.x += speed * dt;
      if (girl.x > 50 && dialogLevel == 0) {
        dialogLevel = 1;
      }
      if (girl.x > 150 && dialogLevel == 1) {
        dialogLevel = 2;
      }
    }
    if (boy.x > size[0] / 2 - 50 && screenLevel == 1) {
      boy.x -= speed * dt;
    } else {
      if (!turnAway && screenLevel == 1) {
        turnAway = true;
        boy.flipHorizontally();
        if (dialogLevel == 2) {
          dialogLevel = 3;
          add(dialogButton);
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    switch (dialogLevel) {
      case 0:
        renderDialogTextPaint(canvas, "Yamate Kudasai: em không sai");
        break;
      case 1:
        renderDialogTextPaint(canvas, "Yamate Kudasai: Anh không sai 30 sai");
        break;
      case 2:
        renderDialogTextPaint(canvas, "Xyz: Ummmmm");
        break;
      case 3:
        renderDialogTextPaint(canvas, "Yamate Kudasai: ahihi");
        break;
    }

    switch (dialogButton.screen2Level) {
      case 1:
        screenLevel = 2;
        canvas.drawRect(
          Rect.fromLTWH(0, size.y - 100, size.x - 60, 100),
          Paint()..color = Colors.black,
        );
        renderDialogTextPaint(canvas, "Hop thoai 1");
        if (turnAway) {
          boy.flipHorizontally();
          boy.x += 150;
          turnAway = false;
          remove(background);
          add(background2);
          boy.changeParent(background2);
          girl.changeParent(background2);
        }
        break;
      case 2:
        canvas.drawRect(
          Rect.fromLTWH(0, size.y - 100, size.x - 60, 100),
          Paint()..color = Colors.black,
        );
        renderDialogTextPaint(canvas, "Hop thoai 2");
        break;
      case 3:
        canvas.drawRect(
          Rect.fromLTWH(0, size.y - 100, size.x - 60, 100),
          Paint()..color = Colors.black,
        );
        renderDialogTextPaint(canvas, "Hop thoai 3");
        break;
      case 4:
        canvas.drawRect(
          Rect.fromLTWH(0, size.y - 100, size.x - 60, 100),
          Paint()..color = Colors.black,
        );
        renderDialogTextPaint(canvas, "Hop thoai 4");
        break;
    }
  }

  void renderDialogTextPaint(Canvas canvas, String dialog) {
    return dialogTextPaint.render(
        canvas, dialog, Vector2(10, size[1] - textBoxHeight));
  }
}

class DialogButton extends SpriteComponent with Tappable {
  int screen2Level = 0;
  @override
  bool onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    try {
      print("we will move to the next screen");
      screen2Level++;
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
