-------------------------------------------------------------------------------------------------
-- File     :  /data/projectiles/SIFLaanseTacticalMissile04/SIFLaanseTacticalMissile04_script.lua
-- Author(s):  Gordon Duclos, Aaron Lundquist
-- Summary  :  Laanse Tactical Missile Projectile script, XSB2108
-- Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
-------------------------------------------------------------------------------------------------
local SLaanseTacticalMissile = import('/lua/seraphimprojectiles.lua').SLaanseTacticalMissile
local BlackOpsEffectTemplate = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsEffectTemplates.lua')

---@class SIFLaanseTacticalMissile04 : SLaanseTacticalMissile
SIFLaanseTacticalMissile04 = Class(SLaanseTacticalMissile) {
    FxImpactUnit = BlackOpsEffectTemplate.MGHeadshotHit01,
    FxImpactAirUnit = BlackOpsEffectTemplate.MGHeadshotHit01,
    FxImpactProp = BlackOpsEffectTemplate.MGHeadshotHit01,
    FxImpactLand = BlackOpsEffectTemplate.MGHeadshotHit01,

    ---@param self SIFLaanseTacticalMissile04
    OnCreate = function(self)
        SLaanseTacticalMissile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2.0)
        self:ForkThread(self.MovementThread)
    end,

    ---@param self SIFLaanseTacticalMissile04
    ---@param targetType string
    ---@param targetEntity Entity
    OnImpact = function(self, targetType, targetEntity)
        SLaanseTacticalMissile.OnImpact(self, targetType, targetEntity)
        local army = self.Army

        local position = self:GetPosition()
        local spiritUnit1 = CreateUnitHPR('BSB2211', army, position[1], position[2], position[3], 0, 0, 0)
        local spiritUnit2 = CreateUnitHPR('BSB2211', army, position[1]+1, position[2], position[3]+1, 0, 0, 0)
        local spiritUnit3 = CreateUnitHPR('BSB2211', army, position[1]-1, position[2], position[3]+1, 0, 0, 0)
        local spiritUnit4 = CreateUnitHPR('BSB2211', army, position[1]+1, position[2], position[3]-1, 0, 0, 0)
        local spiritUnit5 = CreateUnitHPR('BSB2211', army, position[1]-1, position[2], position[3]-1, 0, 0, 0)

        -- Create effects for spawning of energy being
        for _, v in BlackOpsEffectTemplate.SerMineRiftIn_Small do
            CreateAttachedEmitter(spiritUnit1, -1, army, v):ScaleEmitter(1)
            CreateAttachedEmitter(spiritUnit2, -1, army, v):ScaleEmitter(1)
            CreateAttachedEmitter(spiritUnit3, -1, army, v):ScaleEmitter(1)
            CreateAttachedEmitter(spiritUnit4, -1, army, v):ScaleEmitter(1)
            CreateAttachedEmitter(spiritUnit5, -1, army, v):ScaleEmitter(1)
        end
    end,

    ---@param self SIFLaanseTacticalMissile04
    MovementThread = function(self)
        self.WaitTime = 0.1
        self:SetTurnRate(8)
        WaitSeconds(0.3)
        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitSeconds(self.WaitTime)
        end
    end,

    ---@param self SIFLaanseTacticalMissile04
    SetTurnRateByDist = function(self)
        local dist = self:GetDistanceToTarget()
        -- Get the nuke as close to 90 deg as possible
        if dist > 50 then
            -- Freeze the turn rate as to prevent steep angles at long distance targets
            WaitSeconds(2)
            self:SetTurnRate(20)
        elseif dist > 128 and dist <= 213 then
            self:SetTurnRate(30)
            WaitSeconds(1.5)
            self:SetTurnRate(30)
        elseif dist > 43 and dist <= 107 then
            WaitSeconds(0.3)
            self:SetTurnRate(50)
        elseif dist > 0 and dist <= 43 then
            self:SetTurnRate(100)
            KillThread(self.MoveThread)
        end
    end,

    ---@param self SIFLaanseTacticalMissile04
    ---@return nil
    GetDistanceToTarget = function(self)
        local tpos = self:GetCurrentTargetPosition()
        local mpos = self:GetPosition()
        local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
        return dist
    end,
}

TypeClass = SIFLaanseTacticalMissile04
