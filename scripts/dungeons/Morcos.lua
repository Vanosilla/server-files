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

local mob_map = Map.Create().WithMapId(135)
local boss_map = Map.Create().WithMapId(136)

local to_tundra_portal = Portal.Create(PortalType.TsNormal).From(mob_map, 39, 175).To(mob_map, 0, 0).AsReturn()
local to_boss_portal = Portal.Create(PortalType.TsNormal).From(mob_map, 147, 44).To(boss_map, 56, 77).WithDelay(30*60)

mob_map.AddPortals({
    to_tundra_portal,
    to_boss_portal,
});

local boss = Monster.CreateWithVnum(563).At(57, 13).AsDungeonBoss().OnHalfHp({
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
        Drop.Create(2514, 2), -- Small Ruby of Completion
        Drop.Create(2514, 3), -- Small Ruby of Completion
    })
    .WithDropsStackCount(35)

boss_map.AddMonster(boss)

boss_map.AddMonsters({
    Monster.CreateWithVnum(970).At(13, 33), -- Rolling Stone 2
    Monster.CreateWithVnum(970).At(31, 40), -- Rolling Stone 2
    Monster.CreateWithVnum(970).At(34, 54), -- Rolling Stone 2
    Monster.CreateWithVnum(970).At(59, 75), -- Rolling Stone 2
    Monster.CreateWithVnum(970).At(61, 74), -- Rolling Stone 2
    Monster.CreateWithVnum(970).At(62, 64), -- Rolling Stone 2
    Monster.CreateWithVnum(970).At(94, 27), -- Rolling Stone 2
})

boss_map.AddMonsterWaves({
    MonsterWave.CreateWithDelay(60).AsLoop(120).ScaledWithPlayerAmount().WithMonsters({
        Monster.CreateWithVnum(561).AtRandomPosition(), -- Powerful Molda's Warrior
        Monster.CreateWithVnum(561).AtRandomPosition(), -- Powerful Molda's Warrior
        Monster.CreateWithVnum(562).AtRandomPosition(), -- Powerful Molda's Warlock
        Monster.CreateWithVnum(562).AtRandomPosition(), -- Powerful Molda's Warlock
    }),
    
    MonsterWave.CreateWithDelay(60).AsLoop(120).WithMonsters({
        Monster.CreateWithVnum(561).AtRandomPosition(), -- Powerful Molda's Warrior
        Monster.CreateWithVnum(561).AtRandomPosition(), -- Powerful Molda's Warrior
        Monster.CreateWithVnum(561).AtRandomPosition(), -- Powerful Molda's Warrior
        Monster.CreateWithVnum(561).AtRandomPosition(), -- Powerful Molda's Warrior
        Monster.CreateWithVnum(562).AtRandomPosition(), -- Powerful Molda's Warlock
        Monster.CreateWithVnum(562).AtRandomPosition(), -- Powerful Molda's Warlock
        Monster.CreateWithVnum(562).AtRandomPosition(), -- Powerful Molda's Warlock
        Monster.CreateWithVnum(562).AtRandomPosition(), -- Powerful Molda's Warlock
    }),
})

boss_map.AfterSlowMotion({
    Event.ThrowRaidDrops(drops),
})

local dungeon = Dungeon.Create(DungeonType.Morcos)
    .WithMaps({mob_map, boss_map})
    .WithSpawn(Location.InMap(mob_map).At(40, 180))
    .WithReward(reward)
return dungeon
