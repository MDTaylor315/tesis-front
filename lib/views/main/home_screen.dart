// Clase de modelo para los datos de los gráficos
import 'package:adipix/theme/app_theme.dart';
import 'package:adipix/widgets/dropdown_menu_button.dart';
import 'package:adipix/widgets/streak_week.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MetricData {
  MetricData(this.month, this.value);
  final String month;
  final double value;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rotatedIcon = Transform.rotate(
      angle: 45 * 3.1415926535 / 180, // Convertir 45 grados a radianes
      child: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
    );
    return Scaffold(
      body: SafeArea(
        // Usamos ListView para que toda la pantalla sea deslizable
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 20),
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildStreakPill(),
            const SizedBox(height: 24),
            WeeklyStreakWidget(
              days: WeeklyStreakHelper.createWeek(
                mondayCompleted: true,
                tuesdayCompleted: true,
                wednesdayCompleted: true,
              ),
            ),
            const SizedBox(height: 20),
            _buildPlanButton(context),
            const SizedBox(height: 30),
            _buildMetricChart(
              context,
              title: 'Peso',
              data: _getWeightData(),
              currentValue: 120.0,
              yAxisLabel: 'kg',
            ),
            const SizedBox(height: 30),
            _buildMetricChart(
              context,
              title: 'Grasa corporal',
              data: _getFatData(),
              currentValue: 40.0,
              yAxisLabel: '% kg',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ============== HEADER (CABECERA) ==============
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fecha actual
        Text(
          '18 de Octubre, 2025',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        // Saludo
        Text(
          'Hola Nick 👋',
          style: AppTheme.lightTheme.textTheme.headlineLarge,
        ),
        const SizedBox(height: 4),
        // Mensaje de ánimo
        const Text(
          '¡Que tengas un gran día!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ============== PILL DE RACHA (STREAK PILL) ==============
  Widget _buildStreakPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        // Degradado horizontal: empieza a la izquierda, termina a la derecha
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppTheme.darkOrange,
            AppTheme.lightOrange,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFC06918), // Color blanco para el borde
          width: 1.5, // Grosor del borde
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondaryColor.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SUSTITUCIÓN: Usamos un Icono de Flutter ya que no se tiene acceso al SVG.
          SvgPicture.asset(
            'assets/icons/fire.svg',
            width: 24,
            color: Colors.white,
          ),

          SizedBox(width: 8),
          Text(
            'No pierdas tu racha semanal.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // ============== RACHA SEMANAL ==============

  InputDecoration _inputDecoration(String hint, {bool showCalendar = false}) =>
      InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Color(0xFF9AAEBF)),
          suffixIcon: showCalendar
              ? const Icon(Icons.calendar_month_rounded,
                  size: 18, color: AppTheme.primaryColor)
              : null,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.unselected)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.unselected)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: AppTheme.primaryColor, width: 2)));

  // ============== BOTÓN DE PLAN PERSONALIZADO ==============
  Widget _buildPlanButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Acción para ir al plan
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Revisando plan personalizado...')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Revisar plan personalizado',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ============== FUNCIÓN PARA MOSTRAR EL DIÁLOGO DE FILTRO (LÓGICA IMPLEMENTADA) ==============
  void _showFilterDialog(BuildContext context, String metricType) {
    // La función _inputDecoration ahora es un método de la clase HomeScreen y se llama directamente.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          content: SingleChildScrollView(
            // ⭐ Usamos el nuevo FilterForm (StatefulWidget) para manejar el estado
            child: FilterForm(
              metricType: metricType,
              inputDecoration: _inputDecoration,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        );
      },
    );
  }

  // ============== GRÁFICO DE MÉTRICAS (SfCartesianChart) ==============
  Widget _buildMetricChart(
    BuildContext context, {
    required String title,
    required List<MetricData> data,
    required double currentValue,
    required String yAxisLabel,
  }) {
    // Obtener los valores mínimo y máximo para el eje Y
    final double minValue =
        data.map((d) => d.value).reduce((a, b) => a < b ? a : b);
    final double maxValue =
        data.map((d) => d.value).reduce((a, b) => a > b ? a : b);

    // Usar un rango extendido para que los puntos no toquen el borde
    final double yMin = minValue - 5;
    final double yMax = maxValue + 5;

    // Generar PlotBands para sombrear todos los meses con ancho reducido (para espaciado)
    final List<PlotBand> shadeBands = [];
    final shadeColor = Colors.grey[100]!;

    for (int i = 0; i < data.length; i++) {
      // Sombreado en el eje X para cada punto
      shadeBands.add(
        PlotBand(
          isVisible: true,
          start: i - 0.4,
          end: i + 0.4,
          color: shadeColor,
        ),
      );
    }

    // LÍNEA DE REFERENCIA HORIZONTAL (en el Eje Y)
    final List<PlotBand> horizontalLine = [
      PlotBand(
        isVisible: true,
        start: currentValue,
        end: currentValue,
        borderColor: AppTheme.secondaryColor.withOpacity(0.8),
        borderWidth: 2,
        dashArray: const <double>[5, 5],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Métricas visuales",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            // Botón de filtro que activa el diálogo
            OutlinedButton.icon(
              onPressed: () {
                _showFilterDialog(context, title); // Llama al diálogo correcto
              },
              icon: const Icon(Icons.tune,
                  size: 18, color: AppTheme.primaryColor),
              label: const Text(
                'Filtrar por',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.greyBorder, width: 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 200,
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            margin: const EdgeInsets.only(top: 20, right: 10, left: 10),

            // Reemplazar tooltip con trackball para mejor interactividad
            trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              lineType: TrackballLineType.vertical,
              lineColor: AppTheme.primaryColor.withOpacity(0.3),
              lineWidth: 2,
              tooltipSettings: InteractiveTooltip(
                enable: true,
                color: AppTheme.primaryColor,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                format: 'point.y $yAxisLabel',
                borderRadius: 8,
              ),
              markerSettings: const TrackballMarkerSettings(
                markerVisibility: TrackballVisibilityMode.visible,
                height: 14,
                width: 14,
                color: Colors.white,
                borderWidth: 3,
                borderColor: AppTheme.primaryColor,
              ),
            ),

            axes: const <ChartAxis>[],
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              axisLine: const AxisLine(width: 0),
              labelStyle: TextStyle(
                  color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              majorTickLines: const MajorTickLines(width: 0),
              plotBands: shadeBands,
            ),
            primaryYAxis: NumericAxis(
              isVisible: false,
              minimum: yMin,
              maximum: yMax,
              plotBands: horizontalLine,
            ),
            series: <CartesianSeries<MetricData, String>>[
              LineSeries<MetricData, String>(
                dataSource: data,
                xValueMapper: (MetricData metric, _) => metric.month,
                yValueMapper: (MetricData metric, _) => metric.value,
                color: AppTheme.primaryColor,
                width: 3,
                markerSettings: const MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  height: 12,
                  width: 12,
                  color: AppTheme.primaryColor,
                  borderColor: Colors.white,
                  borderWidth: 3,
                ),
                // Remover dataLabelSettings para no tener punto seleccionado por defecto
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============== DATOS SIMULADOS ==============

  List<MetricData> _getWeightData() {
    return [
      MetricData('JUL', 115),
      MetricData('AGO', 116),
      MetricData('SET', 118),
      MetricData('OCT', 120), // Valor actual
      MetricData('NOV', 121),
      MetricData('DIC', 122),
    ];
  }

  List<MetricData> _getFatData() {
    return [
      MetricData('JUL', 42),
      MetricData('AGO', 41),
      MetricData('SET', 40.5),
      MetricData('OCT', 40), // Valor actual
      MetricData('NOV', 39),
      MetricData('DIC', 38.5),
    ];
  }
}

typedef InputDecorationCallback = InputDecoration Function(String,
    {bool showCalendar});

class FilterForm extends StatefulWidget {
  final String metricType;
  final InputDecorationCallback inputDecoration;

  const FilterForm({
    super.key,
    required this.metricType,
    required this.inputDecoration,
  });

  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  // Estado para el Checkbox
  bool _isFilterApplied = true;

  // Estado para las Fechas
  DateTime? _startDate;
  DateTime? _endDate;

  // Helper para formatear la fecha a 'dd-mm-aa'
  String _formatDate(DateTime? date) {
    if (date == null) return 'dd-mm-aa';
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  // Función para mostrar el DatePicker
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('es', 'ES'), // Establecer el idioma a español
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor, // Color de fondo del encabezado
              onPrimary: Colors.white, // Color del texto del encabezado
              onSurface: AppTheme
                  .primaryColor, // Color de los elementos del calendario
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isBodyFat = widget.metricType.toLowerCase().contains('grasa');
    String filterTitle;
    Widget content;

    // Lógica para determinar el contenido del filtro
    if (isBodyFat) {
      // FILTRO PARA GRASA CORPORAL (Incluye Unidad de Medida)
      filterTitle = 'Aplicar filtros a % de grasa corporal.';
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // UNIDAD DE MEDIDA
          const Text('Unidad de Medida',
              style: TextStyle(fontWeight: FontWeight.bold)),
          RotatedDropdown<String>(
              decoration: widget.inputDecoration('Selecciona unidad'),
              items: const [
                DropdownMenuItem(value: 'kg', child: Text('Kilogramos (kg)')),
                DropdownMenuItem(value: 'lbs', child: Text('Libras (lbs)')),
              ],
              onChanged: (val) {},
              hint: 'kg o lbs'),
          const SizedBox(height: 20),

          // PERÍODO
          const Text('Período', style: TextStyle(fontWeight: FontWeight.bold)),
          RotatedDropdown<String>(
              decoration: widget.inputDecoration('Selecciona período'),
              items: const [
                DropdownMenuItem(value: 'semanal', child: Text('Semanal')),
                DropdownMenuItem(value: 'mensual', child: Text('Mensual')),
                DropdownMenuItem(value: 'anual', child: Text('Anual')),
              ],
              onChanged: (val) {},
              hint: 'Semanal, mensual, anual'),
          const SizedBox(height: 20),

          // FECHA INICIO / FIN (Start Date & End Date)
          Row(
            children: [
              // FECHA INICIO (Start Date) - Implementación del Date Picker
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context, true),
                  child: IgnorePointer(
                    child: TextField(
                        decoration: widget.inputDecoration(
                            _formatDate(_startDate),
                            showCalendar: true)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // FECHA FIN (End Date) - Implementación del Date Picker
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context, false),
                  child: IgnorePointer(
                    child: TextField(
                        decoration: widget.inputDecoration(
                            _formatDate(_endDate),
                            showCalendar: true)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // CHECKBOX - Implementación de cambio de estado
          Row(
            children: [
              Checkbox(
                  value: _isFilterApplied,
                  onChanged: (bool? val) {
                    setState(() {
                      _isFilterApplied = val ?? false;
                    });
                  },
                  activeColor: AppTheme.primaryColor),
              Text(filterTitle, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ],
      );
    } else {
      // metricType == 'Peso'
      // FILTRO PARA PESO (NO incluye Unidad de Medida)
      filterTitle = 'Aplicar filtros a peso.';
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PERÍODO
          const Text('Período', style: TextStyle(fontWeight: FontWeight.bold)),
          RotatedDropdown<String>(
              decoration: widget.inputDecoration('Selecciona período'),
              items: const [
                DropdownMenuItem(value: 'semanal', child: Text('Semanal')),
                DropdownMenuItem(value: 'mensual', child: Text('Mensual')),
                DropdownMenuItem(value: 'anual', child: Text('Anual')),
              ],
              onChanged: (val) {},
              hint: 'Semanal, mensual, anual'),
          const SizedBox(height: 20),

          // FECHA INICIO / FIN (Start Date & End Date)
          Row(
            children: [
              // FECHA INICIO (Start Date) - Implementación del Date Picker
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context, true),
                  child: IgnorePointer(
                    child: TextField(
                        decoration: widget.inputDecoration(
                            _formatDate(_startDate),
                            showCalendar: true)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // FECHA FIN (End Date) - Implementación del Date Picker
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context, false),
                  child: IgnorePointer(
                    child: TextField(
                        decoration: widget.inputDecoration(
                            _formatDate(_endDate),
                            showCalendar: true)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // CHECKBOX - Implementación de cambio de estado
          Row(
            children: [
              Checkbox(
                value: _isFilterApplied,
                onChanged: (bool? val) {
                  setState(() {
                    _isFilterApplied = val ?? false;
                  });
                },
                activeColor: AppTheme.primaryColor,
                shape: CircleBorder(),
              ),
              Text(filterTitle, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ],
      );
    }

    // Estructura final del diálogo (cabeza y botón de filtro)
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personaliza tu vista',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor),
        ),
        const SizedBox(height: 5),
        const Text(
          'Personaliza tu progreso. Tú decides cómo verlo.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        // Contenido dinámico (FilterForm's content)
        content,
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            minimumSize: const Size(double.infinity, 45),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Filtrar',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
