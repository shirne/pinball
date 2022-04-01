// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Spaceship', () {
    late Filter filterData;
    late Fixture fixture;
    late Body body;
    late Ball ball;
    late SpaceshipEntrance entrance;
    late SpaceshipHole hole;
    late Forge2DGame game;

    setUp(() {
      filterData = MockFilter();

      fixture = MockFixture();
      when(() => fixture.filterData).thenReturn(filterData);

      body = MockBody();
      when(() => body.fixtures).thenReturn([fixture]);

      game = MockGame();

      ball = MockBall();
      when(() => ball.gameRef).thenReturn(game);
      when(() => ball.body).thenReturn(body);

      entrance = MockSpaceshipEntrance();
      hole = MockSpaceshipHole();
    });

    group('Spaceship', () {
      final tester = FlameTester(TestGame.new);

      tester.testGameWidget(
        'renders correctly',
        setUp: (game, tester) async {
          await game.addFromBlueprint(Spaceship(position: Vector2(30, -30)));
          await game.ready();
          await tester.pump();
        },
        verify: (game, tester) async {
          // FIXME(erickzanardo): Failing pipeline.
          // await expectLater(
          //   find.byGame<Forge2DGame>(),
          //   matchesGoldenFile('golden/spaceship.png'),
          // );
        },
      );
    });

    group('SpaceshipEntranceBallContactCallback', () {
      test('changes the ball priority on contact', () {
        when(() => ball.priority).thenReturn(2);
        when(() => entrance.insidePriority).thenReturn(3);

        SpaceshipEntranceBallContactCallback().begin(
          entrance,
          ball,
          MockContact(),
        );

        verify(() => ball.sendTo(entrance.insidePriority)).called(1);
      });
    });

    group('SpaceshipHoleBallContactCallback', () {
      test('changes the ball priority on contact', () {
        when(() => ball.priority).thenReturn(2);
        when(() => hole.outsideLayer).thenReturn(Layer.board);
        when(() => hole.outsidePriority).thenReturn(1);

        SpaceshipHoleBallContactCallback().begin(
          hole,
          ball,
          MockContact(),
        );

        verify(() => ball.sendTo(hole.outsidePriority)).called(1);
      });
    });
  });
}