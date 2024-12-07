-----------------------------------------------------------------
-- File     :  /cdimage/units/UEB2303/UEB2303_script.lua
-- Author(s):  John Comes, David Tomandl, Jessica St. Croix
-- Summary  :  UEF Light Artillery Script
-- Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local BOHellstormGun = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsWeapons.lua').BOHellstormGun

-- Weapon bones for recoil effects
local muzzleBones = {'Muzzle01', 'Muzzle02', 'Muzzle03'}
local recoilgroup1 = {'Recoil_01', 'Recoil_02', 'Recoil_03'}

---@class BEB2303 : TStructureUnit
BEB2303 = Class(TStructureUnit) {

    ---@param self BEB2303
    ---@param builder Unit
    ---@param layer Layer
    OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
        local bp = self.Blueprint
        if bp.Audio.Activate then
            self:PlaySound(bp.Audio.Activate)
        end
    end,

    Weapons = {
        MainGun = Class(BOHellstormGun) {

        OnCreate = function(self)
            BOHellstormGun.OnCreate(self)
            self.CurrentBarrel = 1
            self.CurrentGoal = 120
        end,

        PlayRackRecoil = function(self, rackList)
            -- Reset the recoil table
            local recoilTbl = {}
            -- Select the barrel to recoil
            recoilTbl.MuzzleBones = muzzleBones[self.CurrentBarrel]
            recoilTbl.RackBone = recoilgroup1[self.CurrentBarrel]

            table.insert(rackList, recoilTbl)

            BOHellstormGun.PlayRackRecoil(self, rackList)

            -- Perform the recoil effects
            if not self.SpinManip then
                -- Create the cannon rotator
                self.SpinManip = CreateRotator(self.unit, 'Barrel_Rotator', 'z', self.CurrentGoal, 200, 200, 200)
                self.unit.Trash:Add(self.SpinManip)
            else
                -- Spin to the next barrel
                self.SpinManip:SetGoal(self.CurrentGoal)
                self.SpinManip:SetAccel(100)
                self.SpinManip:SetTargetSpeed(100)
            end

            -- Increment to the next barrel and goal
            self.CurrentBarrel = self.CurrentBarrel + 1
            self.CurrentGoal = self.CurrentGoal + 120

            if self.CurrentBarrel > 3 then
                self.CurrentBarrel = 1
                self.CurrentGoal = 120
            end
        end,

        PlayFxWeaponPackSequence = function(self)
            if self.SpinManip then
                self.SpinManip:SetTargetSpeed(0)
            end
            BOHellstormGun.PlayFxWeaponPackSequence(self)
        end,
        },
    },
}

TypeClass = BEB2303
