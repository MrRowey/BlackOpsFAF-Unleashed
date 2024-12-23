local MGQAIRocketChildProjectile = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsProjectiles.lua').MGQAIRocketChildProjectile

-- Aeon Serpentine Missile
---@class MGQAIRocket01 : MGQAIRocketChildProjectile
MGQAIRocket01 = Class(MGQAIRocketChildProjectile) {

    ---@param self MGQAIRocket01
    OnCreate = function(self)
        MGQAIRocketChildProjectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2)
        self:ForkThread(self.UpdateThread)
    end,

    ---@param self MGQAIRocket01
    UpdateThread = function(self)
        WaitSeconds(0.1)
        self:SetTurnRate(360)

        WaitSeconds(0.5)
        self:SetTurnRate(15)
    end,

    ---@param self MGQAIRocket01
    ---@param damageData table
    PassDamageData = function(self, damageData)
        MGQAIRocketChildProjectile.PassDamageData(self,damageData)
        local launcherbp = self.Launcher.Blueprint
        self.ChildDamageData = table.copy(self.DamageData)
        self.ChildDamageData.DamageAmount = launcherbp.SplitDamage.DamageAmount or 0
        self.ChildDamageData.DamageRadius = launcherbp.SplitDamage.DamageRadius or 1
    end,
}

TypeClass = MGQAIRocket01
