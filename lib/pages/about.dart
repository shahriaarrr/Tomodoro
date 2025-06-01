import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  void _launchURL() async {
    final channelId = 'UCP_y9q-smQQD4ri-nhLhTYw';
    final youtubeAppUrl = Uri.parse(
      'youtube://www.youtube.com/channel/$channelId',
    );
    final youtubeAppUrl2 = Uri.parse('vnd.youtube://channel/$channelId');
    final youtubeWebUrl = Uri.parse('https://youtube.com/channel/$channelId');

    if (await canLaunchUrl(youtubeAppUrl)) {
      await launchUrl(youtubeAppUrl, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(youtubeAppUrl2)) {
      await launchUrl(youtubeAppUrl2, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(youtubeWebUrl)) {
      await launchUrl(youtubeWebUrl, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 54,
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
              const SizedBox(height: 10),
              const Text(
                'shahriaarrr',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Software Engineer',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[850]
                            : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.12),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Hi! I\'m Shahriar, a computer engineering student passionate about programming and continuous learning.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.5,
                          height: 1.7,
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Divider(height: 1, color: Colors.grey[300]),
                      const SizedBox(height: 12),
                      Text(
                        'I enjoy building projects using Python, Go, and Dart, and have experience with frameworks like Django, FastAPI, and Flutter.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.5,
                          height: 1.7,
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Divider(height: 1, color: Colors.grey[300]),
                      const SizedBox(height: 12),
                      Text(
                        'On my YouTube channel, I share tutorials, coding experiences, and insights from my journey in tech.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.5,
                          height: 1.7,
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 230,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _launchURL,
                  icon: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 28,
                  ),
                  label: const Text(
                    'My YouTube Channel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
