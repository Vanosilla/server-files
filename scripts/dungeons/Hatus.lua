local Map = require('Map')
local Monster = require ('Monster')
local Event = require('Event')
local Portal = require('Portal')
local PortalType = require('PortalType')
local Dungeon = require('Dungeon')
local DungeonType = require('DungeonType')
local Location = require('Location')
local RaidDrop = require('RaidDrop')
local Drop = require('Drop')
local RaidReward = require('RaidReward')
local RaidBox = require('RaidBox')
local RaidBoxRarity = require('RaidBoxRarity')
local MonsterWave = require('MonsterWave')

local raidBox = RaidBox.Create()
    .WithVnum(1)
    .WithBoxRarity(RaidBoxRarity.CreateBoxRarity().WithRarity(1).WithChance(1350))
    .WithBoxRarity(RaidBoxRarity.CreateBoxRarity().WithRarity(2).WithChance(1700))
    .WithBoxRarity(RaidBoxRarity.CreateBoxRarity().WithRarity(3).WithChance(2500))
    .WithBoxRarity(RaidBoxRarity.CreateBoxRarity().WithRarity(4).WithChance(2000))
    .WithBoxRarity(RaidBoxRarity.CreateBoxRarity().WithRarity(5).WithChance(1500))
    .WithBoxRarity(RaidBoxRarity.CreateBoxRarity().WithRarity(6).WithChance(750))
    .WithBoxRarity(RaidBoxRarity.CreateBoxRarity().WithRarity(7).WithChance(200))

local reward = RaidReward.Create()
    .WithRaidBox(raidBox)

local mob_map = Map.Create().WithMapId(137)
local boss_map = Map.Create().WithMapId(138)

local to_tundra_portal = Portal.Create(PortalType.TsNormal).From(mob_map, 15, 11).To(mob_map, 0, 0).AsReturn()
local to_boss_portal = Portal.Create(PortalType.TsNormal).From(mob_map, 36, 156).To(boss_map, 36, 57).WithDelay(30*60)

mob_map.AddPortals({
    to_tundra_portal,
    to_boss_portal,
});

local boss = Monster.CreateWithVnum(577).At(36, 18).AsDungeonBoss().OnHalfHp({
        Event.RemovePortal(to_boss_portal),
    }).OnDeath({
        Event.DungeonRewardEvent(),
    })

local drops = RaidDrop.Create(boss)
    .WithGoldRange(20000, 20000)
    .WithGoldStackCount(15)
    .WithDrops({
        Drop.Create(1011, 5), -- Huge Recovery Potion
        Drop.Create(1122, 3), -- Cylloan Spring Water
        Drop.Create(2135, 2), -- Cheese Sticks
        Drop.Create(2136, 2), -- Secret Recipe Fries
        Drop.Create(2516, 2), -- Small Obsidian of Completion
        Drop.Create(2516, 3), -- Small Obsidian of Completion
    })
    .WithDropsStackCount(35)

boss_map.AddMonster(boss)

boss_map.AddMonsterWaves({
    MonsterWave.CreateWithDelay(60).AsLoop(60).ScaledWithPlayerAmount().WithMonsters({
        Monster.CreateWithVnum(575).AtRandomPosition(), -- Shadow Predator
        Monster.CreateWithVnum(575).AtRandomPosition(), -- Shadow Predator
        Monster.CreateWithVnum(575).AtRandomPosition(), -- Shadow Predator
    }),
    
    MonsterWave.CreateWithDelay(60).AsLoop(60).WithMonsters({
        Monster.CreateWithVnum(575).AtRandomPosition(), -- Shadow Predator
        Monster.CreateWithVnum(575).AtRandomPosition(), -- Shadow Predator
        Monster.CreateWithVnum(575).AtRandomPosition(), -- Shadow Predator
        Monster.CreateWithVnum(575).AtRandomPosition(), -- Shadow Predator
        Monster.CreateWithVnum(575).AtRandomPosition(), -- Shadow Predator
        Monster.CreateWithVnum(575).AtRandomPosition(), -- Shadow Predator
        Monster.CreateWithVnum(575).AtRandomPosition(), -- Shadow Predator
        Monster.CreateWithVnum(575).AtRandomPosition(), -- Shadow Predator
    }),
})

boss_map.AfterSlowMotion({
    Event.ThrowRaidDrops(drops),
})

local dungeon = Dungeon.Create(DungeonType.Hatus)
    .WithMaps({mob_map, boss_map})
    .WithSpawn(Location.InMap(mob_map).At(18, 11))
    .WithReward(reward)
return dungeon
