import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CyberGuardApp(),
    themeMode: ThemeMode.light,
  ));
}

class CyberGuardApp extends StatefulWidget {
  const CyberGuardApp({super.key});

  @override
  State<CyberGuardApp> createState() => _CyberGuardAppState();
}

class _CyberGuardAppState extends State<CyberGuardApp> {
  File? _screenshot;
  String _analysisResult = "";
  bool _isLoading = false;
  
  // ============================================================
  // !!!  PASTE YOUR API KEY INSIDE THE QUOTES BELOW  !!!
  // ============================================================
  final String _apiKey = "AIzaSyBjIDYGW1SLsrYPViYpNLVBNzE14xFT-zg"; 
  // ============================================================

  // Colors for the UI
  final Color _primaryColor = const Color(0xFF1E3A8A); // Dark Blue
  final Color _accentColor = const Color(0xFF3B82F6);  // Light Blue

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _screenshot = File(pickedFile.path);
        _analysisResult = "";
      });
    }
  }

  Future<void> _checkSafety() async {
    if (_screenshot == null) return;

    setState(() {
      _isLoading = true;
      _analysisResult = "Analyzing image... Please wait.";
    });

    try {
      // 1. Validation
      if (_apiKey.contains("PASTE_YOUR") || _apiKey.isEmpty) {
        throw "API Key is missing. Please open lib/main.dart and add your key.";
      }

      // 2. Setup Model
      // We use 'gemini-1.5-flash' as it is the current standard.
      // If this fails with 404, try 'gemini-1.5-flash-latest'
      final model = GenerativeModel(model: 'gemini-flash-latest', apiKey: _apiKey);
      
      final prompt = TextPart("Analyze this screenshot. Is this message, link, or content a SCAM, FAKE, or UNSAFE? Answer 'SAFE' or 'UNSAFE' followed by a short explanation.");
      
      final imageBytes = await _screenshot!.readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);

      // 3. Send to Google
      final response = await model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      setState(() {
        _analysisResult = response.text ?? "Error: AI returned empty response.";
      });
      
    } catch (e) {
      // 4. ERROR HANDLING (Shows the REAL error on screen)
      setState(() {
        _analysisResult = "SYSTEM ERROR:\n$e";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _reportToPolice() async {
    final Email email = Email(
      body: 'Respected Officer,\n\nI found this suspicious content.\n\nAI Analysis:\n$_analysisResult\n\nPlease check the attached screenshot.',
      subject: 'Cyber Complaint: Suspicious Activity',
      recipients: ['cyberps@keralapolice.gov.in'], 
      attachmentPaths: [_screenshot!.path],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open email app: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the result is unsafe to show the red warning
    bool isUnsafe = _analysisResult.toUpperCase().contains("UNSAFE") || 
                    _analysisResult.toUpperCase().contains("SCAM") ||
                    _analysisResult.toUpperCase().contains("PHISHING");

    // Check if there is an error (so we don't show the green shield on errors)
    bool isError = _analysisResult.startsWith("SYSTEM ERROR") || 
                   _analysisResult.startsWith("API Key is missing");

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text("Kerala Cyber Guard", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header Card
            Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.shield_moon, size: 50, color: _primaryColor),
                    const SizedBox(height: 10),
                    const Text(
                      "Verify Suspicious Messages",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Upload a screenshot to detect scams.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Image Preview
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _screenshot == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey[400]),
                          const Text("Tap to Upload Screenshot", style: TextStyle(color: Colors.grey)),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.file(_screenshot!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. Action Buttons
            if (_screenshot != null && _analysisResult.isEmpty)
              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _checkSafety,
                  icon: _isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.search),
                  label: Text(_isLoading ? "Analyzing..." : "Analyze Screenshot"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            // 4. Result Area
            if (_analysisResult.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  // Logic to choose color: Red for unsafe, Green for safe, Grey for error
                  color: isError ? Colors.grey[200] : (isUnsafe ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4)), 
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isError ? Colors.grey : (isUnsafe ? Colors.red : Colors.green)
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isError)
                      Row(
                        children: [
                          Icon(
                            isUnsafe ? Icons.warning : Icons.check_circle, 
                            color: isUnsafe ? Colors.red : Colors.green
                          ),
                          const SizedBox(width: 10),
                          Text(
                            isUnsafe ? "POTENTIAL THREAT" : "LIKELY SAFE",
                            style: TextStyle(
                              color: isUnsafe ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),
                          ),
                        ],
                      ),
                    if (!isError) const Divider(),
                    
                    // Display Result
                    MarkdownBody(data: _analysisResult),
                  ],
                ),
              ),
            ],

            // 5. Report Button (Only shows if UNSAFE)
            if (isUnsafe && !isError) ...[
              const SizedBox(height: 20),
              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _reportToPolice,
                  icon: const Icon(Icons.email),
                  label: const Text("Report to Kerala Cyber Cell"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}