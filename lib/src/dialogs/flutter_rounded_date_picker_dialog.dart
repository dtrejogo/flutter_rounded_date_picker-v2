import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_rounded_date_picker/src/flutter_rounded_button_action.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_date_picker_style.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_year_picker_style.dart';
import 'package:flutter_rounded_date_picker/src/widgets/flutter_rounded_date_picker_header.dart';
import 'package:flutter_rounded_date_picker/src/widgets/flutter_rounded_day_picker.dart';
import 'package:flutter_rounded_date_picker/src/widgets/flutter_rounded_month_picker.dart';
import 'package:flutter_rounded_date_picker/src/widgets/flutter_rounded_year_picker.dart';

class FlutterRoundedDatePickerDialog extends StatefulWidget {
  const FlutterRoundedDatePickerDialog(
      {Key? key,
      this.height,
      required this.initialDate,
      required this.firstDate,
      required this.lastDate,
      this.selectableDayPredicate,
      required this.initialDatePickerMode,
      required this.era,
      this.locale,
      required this.borderRadius,
      this.imageHeader,
      this.description = "",
      this.fontFamily,
      this.textNegativeButton,
      this.textPositiveButton,
      this.textActionButton,
      this.onTapActionButton,
      this.styleDatePicker,
      this.styleYearPicker,
      this.customWeekDays,
      this.builderDay,
      this.listDateDisabled,
      this.onTapDay,
      this.onTapButtonPositive,
      this.onTapButtonNegative,
      this.isFirstTime = false})
      : super(key: key);

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final SelectableDayPredicate? selectableDayPredicate;
  final DatePickerMode initialDatePickerMode;

  /// double height.
  final double? height;

  /// Custom era year.
  final EraMode era;
  final Locale? locale;

  /// Border
  final double borderRadius;

  ///  Header;
  final ImageProvider? imageHeader;
  final String description;

  /// Font
  final String? fontFamily;

  /// Button
  final String? textNegativeButton;
  final String? textPositiveButton;
  final String? textActionButton;

  final VoidCallback? onTapActionButton;

  /// Style
  final MaterialRoundedDatePickerStyle? styleDatePicker;
  final MaterialRoundedYearPickerStyle? styleYearPicker;

  /// Custom Weekday
  final List<String>? customWeekDays;

  final BuilderDayOfDatePicker? builderDay;

  final List<DateTime>? listDateDisabled;
  final OnTapDay? onTapDay;

  final VoidCallback? onTapButtonNegative;
  final VoidCallback? onTapButtonPositive;

  final bool isFirstTime;

  @override
  FlutterRoundedDatePickerDialogState createState() =>
      FlutterRoundedDatePickerDialogState();
}

class FlutterRoundedDatePickerDialogState
    extends State<FlutterRoundedDatePickerDialog> {
  bool _cancelClicked = false;
  double calendarOpacity = 1;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _mode = widget.initialDatePickerMode;

    if (widget.isFirstTime) {
      calendarOpacity = 0.3;
    }
  }

  bool _announcedInitialDate = false;

  late MaterialLocalizations localizations;
  late TextDirection textDirection;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = MaterialLocalizations.of(context);
    textDirection = Directionality.of(context);
    if (!_announcedInitialDate) {
      _announcedInitialDate = true;
      SemanticsService.announce(
        localizations.formatFullDate(_selectedDate),
        textDirection,
      );
    }
  }

  late DateTime _selectedDate;
  late DatePickerMode _mode;
  final GlobalKey _pickerKey = GlobalKey();
  final GlobalKey<FlutterRoundedMonthPickerState> _monthPicker =
      GlobalKey<FlutterRoundedMonthPickerState>();

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        HapticFeedback.vibrate();
        break;
      case TargetPlatform.iOS:
      default:
        break;
    }
  }

  void _handleModeChanged(DatePickerMode mode) {
    _vibrate();
    setState(() {
      _mode = mode;
      calendarOpacity = 1;
      if (_mode == DatePickerMode.day) {
        SemanticsService.announce(
          localizations.formatMonthYear(_selectedDate),
          textDirection,
        );
      } else {
        SemanticsService.announce(
          localizations.formatYear(_selectedDate),
          textDirection,
        );
      }
    });
  }

  void _handleYearChanged(DateTime value) {
    //colocar julio por default cuando cambia de año.
    value = DateTime(value.year, DateTime.july, value.day);

    if (value.isBefore(widget.firstDate)) {
      value = widget.firstDate;
    } else if (value.isAfter(widget.lastDate)) {
      value = widget.lastDate;
    }
    //if (value == _selectedDate) return;

    _vibrate();
    setState(() {
      _mode = DatePickerMode.day;
      _selectedDate = value;
    });

    Future.delayed(Duration(milliseconds: 300), () {
      _monthPicker.currentState?.startAnimation();
    });
  }

  void _handleDayChanged(DateTime value) {
    _vibrate();
    setState(() {
      _selectedDate = value;
    });
  }

  void _handleCancel() {
    //Navigator.of(context).pop();
    _cancelClicked = true;
    if (widget.onTapButtonNegative != null) {
      widget.onTapButtonNegative!();
    }
  }

  void _handleOk() {
    //Navigator.of(context).pop(_selectedDate);
    if (widget.onTapButtonPositive != null) {
      widget.onTapButtonPositive!();
    }
  }

  bool cancelClicked() => _cancelClicked;

  DateTime getSelectedDate() {
    return _selectedDate;
  }

  Widget _buildPicker() {
    switch (_mode) {
      case DatePickerMode.year:
        return FlutterRoundedYearPicker(
          key: _pickerKey,
          selectedDate: _selectedDate,
          onChanged: _handleYearChanged,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          era: widget.era,
          fontFamily: widget.fontFamily,
          style: widget.styleYearPicker,
        );
      case DatePickerMode.day:
      default:
        return FlutterRoundedMonthPicker(
          key: _monthPicker,
          selectedDate: _selectedDate,
          onChanged: _handleDayChanged,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          era: widget.era,
          locale: widget.locale,
          selectableDayPredicate: widget.selectableDayPredicate,
          fontFamily: widget.fontFamily,
          style: widget.styleDatePicker,
          borderRadius: widget.borderRadius,
          customWeekDays: widget.customWeekDays,
          builderDay: widget.builderDay,
          listDateDisabled: widget.listDateDisabled,
          onTapDay: widget.onTapDay,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Widget picker = _buildPicker();

    final Widget actions = FlutterRoundedButtonAction(
      textButtonNegative: widget.textNegativeButton,
      textButtonPositive: widget.textPositiveButton,
      onTapButtonNegative: _handleCancel,
      onTapButtonPositive: _handleOk,
      textActionButton: widget.textActionButton,
      onTapButtonAction: widget.onTapActionButton,
      localizations: localizations,
      textStyleButtonNegative: widget.styleDatePicker?.textStyleButtonNegative,
      textStyleButtonPositive: widget.styleDatePicker?.textStyleButtonPositive,
      textStyleButtonAction: widget.styleDatePicker?.textStyleButtonAction,
      borderRadius: widget.borderRadius,
      paddingActionBar: widget.styleDatePicker?.paddingActionBar,
      background: widget.styleDatePicker?.backgroundActionBar,
    );

    Color backgroundPicker = theme.dialogBackgroundColor;
    if (_mode == DatePickerMode.day) {
      backgroundPicker = widget.styleDatePicker?.backgroundPicker ??
          theme.dialogBackgroundColor;
    } else {
      backgroundPicker = widget.styleYearPicker?.backgroundPicker ??
          theme.dialogBackgroundColor;
    }

    final Dialog dialog = Dialog(
      alignment: Alignment.topCenter,
      insetPadding: EdgeInsets.all(0),
      child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
        final Widget header = FlutterRoundedDatePickerHeader(
          selectedDate: _selectedDate,
          mode: _mode,
          onModeChanged: _handleModeChanged,
          orientation: orientation,
          era: widget.era,
          borderRadius: widget.borderRadius,
          imageHeader: widget.imageHeader,
          description: widget.description,
          fontFamily: widget.fontFamily,
          style: widget.styleDatePicker,
          isFirstTime: widget.isFirstTime,
        );
        switch (orientation) {
          case Orientation.landscape:
            return Container(
              decoration: BoxDecoration(
                color: backgroundPicker,
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(flex: 1, child: header),
                  Flexible(
                    flex: 2, // have the picker take up 2/3 of the dialog width
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Flexible(child: picker),
                        actions,
                      ],
                    ),
                  ),
                ],
              ),
            );
          case Orientation.portrait:
          default:
            return Container(
              decoration: BoxDecoration(
                color: backgroundPicker,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(widget.borderRadius),
                    bottomRight: Radius.circular(widget.borderRadius)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    header,
                    if (widget.height == null)
                      Flexible(child: picker)
                    else
                      Opacity(
                        opacity: calendarOpacity,
                        child: SizedBox(
                          height: widget.height,
                          child: picker,
                        ),
                      ),
                    actions,
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            );
        }
      }),
    );

    return Theme(
      data: theme.copyWith(dialogBackgroundColor: Colors.transparent),
      child: dialog,
    );
  }
}
