import 'package:flutter/material.dart';
import 'moodlogs/mood_logs.dart';
import 'meditations/meditation_page.dart';
import 'therapy/therapy_sessions_page.dart';
import 'journal/journal_page.dart';
import 'chats/chat_list_page.dart';
import 'settings/settings_page.dart';

class HomePage extends StatelessWidget {
  final int userId;

  const HomePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Welcome, User!',
                  style: TextStyle(color: Colors.white),
                ),
                background: Image.asset(
                  'assets/images/background.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              backgroundColor: Color(0xFFb2c2a1),
              actions: [
                IconButton(
                  icon: Icon(Icons.account_circle, color: Colors.white),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage(userId: userId)),
                  ),
                ),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                delegate: SliverChildListDelegate([
                  _buildFeatureCard(
                    context,
                    'Mood Tracker',
                    Icons.mood,
                    Color(0xFFdcc9f3),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MoodLogs()),
                    ),
                  ),
                  _buildFeatureCard(
                    context,
                    'Meditate',
                    Icons.self_improvement,
                    Color(0xFFfff9b0),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MeditationPage()),
                    ),
                  ),
                  _buildFeatureCard(
                    context,
                    'Therapy Sessions',
                    Icons.local_hospital,
                    Color(0xFFb2c2a1),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TherapySessionsPage(userId: userId),
                      ),
                    ),
                  ),
                  _buildFeatureCard(
                    context,
                    'Journal',
                    Icons.book,
                    Color(0xFFfff8ed),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JournalPage()),
                    ),
                  ),
                ]),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  color: Color(0xFFb2c2a1),
                  child: ListTile(
                    leading: Icon(Icons.chat, color: Colors.white),
                    title: Text('Start a Chat', style: TextStyle(color: Colors.white)),
                    subtitle: Text('Connect with a therapist or support group', style: TextStyle(color: Colors.white70)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatListPage(userId: userId.toString())), // Convert userId to String here
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 50, color: Colors.white),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}