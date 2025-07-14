import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:fyp/utils/app_colors.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final List<String> videoUrls;

  const VideoPlayerScreen({Key? key, required this.videoUrls})
      : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer(widget.videoUrls[_currentIndex]);
  }

  void _initializeVideoPlayer(String videoUrl) {
    _controller = VideoPlayerController.network(videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
      errorBuilder: (context, errorMessage) {
        return Center(child: Text('Error: $errorMessage'));
      },
    );

    _controller.initialize().then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error loading video")),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  // Play a specific video by index
  void _playSelectedVideo(int index) {
    setState(() {
      _isLoading = true;
      _currentIndex = index;
    });
    _controller.pause();
    _initializeVideoPlayer(widget.videoUrls[_currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Videos'),
        backgroundColor: Mycolors.primary_cyan,
      ),
      body: Column(
        children: [
          // Video Player Section with limited height (30% of screen height)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            height: MediaQuery.of(context).size.height *
                0.3, // 30% of screen height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Chewie(
                      controller: _chewieController,
                    ),
            ),
          ),
          const SizedBox(height: 20),

          // Video List Section (Below Video 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Column(
              children: widget.videoUrls.asMap().entries.map((entry) {
                int index = entry.key;
                String videoUrl = entry.value;

                return GestureDetector(
                  onTap: () => _playSelectedVideo(index),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      title: Text('Video ${index + 1}',
                          style: TextStyle(fontSize: 18)),
                      trailing:
                          Icon(Icons.play_circle_fill, color: Colors.teal),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
