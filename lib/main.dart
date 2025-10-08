import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spooky Halloween Game',
      theme: ThemeData.dark(),
      home: WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// WELCOME PAGE
class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0d0015),
              Color(0xFF1a0033),
              Color(0xFF330066),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Title
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Text(
                        '👻 SPOOKY HUNT 👻',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          shadows: [
                            Shadow(
                              blurRadius: 20,
                              color: Colors.orange.withOpacity(0.5),
                              offset: Offset(0, 0),
                            ),
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                SizedBox(height: 50),
                
                // Game Description
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Text(
                        ' Find the Magic Emoji! 🎃',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Tap the floating emojis to win!\nBut beware of the spooky traps...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[300],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 60),
                
                // Play Button
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  HalloweenGame(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              transitionDuration: Duration(milliseconds: 500),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 10,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_arrow, size: 30),
                            SizedBox(width: 10),
                            Text(
                              'PLAY',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                SizedBox(height: 40),
                
                // Decorative Halloween Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🦇', style: TextStyle(fontSize: 30)),
                    SizedBox(width: 20),
                    Text('🕷️', style: TextStyle(fontSize: 30)),
                    SizedBox(width: 20),
                    Text('💀', style: TextStyle(fontSize: 30)),
                    SizedBox(width: 20),
                    Text('🧙‍♀️', style: TextStyle(fontSize: 30)),
                    SizedBox(width: 20),
                    Text('🕸️', style: TextStyle(fontSize: 30)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// GAME PAGE
class HalloweenGame extends StatefulWidget {
  @override
  _HalloweenGameState createState() => _HalloweenGameState();
}

class _HalloweenGameState extends State<HalloweenGame>
    with TickerProviderStateMixin {
  bool gameWon = false;
  String message = "Find the Magic Emoji! 🎃";
  int score = 0;
  int attempts = 0;
  
  // Audio players
  final AudioPlayer _backgroundMusic = AudioPlayer();
  final AudioPlayer _soundEffects = AudioPlayer();
  
  // Animation controllers for each item
  late AnimationController _pumpkinController;
  late AnimationController _ghostController;
  late AnimationController _batController;
  late AnimationController _spiderController;
  late AnimationController _skullController;
  
  @override
  void initState() {
    super.initState();
    
    // Start background music
    _playBackgroundMusic();
    
    // Initialize animation controllers with different durations for variety
    _pumpkinController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _ghostController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    _batController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _spiderController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
    
    _skullController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }
  
  // Method to play background music
  void _playBackgroundMusic() async {
    try {
      await _backgroundMusic.play(
        AssetSource('sounds/background.wav'),
        volume: 0.3,
      );
      await _backgroundMusic.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      print('Error playing background music: $e');
    }
  }
  
  // Method to play sound effects
  void _playSoundEffect(String soundFile) async {
    try {
      await _soundEffects.play(
        AssetSource('sounds/$soundFile'),
        volume: 0.7,
      );
    } catch (e) {
      print('Error playing sound effect: $e');
    }
  }
  
  @override
  void dispose() {
    // Stop and dispose audio players
    _backgroundMusic.stop();
    _backgroundMusic.dispose();
    _soundEffects.stop();
    _soundEffects.dispose();
    
    // Dispose animation controllers
    _pumpkinController.dispose();
    _ghostController.dispose();
    _batController.dispose();
    _spiderController.dispose();
    _skullController.dispose();
    super.dispose();
  }
  
  void _handleTap(String item) {
    setState(() {
      attempts++;
      if (item == 'pumpkin') {
        gameWon = true;
        score = max(0, 100 - (attempts - 1) * 10); // Score decreases with more attempts
        message = "🎉 YOU FOUND IT! 🎉";
        _playSoundEffect('win.wav'); // Play success sound
        _showSuccessDialog();
      } else {
        message = "BOO! Wrong item! Try again! 👻";
        _playSoundEffect('fail.wav'); // Play jump scare sound
        Timer(Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              message = "Find the Magic Emoji! 🎃";
            });
          }
        });
      }
    });
  }
  
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.orange,
          title: Column(
            children: [
              Text('🎃 WINNER! 🎃', 
                style: TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text('Score: $score/100', 
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text('You found it in $attempts ${attempts == 1 ? "try" : "tries"}!',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              child: Text('Play Again', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
            TextButton(
              child: Text('Main Menu', style: TextStyle(color: Colors.white)),
              onPressed: () {
                _backgroundMusic.stop(); // Stop music when returning to menu
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to welcome page
              },
            ),
          ],
        );
      },
    );
  }
  
  void _resetGame() {
    setState(() {
      gameWon = false;
      message = "Find the Magic Emoji! 🎃";
      score = 0;
      attempts = 0;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1a0033),
      body: Stack(
        children: [
          // Background decoration
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1a0033),
                  Color(0xFF330066),
                ],
              ),
            ),
          ),
          
          // Back button
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                _backgroundMusic.stop(); // Stop music when leaving
                Navigator.pop(context);
              },
            ),
          ),
          
          // Game title and message
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'SPOOKY HALLOWEEN HUNT',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    shadows: [
                      Shadow(blurRadius: 10, color: Colors.black, offset: Offset(2, 2)),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    shadows: [
                      Shadow(blurRadius: 5, color: Colors.black),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Attempts: $attempts',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
          
          // Magic Pumpkin (Correct Item) - with glow effect
          AnimatedBuilder(
            animation: _pumpkinController,
            builder: (context, child) {
              return Positioned(
                top: 170 + (_pumpkinController.value * 100),
                left: 50 + (_pumpkinController.value * 200),
                child: GestureDetector(
                  onTap: () => _handleTap('pumpkin'),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Text('🎃', style: TextStyle(fontSize: 60)),
                  ),
                ),
              );
            },
          ),
          
          AnimatedBuilder(
            animation: _pumpkinController,
            builder: (context, child) {
              return Positioned(
                bottom: 250 + (_pumpkinController.value * 60),
                left: 90 + (_pumpkinController.value * 180),
                child: GestureDetector(
                  onTap: () => _handleTap('fake_pumpkin'),
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepOrange.withOpacity(0.4),
                          blurRadius: 16,
                          spreadRadius: 7,
                        ),
                      ],
                    ),
                    child: Text('🎃', style: TextStyle(fontSize: 45)),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _pumpkinController,
            builder: (context, child) {
              return Positioned(
                top: 200 + (_pumpkinController.value * 110),
                right: 220 + (_pumpkinController.value * 80),
                child: GestureDetector(
                  onTap: () => _handleTap('trap'),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.withOpacity(0.3),
                          blurRadius: 14,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: Text('🎃', style: TextStyle(fontSize: 40)),
                  ),
                ),
              );
            },
          ),
          
          // Ghost (Trap Item)
          AnimatedBuilder(
            animation: _ghostController,
            builder: (context, child) {
              return Positioned(
                top: 220 + (_ghostController.value * 150),
                right: 30 + (_ghostController.value * 100),
                child: GestureDetector(
                  onTap: () => _handleTap('ghost'),
                  child: Text('👻', style: TextStyle(fontSize: 60)),
                ),
              );
            },
          ),
          // Duplicate Ghost (purple glow, slightly shifted)
          AnimatedBuilder(
            animation: _ghostController,
            builder: (context, child) {
              return Positioned(
                top: 250 + (_ghostController.value * 120),
                right: 70 + (_ghostController.value * 80),
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purpleAccent.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Text('👻', style: TextStyle(fontSize: 40)),
                ),
              );
            },
          ),
          
          // Bat (Trap Item)
          AnimatedBuilder(
            animation: _batController,
            builder: (context, child) {
              return Positioned(
                top: 320 + (sin(_batController.value * 2 * pi) * 50),
                left: 150 + (cos(_batController.value * 2 * pi) * 100),
                child: GestureDetector(
                  onTap: () => _handleTap('bat'),
                  child: Text('🦇', style: TextStyle(fontSize: 50)),
                ),
              );
            },
          ),
          // Duplicate Bat (green glow, slightly shifted)
          AnimatedBuilder(
            animation: _batController,
            builder: (context, child) {
              return Positioned(
                top: 350 + (sin(_batController.value * 2 * pi) * 30),
                left: 190 + (cos(_batController.value * 2 * pi) * 80),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.greenAccent.withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 7,
                      ),
                    ],
                  ),
                  child: Text('🦇', style: TextStyle(fontSize: 30)),
                ),
              );
            },
          ),
          
          // Spider (Trap Item)
          AnimatedBuilder(
            animation: _spiderController,
            builder: (context, child) {
              return Positioned(
                bottom: 150 + (_spiderController.value * 100),
                right: 80 + (_spiderController.value * 150),
                child: GestureDetector(
                  onTap: () => _handleTap('spider'),
                  child: Text('🕷️', style: TextStyle(fontSize: 55)),
                ),
              );
            },
          ),
          // Duplicate Spider (blue glow, slightly shifted)
          AnimatedBuilder(
            animation: _spiderController,
            builder: (context, child) {
              return Positioned(
                bottom: 120 + (_spiderController.value * 80),
                right: 130 + (_spiderController.value * 120),
                child: Container(
                  width: 39,
                  height: 39,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.45),
                        blurRadius: 13,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: Text('🕷️', style: TextStyle(fontSize: 27)),
                ),
              );
            },
          ),
          
          // Skull (Trap Item)
          AnimatedBuilder(
            animation: _skullController,
            builder: (context, child) {
              return Positioned(
                bottom: 250 + (_skullController.value * 80),
                left: 100 + (_skullController.value * 120),
                child: GestureDetector(
                  onTap: () => _handleTap('skull'),
                  child: Text('💀', style: TextStyle(fontSize: 50)),
                ),
              );
            },
          ),
          // Duplicate Skull (red glow, slightly shifted)
          AnimatedBuilder(
            animation: _skullController,
            builder: (context, child) {
              return Positioned(
                bottom: 290 + (_skullController.value * 60),
                right: 140 + (_skullController.value * 100),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: Text('💀', style: TextStyle(fontSize: 24)),
                ),
              );
            },
          ),
          
          // Add some decorative elements
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}