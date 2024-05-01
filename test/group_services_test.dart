import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:qr_manager/src/data/models/group/group.dart';
import 'package:qr_manager/src/data/services/group/group_services.dart';

class MockGroupServices extends Mock implements GroupServices {}

void main() {
  late GroupServices groupServices;

  setUp(() {
    groupServices = MockGroupServices();
  });

  group('GroupServices', () {
    final mockGroups = [
      Group(id: '1', name: 'Test 1', memberIds: ['1', '2']),
      Group(id: '2', name: 'Test 2', memberIds: []),
      Group(id: '3', name: 'Test 3', memberIds: ['3']),
    ];

    test('loadGroups return a list of groups', () async {
      when(() => groupServices.loadGroups())
          .thenAnswer((_) async => mockGroups);

      final groups = await groupServices.loadGroups();

      expect(groups, isA<List<Group>>());
      verify(() => groupServices.loadGroups()).called(1);
    });

    test('addGroup adds a group and returns updated list', () async {
      final updatedGroups = List<Group>.from(mockGroups);
      updatedGroups.add(Group(name: 'Test 4'));
      when(() => groupServices.addGroup('Test 4'))
          .thenAnswer((_) async => updatedGroups);

      final groups = await groupServices.addGroup('Test 4');

      expect(groups, anyElement((group) => group.name == 'Test 4'));
      verify(() => groupServices.addGroup('Test 4')).called(1);
    });

    test('addMember adds a member and returns updated list', () async {
      final updatedGroups = List<Group>.from(mockGroups);
      updatedGroups.firstWhere((group) => group.id == '1').memberIds.add('3');
      when(() => groupServices.addMember('1', '3'))
          .thenAnswer((_) async => updatedGroups);

      final groups = await groupServices.addMember('1', '3');

      expect(groups.firstWhere((group) => group.id == '1').memberIds,
          contains('3'));
      verify(() => groupServices.addMember('1', '3')).called(1);
    });

    test('getMemberIds returns a list of member ids', () async {
      final mockMemberIds = ['3'];
      when(() => groupServices.getMemberIds('3'))
          .thenAnswer((_) async => mockMemberIds);

      final memberIds = await groupServices.getMemberIds('3');

      expect(memberIds, contains('3'));
      verify(() => groupServices.getMemberIds('3')).called(1);
    });

    test('removeGroup removes a group and returns updated list', () async {
      final updatedGroups = List<Group>.from(mockGroups);
      updatedGroups.removeWhere((group) => group.id == '1');
      when(() => groupServices.removeGroup('1'))
          .thenAnswer((_) async => updatedGroups);

      final groups = await groupServices.removeGroup('1');

      expect(groups, isNot(contains(mockGroups.firstWhere((group) => group.id == '1'))));
      verify(() => groupServices.removeGroup('1')).called(1);
    });

    test('removeMember removes a member and returns updated list', () async {
      final updatedGroups = List<Group>.from(mockGroups);
      updatedGroups
          .firstWhere((group) => group.id == '1')
          .memberIds
          .remove('2');
      when(() => groupServices.removeMember('1', '2'))
          .thenAnswer((_) async => updatedGroups);

      final groups = await groupServices.removeMember('1', '2');

      expect(groups.firstWhere((group) => group.id == '1').memberIds,
          isNot(contains('2')));
      verify(() => groupServices.removeMember('1', '2')).called(1);
    });

    test('editGroupName edits a group name and returns updated list', () async {
      final updatedGroups = List<Group>.from(mockGroups);
      final oldGroup = updatedGroups.firstWhere((group) => group.id == '1');
      final newGroup =
          Group(id: oldGroup.id, name: 'Test 5', memberIds: oldGroup.memberIds);
      updatedGroups[updatedGroups.indexOf(oldGroup)] = newGroup;
      when(() => groupServices.editGroupName('1', 'Test 5'))
          .thenAnswer((_) async => updatedGroups);

      final groups = await groupServices.editGroupName('1', 'Test 5');

      expect(groups.firstWhere((group) => group.id == '1').name, 'Test 5');
      verify(() => groupServices.editGroupName('1', 'Test 5')).called(1);
    });

    test('addGroup does not add a group that already exists', () async {
      final updatedGroups = List<Group>.from(mockGroups);
      when(() => groupServices.addGroup('Test 1'))
          .thenAnswer((_) async => updatedGroups);

      final groups = await groupServices.addGroup('Test 1');

      expect(groups, hasLength(mockGroups.length));
      verify(() => groupServices.addGroup('Test 1')).called(1);
    });

    test('addMember does not add a member that already exists', () async {
      final updatedGroups = List<Group>.from(mockGroups);
      when(() => groupServices.addMember('1', '2'))
          .thenAnswer((_) async => updatedGroups);

      final groups = await groupServices.addMember('1', '2');

      expect(groups.firstWhere((group) => group.id == '1').memberIds,
          hasLength(mockGroups.firstWhere((group) => group.id == '1').memberIds.length));
      verify(() => groupServices.addMember('1', '2')).called(1);
    });
  });
}
