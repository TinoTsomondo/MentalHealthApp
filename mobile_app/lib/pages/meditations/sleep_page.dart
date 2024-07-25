import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SleepPage extends StatefulWidget {
  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> _audioUrls = [
    'https://mental-health-app-files.s3.amazonaws.com/sleepaudios/sleep-meditate.mp3',
    'https://mental-health-app-files.s3.amazonaws.com/sleepaudios/sleep.mp3',
    'https://mental-health-app-files.s3.amazonaws.com/sleepaudios/relaxing-peaceful-music.mp3',
    'https://mental-health-app-files.s3.amazonaws.com/sleepaudios/deep-sleep.mp3',
    'https://mental-health-app-files.s3.amazonaws.com/sleepaudios/calming-waves.mp3',
  ];
  String? _currentTrack;
  bool _isPlaying = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Define the color scheme
    final Color backgroundColor = Color(0xFFb2c2a1); // Soft Green
    final Color cardColor1 = Color(0xFFFFF9B0); // Light Yellow
    final Color cardColor2 = Color(0xFFDCC9F3); // Light Purple
    final Color cardColor3 = Color(0xFFFFF8ED); // Light Cream
    final Color textColor = Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor1,
        title: Text(
          'Sleep Audio',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: textColor),
            onPressed: () {
              // Optionally add an info dialog or page here
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/starry_sky.jpg'), // Add your starry sky image here
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Calm Your Mind',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Choose from a variety of relaxing sleep tracks to help you unwind and drift off peacefully.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _audioUrls.length,
                    itemBuilder: (context, index) {
                      // Choose a card color based on the index
                      Color cardColor;
                      switch (index % 3) {
                        case 0:
                          cardColor = cardColor1;
                          break;
                        case 1:
                          cardColor = cardColor2;
                          break;
                        case 2:
                          cardColor = cardColor3;
                          break;
                        default:
                          cardColor = Colors.white;
                      }

                      return Card(
                        color: cardColor,
                        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.play_arrow,
                            color: textColor,
                          ),
                          title: Text(
                            'Track ${index + 1}',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () async {
                            try {
                              if (_currentTrack != null &&
                                  _currentTrack != _audioUrls[index]) {
                                await _audioPlayer.stop();
                                setState(() {
                                  _isPlaying = false;
                                });
                              }
                              setState(() {
                                _currentTrack = _audioUrls[index];
                              });
                              if (_isPlaying) {
                                await _audioPlayer.pause();
                              } else {
                                await _audioPlayer.play(UrlSource(_audioUrls[index]));
                              }
                              setState(() {
                                _isPlaying = !_isPlaying;
                                _errorMessage = '';
                              });
                            } catch (e) {
                              setState(() {
                                _errorMessage = 'Failed to play audio: $e';
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
