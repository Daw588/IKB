# Inverse Kinematics Bundle

Simple, lightweight, and performant inverse kinematics bundle for everyone.

## About :placard:

As the name implies, it’s an **I**nverse **K**inematics **B**undle, containing modules for common IK implementations, currently supporting R6 and R15 rigs, with more coming soon!

## Purpose :performing_arts:

Makes IK simple and easy to implement for common use cases with little to no knowledge about the math and logic behind the library itself, as well as keeping itself lightweight, and causing little to no impact on the CPU.

## Performance :zap:

| Module |   Method   |  Runs |  Calls | Avg. Runtime |
|:------:|:----------:|:-----:|:------:|:------------:|
| R15.AL | `:Solve()` | 1,000 | 10,000 |    28.1ms    |
| R6.Arm | `:Solve()` | 1,000 | 10,000 |    18.0ms    |
| R6.Leg | `:Solve()` | 1,000 | 10,000 |    14.5ms    |

## Credits :medal_sports:

- [@LMH_Hutch](https://devforum.roblox.com/u/LMH_Hutch) - For [R6 Arm IK](https://devforum.roblox.com/t/r6-rig-inverse-kinematics/269250/5), and [R15 IK](https://devforum.roblox.com/t/2-joint-2-limb-inverse-kinematics/252399).
- [@x_o](https://devforum.roblox.com/u/x_o) - For [R6 Leg IK](https://www.roblox.com/games/367789063).

## Installation :building_construction:

Grab this asset: <https://www.roblox.com/library/10493264838>

## Getting Started :open_book:

R15

```lua
local R15ALIK = require(script.IKB.R15.AL) -- "AL" stands for "Arm & Leg".

local LeftArmIK = R15ALIK.new(Character, "Left", "Arm")
LeftArmIK.ExtendWhenUnreachable = true -- Move body part when it normally cannot reach (do not include this line if you don't want this behavior).
LeftArmIK:Solve(Target.Position)
```

R6

```lua
local R6ArmIK = require(script.IKB.R6.Arm)

local LeftArmIK = R6ArmIK.new(Character, "Left")
-- Note: R6 does not support "ExtendWhenUnreachable" behavior yet.
LeftArmIK:Solve(Target.Position)
```

## License :judge:

[MIT License](https://choosealicense.com/licenses/mit/)