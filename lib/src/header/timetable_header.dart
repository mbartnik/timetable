import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';

import '../controller.dart';
import '../event.dart';
import '../theme.dart';
import '../timetable.dart';
import 'all_day_events.dart';
import 'multi_date_header.dart';
import 'week_indicator.dart';

class TimetableHeader<E extends Event> extends StatelessWidget {
  const TimetableHeader({
    Key key,
    @required this.controller,
    @required this.allDayEventBuilder,
    this.onCreateAllDayEvent,
  })  : assert(controller != null),
        assert(allDayEventBuilder != null),
        super(key: key);

  final TimetableController<E> controller;
  final AllDayEventBuilder<E> allDayEventBuilder;
  final OnCreateEventCallback onCreateAllDayEvent;

  @override
  Widget build(BuildContext context) {
    // Like [WeekYearRules.iso], but with a variable first day of week.
    final weekYearRule =
        WeekYearRules.forMinDaysInFirstWeek(4, controller.firstDayOfWeek);

    return Row(
      children: <Widget>[
        SizedBox(
          width: hourColumnWidth,
          child: Center(
            child: ValueListenableBuilder<LocalDate>(
              valueListenable: controller.dateListenable,
              builder: (context, date, _) =>
                  WeekIndicator(weekYearRule.getWeekOfWeekYear(date)),
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: context.timetableTheme?.totalDateIndicatorHeight ?? 72,
                child: MultiDateHeader(controller: controller),
              ),
              AllDayEvents<E>(
                controller: controller,
                onCreateAllDayEvent: onCreateAllDayEvent,
                allDayEventBuilder: allDayEventBuilder,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
