import 'package:flutter/material.dart';

class DoctorsListScreen extends StatefulWidget {
  const DoctorsListScreen({super.key});

  @override
  State<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  final List<Map<String, String>> _allDoctors = const [
    {'name': 'د. أحمد السعدي', 'speciality': 'أمراض قلب'},
    {'name': 'د. سارة النجار', 'speciality': 'أمراض جلدية'},
    {'name': 'د. محمود حسنين', 'speciality': 'جراحة عظام'},
    {'name': 'د. منى سمير', 'speciality': 'طب أعصاب'},
    {'name': 'د. خالد عبد اللطيف', 'speciality': 'طب أطفال'},
    {'name': 'د. ليلى إبراهيم', 'speciality': 'طب نساء وتوليد'},
  ];

  late List<Map<String, String>> _filteredDoctors;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredDoctors = List.from(_allDoctors);
    _searchCtrl.addListener(_filterList);
  }

  void _filterList() {
    final query = _searchCtrl.text.trim();
    if (query.isEmpty) {
      setState(() => _filteredDoctors = List.from(_allDoctors));
    } else {
      setState(() {
        _filteredDoctors = _allDoctors.where((doc) {
          final name = doc['name']!;
          final spec = doc['speciality']!;
          return name.contains(query) || spec.contains(query);
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('قائمة الأطباء'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'ابحث بالاسم أو التخصص...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredDoctors.isEmpty
                ? const Center(child: Text('لا يوجد نتائج'))
                : ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: _filteredDoctors.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final doctor = _filteredDoctors[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 2,
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(doctor['name']!),
                          subtitle: Text(doctor['speciality']!),
                          trailing: IconButton(
                            icon: const Icon(Icons.calendar_month),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('حجز الموعد قادم قريبًا ...')),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
