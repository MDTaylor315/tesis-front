import 'package:adipix/views/main/observations_dialog.dart';
import 'package:adipix/widgets/streak_week.dart';
import 'package:flutter/material.dart';

class StreakScreen extends StatefulWidget {
  @override
  _StreakScreenState createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  // Variables para controlar el plan seleccionado y días activos
  bool isNutritionalPlan = true;
  Color undone = Color(0xFFDDE4EB);

  // Días: true si está seleccionado
  Map<String, bool> selectedDays = {
    'Lun': true,
    'Mar': true,
    'Mie': true,
    'Jue': false,
    'Vie': false,
    'Sáb': false,
    'Dom': false,
  };

  // Ejercicios para plan deportivo (ejemplo)
  final Map<String, List<Map<String, dynamic>>> ejerciciosPlanDeportivo = {
    'Fuerza': [
      {'name': 'Sentadilla libre', 'series': 4, 'reps': 10, 'selected': true},
      {'name': 'Sentadilla hack', 'series': 4, 'reps': 8, 'selected': false},
      {'name': 'Prensa', 'series': 4, 'reps': 12, 'selected': false},
      {'name': 'Hip thrust', 'series': 4, 'reps': 12, 'selected': false},
      {
        'name': 'Elevación de pantorrillas',
        'series': 4,
        'reps': 10,
        'selected': false
      },
    ],
    'Cardio': [
      {'name': 'Correr en cinta', 'time': 15, 'selected': true},
      {'name': 'Caminar', 'time': 20, 'selected': false},
    ],
  };

  // Datos para plan nutricional (ejemplo, para simular que cambia contenido)
  final Map<String, List<Map<String, dynamic>>> nutricionDelDia = {
    'Desayuno': [
      {
        'nombre': 'Pan integral',
        'cantidad': '2 rebanadas',
        'kcal': 200,
        'proteinas': 8,
        'grasas': 4,
        'carbohidratos': 36,
        'seleccionado': true,
      },
      {
        'nombre': 'Huevo revuelto',
        'cantidad': '150 gramos',
        'kcal': 210,
        'proteinas': 18,
        'grasas': 15,
        'carbohidratos': 2,
        'seleccionado': true,
      },
    ],
    'Almuerzo': [
      {
        'nombre': 'Pollo a la plancha',
        'cantidad': '300 gramos',
        'kcal': 200,
        'proteinas': 8,
        'grasas': 4,
        'carbohidratos': 36,
        'seleccionado': true,
      },
      {
        'nombre': 'Cereales',
        'cantidad': '150 gramos',
        'kcal': 210,
        'proteinas': 18,
        'grasas': 15,
        'carbohidratos': 2,
        'seleccionado': true,
      },
    ],
    'Cena': [
      {
        'nombre': 'Espinaca salteada',
        'cantidad': '300 gramos',
        'kcal': 200,
        'proteinas': 8,
        'grasas': 4,
        'carbohidratos': 36,
        'seleccionado': true,
      }
    ],
    'Snack': [
      {
        'nombre': 'Galleta de agua',
        'cantidad': '300 gramos',
        'kcal': 200,
        'proteinas': 8,
        'grasas': 4,
        'carbohidratos': 36,
        'seleccionado': true,
      }
    ],
  };

  @override
  Widget build(BuildContext context) {
    int daysSelected = selectedDays.values.where((v) => v).length;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selector de planes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPlanTab('Plan nutricional', isNutritionalPlan),
                _buildPlanTab('Plan deportivo', !isNutritionalPlan),
              ],
            ),

            SizedBox(height: 24),
            WeeklyStreakWidget(
              days: WeeklyStreakHelper.createWeek(
                mondayCompleted: true,
                tuesdayCompleted: true,
                wednesdayCompleted: true,
              ),
            ),

            SizedBox(height: 24),

            // Contenido que depende del plan seleccionado
            Expanded(
              child: isNutritionalPlan
                  ? _buildNutricionDelDia()
                  : _buildDeportivePlan(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanTab(String text, bool selected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isNutritionalPlan = text == 'Plan nutricional';
          });
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: selected ? Color(0xFFF2F6FA) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? Color(0xFFF2F6FA) : Color(0xFFE0E6F0),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Color(0xFF0B2E56),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutricionDelDia() {
    return ListView(
      children: [
        Text(
          'Nutrición del día',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xFF0B2E56),
          ),
        ),
        SizedBox(height: 16),
        ...nutricionDelDia.entries.map((entry) {
          String comida = entry.key;
          List<Map<String, dynamic>> alimentos = entry.value;

          return Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF2F6FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Etiqueta comida
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFD7E0F3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    comida,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0B2E56),
                    ),
                  ),
                ),
                SizedBox(height: 12),

                // Alimentos
                ...alimentos.map((alimento) {
                  bool seleccionado = alimento['seleccionado'];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alimento['nombre'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0B2E56),
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.kitchen,
                                    size: 16,
                                    color: Color(0xFF8B98B4),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    alimento['cantidad'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF8B98B4),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoNutricional(
                                  '${alimento['kcal']}', 'Kcal'),
                              _buildInfoNutricional(
                                  '${alimento['proteinas']}', 'Prot.'),
                              _buildInfoNutricional(
                                  '${alimento['grasas']}', 'Grasas'),
                              _buildInfoNutricional(
                                  '${alimento['carbohidratos']}', 'Carb.'),
                            ],
                          ),
                        ),

                        SizedBox(width: 8),

                        // Check derecho
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: seleccionado
                                ? Color(0xFF093C7E)
                                : Colors.transparent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.check,
                              size: 20,
                              color: seleccionado
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        }).toList(),

        // Botón agregado al final
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Aquí puedes agregar la acción que deseas ejecutar al presionar el botón
            showPlanObservationsDialog(context); // ← Aquí
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF093C7E), // Color azul oscuro
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Cambiar nutrición del día',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(height: 20), // Espacio debajo del botón
      ],
    );
  }

  Widget _buildInfoNutricional(String valor, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          valor,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B2E56),
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF8B98B4),
          ),
        ),
      ],
    );
  }

  Widget _buildDeportivePlan() {
    return ListView(
      children: [
        Text(
          'Ejercicios del día',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF0B2E56),
          ),
        ),
        SizedBox(height: 12),
        ...ejerciciosPlanDeportivo.entries.map(
          (entry) {
            String category = entry.key;
            List<Map<String, dynamic>> ejercicios = entry.value;
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFF2F6FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5C6C7B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  ...ejercicios.map((ejercicio) {
                    bool selected = ejercicio['selected'];
                    String subtitle = '';
                    if (category == 'Fuerza') {
                      subtitle =
                          '${ejercicio['series']} series x ${ejercicio['reps']} repeticiones';
                    } else if (category == 'Cardio') {
                      subtitle = '${ejercicio['time']} minutos';
                    }
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Cambiar solo el ejercicio clickeado (selector único por categoría)
                          // Aquí asumimos que solo 1 ejercicio puede estar seleccionado por categoría
                          for (var e in ejercicios) {
                            e['selected'] = false;
                          }
                          ejercicio['selected'] = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ejercicio['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0B2E56),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.fitness_center,
                                        size: 14,
                                        color:
                                            Color(0xFF8B98B4).withOpacity(0.7),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        subtitle,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8B98B4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selected ? Color(0xFF093C7E) : undone,
                                  width: 1.5,
                                ),
                                color: selected ? Color(0xFF093C7E) : undone,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ).toList(),
      ],
    );
  }
}
