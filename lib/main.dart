import 'package:flutter/material.dart';

void main() {
  runApp(const MyFitnessApp());
}

class MyFitnessApp extends StatelessWidget {
  const MyFitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Custom Olive Green & Coffee Brown Color Palette
    const Color oliveGreen = Color(0xFF556B2F);
    const Color coffeeBrown = Color(0xFF4A3525);
    const Color warmBackground = Color(0xFFF7F5F0);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '85-Day Fitness Journey',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: warmBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: oliveGreen,
          primary: oliveGreen,
          secondary: coffeeBrown,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: oliveGreen,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0; // Tracks active tab: 0 = Dashboard, 1 = Log Activity

  // 85-Day Journey State
  int currentDay = 1;
  final int totalDays = 85;

  // Calorie & Macro Tracker State
  int calorieGoal = 2000;
  int caloriesConsumed = 0;
  int proteinGrams = 0;
  int carbsGrams = 0;
  int fatGrams = 0;

  // Daily Habits State
  bool completedExercise = false;
  bool sleptWell = false;
  bool drankWater = false;

  // Logged Food List History
  List<Map<String, dynamic>> loggedMeals = [];

  // Manual Food Form Controllers
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  // Color Definitions for UI elements
  static const Color oliveGreen = Color(0xFF556B2F);
  static const Color coffeeBrown = Color(0xFF4A3525);

  void _addMeal() {
    String name = _foodNameController.text.trim();
    int calories = int.tryParse(_caloriesController.text) ?? 0;
    int protein = int.tryParse(_proteinController.text) ?? 0;
    int carbs = int.tryParse(_carbsController.text) ?? 0;
    int fat = int.tryParse(_fatController.text) ?? 0;

    if (name.isNotEmpty && calories > 0) {
      setState(() {
        caloriesConsumed += calories;
        proteinGrams += protein;
        carbsGrams += carbs;
        fatGrams += fat;

        loggedMeals.add({
          'name': name,
          'calories': calories,
          'protein': protein,
          'carbs': carbs,
          'fat': fat,
        });
      });

      _foodNameController.clear();
      _caloriesController.clear();
      _proteinController.clear();
      _carbsController.clear();
      _fatController.clear();

      FocusScope.of(context).unfocus(); // Close keyboard

      // Show confirmation banner
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name logged successfully!'),
          backgroundColor: oliveGreen,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _resetDay() {
    setState(() {
      caloriesConsumed = 0;
      proteinGrams = 0;
      carbsGrams = 0;
      fatGrams = 0;
      completedExercise = false;
      sleptWell = false;
      drankWater = false;
      loggedMeals.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen content based on active tab index
    Widget activeBody = _selectedIndex == 0 ? _buildDashboardTab() : _buildLoggingTab();

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Dashboard — Day $currentDay / $totalDays' : 'Log Food & Habits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Day',
            onPressed: _resetDay,
          ),
        ],
      ),
      body: activeBody,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: oliveGreen,
        unselectedItemColor: Colors.grey[600],
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Log Entry',
          ),
        ],
      ),
    );
  }

  // TAB 1: DASHBOARD PAGE
  Widget _buildDashboardTab() {
    int caloriesRemaining = calorieGoal - caloriesConsumed;
    double progress = (caloriesConsumed / calorieGoal).clamp(0.0, 1.0);
    bool ateWithinGoal = caloriesConsumed > 0 && caloriesConsumed <= calorieGoal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 85-Day Journey Banner Card
          Card(
            color: coffeeBrown,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.white, size: 36),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Day $currentDay of $totalDays',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${totalDays - currentDay} days remaining in your journey',
                        style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Calorie Progress Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    'Calories Remaining',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$caloriesRemaining',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: caloriesRemaining < 0 ? Colors.red : oliveGreen,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 12,
                    backgroundColor: Colors.grey[300],
                    color: progress >= 1.0 ? Colors.red : oliveGreen,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Target Goal: $calorieGoal kcal', style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('Consumed: $caloriesConsumed kcal', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Macro Summary Row
          Row(
            children: [
              _buildMacroTile('Protein', '${proteinGrams}g', coffeeBrown),
              const SizedBox(width: 8),
              _buildMacroTile('Carbs', '${carbsGrams}g', oliveGreen),
              const SizedBox(width: 8),
              _buildMacroTile('Fat', '${fatGrams}g', Colors.amber[800]!),
            ],
          ),
          const SizedBox(height: 24),

          // Daily Habit Tracker Status Summary
          const Text('Daily Habits Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: coffeeBrown)),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _buildHabitSummaryRow('Exercise Done (30+ mins)', completedExercise),
                const Divider(height: 1),
                _buildHabitSummaryRow('Slept 7–8 Hours', sleptWell),
                const Divider(height: 1),
                _buildHabitSummaryRow('Hydration Goal (2.5L+)', drankWater),
                const Divider(height: 1),
                _buildHabitSummaryRow('Stayed Within Calorie Goal', ateWithinGoal),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: SEPARATE LOGGING PAGE
  Widget _buildLoggingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Log Food & Meal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: coffeeBrown)),
          const SizedBox(height: 12),

          // Custom Meal Entry Card Form
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _foodNameController,
                    decoration: const InputDecoration(
                      labelText: 'Food Name (e.g. Grilled Chicken & Rice)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _caloriesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Calories (kcal)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _proteinController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Protein (g)', border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _carbsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Carbs (g)', border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _fatController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Fat (g)', border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _addMeal,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Meal to Daily Log', style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: oliveGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Daily Habits Checklist
          const Text('Track Daily Habits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: coffeeBrown)),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                CheckboxListTile(
                  title: const Text('Workout / Exercise Done'),
                  subtitle: const Text('30+ minutes of intentional activity'),
                  value: completedExercise,
                  activeColor: oliveGreen,
                  onChanged: (val) => setState(() => completedExercise = val ?? false),
                ),
                const Divider(height: 1),
                CheckboxListTile(
                  title: const Text('Slept 7–8 Hours'),
                  subtitle: const Text('Restful sleep last night'),
                  value: sleptWell,
                  activeColor: oliveGreen,
                  onChanged: (val) => setState(() => sleptWell = val ?? false),
                ),
                const Divider(height: 1),
                CheckboxListTile(
                  title: const Text('Hydration Goal'),
                  subtitle: const Text('Drank 2.5L+ of water'),
                  value: drankWater,
                  activeColor: oliveGreen,
                  onChanged: (val) => setState(() => drankWater = val ?? false),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logged Food List History
          if (loggedMeals.isNotEmpty) ...[
            const Text('Meals Logged Today', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: coffeeBrown)),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: loggedMeals.length,
              itemBuilder: (context, index) {
                final meal = loggedMeals[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.restaurant, color: oliveGreen),
                    title: Text(meal['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('P: ${meal['protein']}g | C: ${meal['carbs']}g | F: ${meal['fat']}g'),
                    trailing: Text('${meal['calories']} kcal', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: coffeeBrown)),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  // Helper Widget for Macro Cards
  Widget _buildMacroTile(String label, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Column(
            children: [
              Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget for Habit Rows in Dashboard
  Widget _buildHabitSummaryRow(String habit, bool isCompleted) {
    return ListTile(
      title: Text(habit, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Icon(
        isCompleted ? Icons.check_circle : Icons.cancel_outlined,
        color: isCompleted ? oliveGreen : Colors.grey[400],
      ),
    );
  }
}