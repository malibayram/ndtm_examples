abstract class NotificationHub {
  List<TeamMember> getTeamMembers();
  void register(TeamMember member);
  void send(TeamMember sender, String message);
  void sendTo<T extends TeamMember>(TeamMember sender, String message);
}

abstract class TeamMember {
  final String name;

  NotificationHub? notificationHub;
  String? lastNotification;

  TeamMember({required this.name});

  void receive(String from, String message) {
    lastNotification = '$from: "$message"';
  }

  void send(String message) {
    notificationHub?.send(this, message);
  }

  void sendTo<T extends TeamMember>(String message) {
    notificationHub?.sendTo<T>(this, message);
  }
}

class Admin extends TeamMember {
  Admin({required super.name});

  @override
  String toString() {
    return "$name (Admin)";
  }
}

class Developer extends TeamMember {
  Developer({required super.name});

  @override
  String toString() {
    return "$name (Developer)";
  }
}

class Tester extends TeamMember {
  Tester({required super.name});

  @override
  String toString() {
    return "$name (QA)";
  }
}

class TeamNotificationHub extends NotificationHub {
  final _teamMembers = <TeamMember>[];

  TeamNotificationHub({List<TeamMember>? members}) {
    members?.forEach(register);
  }

  @override
  List<TeamMember> getTeamMembers() => _teamMembers;

  @override
  void register(TeamMember member) {
    member.notificationHub = this;

    _teamMembers.add(member);
  }

  @override
  void send(TeamMember sender, String message) {
    final filteredMembers = _teamMembers.where((m) => m != sender);

    for (final member in filteredMembers) {
      member.receive(sender.toString(), message);
    }
  }

  @override
  void sendTo<T extends TeamMember>(TeamMember sender, String message) {
    final filteredMembers =
        _teamMembers.where((m) => m != sender).whereType<T>();

    for (final member in filteredMembers) {
      member.receive(sender.toString(), message);
    }
  }
}
