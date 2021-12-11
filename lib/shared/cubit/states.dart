abstract class AppStates {}

class AppInitState extends AppStates {}

class AppDatabaseCreatedState extends AppStates {}

class AppDatabaseInsertedState extends AppStates {}

class AppDatabaseGetState extends AppStates {}

class AppDatabaseGetTodayState extends AppStates {}

class AppDatabaseUpdatedState extends AppStates {}

class AppDatabaseDeletedState extends AppStates {}

class AppDatabaseLoadingState extends AppStates {}

class AppChangeTaskTypeState extends AppStates {}

class AppChangeSceneState extends AppStates {}

class AppToAddTaskState extends AppStates {}

class AppDrawerOpenedState extends AppStates {}

class AppDrawerClosedState extends AppStates {}
