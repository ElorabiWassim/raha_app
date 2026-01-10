import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ra7a/logic/cubits/demands/demands_cubit.dart';
import 'package:ra7a/data/models/demand_model.dart';

import '../helpers/fake_http_overrides.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DemandsCubit (Unit)', () {
    late FakeHttpOverrides overrides;

    setUp(() {
      SharedPreferences.setMockInitialValues({'user_id': 'homeowner_1'});

      final fakeResponseBody = jsonEncode([
        {
          'demand_id': 'd1',
          'title': 'Fix sink',
          'description': 'Kitchen sink is leaking',
          'location': 'Algiers',
          'date': '2026-01-10',
          'time': '10:00',
          'status': 'matched',
          'service_categories': {'name': 'Plumbing'},
        },
        {
          'demand_id': 'd2',
          'title': 'Paint wall',
          'description': 'Need living room repaint',
          'location': 'Oran',
          'date': '2026-01-11',
          'time': '15:00',
          'status': 'completed',
          'service_categories': {'name': 'Painting'},
        },
        {
          'demand_id': 'd3',
          'title': 'Electrical check',
          'description': 'Breaker trips sometimes',
          'location': 'Algiers',
          'date': '2026-01-12',
          'time': '09:00',
          'status': 'cancelled',
          'service_categories': {'name': 'Electrical'},
        },
      ]);

      overrides = FakeHttpOverrides(
        routes: {
          RegExp(r'/homeowner/getUserDemands\?homeowner_id=homeowner_1'):
              FakeHttpResponse(statusCode: 200, body: fakeResponseBody),
        },
      );
    });

    blocTest<DemandsCubit, DemandsState>(
      'emits [DemandsLoading, DemandsLoaded] when backend returns demands',
      build: () {
        return DemandsCubit();
      },
      act: (cubit) async {
        // loadDemands triggers an HTTP call; FakeHttpOverrides intercepts it.
        await HttpOverrides.runZoned(() async {
          await cubit.loadDemands();
        }, createHttpClient: overrides.createHttpClient);
      },
      expect: () => [
        isA<DemandsLoading>(),
        isA<DemandsLoaded>().having(
          (s) => s.demands.length,
          'demands.length',
          1,
        ),
      ],
    );

    blocTest<DemandsCubit, DemandsState>(
      'parses backend status into DemandStatus (matched->inProgress, completed->completed, cancelled->cancelled)',
      build: () => DemandsCubit(),
      act: (cubit) async {
        await HttpOverrides.runZoned(() async {
          await cubit.loadDemands();
        }, createHttpClient: overrides.createHttpClient);
      },
      verify: (cubit) {
        final state = cubit.state;
        expect(state, isA<DemandsLoaded>());
        final loaded = state as DemandsLoaded;

        final byId = {for (final d in loaded.demands) d.id: d};
        expect(byId['d1']?.status, DemandStatus.inProgress);
        expect(byId['d2']?.status, DemandStatus.completed);
        expect(byId['d3']?.status, DemandStatus.cancelled);
      },
    );

    blocTest<DemandsCubit, DemandsState>(
      'filterDemands filters by status + search + category',
      build: () => DemandsCubit(),
      act: (cubit) async {
        await HttpOverrides.runZoned(() async {
          await cubit.loadDemands();
        }, createHttpClient: overrides.createHttpClient);

        // Search "paint" should match title/description.
        cubit.filterDemands(searchQuery: 'paint');

        // Now restrict to completed.
        cubit.filterDemands(statusFilter: DemandStatus.completed);

        // And to category Painting.
        cubit.filterDemands(categoryFilter: const ['Painting']);
      },
      expect: () => [
        isA<DemandsLoading>(),
        isA<DemandsLoaded>().having((s) => s.demands.length, 'all', 3),
        isA<DemandsLoaded>().having((s) => s.demands.length, 'search paint', 1),
        isA<DemandsLoaded>().having((s) => s.demands.length, 'completed', 1),
        isA<DemandsLoaded>().having((s) => s.demands.length, 'painting', 1),
      ],
    );

    blocTest<DemandsCubit, DemandsState>(
      'emits [DemandsLoading, DemandsError] when user_id is missing',
      build: () {
        SharedPreferences.setMockInitialValues({});
        return DemandsCubit();
      },
      act: (cubit) async {
        await cubit.loadDemands();
      },
      expect: () => [
        isA<DemandsLoading>(),
        isA<DemandsError>().having(
          (s) => s.message,
          'message',
          contains('Please login'),
        ),
      ],
    );
  });
}
