import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors/app_colors.dart';
import 'create_plan_viewmodel.dart';

class CreatePlanScreen extends StatelessWidget {
  const CreatePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<CreatePlanViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Create Travel Plan',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppColors.sfaBlue.withValues(alpha: 0.1),
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Top Section
            const SizedBox(height: 8),
            _buildStepper(),
            const SizedBox(height: 12),
            _buildTopToggle(viewModel),
            const SizedBox(height: 12),
            _buildDateHeader(),
            const SizedBox(height: 8),
            _buildCalendarStrip(),
            const SizedBox(height: 12),
            _buildObjectiveField(),
            const SizedBox(height: 8),

            // Scrollable Content Area
            Expanded(
              child: Obx(
                () => ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    viewModel.selectedTabIndex.value == 0
                        ? _buildAiSmartPlanContent(viewModel)
                        : _buildManualSelectContent(viewModel),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Fixed Bottom Action Button
            //  _buildActionButton(viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Connecting Line
          Positioned(
            top: 15, // Centers vertically with the 30px circles
            left: 20,
            right: 20,
            child: Container(height: 1, color: Colors.grey.shade300),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStep(1, 'Select', true),
              _buildStep(2, 'Review', false),
              _buildStep(3, 'Done', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: isActive ? AppColors.sfaBlue : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                color: isActive ? AppColors.sfaBlue : Colors.grey.shade400,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.sfaBlue : Colors.grey.shade400,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTopToggle(CreatePlanViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 38,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildToggleItem(
                  title: 'AI Smart Plan',
                  icon: Icons.auto_awesome,
                  isSelected: viewModel.selectedTabIndex.value == 0,
                  onTap: () => viewModel.changeTab(0),
                ),
              ),
              Expanded(
                child: _buildToggleItem(
                  title: 'Manual Select',
                  icon: Icons.edit_outlined,
                  isSelected: viewModel.selectedTabIndex.value == 1,
                  onTap: () => viewModel.changeTab(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sfaBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: 'Plan for ',
                  style: TextStyle(color: Colors.grey),
                ),
                TextSpan(
                  text: 'Tue, 25 Aug 2026',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Colors.lightBlue,
            ),
            label: const Text(
              'Calendar',
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              backgroundColor: Colors.lightBlue.withValues(alpha: 0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarStrip() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(7, (index) {
          final isSelected = index == 3;
          final days = ['S', 'S', 'M', 'T', 'W', 'T', 'F'];
          final dates = ['22', '23', '24', '25', '26', '27', '28'];

          return Container(
            width: 50,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.sfaBlue : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? AppColors.sfaBlue
                    : Colors.black.withValues(alpha: 0.08),
              ),
            ),
            child: Column(
              children: [
                Text(
                  days[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white70 : Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  dates[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                if (index == 2) ...[
                  const SizedBox(height: 1),
                  Container(
                    width: 1,
                    height: 1,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildObjectiveField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Visit objective (optional)',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            icon: Icon(Icons.flag_outlined, color: Colors.grey, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildAiSmartPlanContent(CreatePlanViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 30, thickness: 1, color: Color(0xFFF1F5F9)),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'How can AI help?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Pick a goal — AI generates a complete plan you can review',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),

        // Smart Pick Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSmartPickCard(
            isSelected: viewModel.isSmartPickSelected.value,
            onTap: () => viewModel.toggleSmartPick(),
          ),
        ),

        const SizedBox(height: 16),

        // Goals Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.aiGoals.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.4,
            ),
            itemBuilder: (context, index) {
              final goal = viewModel.aiGoals[index];
              return _buildGoalCard(
                goal: goal,
                isSelected: viewModel.selectedGoalIndex.value == index,
                onTap: () => viewModel.selectGoal(index),
              );
            },
          ),
        ),

        const SizedBox(height: 32),

        // Detailed Help Section at the bottom
        _buildHowAiHelpSection(),
      ],
    );
  }

  Widget _buildHowAiHelpSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'More about AI Planning',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildHelpItem(
            icon: Icons.insights_rounded,
            title: 'Identify Opportunities',
            description:
                'AI analyzes sales data to find customers who are likely to buy or need a follow-up.',
          ),
          const SizedBox(height: 12),
          _buildHelpItem(
            icon: Icons.route_rounded,
            title: 'Optimize Routes',
            description:
                'Get the most efficient travel path to save time and fuel while maximizing coverage.',
          ),
          const SizedBox(height: 12),
          _buildHelpItem(
            icon: Icons.trending_up_rounded,
            title: 'Hit Your Targets',
            description:
                'Smart recommendations focused on helping you reach your monthly sales goals.',
          ),
        ],
      ),
    );
  }

  Widget _buildSmartPickCard({
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 120),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00A3FF), Color(0xFF0081C9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.sfaBlue.withValues(alpha: 0.25),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: isSelected
              ? Border.all(
                  color: Colors.white.withValues(alpha: 0.6),
                  width: 2.5,
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Smart Pick',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Let AI pick the best customers for the day',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard({
    required AiGoal goal,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.sfaBlue
                : Colors.black.withValues(alpha: 0.08),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.sfaLightBlue
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                goal.icon,
                color: isSelected ? AppColors.sfaBlue : Colors.grey,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    goal.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: isSelected
                          ? AppColors.sfaBlue
                          : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    goal.subtitle,
                    style: const TextStyle(
                      fontSize: 8,
                      color: Colors.grey,
                      height: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualSelectContent(CreatePlanViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Build your plan manually',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Search and pick the customers you want to visit from your list.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 1),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_circle_outline, size: 22),
                  label: const Text(
                    'Pick Customers',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.sfaBlue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.sfaBlue, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
