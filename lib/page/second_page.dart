import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:musicplayer/service/audio_player_service.dart';
import 'package:musicplayer/utils/color.dart';

class Secondpagees extends StatefulWidget {
  final String songUrl;
  final List<String> songUrls; // List of all song URLs
  final int initialIndex; // Index of the current song

  const Secondpagees({
    super.key,
    required this.songUrl,
    required this.songUrls,
    required this.initialIndex,
  });

  @override
  State<Secondpagees> createState() => _SecondpageesState();
}

class _SecondpageesState extends State<Secondpagees> {
  bool _isPlaying = false; // Track if the music is playing
  late int _currentIndex; // Current song index
  final AudioPlayerService _audioPlayerService = AudioPlayerService();

  @override
  void initState() {
    super.initState();
    _currentIndex =
        widget.initialIndex; // Set the current index from the initial index
    _playCurrentSong();
  }

  // Play the current song and reset position
  void _playCurrentSong() async {
    if (_audioPlayerService.currentUrl != widget.songUrls[_currentIndex]) {
      await _audioPlayerService.play(widget.songUrls[_currentIndex]);
    }
    setState(() {
      _isPlaying = true; // Ensure _isPlaying is true when the song starts
    });
  }

  // Toggle play/pause functionality
  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _audioPlayerService.pause();
      } else {
        _audioPlayerService.resume();
      }
      _isPlaying = !_isPlaying; // Toggle playing state
    });
  }

  // Skip to the previous song
  void _skipToPrevious() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _playCurrentSong();
    }
  }

  // Skip to the next song
  void _skipToNext() {
    if (_currentIndex < widget.songUrls.length - 1) {
      _currentIndex++;
      _playCurrentSong();
    }
  }

  // Seek to a new position in the audio
  void _seekToPosition(Duration newPosition) {
    _audioPlayerService.seek(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Now Playing"),
        backgroundColor: purpleColor,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: purpleColor,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                color: purpleColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(8, 8),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-8, -8),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Lottie.asset("assets/3rdanime.json"),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                iconButton(
                  icon: Icons.skip_previous,
                  ontap: _skipToPrevious,
                ),
                iconButton(
                  icon: _isPlaying ? Icons.pause : Icons.play_arrow,
                  ontap: _togglePlayPause,
                ),
                iconButton(
                  icon: Icons.skip_next,
                  ontap: _skipToNext,
                ),
              ],
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: StreamBuilder<Duration>(
                stream: _audioPlayerService
                    .positionStream, // Listen to position updates
                builder: (context, snapshot) {
                  return ProgressBar(
                    progress:
                        snapshot.data ?? Duration.zero, // Current position
                    total: _audioPlayerService.duration, // Total duration
                    onSeek: _seekToPosition, // Seek to new position
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget iconButton({required IconData icon, required VoidCallback ontap}) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: purpleColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(8, 8),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-8, -8),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 30,
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }
}
