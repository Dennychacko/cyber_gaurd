import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================
// !!!  PASTE YOUR NEW API KEY HERE  !!!
// ============================================================
const String globalApiKey = "PASTE_YOUR_API_KEY_HERE"; 
// ============================================================

// --- GLOBAL LANGUAGE NOTIFIER ---
final ValueNotifier<String> currentLanguage = ValueNotifier("en");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  currentLanguage.value = prefs.getString('language_code') ?? "en";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: currentLanguage,
      builder: (context, lang, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const LoginPage(),
          themeMode: ThemeMode.light,
          title: "Cyber Guard",
        );
      },
    );
  }
}

// ============================================================
// 🌍 TRANSLATION ENGINE
// ============================================================
class T {
  static Map<String, Map<String, String>> db = {
    "en": {
      "app_name": "Cyber Guard",
      "subtitle": "Secure your digital life.",
      "login_google": "Sign in with Google",
      "menu_screenshot": "Screenshot & AI Detector",
      "menu_video": "Deepfake Video Scanner",
      "menu_link": "Link / URL Analyzer",
      "menu_helpline": "Helpline Numbers",
      "menu_settings": "Settings",
      "menu_logout": "Logout",
      "scan_title": "Screenshot & AI Detector",
      "video_title": "Deepfake Video Scanner",
      "upload_text": "Tap to Upload Image",
      "upload_video_text": "Tap to Upload Video (Short)",
      "verify_btn": "Check Safety",
      "report_btn": "Report to Police",
      "analyzing": "Scanning for Scams & AI...",
      "link_title": "Link / URL Scanner",
      "paste_link": "Paste link here",
      "scan_link_btn": "Scan Link",
      "helpline_title": "Cyber Helplines",
      "call": "Call",
      "settings_title": "Settings",
      "select_lang": "Select Language",
    },
    "ml": {
      "app_name": "സൈബർ ഗാർഡ്",
      "subtitle": "നിങ്ങളുടെ ഡിജിറ്റൽ ജീവിതം സുരക്ഷിതമാക്കൂ.",
      "login_google": "Google വഴി ലോഗിൻ ചെയ്യുക",
      "menu_screenshot": "ചിത്രങ്ങൾ / AI പരിശോധന",
      "menu_video": "ഡീപ്ഫേക്ക് വീഡിയോ സ്കാനർ",
      "menu_link": "ലിങ്ക് പരിശോധന",
      "menu_helpline": "സഹായ നമ്പറുകൾ",
      "menu_settings": "ക്രമീകരണങ്ങൾ",
      "menu_logout": "പുറത്തുകടക്കുക",
      "scan_title": "ചിത്രങ്ങൾ / AI പരിശോധന",
      "video_title": "ഡീപ്ഫേക്ക് വീഡിയോ സ്കാനർ",
      "upload_text": "ചിത്രം അപ്‌ലോഡ് ചെയ്യുക",
      "upload_video_text": "വീഡിയോ അപ്‌ലോഡ് ചെയ്യുക",
      "verify_btn": "സുരക്ഷ പരിശോധിക്കൂ",
      "report_btn": "പോലീസിൽ അറിയിക്കുക",
      "analyzing": "പരിശോധിക്കുന്നു...",
      "link_title": "ലിങ്ക് സ്കാനർ",
      "paste_link": "ലിങ്ക് ഇവിടെ ചേർക്കുക",
      "scan_link_btn": "ലിങ്ക് സ്കാൻ ചെയ്യുക",
      "helpline_title": "സൈബർ സഹായ നമ്പറുകൾ",
      "call": "വിളിക്കുക",
      "settings_title": "ക്രമീകരണങ്ങൾ",
      "select_lang": "ഭാഷ തിരഞ്ഞെടുക്കുക",
    },
     "hi": {
      "app_name": "साइबर गार्ड",
      "subtitle": "अपने डिजिटल जीवन को सुरक्षित करें।",
      "login_google": "Google के साथ साइन इन करें",
      "menu_screenshot": "स्क्रीनशॉट / AI एनालाइजर",
      "menu_video": "दीपफेक वीडियो स्कैनर",
      "menu_link": "लिंक / URL एनालाइजर",
      "menu_helpline": "हेल्पलाइन नंबर",
      "menu_settings": "सेटिंग्स",
      "menu_logout": "लॉग आउट",
      "scan_title": "स्क्रीनशॉट / AI एनालाइजर",
      "video_title": "दीपफेक वीडियो स्कैनर",
      "upload_text": "स्क्रीनशॉट अपलोड करें",
      "upload_video_text": "वीडियो अपलोड करें",
      "verify_btn": "सुरक्षा जांचें",
      "report_btn": "पुलिस को रिपोर्ट करें",
      "analyzing": "स्कैनिंग...",
      "link_title": "लिंक स्कैनर",
      "paste_link": "लिंक यहाँ पेस्ट करें",
      "scan_link_btn": "लिंक स्कैन करें",
      "helpline_title": "साइबर हेल्पलाइन",
      "call": "कॉल करें",
      "settings_title": "सेटिंग्स",
      "select_lang": "भाषा चुनें",
    },
    "ta": {
      "app_name": "சைபர் கார்ட்",
      "subtitle": "உங்கள் டிஜிட்டல் வாழ்க்கையைப் பாதுகாக்கவும்.",
      "login_google": "Google மூலம் உள்நுழையவும்",
      "menu_screenshot": "AI மற்றும் பட அனலைசர்",
      "menu_video": "டீப் ஃபேக் வீடியோ ஸ்கேனர்",
      "menu_link": "இணைப்பு / URL அனலைசர்",
      "menu_helpline": "உதவி எண்கள்",
      "menu_settings": "அமைப்புகள்",
      "menu_logout": "வெளியேறு",
      "scan_title": "AI மற்றும் பட அனலைசர்",
      "video_title": "டீப் ஃபேக் வீடியோ ஸ்கேனர்",
      "upload_text": "படத்தைப் பதிவேற்றவும்",
      "upload_video_text": "வீடியோவைப் பதிவேற்றவும்",
      "verify_btn": "பாதுகாப்பைச் சரிபார்க்கவும்",
      "report_btn": "காவல்துறையிடம் புகார் அளிக்கவும்",
      "analyzing": "ஸ்கேன் செய்கிறது...",
      "link_title": "இணைப்பு ஸ்கேனர்",
      "paste_link": "இணைப்பை இங்கே ஒட்டவும்",
      "scan_link_btn": "இணைப்பை ஸ்கேன் செய்யவும்",
      "helpline_title": "சைபர் உதவி எண்கள்",
      "call": "அழைக்கவும்",
      "settings_title": "அமைப்புகள்",
      "select_lang": "மொழியைத் தேர்ந்தெடுக்கவும்",
    }
  };

  static String get(String key) {
    return db[currentLanguage.value]?[key] ?? db["en"]![key]!;
  }
}

// ============================================================
// 1. LOGIN PAGE
// ============================================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const CyberGuardHome())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.security, size: 80, color: Color(0xFF1E3A8A)),
              const SizedBox(height: 20),
              Text(
                T.get("app_name"), 
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))
              ),
              const SizedBox(height: 10),
              Text(T.get("subtitle"), style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 50),
              
              if (_isLoading)
                const CircularProgressIndicator()
              else
                InkWell(
                  onTap: _handleLogin,
                  child: Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade200, blurRadius: 5, offset: const Offset(0, 3))
                      ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.g_mobiledata, size: 40, color: Colors.blue),
                        const SizedBox(width: 10),
                        Text(T.get("login_google"), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 2. HOME PAGE (NAVIGATION)
// ============================================================
class CyberGuardHome extends StatefulWidget {
  const CyberGuardHome({super.key});

  @override
  State<CyberGuardHome> createState() => _CyberGuardHomeState();
}

class _CyberGuardHomeState extends State<CyberGuardHome> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const ImageAnalyzerPage(),
    const VideoAnalyzerPage(),
    const LinkAnalyzerPage(),
    const HelplinePage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(T.get("app_name"), style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF1E3A8A)),
              accountName: Text("Demo User"),
              accountEmail: Text("user@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Color(0xFF1E3A8A)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.image_search),
              title: Text(T.get("menu_screenshot")),
              selected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.videocam_outlined),
              title: Text(T.get("menu_video")),
              selected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: Text(T.get("menu_link")),
              selected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              leading: const Icon(Icons.phone_in_talk),
              title: Text(T.get("menu_helpline")),
              selected: _selectedIndex == 3,
              onTap: () => _onItemTapped(3),
            ),
             ListTile(
              leading: const Icon(Icons.language),
              title: Text(T.get("menu_settings")),
              selected: _selectedIndex == 4,
              onTap: () => _onItemTapped(4),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(T.get("menu_logout")),
              onTap: () {
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

// ============================================================
// 3. IMAGE & AI ANALYZER
// ============================================================
class ImageAnalyzerPage extends StatefulWidget {
  const ImageAnalyzerPage({super.key});

  @override
  State<ImageAnalyzerPage> createState() => _ImageAnalyzerPageState();
}

class _ImageAnalyzerPageState extends State<ImageAnalyzerPage> {
  File? _screenshot;
  String _analysisResult = "";
  bool _isLoading = false;

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
    setState(() { _isLoading = true; _analysisResult = T.get("analyzing"); });

    try {
      if (globalApiKey.contains("PASTE_YOUR")) throw "API Key is missing!";
      
      // Using gemini-1.5-flash-latest to avoid version errors
      final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: globalApiKey);
      
      String langName = currentLanguage.value == "ml" ? "Malayalam" : "English";
      if (currentLanguage.value == "hi") langName = "Hindi";
      if (currentLanguage.value == "ta") langName = "Tamil";

      final prompt = TextPart("""
      Analyze this image.
      1. Is it a SCAM, UNSAFE, or SAFE?
      2. Is it AI-GENERATED (Deepfake)?
      
      Answer in $langName language for a 10-year-old.
      Keywords: SAFE ✅, DANGEROUS 🛑, AI GENERATED 🤖.
      """);
      
      final imageBytes = await _screenshot!.readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);
      
      final response = await model.generateContent([Content.multi([prompt, imagePart])]);
      setState(() => _analysisResult = response.text ?? "No response");
    } catch (e) {
      setState(() => _analysisResult = "Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _reportToPolice() async {
    if (_screenshot == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No evidence found!")));
      return;
    }

    final Email email = Email(
      body: 'Respected Officer,\n\nSuspicious activity report.\n\nAI Result:\n$_analysisResult\n\nEvidence attached.',
      subject: 'Cyber Crime Report',
      recipients: ['cyberps@keralapolice.gov.in'],
      attachmentPaths: [_screenshot!.path],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email App Error: $error"), backgroundColor: Colors.red),
      );
      // Fallback
      final Uri mailLaunch = Uri(
        scheme: 'mailto',
        path: 'cyberps@keralapolice.gov.in',
        query: 'subject=Cyber Report&body=Please check attached evidence.',
      );
      await launchUrl(mailLaunch);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isRed = _analysisResult.toUpperCase().contains("DANGEROUS") || 
                 _analysisResult.toUpperCase().contains("SCAM") || 
                 _analysisResult.toUpperCase().contains("AI GENERATED") ||
                 _analysisResult.toUpperCase().contains("AI-GENERATED") ||
                 _analysisResult.toUpperCase().contains("UNSAFE") ||
                 _analysisResult.contains("Error") ||
                 _analysisResult.contains("🛑") || 
                 _analysisResult.contains("🤖");

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(T.get("scan_title"), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 200,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
              child: _screenshot == null ? Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                  Text(T.get("upload_text"))
                ],
              )) : Image.file(_screenshot!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _checkSafety, 
            icon: const Icon(Icons.shield), 
            label: Text(T.get("verify_btn")),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A), foregroundColor: Colors.white),
          ),
          if (_analysisResult.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isRed ? Colors.red.shade100 : Colors.green.shade100,
                border: Border.all(color: isRed ? Colors.red : Colors.green, width: 2),
                borderRadius: BorderRadius.circular(8)
              ),
              child: MarkdownBody(data: _analysisResult),
            ),
          ],
          if (isRed) ...[
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _reportToPolice, 
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), 
              child: Text(T.get("report_btn"))
            ),
          ]
        ],
      ),
    );
  }
}

// ============================================================
// 4. DEEPFAKE VIDEO ANALYZER
// ============================================================
class VideoAnalyzerPage extends StatefulWidget {
  const VideoAnalyzerPage({super.key});

  @override
  State<VideoAnalyzerPage> createState() => _VideoAnalyzerPageState();
}

class _VideoAnalyzerPageState extends State<VideoAnalyzerPage> {
  File? _video;
  String _analysisResult = "";
  bool _isLoading = false;

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() { 
        _video = File(pickedFile.path); 
        _analysisResult = ""; 
      });
    }
  }

  Future<void> _checkDeepfake() async {
    if (_video == null) return;
    setState(() { _isLoading = true; _analysisResult = T.get("analyzing"); });

    try {
      if (globalApiKey.contains("PASTE_YOUR")) throw "API Key is missing!";
      
      final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: globalApiKey);
      
      String langName = currentLanguage.value == "ml" ? "Malayalam" : "English";

      final prompt = TextPart("""
      Analyze this video for Deepfakes. 
      Is this REAL or FAKE? Answer in $langName for a 10-year-old.
      Keywords: SAFE ✅, DANGEROUS 🛑, DEEPFAKE DETECTED 🤖.
      """);
      
      final videoBytes = await _video!.readAsBytes();
      final videoPart = DataPart('video/mp4', videoBytes);
      
      final response = await model.generateContent([Content.multi([prompt, videoPart])]);
      setState(() => _analysisResult = response.text ?? "No response");
    } catch (e) {
      setState(() => _analysisResult = "Error: $e. (Video might be too large)");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isRed = _analysisResult.toUpperCase().contains("FAKE") || 
                 _analysisResult.toUpperCase().contains("DEEPFAKE") || 
                 _analysisResult.toUpperCase().contains("DANGEROUS") ||
                 _analysisResult.contains("Error") ||
                 _analysisResult.contains("🛑") || 
                 _analysisResult.contains("🤖");

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(T.get("video_title"), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _pickVideo,
            child: Container(
              height: 200,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
              child: _video == null ? Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.video_library, size: 50, color: Colors.grey),
                  Text(T.get("upload_video_text"))
                ],
              )) : const Center(child: Icon(Icons.check_circle, size: 60, color: Colors.green)),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _checkDeepfake, 
            icon: const Icon(Icons.scanner), 
            label: const Text("Scan for Deepfake"),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A), foregroundColor: Colors.white),
          ),
          if (_analysisResult.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isRed ? Colors.red.shade100 : Colors.green.shade100,
                border: Border.all(color: isRed ? Colors.red : Colors.green, width: 2),
                borderRadius: BorderRadius.circular(8)
              ),
              child: MarkdownBody(data: _analysisResult),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================
// 5. LINK ANALYZER
// ============================================================
class LinkAnalyzerPage extends StatefulWidget {
  const LinkAnalyzerPage({super.key});

  @override
  State<LinkAnalyzerPage> createState() => _LinkAnalyzerPageState();
}

class _LinkAnalyzerPageState extends State<LinkAnalyzerPage> {
  final TextEditingController _linkController = TextEditingController();
  String _result = "";
  bool _isLoading = false;

  Future<void> _analyzeLink() async {
    if (_linkController.text.isEmpty) {
      setState(() => _result = T.get("paste_link"));
      return;
    }
    setState(() { _isLoading = true; _result = T.get("analyzing"); });

    try {
      if (globalApiKey.contains("PASTE_YOUR")) throw "API Key is missing in code!";

      final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: globalApiKey);
      
      String langName = currentLanguage.value == "ml" ? "Malayalam" : "English";

      final prompt = "Is this link '${_linkController.text}' SAFE ✅ or DANGEROUS 🛑? Explain to a 10-year-old in $langName. If safe, say 'SAFE'. If dangerous, say 'DANGEROUS'.";
      
      final response = await model.generateContent([Content.text(prompt)]);
      setState(() => _result = response.text ?? "No response");
    } catch (e) {
      setState(() => _result = "Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isRed = _result.toUpperCase().contains("DANGEROUS") || 
                 _result.toUpperCase().contains("SCAM") || 
                 _result.toUpperCase().contains("UNSAFE") ||
                 _result.contains("Error") ||
                 _result.contains("🛑");

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(T.get("link_title"), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _linkController,
              decoration: InputDecoration(
                labelText: T.get("paste_link"),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _analyzeLink,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A), foregroundColor: Colors.white, padding: const EdgeInsets.all(15)),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(T.get("scan_link_btn")),
              ),
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: isRed ? Colors.red.shade100 : Colors.green.shade100, 
                  border: Border.all(color: isRed ? Colors.red : Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: MarkdownBody(data: _result),
              )
            ]
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 6. HELPLINE PAGE (Working Dialer)
// ============================================================
class HelplinePage extends StatelessWidget {
  const HelplinePage({super.key});

  Future<void> _makeCall(String number) async {
    final Uri launchUri = Uri(scheme: 'tel', path: number);
    try {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Error launching dialer: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(T.get("helpline_title"), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        _buildHelplineCard("National Cyber Helpline", "1930", Colors.red),
        _buildHelplineCard("Kerala Cyber Dome", "9497900999", Colors.blue),
        _buildHelplineCard("Police Control Room", "112", Colors.orange),
        const SizedBox(height: 20),
        const Text("Official Emails", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const ListTile(
          leading: Icon(Icons.email),
          title: Text("spcyberops.pol@kerala.gov.in"),
          subtitle: Text("Superintendent of Police (Cyber)"),
        ),
      ],
    );
  }

  Widget _buildHelplineCard(String title, String number, Color color) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(Icons.phone, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(number, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        trailing: ElevatedButton(
          onPressed: () => _makeCall(number),
          style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
          child: Text(T.get("call")),
        ),
      ),
    );
  }
}

// ============================================================
// 7. SETTINGS PAGE
// ============================================================
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _changeLanguage(String? langCode) async {
    if (langCode == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', langCode);
    currentLanguage.value = langCode;
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(T.get("settings_title"), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(T.get("select_lang"), style: const TextStyle(color: Colors.grey, fontSize: 16)),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                RadioListTile(
                  title: const Text("English"),
                  value: "en",
                  groupValue: currentLanguage.value,
                  onChanged: _changeLanguage,
                ),
                RadioListTile(
                  title: const Text("മലയാളം (Malayalam)"),
                  value: "ml",
                  groupValue: currentLanguage.value,
                  onChanged: _changeLanguage,
                ),
                RadioListTile(
                  title: const Text("हिंदी (Hindi)"),
                  value: "hi",
                  groupValue: currentLanguage.value,
                  onChanged: _changeLanguage,
                ),
                RadioListTile(
                  title: const Text("தமிழ் (Tamil)"),
                  value: "ta",
                  groupValue: currentLanguage.value,
                  onChanged: _changeLanguage,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}