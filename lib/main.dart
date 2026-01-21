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
const String globalApiKey = "AIzaSyCMYRwcb4uz5fy04xEeDAZx8VZuEteypMU"; 
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
      "app_name": "Kerala Cyber Guard",
      "subtitle": "Secure your digital life.",
      "login_google": "Sign in with Google",
      "menu_screenshot": "Screenshot & AI Detector",
      "menu_link": "Link / URL Analyzer",
      "menu_helpline": "Helpline Numbers",
      "menu_settings": "Settings",
      "menu_logout": "Logout",
      "scan_title": "Screenshot & AI Detector",
      "upload_text": "Tap to Upload Image",
      "verify_btn": "Check Safety",
      "report_btn": "Report to Police",
      "analyzing": "Scanning for Scams & AI...",
      "link_title": "Link / URL Scanner",
      "paste_link": "Paste link here",
      "scan_link_btn": "Scan Link",
      "helpline_title": "Kerala Cyber Helplines",
      "call": "Call",
      "settings_title": "Settings",
      "select_lang": "Select Language",
    },
    // ... (Keep your other languages here if needed, keeping it short for copy-paste)
    "ml": {
      "app_name": "കേരള സൈബർ ഗാർഡ്",
      "subtitle": "നിങ്ങളുടെ ഡിജിറ്റൽ ജീവിതം സുരക്ഷിതമാക്കൂ.",
      "login_google": "Google വഴി ലോഗിൻ ചെയ്യുക",
      "menu_screenshot": "ചിത്രങ്ങൾ / AI പരിശോധന",
      "menu_link": "ലിങ്ക് പരിശോധന",
      "menu_helpline": "സഹായ നമ്പറുകൾ",
      "menu_settings": "ക്രമീകരണങ്ങൾ",
      "menu_logout": "പുറത്തുകടക്കുക",
      "scan_title": "ചിത്രങ്ങൾ / AI പരിശോധന",
      "upload_text": "ചിത്രം അപ്‌ലോഡ് ചെയ്യുക",
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
  };

  static String get(String key) {
    // Default to English if translation is missing
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
// 2. HOME PAGE
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
              leading: const Icon(Icons.link),
              title: Text(T.get("menu_link")),
              selected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.phone_in_talk),
              title: Text(T.get("menu_helpline")),
              selected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
             ListTile(
              leading: const Icon(Icons.language),
              title: Text(T.get("menu_settings")),
              selected: _selectedIndex == 3,
              onTap: () => _onItemTapped(3),
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
// 3. IMAGE ANALYZER (USING gemini-1.5-pro)
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
      
      // SWITCHED TO 'gemini-1.5-pro' which is very reliable
      final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: globalApiKey);
      
      String langName = "English";
      if (currentLanguage.value == "ml") langName = "Malayalam";

      final prompt = TextPart("""
      Analyze this image.
      1. Is it a SCAM, UNSAFE, or SAFE?
      2. Is it AI-GENERATED (Deepfake)?
      
      Answer in $langName language for a 10-year-old.
      
      Keywords to use in answer:
      - 'SAFE ✅' if safe.
      - 'DANGEROUS 🛑' if unsafe.
      - 'AI GENERATED 🤖' if fake.
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
    final Email email = Email(
      body: 'Report:\n\n$_analysisResult', 
      subject: 'Cyber Report',
      recipients: ['cyberps@keralapolice.gov.in'], 
      attachmentPaths: [_screenshot!.path], 
      isHTML: false,
    );
    try { await FlutterEmailSender.send(email); } catch (e) { print(e); }
  }

  @override
  Widget build(BuildContext context) {
    // RED BOX LOGIC
    bool isRed = _analysisResult.toUpperCase().contains("DANGEROUS") || 
                 _analysisResult.toUpperCase().contains("SCAM") || 
                 _analysisResult.toUpperCase().contains("AI GENERATED") ||
                 _analysisResult.toUpperCase().contains("AI-GENERATED") ||
                 _analysisResult.toUpperCase().contains("UNSAFE") ||
                 _analysisResult.contains("Error") || // Added Error to Red List
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
// 4. LINK ANALYZER (USING gemini-1.5-pro)
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
      if (globalApiKey.contains("PASTE_YOUR")) throw "API Key is missing!";

      // SWITCHED TO 'gemini-1.5-pro'
      final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: globalApiKey);
      
      String langName = "English";
      if (currentLanguage.value == "ml") langName = "Malayalam";

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
                 _result.contains("Error") || // Added Error to Red List
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
// 5. HELPLINE PAGE
// ============================================================
class HelplinePage extends StatelessWidget {
  const HelplinePage({super.key});

  Future<void> _makeCall(String number) async {
    final Uri launchUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
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
// 6. SETTINGS PAGE
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
                // Add more languages here if you want
              ],
            ),
          )
        ],
      ),
    );
  }
}