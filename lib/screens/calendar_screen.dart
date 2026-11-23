import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import 'auth_screen.dart';
import 'task_list_screen.dart';

class CalendarScreen extends StatefulWidget {
  final String userName;

  const CalendarScreen({super.key, required this.userName});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDate = DateTime.now();

  // Armazena as tarefas por data no formato 'YYYY-MM-DD'
  final Map<String, List<Task>> _tasksByDate = {};

  final List<String> _monthNames = [
    'JANEIRO', 'FEVEREIRO', 'MARÇO', 'ABRIL', 'MAIO', 'JUNHO',
    'JULHO', 'AGOSTO', 'SETEMBRO', 'OUTUBRO', 'NOVEMBRO', 'DEZEMBRO'
  ];

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  List<Task> _getTasksForDate(DateTime date) {
    final key = _dateKey(date);
    _tasksByDate.putIfAbsent(key, () => []);
    return _tasksByDate[key]!;
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + offset);
    });
  }

  void _openTaskListScreen(DateTime date) async {
    final tasks = _getTasksForDate(date);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskListScreen(
          selectedDate: date,
          tasks: tasks,
        ),
      ),
    );
    // Atualiza os contadores e marcadores do calendário ao retornar
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final selectedTasks = _getTasksForDate(_selectedDate);
    final pendingCount = selectedTasks.where((t) => !t.isCompleted).length;
    final completedCount = selectedTasks.where((t) => t.isCompleted).length;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho com saudação e botão de sair
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OLÁ, ${widget.userName.toUpperCase()} ⚡',
                        style: const TextStyle(
                          color: AppTheme.neonCyan,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Seu Calendário',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const AuthScreen()),
                      );
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.cardDark,
                      padding: const EdgeInsets.all(12),
                    ),
                    icon: const Icon(Icons.logout_rounded, color: AppTheme.neonPink),
                    tooltip: 'Sair',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Seletor de Mês com Gradiente
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: AppTheme.mainGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.neonPink.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => _changeMonth(-1),
                      icon: const Icon(Icons.chevron_left_rounded,
                          color: Colors.white, size: 30),
                    ),
                    Text(
                      '${_monthNames[_focusedMonth.month - 1]} ${_focusedMonth.year}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _changeMonth(1),
                      icon: const Icon(Icons.chevron_right_rounded,
                          color: Colors.white, size: 30),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Cabeçalho dos dias da semana
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['DOM', 'SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB']
                    .map((day) => Text(
                          day,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),

              // Grade do Calendário
              Expanded(
                child: _buildCalendarGrid(),
              ),

              // Cartão Resumo do Dia Selecionado
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppTheme.neonCyan.withOpacity(0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.neonCyan.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.calendar_today_rounded,
                                color: AppTheme.neonCyan,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DIA ${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  selectedTasks.isEmpty
                                      ? 'Nenhuma tarefa registrada'
                                      : '$pendingCount pendente(s) • $completedCount concluída(s)',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _openTaskListScreen(_selectedDate),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.neonCyan,
                          foregroundColor: AppTheme.bgDark,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(Icons.list_alt_rounded),
                        label: const Text(
                          'GERENCIAR TAREFAS DO DIA',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth =
        DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final firstWeekday = firstDayOfMonth.weekday % 7; // 0 = Domingo ... 6 = Sábado

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: daysInMonth + firstWeekday,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        if (index < firstWeekday) {
          return const SizedBox.shrink();
        }

        final dayNumber = index - firstWeekday + 1;
        final currentDate =
            DateTime(_focusedMonth.year, _focusedMonth.month, dayNumber);
        final isSelected = DateUtils.isSameDay(currentDate, _selectedDate);
        final isToday = DateUtils.isSameDay(currentDate, DateTime.now());

        final dayTasks = _tasksByDate[_dateKey(currentDate)] ?? [];
        final hasTasks = dayTasks.isNotEmpty;
        final hasPending = dayTasks.any((t) => !t.isCompleted);

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = currentDate;
            });
          },
          onDoubleTap: () => _openTaskListScreen(currentDate),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: isSelected ? AppTheme.cyanGradient : null,
              color: isSelected ? null : AppTheme.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: isToday && !isSelected
                  ? Border.all(color: AppTheme.neonPink, width: 2)
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppTheme.neonCyan.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$dayNumber',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: isSelected ? AppTheme.bgDark : Colors.white,
                  ),
                ),
                if (hasTasks) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppTheme.bgDark
                          : (hasPending
                              ? AppTheme.electricYellow
                              : AppTheme.neonCyan),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}