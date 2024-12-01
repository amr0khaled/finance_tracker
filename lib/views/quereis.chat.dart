import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text("Over All"),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                "TODOs",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Task Items
              _buildTaskItem(
                context,
                "Groceries from Convenient Store",
                "-\$400",
                [
                  "8 Eggs",
                  "2K Flour",
                  "1K Tomatoes",
                  "8 Eggs",
                  "2K Flour",
                  "1K Tomatoes",
                ],
              ),
              _buildTaskItem(
                context,
                "Pay University’s Tuition",
                "-\$15,000",
                null,
              ),
              _buildTaskItem(
                context,
                "Get Snacks",
                "",
                null,
              ),
              const SizedBox(height: 16),

              // Recent Transaction Section
              const Text(
                "Recent Transaction",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildTransactionItem(
                  context, "Food", "-\$30", Colors.red.shade100),
              _buildTransactionItem(
                  context, "Salary", "+\$8000", Colors.green.shade100),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.note_alt_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.wallet_outlined),
              onPressed: () {},
            ),
            const SizedBox(width: 40), // Space for FAB
            IconButton(
              icon: const Icon(Icons.refresh_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTaskItem(
    BuildContext context,
    String title,
    String amount,
    List<String>? subtasks,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (amount.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    amount,
                    style: const TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ),
            ],
          ),
          if (subtasks != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: subtasks
                    .map(
                      (subtask) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Checkbox(
                            value: false,
                            onChanged: null,
                          ),
                          Text(
                            subtask,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
      BuildContext context, String title, String amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 14,
                color: color == Colors.red.shade100 ? Colors.red : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
