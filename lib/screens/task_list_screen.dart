import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/add_task_dialog.dart';

class TaskListScreen extends StatefulWidget {
  final DateTime selectedDate;
  final List<Task> tasks;

  const TaskListScreen({
    super.key,
    required this.selectedDate,
    required this.tasks,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Ordena a lista:
  // 1º Pendentes (isCompleted == false) antes de Concluídas (isCompleted == true)
  // 2º Ordem alfabética (A-Z) ignorando maiúsculas/minúsculas
  void _sortTasks() {
    widget.tasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
  }

  void _addTask(String title) {
    setState(() {
      widget.tasks.add(
        Task(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: title,
          isCompleted: false, // Padrão: não concluída
        ),
      );
      _sortTasks();
    });
  }

  void _toggleTaskStatus(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
      _sortTasks();
    });
  }

  void _removeTask(Task task) {
    setState(() {
      widget.tasks.removeWhere((t) => t.id == task.id);
      _sortTasks();
    });
  }

  Future<void> _showAddDialog() async {
    final newTaskTitle = await showDialog<String>(
      context: context,
      builder: (_) => const AddTaskDialog(),
    );

    if (newTaskTitle != null && newTaskTitle.trim().isNotEmpty) {
      _addTask(newTaskTitle.trim());
    }
  }

  @override
  void initState() {
    super.initState();
    _sortTasks();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted =
        '${widget.selectedDate.day.toString().padLeft(2, '0')}/${widget.selectedDate.month.toString().padLeft(2, '0')}/${widget.selectedDate.year}';

    final pendingCount = widget.tasks.where((t) => !t.isCompleted).length;
    final completedCount = widget.tasks.where((t) => t.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppTheme.neonCyan),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TAREFAS DO DIA',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.5,
                color: AppTheme.neonPink,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              dateFormatted,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // Painel de Estatísticas Rápidas
            Row(
              children: [
                Expanded(
                  child: _buildCounterCard(
                    label: 'PENDENTES',
                    count: pendingCount,
                    color: AppTheme.electricYellow,
                    icon: Icons.pending_actions_rounded,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildCounterCard(
                    label: 'CONCLUÍDAS',
                    count: completedCount,
                    color: AppTheme.neonCyan,
                    icon: Icons.task_alt_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Lista de Tarefas
            Expanded(
              child: widget.tasks.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: widget.tasks.length,
                      itemBuilder: (context, index) {
                        final task = widget.tasks[index];
                        return _buildTaskCard(task);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        backgroundColor: AppTheme.neonPink,
        foregroundColor: Colors.white,
        elevation: 10,
        icon: const Icon(Icons.add_rounded, size: 26),
        label: const Text(
          'NOVA TAREFA',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildCounterCard({
    required String label,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    final bool completed = task.isCompleted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: completed
            ? AppTheme.cardDark.withOpacity(0.45)
            : AppTheme.cardDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: completed
              ? Colors.white12
              : AppTheme.neonPink.withOpacity(0.6),
          width: 1.5,
        ),
        boxShadow: completed
            ? []
            : [
                BoxShadow(
                  color: AppTheme.neonPink.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          // Botão Customizado para Marcar/Desmarcar Concluída
          GestureDetector(
            onTap: () => _toggleTaskStatus(task),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: completed ? AppTheme.cyanGradient : null,
                border: completed
                    ? null
                    : Border.all(color: AppTheme.electricYellow, width: 2.5),
              ),
              child: completed
                  ? const Icon(Icons.check_rounded,
                      size: 20, color: AppTheme.bgDark)
                  : null,
            ),
          ),
          const SizedBox(width: 16),

          // Título e Status da Tarefa
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: completed ? Colors.white38 : Colors.white,
                    decoration: completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: completed
                        ? AppTheme.neonCyan.withOpacity(0.15)
                        : AppTheme.electricYellow.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    completed ? 'CONCLUÍDA' : 'PENDENTE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                      color: completed
                          ? AppTheme.neonCyan
                          : AppTheme.electricYellow,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Botão para Remover Tarefa
          IconButton(
            onPressed: () => _removeTask(task),
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppTheme.neonPink,
            ),
            tooltip: 'Remover tarefa',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.cardDark,
              border: Border.all(color: Colors.white10, width: 2),
            ),
            child: const Icon(
              Icons.rocket_launch_rounded,
              size: 56,
              color: AppTheme.neonCyan,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Dia livre por enquanto!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Toque em "NOVA TAREFA" para planejar seu dia.',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}