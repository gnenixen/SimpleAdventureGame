class_name CEnums

enum EGameState {
    NONE = 0,           # Used only at game startup
    GAME,
    STORAGE,
    DOOR_LOCK,
}

static var EGroups = {
    PLAYER_SPAWN_POSITIONS = "player_spawn_positions",
    DOORS_LOCKS = "doors_locks",
}

static var EScenes = {
    STREET = "street",
    HOUSE_1 = "house_1",
    HOUSE_2 = "house_2",
    HOUSE_3 = "house_3",
}