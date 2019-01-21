-----------------------------------------------------------------
-- File     :  /cdimage/units/UAB0303/UAB0303_script.lua
-- Author(s):  John Comes, David Tomandl, Gordon Duclos
-- Summary  :  Aeon Tier 3 Naval Factory Script
-- Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------
local SSeaFactoryUnit = import('/lua/seraphimunits.lua').SSeaFactoryUnit
BSB0004 = Class(SSeaFactoryUnit) {
    OnCreate = function(self)
        SSeaFactoryUnit.OnCreate(self)
        local bp = self:GetBlueprint()
        self.Rotator1 = CreateRotator(self, 'Pod01', 'y', nil, 8, 0, 0)
        self.Trash:Add(self.Rotator1)

        self.Rotator2 = CreateRotator(self, 'Pod02', 'y', nil, 8, 0, 0)
        self.Trash:Add(self.Rotator2)

        self.Rotator3 = CreateRotator(self, 'Pod03', 'y', nil, 8, 0, 0)
        self.Trash:Add(self.Rotator3)
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        self.Rotator1:SetSpeed(0)
        self.Rotator2:SetSpeed(0)
        self.Rotator3:SetSpeed(0)
        SSeaFactoryUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    -- Make this unit invulnerable
    OnDamage = function()
    end,
}

TypeClass = BSB0004
