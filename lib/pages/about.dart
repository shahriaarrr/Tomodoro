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

  void _launchDonationURL() async {
    final donationUrl = Uri.parse('https://daramet.com/shahriaarrr');
    if (await canLaunchUrl(donationUrl)) {
      await launchUrl(donationUrl, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = theme.cardColor;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;
    final dividerColor = isDark ? Colors.grey[700] : Colors.grey[300];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 54,
                backgroundImage: const AssetImage('assets/images/profile.jpg'),
              ),
              const SizedBox(height: 10),
              Text(
                'shahriaarrr',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                'Software Engineer',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: subtitleColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Hi! I\'m Shahriar, a computer engineering student passionate about programming and continuous learning.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.7,
                          color: textColor,
                          fontSize: 16.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Divider(height: 1, color: dividerColor),
                      const SizedBox(height: 12),
                      Text(
                        'I enjoy building projects using Python, Go, and Dart, and have experience with frameworks like Django, FastAPI, and Flutter.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.7,
                          color: textColor,
                          fontSize: 16.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Divider(height: 1, color: dividerColor),
                      const SizedBox(height: 12),
                      Text(
                        'On my YouTube channel, I share tutorials, coding experiences, and insights from my journey in tech.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.7,
                          color: textColor,
                          fontSize: 16.5,
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
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink.shade600, Colors.orange.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _launchDonationURL,
                    style: ElevatedButton.styleFrom(
                      elevation: 0, // shadow is handled by DecoratedBox
                      backgroundColor: Colors.transparent, // <-- here
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 28,
                    ),
                    label: const Text(
                      'Fuel the App! 🔋',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: 230,
                height: 48,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade700, Colors.pink.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _launchURL,
                    style: ElevatedButton.styleFrom(
                      elevation: 0, // shadow handled by DecoratedBox
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 28,
                    ),
                    label: const Text(
                      'My YouTube Channel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
