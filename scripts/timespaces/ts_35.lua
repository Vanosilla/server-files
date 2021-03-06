-- TimeSpace Script generated by friends111's python script. Replace all %TODO% values accordingly, check for errors (packet-generation isn't perfect), and modify things if needed.
local Map = require('Map')
local Monster = require('Monster')
local Event = require('Event')
local MapObject = require('MapObject')
local MapNpc = require('MapNpc')
local Portal = require('Portal')
local Location = require('Location')
local TimeSpace = require('TimeSpace')
local PortalType = require("PortalType")
local PortalMinimapOrientation = require('PortalMinimapOrientation')
local TimeSpaceObjective = require('TimeSpaceObjective')
local TimeSpaceTaskType = require('TimeSpaceTaskType')
local TimeSpaceTask = require('TimeSpaceTask')
local MonsterWave = require('MonsterWave')

local objectives = TimeSpaceObjective.Create()
    .WithGoToExit()

-- Grid min:(3, 6) ~ max:(3, 11) (width: 0, height: 5)
--     [ 0][ 1][ 2][ 3][ 4][ 5][ 6][ 7][ 8][ 9][10]
-- [ 0][  ][  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]
-- [ 1][  ][  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]
-- [ 2][  ][  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]
-- [ 3][  ][  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]
-- [ 4][  ][  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]
-- [ 5][  ][  ][  ][  ][  ][  ][  ][  ][  ][  ][  ]
-- [ 6][  ][  ][  ][XX][  ][  ][  ][  ][  ][  ][  ]
-- [ 7][  ][  ][  ][XX][  ][  ][  ][  ][  ][  ][  ]
-- [ 8][  ][  ][  ][XX][  ][  ][  ][  ][  ][  ][  ]
-- [ 9][  ][  ][  ][XX][  ][  ][  ][  ][  ][  ][  ]
-- [10][  ][  ][  ][XX][  ][  ][  ][  ][  ][  ][  ]
-- [11][  ][  ][  ][OO][  ][  ][  ][  ][  ][  ][  ]

local map_3_11 = Map.Create().WithMapId(5206).SetMapCoordinates(3, 11).WithTask(
    TimeSpaceTask.Create(TimeSpaceTaskType.None)
) -- start
local map_3_10 = Map.Create().WithMapId(5206).SetMapCoordinates(3, 10).WithTask(
    TimeSpaceTask.Create(TimeSpaceTaskType.KillAllMonsters).WithTaskText("TS_25_TEXT_0")
)
local map_3_9 = Map.Create().WithMapId(5206).SetMapCoordinates(3, 9).WithTask(
    TimeSpaceTask.Create(TimeSpaceTaskType.KillAllMonsters).WithTaskText("TS_25_TEXT_0")
)
local map_3_8 = Map.Create().WithMapId(5206).SetMapCoordinates(3, 8).WithTask(
    TimeSpaceTask.Create(TimeSpaceTaskType.KillAllMonsters).WithTaskText("TS_25_TEXT_0")
)
local map_3_7 = Map.Create().WithMapId(5206).SetMapCoordinates(3, 7).WithTask(
    TimeSpaceTask.Create(TimeSpaceTaskType.KillAllMonsters).WithTaskText("TS_25_TEXT_0")
)
local map_3_6 = Map.Create().WithMapId(5206).SetMapCoordinates(3, 6).WithTask(
    TimeSpaceTask.Create(TimeSpaceTaskType.Survive, 120).WithTaskText("TS_25_TEXT_1").WithOnStartDialog(6123)
)

local portal_3_11_to_3_10 = Portal.Create(PortalType.TsNormal).From(map_3_11, 12, 1).To(map_3_10, 12, 23).MinimapOrientation(PortalMinimapOrientation.North)
local portal_3_10_to_3_9 = Portal.Create(PortalType.Locked).From(map_3_10, 12, 1).To(map_3_9, 12, 23).MinimapOrientation(PortalMinimapOrientation.North)
local portal_3_10_to_3_11 = Portal.Create(PortalType.Locked).From(map_3_10, 12, 23).To(map_3_11, 12, 1).MinimapOrientation(PortalMinimapOrientation.South)
local portal_3_9_to_3_8 = Portal.Create(PortalType.Locked).From(map_3_9, 12, 1).To(map_3_8, 12, 23).MinimapOrientation(PortalMinimapOrientation.North)
local portal_3_9_to_3_10 = Portal.Create(PortalType.Locked).From(map_3_9, 12, 23).To(map_3_10, 12, 1).MinimapOrientation(PortalMinimapOrientation.South)
local portal_3_8_to_3_7 = Portal.Create(PortalType.Locked).From(map_3_8, 12, 1).To(map_3_7, 12, 23).MinimapOrientation(PortalMinimapOrientation.North)
local portal_3_8_to_3_9 = Portal.Create(PortalType.Locked).From(map_3_8, 12, 23).To(map_3_9, 12, 1).MinimapOrientation(PortalMinimapOrientation.South)
local portal_3_7_to_3_6 = Portal.Create(PortalType.Locked).From(map_3_7, 12, 1).To(map_3_6, 12, 23).MinimapOrientation(PortalMinimapOrientation.North)
local portal_3_7_to_3_8 = Portal.Create(PortalType.Locked).From(map_3_7, 12, 23).To(map_3_8, 12, 1).MinimapOrientation(PortalMinimapOrientation.South)
local portal_3_6_to_UNKNOWN = Portal.Create(PortalType.TSEndClosed).From(map_3_6, 12, 1).To(map_3_6, 12, 1).MinimapOrientation(PortalMinimapOrientation.North)
local portal_3_6_to_3_7 = Portal.Create(PortalType.Locked).From(map_3_6, 12, 23).To(map_3_7, 12, 1).MinimapOrientation(PortalMinimapOrientation.South)

map_3_11.AddPortal(portal_3_11_to_3_10)
map_3_10.AddPortal(portal_3_10_to_3_9)
map_3_10.AddPortal(portal_3_10_to_3_11)
map_3_9.AddPortal(portal_3_9_to_3_8)
map_3_9.AddPortal(portal_3_9_to_3_10)
map_3_8.AddPortal(portal_3_8_to_3_7)
map_3_8.AddPortal(portal_3_8_to_3_9)
map_3_7.AddPortal(portal_3_7_to_3_6)
map_3_7.AddPortal(portal_3_7_to_3_8)
map_3_6.AddPortal(portal_3_6_to_UNKNOWN)
map_3_6.AddPortal(portal_3_6_to_3_7)

--- Map 3_11
map_3_11.OnMapJoin({
    Event.TryStartTaskForMap(map_3_11),
})
---

--- Map 3_10
map_3_10.AddMonsters({
    Monster.CreateWithVnum(118).At(14, 10).Facing(3), -- Koaren Archer [16:19:17]
    Monster.CreateWithVnum(115).At(10, 17).Facing(3), -- Koaren Sword Fighter [16:19:17]
    Monster.CreateWithVnum(115).At(9, 15).Facing(1), -- Koaren Sword Fighter [16:19:17]
    Monster.CreateWithVnum(118).At(13, 19).Facing(5).SpawnAfterMobsKilled(1), -- Koaren Archer [16:19:19]
    Monster.CreateWithVnum(118).At(14, 15).Facing(4).SpawnAfterMobsKilled(2), -- Koaren Archer [16:19:20]
})
map_3_10.OnMapJoin({
    Event.TryStartTaskForMap(map_3_10),
})
map_3_10.OnTaskFinish({
    Event.OpenPortal(portal_3_10_to_3_9),
    Event.AddTime(60),
})
---

--- Map 3_9
map_3_9.AddMonsters({
    Monster.CreateWithVnum(118).At(15, 18).Facing(4), -- Koaren Archer [16:19:29]
    Monster.CreateWithVnum(118).At(13, 15).Facing(0), -- Koaren Archer [16:19:29]
    Monster.CreateWithVnum(118).At(12, 12).Facing(1).SpawnAfterMobsKilled(1), -- Koaren Archer [16:19:30]
    Monster.CreateWithVnum(121).At(8, 14).Facing(5).SpawnAfterMobsKilled(3), -- Koaren Warrior [16:19:32]
    Monster.CreateWithVnum(121).At(13, 15).Facing(6).SpawnAfterMobsKilled(3), -- Koaren Warrior [16:19:32]
    Monster.CreateWithVnum(121).At(9, 10).Facing(1).SpawnAfterMobsKilled(4), -- Koaren Warrior [16:19:34]
    Monster.CreateWithVnum(121).At(13, 10).Facing(2).SpawnAfterMobsKilled(4), -- Koaren Warrior [16:19:34]
})
map_3_9.OnMapJoin({
    Event.TryStartTaskForMap(map_3_9),
})
map_3_9.OnTaskFinish({
    Event.OpenPortal(portal_3_9_to_3_8),
    Event.AddTime(80),
})
---

--- Map 3_8
map_3_8.AddMonsters({
    Monster.CreateWithVnum(118).At(12, 16).Facing(7), -- Koaren Archer [16:19:41]
    Monster.CreateWithVnum(118).At(11, 18).Facing(6), -- Koaren Archer [16:19:41]
    Monster.CreateWithVnum(118).At(9, 15).Facing(6).SpawnAfterMobsKilled(1), -- Koaren Archer [16:19:42]
    Monster.CreateWithVnum(121).At(14, 18).Facing(1).SpawnAfterMobsKilled(2), -- Koaren Warrior [16:19:44]
    Monster.CreateWithVnum(121).At(8, 9).Facing(7).SpawnAfterMobsKilled(4), -- Koaren Warrior [16:19:46]
    Monster.CreateWithVnum(121).At(14, 13).Facing(6).SpawnAfterMobsKilled(4), -- Koaren Warrior [16:19:46]
    Monster.CreateWithVnum(121).At(16, 12).Facing(6).SpawnAfterMobsKilled(5), -- Koaren Warrior [16:19:48]
    Monster.CreateWithVnum(121).At(9, 14).Facing(7).SpawnAfterMobsKilled(6), -- Koaren Warrior [16:19:49]
    Monster.CreateWithVnum(118).At(14, 16).Facing(1).SpawnAfterMobsKilled(7), -- Koaren Archer [16:19:50]
})
map_3_8.AddObjects({
    MapObject.CreateRegularBox().At(17, 12), -- [16:19:41]
})
map_3_8.OnMapJoin({
    Event.TryStartTaskForMap(map_3_8),
})
map_3_8.OnTaskFinish({
    Event.OpenPortal(portal_3_8_to_3_7),
    Event.AddTime(80),
})
---

--- Map 3_7
map_3_7.AddMonsters({
    Monster.CreateWithVnum(118).At(17, 10).Facing(0), -- Koaren Archer [16:19:56]
    Monster.CreateWithVnum(118).At(15, 14).Facing(6), -- Koaren Archer [16:19:56]
    Monster.CreateWithVnum(118).At(9, 11).Facing(7), -- Koaren Archer [16:19:56]
    Monster.CreateWithVnum(115).At(10, 17).Facing(7).SpawnAfterMobsKilled(2), -- Koaren Sword Fighter [16:19:59]
    Monster.CreateWithVnum(118).At(12, 15).Facing(6).SpawnAfterMobsKilled(2), -- Koaren Archer [16:19:59]
    Monster.CreateWithVnum(115).At(13, 17).Facing(4).SpawnAfterMobsKilled(4), -- Koaren Sword Fighter [16:20:02]
    Monster.CreateWithVnum(115).At(16, 15).Facing(7).SpawnAfterMobsKilled(4), -- Koaren Sword Fighter [16:20:02]
    Monster.CreateWithVnum(115).At(14, 17).Facing(4).SpawnAfterMobsKilled(5), -- Koaren Sword Fighter [16:20:03]
})
map_3_7.AddObjects({
    MapObject.CreateOldBox().At(15, 15), -- [16:19:56]
})
map_3_7.OnMapJoin({
    Event.TryStartTaskForMap(map_3_7),
})
map_3_7.OnTaskFinish({
    Event.OpenPortal(portal_3_7_to_3_6),
    Event.AddTime(200),
})
---

--- Map 3_6
map_3_6.AddMonsterWaves({
    -- wave 1
    MonsterWave.CreateWithDelay(0 * 30).WithMonsters({
        Monster.CreateWithVnum(118).At(16, 10).Facing(3), -- Koaren Archer [16:20:12]
        Monster.CreateWithVnum(316).At(15, 18).Facing(1).WithCustomLevel(40), -- Kenko Flailman [16:20:12]
        Monster.CreateWithVnum(118).At(9, 9).Facing(4), -- Koaren Archer [16:20:12]
        Monster.CreateWithVnum(115).At(8, 11).Facing(3), -- Koaren Sword Fighter [16:20:12]
    }),
})
map_3_6.OnMapJoin({
    Event.TryStartTaskForMap(map_3_6),
})
map_3_6.OnTaskFinish({
    Event.OpenPortal(portal_3_6_to_UNKNOWN),
    Event.DespawnAllMobsInRoom(map_3_6),
})
---

local ts = TimeSpace.Create(25)  -- TimeSpace ID
    .SetMaps({map_3_11, map_3_10, map_3_9, map_3_8, map_3_7, map_3_6})
    .SetSpawn(Location.InMap(map_3_11).At(9, 11))
    .SetLives(1)
    .SetObjectives(objectives)
    .SetDurationInSeconds(250)
    .SetBonusPointItemDropChance(5000)
return ts
