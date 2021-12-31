# Vanosilla - server-files

`./server-translations` contains all game-server configuration files.

Every .yaml file contains header with the comment.

___

⚠️ This section is mainly for developers with basic C# knowledge only ⚠️

# Creating new config file - Single file

To create a config, you need to create a `.yaml` file (if you don't know what .yaml is, [wiki](https://en.wikipedia.org/wiki/YAML) is your friend).

Let's say we want to create a single file that contains some basic data:

- Maximum upgrade of the Specialist Card is `15`
- Maximum upgrade of the equipment is `10`
- Maximum rarity of the equipment is `7`

First, let's create `maximum_eq_sp.yaml`:

```yaml
max_specialist_upgrade: 15
max_equipment_upgrade: 10
max_equipment_rarity: 7
```

___

## Single file - Load file

Okay, config created and now it's time to load it to the server.

First of all, let's create a new `.cs` file in `./Configurations` directory in `WingsAPI.Game` project and let's name it `SpecialistEquipmentMaximum` like above:

```csharp
public class SpecialistEquipmentMaximum
{
}
```

with 3 properties:

- `MaxSpecialistUpgrade`
- `MaxEquipmentUpgrade`
- `MaxEquipmentRarity`

All properties will be the type of `byte`:

```csharp
public class SpecialistEquipmentMaximum
{
    public byte MaxSpecialistUpgrade { get; set; }
    public byte MaxEquipmentUpgrade { get; set; }
    public byte MaxEquipmentRarity { get; set; }
}
```

___

### ❗ Note

If you want to rename your properties in `.yaml` file to whatever you want (for example because the name is too long) just add `YamlMember` attribute above property:

```csharp
public class SpecialistEquipmentMaximum
{
    [YamlMember(Alias = "max_sp_upgr")]
    public byte MaxSpecialistUpgrade { get; set; }
}
```

and change naming of the property in `.yaml` file:

```yaml
max_sp_upgr: 15
```

___

Great! Now, it's time to load config into server. First, go to the `GameManagersPluginCore.cs` file in `WingsEmu.Plugins.BasicImplementations` project and at the end of the `AddDependencies` method add new line:

```csharp
services.AddFileConfiguration<SpecialistEquipmentMaximum>("maximum_eq_sp");
```

Congratulations! You have successfully created a new config and now it's loaded in the server!

## Single file - Server implementation

Now it's time for server implementation. Let's say that I want to check if the player's Specialist Card upgrade is is greater than or equal to our value in config while player wants to upgrade his Specialist Card.

The event that is responsible for upgrading the Specialist Card is called `SpUpgradeEvent`, so let's find the handler of this event in the solution... and we can find `SpUpgradeEventHandler` (if you don't know anything about events in the emulator, read `Event and Event Handler` section in `./server/README.md`).

First, implement our config in the constructor of `SpUpgradeEventHandler` by using [Depedency Injection](https://docs.microsoft.com/en-us/dotnet/core/extensions/dependency-injection):

```csharp
public class SpUpgradeEventHandler : IAsyncEventProcessor<SpUpgradeEvent>
{
    private readonly SpecialistEquipmentMaximum _specialistEquipmentMaxConfig;

    public SpUpgradeEventHandler(SpecialistEquipmentMaximum specialistEquipmentMaxConfig)
    {
        _specialistEquipmentMaxConfig = specialistEquipmentMaxConfig;
    }
}
```

Now, let's move to the `HandleAsync` method at the very beginning (line ~55) and use our config:

```csharp
GameItemInstance sp = e.InventoryItem.ItemInstance;

if (sp.GameItem.IsPartnerSpecialist)
{
    return;
}

if (sp.Rarity == -2)
{
    return;
}

// First, let's take current Specialist Card upgrade
byte specialistUpgrade = sp.Upgrade;

// Now, let's take maximum upgrade for Specialist Card
byte maxSpecialistUpgrade = _specialistEquipmentMaxConfig.MaxSpecialistUpgrade;

// Check if specialistUpgrade is greater than or equal to maxSpecialistUpgrade
if (specialistUpgrade >= maxSpecialistUpgrade)
{
    return;
}
```

and voilà, the server implementation is done by using new config, again - Congratulations!

# Creating new config file - Multiple configurations in one file

Okay, let's say you want to create some lists of positions on individual maps that give you some amount of gold each time you enter that position.

First, let's create the `.yaml` file - I will call it `give_gold_in_position.yaml` and it will store the following data:

- `map_id` - on which map id it will work
- `amount_of_gold` - amount of gold that is given to the player
- `positions` - list of the cells (X/Y)

So, let's build the `.yaml`:

```yaml
- map_id: 1 # NosVille
  amount_of_gold: 1 # 1x Gold
  positions:
    - x: 1
      y: 1
    - x: 2
      y: 2
- map_id: 10000 # GM Room
  amount_of_gold: 5 # 5x Gold
  positions:
    - x: 10
      y: 15
    - x: 23
      y: 11
```

___

### ❗ Note

I recommend you to use several YAML validators to check that the `.yaml` file is processing correctly before starting the server:
- [YAML Validator by Code Beautify](https://codebeautify.org/yaml-validator)
- [YAML Lint](http://www.yamllint.com/)
- [Online YAML Parser](https://yaml-online-parser.appspot.com) (favorite)

___

Summing up what is above - if the player is in:
- `NosVille` and steps on coordinates `X: 1` | `Y: 1` or `X: 2` | `Y: 2` he will receive `1` gold.
- `GM Room` and steps on coordinates `X: 10` | `Y: 15` or `X: 23` | `Y: 11` he will receive `5` gold.

Okay, we have raw file - now it's time to create proper C# class:

```csharp
public class GiveGoldInPosition
{
    public int MapId { get; set; }
    public int AmountOfGold { get; set; }
    public List<GoldPosition> Positions { get; set; }
}

public class GoldPosition
{
    public short X { get; set; }
    public short Y { get; set; }
}
```

___

### ❗ Note

I couldn't use `Position` struct in this case, because `Position` struct doesn't have setters in `X` and `Y` properties, so instead I created a new class `GoldPosition`.

___

Great, now it's time to load our `give_gold_in_position.yaml` file into `GiveGoldInPosition` class. This time, instead of using `AddFileConfiguration` method, we have to use `AddMultipleConfigurationOneFile` method to create a list of `GiveGoldInPosition` class.

```csharp
services.AddMultipleConfigurationOneFile<GiveGoldInPosition>("give_gold_in_position");
```

## Multiple configurations in one file - Server implementation

Now when our config is loaded in the memory of the server, it's time to use it. Let's enter the `WalkPacketHandler` class in `WingsEmu.Plugins.PacketHandling` project, when player is moving.

Like in the previous section of server implementation, let's implement our config to the class by using [Depedency Injection](https://docs.microsoft.com/en-us/dotnet/core/extensions/dependency-injection):

```csharp
public class WalkPacketHandler : GenericGamePacketHandlerBase<WalkPacket>
{
    private readonly List<GiveGoldInPosition> _giveGoldInPosition;

    public WalkPacketHandler(List<GiveGoldInPosition> giveGoldInPosition)
    {
        _giveGoldInPosition = giveGoldInPosition;
    }
}
```

After some checks inside `HandlePacketAsync` method, we should add our new config below `session.PlayerEntity.ChangePosition` method. First, let's create a new method:

```csharp
public async Task CheckForGoldAsync(IClientSession session, short x, short y)
{
    // Let's take current map id from the player
    int mapId = session.PlayerEntity.MapInstance.MapId;

    // Find given map id from config
    GiveGoldInPosition goldInPosition = _giveGoldInPosition.FirstOrDefault(config => config.MapId == mapId);
    
    // Couldn't find config in giving map
    if (goldInPosition == null)
    {
        return;
    }

    // Let's find GoldPosition in our config, but the player isn't in any given cell
    if (!goldInPosition.Positions.Any(coords => coords.X == x && coords.Y == y))
    {
        return;
    }

    //Execute GenerateGoldEvent event to give player gold
    int amountOfGold = goldInPosition.AmountOfGold;
    await session.EmitEventAsync(new GenerateGoldEvent(amountOfGold));
}
```

and at the end, add our `CheckForGoldAsync` method in `HandlePacketAsync` method somewhere under `ChangePosition` method:

```csharp
session.PlayerEntity.ChangePosition(new Position(walkPacket.XCoordinate, walkPacket.YCoordinate));
await CheckForGoldAsync(session, walkPacket.XCoordinate, walkPacket.YCoordinate);
```

Done... well, kind of. Currently the main problem of this solution is the `FirstOrDefault(config => config.MapId == mapId)` method - just imagine how many times we have to use this method for every player movement even if he isn't on the map given in config, let alone with the proper coordinates... the performance will cost us a lot of doing that and we want to avoid that.

The solution is... [Dictionary](https://docs.microsoft.com/en-us/dotnet/api/system.collections.generic.dictionary-2) - let's implement it.

___

## Multiple configurations in one file - Config Manager

First we need to create a manager for our config - the interface of the config and the class to implement methods from our interface.

I will create the manager inside `GiveGoldInPosition` namespace with interface `IGiveGoldConfig` and the class `GiveGoldConfig` that inherits our interface:

```csharp
public interface IGiveGoldConfig
{

}

public class GiveGoldConfig : IGiveGoldConfig
{

}
```

Great - now let's create a method that will return the `GiveGoldInPosition` class by giving map id:

```csharp
public interface IGiveGoldConfig
{
    GiveGoldInPosition FindConfigByMapId(int mapId);
}

public class GiveGoldConfig : IGiveGoldConfig
{
    public GiveGoldInPosition FindConfigByMapId(int mapId)
    {
        return null;
    }
}
```

For now I will return nothing, because I didn't store any data inside this manager - to do it I need to parse our list of configs inside the constructor of the `GiveGoldConfig` class using Depedency Injection again. As I said previously, we're gonna use Dictionary that will store map id as key and `GiveGoldInPosition` class as value:

```csharp
public interface IGiveGoldConfig
{
    GiveGoldInPosition FindConfigByMapId(int mapId);
}

public class GiveGoldConfig : IGiveGoldConfig
{
    private readonly IReadOnlyDictionary<int, GiveGoldInPosition> _configs = new Dictionary<int, GiveGoldInPosition>();

    public GiveGoldConfig(IEnumerable<GiveGoldInPosition> configs)
    {

    }

    public GiveGoldInPosition FindConfigByMapId(int mapId)
    {
        return null;
    }
}
```

As you can see I used `IReadOnlyDictionary`, because we're not gonna add new data while the server is running, but at startup using the `GiveGoldConfig`'s constructor. Now, let's use `ToDictionary` method which will create a dictionary for us:

```csharp
public interface IGiveGoldConfig
{
    GiveGoldInPosition FindConfigByMapId(int mapId);
}

public class GiveGoldConfig : IGiveGoldConfig
{
    private readonly IReadOnlyDictionary<int, GiveGoldInPosition> _configs = new();

    public GiveGoldConfig(IEnumerable<GiveGoldInPosition> configs)
    {
        // ToDictionary() will create a Dictionary from each element in configs list and map it MapI as key
        _configs = configs.ToDictionary(x => x.MapId);
    }
}
```

Now, we can easy implement our method:

```csharp
public GiveGoldInPosition FindConfigByMapId(int mapId)
{
    return _configs.TryGetValue(mapId, out GiveGoldInPosition config) ? config : null;;
}
```

Now, when everything is done, let's add our config into Depedency Injection to use it later in `WalkPacketHandler`.
To do that, just add `TryAddSingleton` method after `AddMultipleConfigurationOneFile` of our new config - the final result should look like that:

```csharp
services.AddMultipleConfigurationOneFile<GiveGoldInPosition>("give_gold_in_position");
services.TryAddSingleton<IGiveGoldConfig, GiveGoldConfig>();
```

Now, let's move back to the `WalkPacketHandler` and our `CheckForGoldAsync`... and instead of `FirstOrDefault` method we will use `FindConfigByMapId` method - but first, replace our old config in the constructor of the config with our new config manager:

```csharp
public class WalkPacketHandler : GenericGamePacketHandlerBase<WalkPacket>
{
    private readonly IGiveGoldConfig _giveGoldConfig;

    public WalkPacketHandler(IGiveGoldConfig giveGoldConfig)
    {
        _giveGoldConfig = giveGoldConfig;
    }
}
```

... remove `FirstOrDefault` method and replace with `FindConfigByMapId` method from our config manager:

```csharp
public async Task CheckForGoldAsync(IClientSession session, short x, short y)
{
    // Let's take current map id from the player
    int mapId = session.PlayerEntity.MapInstance.MapId;

    // Find given map id from config
    GiveGoldInPosition goldInPosition = _giveGoldConfig.FindConfigByMapId(mapId);

    // Couldn't find config in giving map
    if (goldInPosition == null)
    {
        return;
    }

    // Let's find GoldPosition in our config, but the player isn't in any given cell
    if (!goldInPosition.Positions.Any(coords => coords.X == x && coords.Y == y))
    {
        return;
    }

    //Execute GenerateGoldEvent event to give player gold
    int amountOfGold = goldInPosition.AmountOfGold;
    await session.EmitEventAsync(new GenerateGoldEvent(amountOfGold));
}
```

Well, much better... but **it's just an example**.
Please remember that storing a lot of elements in the list and trying to return one of them have a very high performance cost - the better solution to this is Dictionary as I showed above.

___

### ❗ Note

Remember that everything you return from methods and change in properties of the config while server is running will be saved!
Example:

```csharp
GiveGoldInPosition goldInPosition = _giveGoldConfig.FindConfigByMapId(mapId);

if (goldInPosition == null)
{
    return;
}

goldInPosition.AmountOfGold = 100;
```

The `goldInPosition.AmountOfGold = 100` will be saved inside the memory of the server and each time someone returns the same config from the dictionary it will return `100` instead of `1` just like it was at the beginning of the config.

There are two ways to fix it:

- First one is changing all properties setters `{ set; }` into [`{ init; }`](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/proposals/csharp-9.0/init) so you can't change the value of the property while the sever is running, but only during initialization of the config.
- Second one is returning the config using [Adapt](https://github.com/MapsterMapper/Mapster/blob/master/src/Mapster/TypeAdapter.cs#L24) method:

```csharp
public GiveGoldInPosition FindConfigByMapId(int mapId)
{
    return _configs.TryGetValue(mapId, out GiveGoldInPosition config) ? config.Adapt<GiveGoldInPosition>() : null;;
}
```

*Pssst... do you remember why you couldn't receive the rewards from mini-games in Miniland? Yeah, that's why... We didn't use Adapt<>() method.*
___

The final result of the `.cs` file:

```csharp
public interface IGiveGoldConfig
{
    GiveGoldInPosition FindConfigByMapId(int mapId);
}

public class GiveGoldConfig : IGiveGoldConfig
{
    private readonly IReadOnlyDictionary<int, GiveGoldInPosition> _configs = new Dictionary<int, GiveGoldInPosition>();

    public GiveGoldConfig(IEnumerable<GiveGoldInPosition> configs)
    {
        // ToDictionary() will create a Dictionary from each element in configs list and map MapId as key
        _configs = configs.ToDictionary(x => x.MapId);
    }

    public GiveGoldInPosition FindConfigByMapId(int mapId)
    {
        return _configs.TryGetValue(mapId, out GiveGoldInPosition config) ? config : null;
    }
}

public class GiveGoldInPosition
{
    public int MapId { get; set; }
    public int AmountOfGold { get; set; }
    public List<GoldPosition> Positions { get; set; }
}

public class GoldPosition
{
    public short X { get; set; }
    public short Y { get; set; }
}
```