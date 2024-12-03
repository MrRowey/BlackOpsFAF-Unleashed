---------------------------------------------------------------------------------------------
-- File     :  /data/projectiles/SBOKhamaseenBombEffect05/SBOKhamaseenBombEffect06_script.lua
-- Author(s):  Greg Kohne
-- Summary  :  Ohwalli Strategic Bomb effect script, non-damaging
-- Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
---------------------------------------------------------------------------------------------

local BlackOpsEffectTemplate = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsEffectTemplates.lua')

---@class InqDeathBombEffect06 : EmitterProjectile
InqDeathBombEffect06 = Class(import('/lua/sim/defaultprojectiles.lua').EmitterProjectile) {
    FxTrails = BlackOpsEffectTemplate.GoldLaserBombHitRingProjectileFxTrails06,
    FxTrailScale = 0.3,
}

TypeClass = InqDeathBombEffect06
