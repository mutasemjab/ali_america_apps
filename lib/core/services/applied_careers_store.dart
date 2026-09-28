import 'package:shared_preferences/shared_preferences.dart';

import '../session/auth_session.dart';

/// Tracks which careers this device has already applied to — populated
/// right after a successful apply, and also the moment the backend says
/// "already applied" (a 422 mid-form), so the list reflects it without
/// needing a dedicated flag from GET /careers. Cleared on logout so a
/// different client on the same device doesn't inherit someone else's
/// applied list.
class AppliedCareersStore {
  static const _prefsKey = 'applied_career_ids';

  final SharedPreferences _prefs;

  AppliedCareersStore(this._prefs, AuthSession authSession) {
    authSession.addListener(() {
      if (!authSession.isAuthenticated) clear();
    });
  }

  Set<int> getAppliedIds() {
    final stored = _prefs.getStringList(_prefsKey) ?? const [];
    return stored.map(int.parse).toSet();
  }

  Future<void> markApplied(int careerId) async {
    final ids = getAppliedIds()..add(careerId);
    await _prefs.setStringList(_prefsKey, ids.map((id) => id.toString()).toList());
  }

  Future<void> clear() => _prefs.remove(_prefsKey);
}
