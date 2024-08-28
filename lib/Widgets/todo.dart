import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oz/models/user.dart';  // Import the user model

class CalendarPage extends StatefulWidget {
  final myUser currentUser;

  const CalendarPage({super.key, required this.currentUser});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Map<String, dynamic>>> _getEventsForDay(DateTime day) async {
    List<Map<String, dynamic>> events = [];
    final snapshot = await _firestore.collection('users').doc(widget.currentUser.username).collection('events').get();
    if (snapshot.docs.isNotEmpty) {
      final filteredEvents = snapshot.docs.where((doc) => isSameDay((doc['date'] as Timestamp).toDate(), day)).map((doc) => doc.data()).cast<Map<String, dynamic>>();
      events.addAll(filteredEvents);
    }
    return events;
  }

  Future<void> _addEvent(String event, TimeOfDay time) async {
    final newEvent = {
      'date': _selectedDay,
      'event': event,
      'time': time.format(context),
    };

    await _firestore.collection('users').doc(widget.currentUser.username).collection('events').add(newEvent);
    setState(() {});
  }

  void _showAddEventDialog() {
    final _eventController = TextEditingController();
    TimeOfDay _selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _eventController,
                decoration: const InputDecoration(labelText: 'Event'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Time:'),
                  TextButton(
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (picked != null && picked != _selectedTime) {
                        setState(() {
                          _selectedTime = picked;
                        });
                      }
                    },
                    child: Text(_selectedTime.format(context)),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addEvent(_eventController.text, _selectedTime);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Events', style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: const Color(0xffa4392f),
        actions: [
          IconButton(
            icon: const Icon(Icons.add,color: Colors.white,),
            onPressed: _showAddEventDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Color(0xbea4392f),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color(0xffa4392f),
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(color: Colors.white),
              selectedTextStyle: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _getEventsForDay(_selectedDay ?? _focusedDay),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading events'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No events for this day'));
                } else {
                  final events = snapshot.data!;
                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Card(
                        child: ListTile(
                          title: Text(event['event']),
                          subtitle: Text(event['time']),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
