// lib/src/view/water_intake/water_intake_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nutrio/src/provider/water_intake_provider.dart';
import 'package:nutrio/src/view/water_intake/widgets/water_glass_painter.dart';

class WaterIntakeScreen extends ConsumerStatefulWidget {
  // 1. Add a final variable to accept the user's weight
  final double userWeightKg;

  const WaterIntakeScreen({
    super.key,
    required this.userWeightKg,
  });

  @override
  ConsumerState<WaterIntakeScreen> createState() => _WaterIntakeScreenState();
}

class _WaterIntakeScreenState extends ConsumerState<WaterIntakeScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveAnimationController;
  late AnimationController _fillAnimationController;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _waveAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _fillAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // 2. Use widget.userWeightKg to read the provider's initial state
    final waterState = ref.read(waterIntakeProvider(widget.userWeightKg));
    _fillAnimation = Tween<double>(
      begin: 0.0,
      end: waterState.progressPercentage,
    ).animate(
      CurvedAnimation(
        parent: _fillAnimationController,
        curve: Curves.easeOut,
      ),
    );
    _fillAnimationController.forward();
  }

  @override
  void dispose() {
    _waveAnimationController.dispose();
    _fillAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 3. Use widget.userWeightKg to watch the correct provider instance
    final waterState = ref.watch(waterIntakeProvider(widget.userWeightKg));

    // 4. Use widget.userWeightKg to listen to the correct provider instance
    ref.listen<WaterIntakeState>(waterIntakeProvider(widget.userWeightKg),
        (previous, next) {
      if (previous?.progressPercentage != next.progressPercentage) {
        _fillAnimation = Tween<double>(
          begin: previous?.progressPercentage ?? 0.0,
          end: next.progressPercentage,
        ).animate(
          CurvedAnimation(
            parent: _fillAnimationController,
            curve: Curves.easeOut,
          ),
        );
        _fillAnimationController
          ..reset()
          ..forward();
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Water Intake'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDailyGoal(theme, waterState),
          const SizedBox(height: 32),
          _buildWaterGlass(waterState),
          const SizedBox(height: 32),
          _buildTodaysLog(theme, waterState),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showWaterIntakeDialog(context),
        label: const Text('Log Water'),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildDailyGoal(ThemeData theme, WaterIntakeState waterState) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Daily Goal', style: theme.textTheme.titleMedium),
                Text.rich(
                  TextSpan(
                    text:
                        '${waterState.currentIntakeLiters.toStringAsFixed(1)}L',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: theme.colorScheme.primary),
                    children: [
                      TextSpan(
                        text:
                            ' / ${waterState.dailyGoalLiters.toStringAsFixed(1)}L',
                        style: theme.textTheme.titleMedium?.copyWith(
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.6)),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: waterState.progressPercentage,
                minHeight: 12,
                backgroundColor: theme.colorScheme.surfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterGlass(WaterIntakeState waterState) {
    return Center(
      child: SizedBox(
        width: 150,
        height: 225,
        child: AnimatedBuilder(
            animation: _fillAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: WaterGlassPainter(
                  waterLevelPercent: _fillAnimation.value,
                  waveAnimation: _waveAnimationController,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(waterState.progressPercentage * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        '${waterState.currentIntakeLiters.toStringAsFixed(1)}L',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _buildTodaysLog(ThemeData theme, WaterIntakeState waterState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Today's Log", style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        if (waterState.logs.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No water logged yet today.'),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: waterState.logs.length,
            itemBuilder: (context, index) {
              final log =
                  waterState.logs[waterState.logs.length - 1 - index];
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    child: Icon(Icons.water_drop_outlined,
                        color: theme.colorScheme.primary),
                  ),
                  title: Text('${log.amount.toStringAsFixed(0)}ml'),
                  trailing: Text(DateFormat.jm().format(log.timestamp)),
                ),
              );
            },
          ),
      ],
    );
  }

  void _showWaterIntakeDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Log Water Intake',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller,
                autofocus: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  suffixText: 'ml',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final amount = double.tryParse(controller.text);
                    if (amount != null && amount > 0) {
                      // 5. Use widget.userWeightKg to read the correct notifier instance
                      ref
                          .read(waterIntakeProvider(widget.userWeightKg)
                              .notifier)
                          .addWaterLog(amount);
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Log Water'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}