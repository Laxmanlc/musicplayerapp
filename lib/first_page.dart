import 'package:flutter/material.dart';
import 'package:musicplayer/audio_player_service.dart';
import 'package:musicplayer/color.dart';
import 'package:musicplayer/second_page.dart';
import 'package:musicplayer/strings.dart';

class FirstPagees extends StatefulWidget {
  const FirstPagees({super.key});

  @override
  State<FirstPagees> createState() => _FirstPageesState();
}

class _FirstPageesState extends State<FirstPagees> {
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  bool isLoading = false; // Track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                "What do you want to listen to today?",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: artistNames.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      // Stop current audio and reset player
                      await _audioPlayerService.stop();

                      // Play new song
                      await _audioPlayerService.play(songUrls[index]);

                      // Navigate to second page with updated data
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Secondpagees(
                              songUrl: songUrls[index],
                              songUrls: songUrls,
                              initialIndex: index,
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      // Log or handle error (optional)
                      print("Error playing audio: $e");
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: purpleColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(4, 4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                        const BoxShadow(
                          color: Colors.white,
                          offset: Offset(-4, -4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.music_note,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              songNames[index],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text("Artist: ${artistNames[index]}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Display loading indicator when music is being loaded
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
            ),
        ],
      ),
    );
  }
}
