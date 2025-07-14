import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'components/player.dart';
import 'components/platform.dart';
import 'components/world.dart';
import 'components/score_text.dart';

class JmJumpGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  
  late Player player;
  late DoodleWorld gameWorld;
  late CameraComponent cameraComponent;
  late ScoreText scoreText;
  
  double gravity = 800;
  double jumpVelocity = -400;
  
  int score = 0;
  double worldHeight = 0;
  
  final Random random = Random();
  StreamSubscription? accelerometerSubscription;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    gameWorld = DoodleWorld();
    cameraComponent = CameraComponent.withFixedResolution(
      world: gameWorld,
      width: 400,
      height: 600,
    );
    
    addAll([cameraComponent, gameWorld]);
    
    _generateInitialPlatforms();
    
    player = Player()
      ..position = Vector2(200, 430)
      ..size = Vector2(50, 50);
    
    gameWorld.add(player);
    
    cameraComponent.follow(player);
    
    scoreText = ScoreText();
    cameraComponent.viewport.add(scoreText);
    
    _initializeAccelerometer();
  }
  
  void _generateInitialPlatforms() {
    // 첫 번째 플랫폼을 플레이어 바로 아래에 배치 (플레이어가 y=400에서 시작하므로 y=450에 배치)
    final startPlatform = Platform()
      ..position = Vector2(160, 450)
      ..size = Vector2(80, 20);
    gameWorld.add(startPlatform);
    
    // 나머지 플랫폼들을 위쪽으로 배치
    for (int i = 1; i < 15; i++) {
      final platform = Platform()
        ..position = Vector2(
          random.nextDouble() * (400 - 80),
          450 - (i * 60),
        )
        ..size = Vector2(80, 20);
      gameWorld.add(platform);
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // 플레이어가 첫 번째 점프를 했거나 떨어지기 시작한 경우에만 중력 적용
    if (player.hasStarted || player.velocity.y > 0) {
      player.velocity.y += gravity * dt;
    }
    
    if (player.position.y < worldHeight) {
      worldHeight = player.position.y;
      score = (worldHeight.abs() / 10).round();
      _generateMorePlatforms();
    }
    
    if (player.position.y > 800) {
      _gameOver();
    }
    
    if (player.position.y < cameraComponent.viewfinder.position.y - 100) {
      cameraComponent.viewfinder.position.y = player.position.y + 100;
    }
  }
  
  void _generateMorePlatforms() {
    final platformsInRange = gameWorld.children
        .whereType<Platform>()
        .where((p) => p.position.y > worldHeight - 1200)
        .length;
    
    if (platformsInRange < 10) {
      for (int i = 0; i < 5; i++) {
        final platform = Platform()
          ..position = Vector2(
            random.nextDouble() * (400 - 80),
            worldHeight - 150 - (i * 60),
          )
          ..size = Vector2(80, 20);
        gameWorld.add(platform);
      }
    }
  }
  
  void _gameOver() {
    overlays.add('GameOver');
    pauseEngine();
  }
  
  void restart() {
    overlays.remove('GameOver');
    score = 0;
    worldHeight = 0;
    
    gameWorld.removeAll(gameWorld.children.whereType<Platform>());
    
    player.position = Vector2(200, 430);
    player.velocity = Vector2.zero();
    player.hasStarted = false;
    
    _generateInitialPlatforms();
    resumeEngine();
  }
  
  void movePlayer(double direction) {
    player.velocity.x = direction * 80;
  }
  
  void _initializeAccelerometer() {
    accelerometerSubscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        final tilt = (-event.x).clamp(-5.0, 5.0);
        movePlayer(tilt);
      },
    );
  }
  
  
  @override
  void onDetach() {
    accelerometerSubscription?.cancel();
    super.onDetach();
  }
}