import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller?.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    }).catchError((error) {
      print("Error initializing camera: $error");
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _navigateToNextScreen(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageDisplayScreen(imagePath: imagePath),
      ),
    );
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) {
      print("Error: Camera is not initialized");
      return;
    }

    try {
      await _initializeControllerFuture;

      final image = await _controller!.takePicture();

      // Navigate to the next screen with the captured image path
      _navigateToNextScreen(image?.path ?? '');

      // NOTE: If you don't want to navigate to the next screen, you can directly display the image here using Image.network(image?.path)
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text('Camera Example')),
      body: Stack(
        alignment: Alignment.center,
        children: [
          CameraPreview(_controller!), // Live camera preview
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}

class ImageDisplayScreen extends StatelessWidget {
  final String imagePath;

  ImageDisplayScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Captured Image')),
      body: Center(
        child: Image.network(imagePath), // Display the captured image
      ),
    );
  }
}
