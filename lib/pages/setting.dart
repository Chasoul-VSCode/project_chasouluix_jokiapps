import 'package:flutter/material.dart';

import '../auth/login.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  double _textSize = 14.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF4C2A86),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage('https://placekitten.com/100/100'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Account', Icons.person),
              _buildSettingCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage('https://placekitten.com/100/100'),
                      ),
                      title: const Text('John Doe', style: TextStyle(fontSize: 12)),
                      subtitle: const Text('john.doe@example.com', style: TextStyle(fontSize: 10)),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, size: 16),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              _buildSectionHeader('Preferences', Icons.settings),
              _buildSettingCard(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Dark Mode', style: TextStyle(fontSize: 12)),
                      value: _isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          _isDarkMode = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Notifications', style: TextStyle(fontSize: 12)),
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    ListTile(
                      title: const Text('Language', style: TextStyle(fontSize: 12)),
                      trailing: DropdownButton<String>(
                        value: _selectedLanguage,
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                        items: ['English', 'Indonesian']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedLanguage = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              _buildSectionHeader('About', Icons.info),
              _buildSettingCard(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('App Version', style: TextStyle(fontSize: 12)),
                      subtitle: const Text('1.0.0', style: TextStyle(fontSize: 10)),
                    ),
                    ListTile(
                      title: const Text('Terms of Service', style: TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right, size: 16),
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              _buildSettingCard(
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout', 
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w600
                    )
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout', style: TextStyle(fontSize: 14)),
                        content: const Text('Are you sure you want to logout?', style: TextStyle(fontSize: 12)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel', style: TextStyle(fontSize: 12)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text('Logout', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF4C2A86).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF4C2A86),
              size: 14,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4C2A86),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
