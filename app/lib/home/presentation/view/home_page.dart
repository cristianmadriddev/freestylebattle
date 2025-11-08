import 'package:flutter/material.dart';
import 'package:freestylebattle/battle/battle.dart';

import '../../../training_list/presentation/view/training_list_page.dart';

class HomeTabs extends StatefulWidget {
  const HomeTabs({super.key});

  @override
  State<HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _tabController.index;

    return Scaffold(
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            icon: Image.asset(
              'assets/logo.png',
              height: 32,
              color: selectedIndex == 0
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              colorBlendMode: BlendMode.srcIn,
            ),
            text: 'Batalha',
          ),
          Tab(
            icon: Icon(
              Icons.psychology_sharp,
              color: selectedIndex == 1
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            text: 'Treinar',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [const BattlePage(), TrainingListPage()],
      ),
    );
  }
}
