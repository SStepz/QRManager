import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_manager/models/group.dart';

class DataListNotifier extends StateNotifier<List<Group>> {
  DataListNotifier() : super(const []);

  void addGroup(String name) {
    state = [...state, Group(name: name)];
  }

  void addMember(String groupId, String memberName) {
    state = state.map((group) {
      if (group.id == groupId) {
        final newMember = Member(name: memberName);
        return Group(
          id: groupId,
          name: group.name,
          members: [...group.members, newMember],
        );
      }
      return group;
    }).toList();
  }

  void addQR(String groupId, String memberId, QRCode qrCode) {
    state = state.map((group) {
      if (group.id == groupId) {
        group.members = group.members.map((member) {
          if (member.id == memberId) {
            return Member(
              id: memberId,
              name: member.name,
              qrCodes: [...member.qrCodes, qrCode],
            );
          }
          return member;
        }).toList();
      }
      return group;
    }).toList();
  }

  void removeGroup(String id) {
    state = state.where((n) => n.id != id).toList();
  }

  void removeMember(String groupId, String memberId) {
    state = state.map((group) {
      if (group.id == groupId) {
        group.members = group.members.where((n) => n.id != memberId).toList();
      }
      return group;
    }).toList();
  }

  void removeQR(String groupId, String memberId, String qrId) {
    state = state.map((group) {
      if (group.id == groupId) {
        group.members = group.members.map((member) {
          if (member.id == memberId) {
            member.qrCodes = member.qrCodes.where((n) => n.id != qrId).toList();
          }
          return member;
        }).toList();
      }
      return group;
    }).toList();
  }

  void editGroupName(String id, String newName) {
    state = state.map((group) {
      if (group.id == id) {
        return Group(id: id, name: newName, members: group.members);
      }
      return group;
    }).toList();
  }

  void editMemberName(String groupId, String memberId, String newMemberName) {
    state = state.map((group) {
      if (group.id == groupId) {
        group.members = group.members.map((member) {
          if (member.id == memberId) {
            return Member(
                id: memberId, name: newMemberName, qrCodes: member.qrCodes);
          }
          return member;
        }).toList();
      }
      return group;
    }).toList();
  }

  void editQR(String groupId, String memberId, String qrId, QRCode qrCode) {
    state = state.map((group) {
      if (group.id == groupId) {
        group.members = group.members.map((member) {
          if (member.id == memberId) {
            member.qrCodes = member.qrCodes.map((qr) {
              if (qr.id == qrId) {
                return qrCode;
              }
              return qr;
            }).toList();
          }
          return member;
        }).toList();
      }
      return group;
    }).toList();
  }
}

final dataListProvider = StateNotifierProvider<DataListNotifier, List<Group>>(
  (ref) => DataListNotifier(),
);
