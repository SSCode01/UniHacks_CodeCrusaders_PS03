// CREATE_CAPSULE_SCREEN.DART
import 'package:flutter/material.dart';
import '../widgets/funky_button.dart';

class CreateCapsuleScreen extends StatefulWidget {
  final String groupId;

  const CreateCapsuleScreen({super.key, required this.groupId});

  @override
  State<CreateCapsuleScreen> createState() => _CreateCapsuleScreenState();
}

class _CreateCapsuleScreenState extends State<CreateCapsuleScreen> {
  final TextEditingController _messageController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time Capsule',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Capture this moment',
              style: TextStyle(
                color: Color(0xFFA1A1B5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Intro
            const Text('📦', style: TextStyle(fontSize: 70)),
            const SizedBox(height: 16),
            const Text(
              'Lock in a memory',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Your squad will see this when it unlocks',
              style: TextStyle(
                color: Color(0xFFA1A1B5),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Message
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your message',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1B263B),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF2D2D44)),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: Colors.white),
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "Dear future us...",
                  hintStyle: TextStyle(color: Color(0xFFA1A1B5)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Media Upload
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Add media (optional)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B263B),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF2D2D44)),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.image, color: Color(0xFFA1A1B5), size: 32),
                        SizedBox(height: 8),
                        Text(
                          'Add Photo',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B263B),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF2D2D44)),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.videocam,
                            color: Color(0xFFA1A1B5), size: 32),
                        SizedBox(height: 8),
                        Text(
                          'Add Video',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Unlock Date
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'When should this unlock?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 7)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() => selectedDate = date);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B263B),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF2D2D44)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Color(0xFFA1A1B5), size: 20),
                    const SizedBox(width: 12),
                    Text(
                      selectedDate != null
                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : 'Select unlock date',
                      style: TextStyle(
                        color: selectedDate != null
                            ? Colors.white
                            : const Color(0xFFA1A1B5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1B263B),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF2D2D44)),
              ),
              child: const Row(
                children: [
                  Text('⏰', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Pro tip: Set it for a meaningful date - someone's birthday, your squad anniversary, or just when you think you'll need a nostalgia hit.",
                      style: TextStyle(
                        color: Color(0xFFA1A1B5),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Create Button
            SizedBox(
              width: double.infinity,
              child: FunkyButton(
                onPressed: () {
                  // Create capsule
                  Navigator.pop(context);
                },
                text: "Lock it in 🔒",
                variant: 'accent',
                size: 'lg',
                disabled:
                    _messageController.text.isEmpty || selectedDate == null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
