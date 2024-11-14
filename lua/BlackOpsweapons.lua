-----------------------------------------------------------------
-- File     :  /cdimage/lua/BlackOpsWeapons.lua
-- Author(s):  Lt_hawkeye
-- Summary  :
-- Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local WeaponFile = import('/lua/sim/defaultweapons.lua')
local CollisionBeams = import('/lua/defaultcollisionbeams.lua')
local CollisionBeamFile = import('/lua/defaultcollisionbeams.lua')
local BlackOpsCollisionBeamFile = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsDefaultCollisionBeams.lua')
local MiniQuantumBeamGeneratorCollisionBeam = BlackOpsCollisionBeamFile.MiniQuantumBeamGeneratorCollisionBeam
local SuperQuantumBeamGeneratorCollisionBeam = BlackOpsCollisionBeamFile.SuperQuantumBeamGeneratorCollisionBeam
local HawkTractorClawCollisionBeam = BlackOpsCollisionBeamFile.HawkTractorClawCollisionBeam
local MiniPhasonLaserCollisionBeam = BlackOpsCollisionBeamFile.MiniPhasonLaserCollisionBeam
local YenaothaExperimentalLaserCollisionBeam = BlackOpsCollisionBeamFile.YenaothaExperimentalLaserCollisionBeam
local TDFGoliathCollisionBeam = BlackOpsCollisionBeamFile.TDFGoliathCollisionBeam
local JuggLaserCollisionBeam = BlackOpsCollisionBeamFile.JuggLaserCollisionBeam
local MartyrMicrowaveLaserCollisionBeam01 = BlackOpsCollisionBeamFile.MartyrMicrowaveLaserCollisionBeam01
local GoldenLaserCollisionBeam01 = BlackOpsCollisionBeamFile.GoldenLaserCollisionBeam01
local KamikazeWeapon = WeaponFile.KamikazeWeapon
local BareBonesWeapon = WeaponFile.BareBonesWeapon
local DefaultProjectileWeapon = WeaponFile.DefaultProjectileWeapon
local DefaultBeamWeapon = WeaponFile.DefaultBeamWeapon
local GinsuCollisionBeam = CollisionBeams.GinsuCollisionBeam
local EffectTemplate = import('/lua/EffectTemplates.lua')
local BlackOpsEffectTemplate = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsEffectTemplates.lua')
local QuantumBeamGeneratorCollisionBeam = CollisionBeamFile.QuantumBeamGeneratorCollisionBeam
local PhasonLaserCollisionBeam = CollisionBeamFile.PhasonLaserCollisionBeam
local MicrowaveLaserCollisionBeam01 = CollisionBeamFile.MicrowaveLaserCollisionBeam01

HawkNapalmWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.TGaussCannonFlash,
}

RebelArtilleryProtonWeapon = Class(DefaultProjectileWeapon) {
}

MiniQuantumBeamGenerator = Class(DefaultBeamWeapon) {
    BeamType = BlackOpsCollisionBeamFile.MiniQuantumBeamGeneratorCollisionBeam,

    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 0.2,

    PlayFxWeaponUnpackSequence = function(self)
        local army = self.unit:GetArmy()
        local bp = self.Blueprint
        for k, v in self.FxUpackingChargeEffects do
            for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale):ScaleEmitter(0.2)
            end
        end
        DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
    end,
}

SuperQuantumBeamGenerator = Class(DefaultBeamWeapon) {
    BeamType = BlackOpsCollisionBeamFile.SuperQuantumBeamGeneratorCollisionBeam,

    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function(self)
        local army = self.unit:GetArmy()
        local bp = self.Blueprint
        for k, v in self.FxUpackingChargeEffects do
            for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale):ScaleEmitter(1)
            end
        end
        DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
    end,
}

MiniPhasonLaser = Class(DefaultBeamWeapon) {
    BeamType = BlackOpsCollisionBeamFile.MiniPhasonLaserCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 0.002,

    PlayFxWeaponUnpackSequence = function(self)
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self.Blueprint
            for k, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale):ScaleEmitter(0.002)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}

-- SPIDER BOT WEAPON!
MiniHeavyMicrowaveLaserGenerator = Class(DefaultBeamWeapon) {
    BeamType = BlackOpsCollisionBeamFile.MiniMicrowaveLaserCollisionBeam01,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 1,

    IdleState = State(DefaultBeamWeapon.IdleState) {
        Main = function(self)
            if self.RotatorManip then
                self.RotatorManip:SetSpeed(0)
            end
            if self.SliderManip then
                self.SliderManip:SetGoal(0,0,0)
                self.SliderManip:SetSpeed(2)
            end
            DefaultBeamWeapon.IdleState.Main(self)
        end,
    },

    CreateProjectileAtMuzzle = function(self, muzzle)
        if not self.SliderManip then
            self.SliderManip = CreateSlider(self.unit, 'Center_Turret_Barrel')
            self.unit.Trash:Add(self.SliderManip)
        end
        if not self.RotatorManip then
            self.RotatorManip = CreateRotator(self.unit, 'Center_Turret_Barrel', 'z')
            self.unit.Trash:Add(self.RotatorManip)
        end
        self.RotatorManip:SetSpeed(180)
        self.SliderManip:SetPrecedence(11)
        self.SliderManip:SetGoal(0, 0, -1)
        self.SliderManip:SetSpeed(-1)
        DefaultBeamWeapon.CreateProjectileAtMuzzle(self, muzzle)
    end,

    PlayFxWeaponUnpackSequence = function(self)
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self.Blueprint
            for k, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale):ScaleEmitter(0.2)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}

HawkTractorClaw = Class(DefaultBeamWeapon) {
    BeamType = HawkTractorClawCollisionBeam,
    FxMuzzleFlash = {},

    PlayFxBeamStart = function(self, muzzle)
        local target = self:GetCurrentTarget()
        if not target or
            EntityCategoryContains(categories.STRUCTURE, target) or
            EntityCategoryContains(categories.COMMAND, target) or
            EntityCategoryContains(categories.EXPERIMENTAL, target) or
            EntityCategoryContains(categories.NAVAL, target) or
            EntityCategoryContains(categories.SUBCOMMANDER, target) or
           EntityCategoryContains(categories.TECH3, target) or
            not EntityCategoryContains(categories.ALLUNITS, target) then
            return
        end
        DefaultBeamWeapon.PlayFxBeamStart(self, muzzle)

        self.TT1 = self:ForkThread(self.TractorThread, target)
        self:ForkThread(self.TractorWatchThread, target)
    end,

    OnLostTarget = function(self)
        self:AimManipulatorSetEnabled(true)
        DefaultBeamWeapon.OnLostTarget(self)
    end,

    TractorThread = function(self, target)
        self.unit.Trash:Add(target)
        local beam = self.Beams[1].Beam
        if not beam then return end


        local muzzle = self.Blueprint.MuzzleSpecial
        if not muzzle then return end


        local pos0 = beam:GetPosition(0)
        local pos1 = beam:GetPosition(1)

        local dist = VDist3(pos0, pos1)

        self.Slider = CreateSlider(self.unit, muzzle, 0, 0, dist, -1, true)

        WaitFor(self.Slider)

        target:AttachBoneTo(-1, self.unit, muzzle)

        self.AimControl:SetResetPoseTime(10)
        target:SetDoNotTarget(true)

        self.Slider:SetSpeed(15)
        self.Slider:SetGoal(0,0,0)

        WaitFor(self.Slider)

        if not target.Dead then
            target:Kill()
        end
        self.AimControl:SetResetPoseTime(2)
    end,

    TractorWatchThread = function(self, target)
        while not target.Dead do
            WaitTicks(1)
        end
        KillThread(self.TT1)
        self.TT1 = nil
        if self.Slider then
            self.Slider:Destroy()
            self.Slider = nil
        end
        self.unit:DetachAll(self.Blueprint.MuzzleSpecial or 0)
        self:ResetTarget()
        self.AimControl:SetResetPoseTime(2)
    end,
}

-- SeaDragon Battleship WEAPON!
MartyrHeavyMicrowaveLaserGenerator = Class(DefaultBeamWeapon) {
    BeamType = BlackOpsCollisionBeamFile.MartyrMicrowaveLaserCollisionBeam01,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 1,
}

-- ShadowCat WEAPON!
RailLaserGenerator = Class(DefaultBeamWeapon) {
    BeamType = BlackOpsCollisionBeamFile.RailLaserCollisionBeam01,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 1,
}

--UEF heavy tank railgun and laser
RailGunWeapon01 = Class(DefaultProjectileWeapon) {
    FxChargeMuzzleFlash = {
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/x_cannon_charge_test_01_emit.bp',
    },
    FxMuzzleFlash = {
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/xcannon_cannon_muzzle_01_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/x_cannon_fire_test_01_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/jugg_rail_cannon_muzzle_07_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/jugg_rail_cannon_muzzle_08_emit.bp',
    },
    FxMuzzleFlashScale = 0.25,
    FxChargeMuzzleFlashScale = 0.25,
}

RailGunWeapon02 = Class(DefaultProjectileWeapon) {
    FxChargeMuzzleFlash = {
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/x_cannon_charge_test_01_emit.bp',
    },
    FxMuzzleFlash = {
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/xcannon_cannon_muzzle_01_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/x_cannon_fire_test_01_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/jugg_rail_cannon_muzzle_07_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/jugg_rail_cannon_muzzle_08_emit.bp',
    },
    FxMuzzleFlashScale = 0.75,
    FxChargeMuzzleFlashScale = 0.75,
}

JuggLaserweapon = Class(DefaultBeamWeapon) {
    BeamType = JuggLaserCollisionBeam,

    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 0.2,

    PlayFxWeaponUnpackSequence = function(self)
        local army = self.unit:GetArmy()
        local bp = self.Blueprint
        for k, v in self.FxUpackingChargeEffects do
            for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale):ScaleEmitter(0.2)
            end
        end
        DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
    end,
}

-- SeaDragon Weapon
XCannonWeapon01 = Class(DefaultProjectileWeapon) {
    FxMuzzleFlashScale = 1.2,
    FxChargeMuzzleFlashScale = 5,
}

-- Cybran Hailfire
HailfireLauncherWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = BlackOpsEffectTemplate.HailfireLauncherExhaust,
}

ShadowCannonWeapon01 = Class(DefaultProjectileWeapon) {
    FxChargeMuzzleFlash = {
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/shadow_muzzle_charge_01_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/shadow_muzzle_charge_02_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/shadow_muzzle_charge_05_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/shadow_muzzle_charge_04_emit.bp',
    },

    FxMuzzleFlash = {
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/shadow_cannon_muzzle_01_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/shadow_cannon_muzzle_02_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/shadow_cannon_muzzle_05_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/shadow_cannon_muzzle_06_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/shadow_cannon_muzzle_07_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/shadow_cannon_muzzle_08_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/shadow_hit_10_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/shadow_muzzle_flash_01_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/shadow_muzzle_flash_02_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/shadow_muzzle_flash_03_emit.bp',
    },

    FxMuzzleFlashScale = 0.5,
    FxChargeMuzzleFlashScale = 1,
}

BassieCannonWeapon01 = Class(DefaultProjectileWeapon) {
    FxChargeMuzzleFlash = {
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/shadow_muzzle_charge_01_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/shadow_muzzle_charge_02_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/shadow_muzzle_charge_05_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/shadow_muzzle_charge_04_emit.bp',
    },

    FxMuzzleFlash = {
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/bassie_cannon_muzzle_01_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/bassie_cannon_muzzle_02_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/bassie_cannon_muzzle_05_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/bassie_cannon_muzzle_06_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/bassie_cannon_muzzle_07_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/bassie_cannon_muzzle_08_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/bassie_hit_10_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/bassie_muzzle_flash_01_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/bassie_muzzle_flash_02_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/bassie_muzzle_flash_03_emit.bp',
    },
    FxMuzzleFlashScale = 0.5,
    FxChargeMuzzleFlashScale = 1,
}

-- T3 PD stun weapon Cybran
StunZapperWeapon = Class(DefaultBeamWeapon) {
    BeamType = BlackOpsCollisionBeamFile.EMCHPRFDisruptorBeam,
    FxMuzzleFlash = {'/effects/emitters/cannon_muzzle_flash_01_emit.bp',},
    FxMuzzleFlashScale = 2,
}

ZCannonWeapon = Class(DefaultProjectileWeapon) {
    FxChargeMuzzleFlash = BlackOpsEffectTemplate.ZCannonChargeMuzzleFlash,
    FxMuzzleFlash = BlackOpsEffectTemplate.ZCannonMuzzleFlash,
    FxMuzzleFlashScale = 2.5,
    Version = 1,

    PlayFxRackSalvoReloadSequence = function(self)
        for i = 1, 40 do
        local fxname
            if i < 10 then
                fxname = 'AMC' .. self.Cannon .. 'Steam0' .. i
            else
                fxname = 'AMC' .. self.Cannon .. 'Steam' .. i
            end
            for k, v in self.unit.SteamEffects do
                table.insert(self.unit.SteamEffectsBag, CreateAttachedEmitter(self.unit, fxname, self.unit:GetArmy(), v))
            end
        end
        ZCannonWeapon.PlayFxRackSalvoChargeSequence(self)
    end,
}

YCannonWeapon = Class(DefaultProjectileWeapon) {
    FxChargeMuzzleFlash = BlackOpsEffectTemplate.YCannonMuzzleChargeFlash,
    FxMuzzleFlash = BlackOpsEffectTemplate.YCannonMuzzleFlash,
    FxMuzzleFlashScale = 2,
}

ScorpDisintegratorWeapon = Class(DefaultProjectileWeapon) {
    FxChargeMuzzleFlash = {},
    FxMuzzleFlash = {
        '/effects/emitters/disintegratorhvy_muzzle_flash_01_emit.bp',
        '/effects/emitters/disintegratorhvy_muzzle_flash_02_emit.bp',
        '/effects/emitters/disintegratorhvy_muzzle_flash_03_emit.bp',
        '/effects/emitters/disintegratorhvy_muzzle_flash_04_emit.bp',
        '/effects/emitters/disintegratorhvy_muzzle_flash_05_emit.bp',
    },
    FxMuzzleFlashScale = 0.2,
}

HawkMissileTacticalSerpentineWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = {'/effects/emitters/aeon_missile_launch_02_emit.bp',},
}

LambdaWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.SDFExperimentalPhasonProjMuzzleFlash,
    FxChargeMuzzleFlash = EffectTemplate.SDFExperimentalPhasonProjChargeMuzzleFlash,
}

ArtemisWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = BlackOpsEffectTemplate.ArtemisMuzzleFlash,
    FxChargeMuzzleFlash = BlackOpsEffectTemplate.ArtemisMuzzleChargeFlash,
    FxMuzzleFlashScale = 2,
    FxChargeMuzzleFlashScale = 2,
}

TDFGoliathShoulderBeam = Class(DefaultBeamWeapon) {
    BeamType = BlackOpsCollisionBeamFile.TDFGoliathCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function(self)
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self.Blueprint
            for k, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}

HawkGaussCannonWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.TGaussCannonFlash,
}

UEFNavyMineWeapon = Class(KamikazeWeapon){
    FxDeath = BlackOpsEffectTemplate.NavalMineHit01,

    OnFire = function(self)
        local army = self.unit:GetArmy()
        for k, v in self.FxDeath do
            CreateEmitterAtBone(self.unit,-2,army,v)
        end
        KamikazeWeapon.OnFire(self)
    end,
}

UEFNavyMineDeathWeapon = Class(BareBonesWeapon) {
    FxDeath = BlackOpsEffectTemplate.NavalMineHit01,

    OnCreate = function(self)
        BareBonesWeapon.OnCreate(self)
        self:SetWeaponEnabled(false)
    end,

    OnFire = function(self)
    end,

    Fire = function(self)
        local army = self.unit:GetArmy()
        for k, v in self.FxDeath do
            CreateEmitterAtBone(self.unit,-2,army,v)
        end
        local myBlueprint = self.Blueprint
        DamageArea(self.unit, self.unit:GetPosition(), myBlueprint.DamageRadius, myBlueprint.Damage, myBlueprint.DamageType or 'Normal', myBlueprint.DamageFriendly or false)
    end,
}

AeonMineDeathWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = {
        '/effects/emitters/default_muzzle_flash_01_emit.bp',
        '/effects/emitters/default_muzzle_flash_02_emit.bp',
        '/effects/emitters/torpedo_underwater_launch_01_emit.bp',
    },
    OnWeaponFired = function(self)
        self.unit:Kill()
    end,
}

SeraNavyMineWeapon = Class(KamikazeWeapon){
    FxDeath = BlackOpsEffectTemplate.SDFExperimentalPhasonProjHit01,

    OnFire = function(self)
        local army = self.unit:GetArmy()
        for k, v in self.FxDeath do
            CreateEmitterAtBone(self.unit,-2,army,v)
        end
        KamikazeWeapon.OnFire(self)
    end,
}

SeraNavyMineDeathWeapon = Class(BareBonesWeapon) {
    FxDeath = BlackOpsEffectTemplate.MineExplosion01,

    OnCreate = function(self)
        BareBonesWeapon.OnCreate(self)
        self:SetWeaponEnabled(false)
    end,


    OnFire = function(self)
    end,

    Fire = function(self)
        local army = self.unit:GetArmy()
        for k, v in self.FxDeath do
            CreateEmitterAtBone(self.unit,-2,army,v)
        end
        local myBlueprint = self.Blueprint
        DamageArea(self.unit, self.unit:GetPosition(), myBlueprint.DamageRadius, myBlueprint.Damage, myBlueprint.DamageType or 'Normal', myBlueprint.DamageFriendly or false)
    end,
}

SeraMineDeathExplosion = Class(BareBonesWeapon) {
    FxDeath = BlackOpsEffectTemplate.MineExplosion01,

    OnCreate = function(self)
        BareBonesWeapon.OnCreate(self)
        self:SetWeaponEnabled(false)
    end,


    OnFire = function(self)
    end,

    Fire = function(self)
        local army = self.unit:GetArmy()
        for k, v in self.FxDeath do
            CreateEmitterAtBone(self.unit,-2,army,v)
        end
        local myBlueprint = self.Blueprint
        DamageArea(self.unit, self.unit:GetPosition(), myBlueprint.DamageRadius, myBlueprint.Damage, myBlueprint.DamageType or 'Normal', myBlueprint.DamageFriendly or false)
    end,
}

SeraMineExplosion = Class(KamikazeWeapon){
    FxDeath = BlackOpsEffectTemplate.MineExplosion01,

    OnFire = function(self)
        local army = self.unit:GetArmy()
        for k, v in self.FxDeath do
            CreateEmitterAtBone(self.unit,-2,army,v)
        end
        KamikazeWeapon.OnFire(self)
    end,
}

MGAALaserWeapon = Class(DefaultBeamWeapon) {
    BeamType = BlackOpsCollisionBeamFile.MGAALaserCollisionBeam,
    FxMuzzleFlash = {'/effects/emitters/particle_cannon_muzzle_01_emit.bp'},
}

GoldenLaserGenerator = Class(DefaultBeamWeapon) {
    BeamType = BlackOpsCollisionBeamFile.GoldenLaserCollisionBeam01,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
}

RedHeavyTurboLaserWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = BlackOpsEffectTemplate.RedLaserMuzzleFlash01,
}

ArtemisLaserGenerator = Class(DefaultBeamWeapon) {
    BeamType = BlackOpsCollisionBeamFile.GoldenLaserCollisionBeam01,
    FxMuzzleFlash = BlackOpsEffectTemplate.ArtemisMuzzleFlash,
    FxMuzzleFlashEffectScale = 0.5,
    FxChargeMuzzleFlash = {},
}

BOHellstormGun = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.TIFArtilleryMuzzleFlash,
    FxShellEject  = BlackOpsEffectTemplate.HellStormGunShells,

    PlayFxMuzzleSequence = function(self, muzzle)
        DefaultProjectileWeapon.PlayFxMuzzleSequence(self, muzzle)
        for k, v in self.FxShellEject do
            CreateAttachedEmitter(self.unit, 'Spew', self.unit:GetArmy(), v)
        end
    end,
}

GoliathTMDGun = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.TPhalanxGunMuzzleFlash,
    FxShellEject  = EffectTemplate.TPhalanxGunShells,

    PlayFxMuzzleSequence = function(self, muzzle)
        DefaultProjectileWeapon.PlayFxMuzzleSequence(self, muzzle)
        for k, v in self.FxShellEject do
            CreateAttachedEmitter(self.unit, 'TMD_Barrel', self.unit:GetArmy(), v)
        end
    end,
}

YenzothaExperimentalLaser = Class(DefaultBeamWeapon) {
    BeamType = BlackOpsCollisionBeamFile.YenaothaExperimentalLaserCollisionBeam,
    FxUpackingChargeEffects = EffectTemplate.SDFExperimentalPhasonProjChargeMuzzleFlash,
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function(self)
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self.Blueprint
            for k, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}

YenzothaExperimentalLaser02 = Class(DefaultBeamWeapon) {
    BeamType = BlackOpsCollisionBeamFile.YenaothaExperimentalLaser02CollisionBeam,
    FxUpackingChargeEffects = EffectTemplate.SDFExperimentalPhasonProjChargeMuzzleFlash,
    FxUpackingChargeEffectScale = 0.2,

    PlayFxWeaponUnpackSequence = function(self)
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self.Blueprint
            for k, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}

GoliathRocket02 = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.TIFCruiseMissileLaunchSmoke,
}

-- Goliath rocket script from the Nomads mod
GoliathRocket = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.TIFCruiseMissileLaunchSmoke,

    CreateProjectileForWeapon = function(self, bone)
        local f_count = table.getn(self.Blueprint.RackBones[1].MuzzleBones)
        if not self.FireCounter or self.FireCounter == f_count then self.FireCounter = 0 end
        if not self.TargetTable then self.TargetTable = {} end
        if self.FireCounter == 0 then
            if self:GetCurrentTarget() then
                local PossibleTargetTable
                local aiBrain = self.unit:GetAIBrain()

                if self:GetCurrentTarget() then
                    PossibleTargetTable = aiBrain:GetUnitsAroundPoint(categories.LAND + (categories.STRUCTURE) , self.unit:GetPosition(), self.Blueprint.MaxRadius ,'ENEMY')
                    self.TargetTable = nil
                end

                if not self.TargetTable then self.TargetTable = {} end

                local targetcount = table.getn(PossibleTargetTable)
                local tablecounter = 0

                if targetcount >= f_count then
                    local max_targets = table.getn(PossibleTargetTable)
                    local ran_values = {}
                    repeat
                        local ra = Random(1, max_targets)
                        repeat
                            if table.find(ran_values, ra) then ra = Random(1, max_targets) end
                        until not table.find(ran_values, ra)

                        table.insert(ran_values, ra)
                    until table.getn(ran_values) >= f_count

                    for k, v in ran_values do
                        table.insert(self.TargetTable, PossibleTargetTable[v])
                        tablecounter = tablecounter + 1
                        if tablecounter >= f_count then
                            break
                        end
                    end
                else
                    for k, v in PossibleTargetTable do
                        table.insert(self.TargetTable, v)
                        tablecounter = tablecounter + 1
                        if tablecounter >= targetcount then
                        break
                        end
                    end
                end
            end
        end

        self.FireCounter = self.FireCounter + 1
        local TableSize = table.getn(self.TargetTable)
        local n = self.FireCounter
        if self.TargetTable then
            if TableSize >= 1 then
                if TableSize == f_count then
                    local tar = self.TargetTable[n]
                    if not tar:BeenDestroyed() and not tar.Dead then
                        self:SetTargetEntity(tar)
                        CreateAttachedEmitter(tar, 0, tar:GetArmy(), '/mods/BlackOpsFAF-Unleashed/effects/emitters/targeted_effect_01_emit.bp'):OffsetEmitter(0, 0.5,0)
                    end
                else
                    local ran = Random(1, TableSize)
                    local tar = self.TargetTable[ran]
                    if not tar:BeenDestroyed() and not tar.Dead then
                        self:SetTargetEntity(tar)
                        if tar.Pointed ~= true then
                            CreateAttachedEmitter(tar, 0, tar:GetArmy(), '/mods/BlackOpsFAF-Unleashed/effects/emitters/targeted_effect_01_emit.bp'):OffsetEmitter(0, 0.5,0)
                            tar.Pointed = true
                            tar:ForkThread(self.PointedThread, self)
                        end
                    end
                end
            end
        end
        GoliathRocket02.CreateProjectileForWeapon(self, bone)
    end,

    OnWeaponFired = function(self)
        self.FireCounter = 0
        GoliathRocket02.OnWeaponFired(self)
    end,

    PointedThread = function(tar, self)
        WaitSeconds(5)
        tar.Pointed = false
    end,
}

BasiliskAAMissile02 = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = {
        '/effects/emitters/cannon_muzzle_flash_04_emit.bp',
        '/effects/emitters/cannon_muzzle_smoke_11_emit.bp',
    },
}

BasiliskAAMissile01 = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = {
        '/effects/emitters/cannon_muzzle_flash_04_emit.bp',
        '/effects/emitters/cannon_muzzle_smoke_11_emit.bp',
    },

    CreateProjectileForWeapon = function(self, bone)
            local f_count = table.getn(self.Blueprint.RackBones[1].MuzzleBones)
            if not self.FireCounter or self.FireCounter == f_count then self.FireCounter = 0 end
            if not self.TargetTable then self.TargetTable = {} end

            if self.FireCounter == 0 then
                if self:GetCurrentTarget() then
                    local PossibleTargetTable
                    local aiBrain = self.unit:GetAIBrain()

                    if self:GetCurrentTarget() then
                        PossibleTargetTable = aiBrain:GetUnitsAroundPoint(categories.AIR , self.unit:GetPosition(), self.Blueprint.MaxRadius ,'ENEMY')
                        self.TargetTable = nil
                    end

                    if not self.TargetTable then self.TargetTable = {} end

                    local targetcount = table.getn(PossibleTargetTable)
                    local tablecounter = 0

                    if targetcount >= f_count then
                        local max_targets = table.getn(PossibleTargetTable)
                        local ran_values = {}
                        repeat
                            local ra = Random(1, max_targets)
                            repeat
                                if table.find(ran_values, ra) then ra = Random(1, max_targets) end
                            until not table.find(ran_values, ra)

                            table.insert(ran_values, ra)
                        until table.getn(ran_values) >= f_count

                        for k, v in ran_values do
                            table.insert(self.TargetTable, PossibleTargetTable[v])
                            tablecounter = tablecounter + 1
                            if tablecounter >= f_count then
                                break
                            end
                        end

                    else
                        for k, v in PossibleTargetTable do
                            table.insert(self.TargetTable, v)
                            tablecounter = tablecounter + 1
                            if tablecounter >= targetcount then
                                break
                            end
                        end
                    end
                end
            end

            self.FireCounter = self.FireCounter + 1
            local TableSize = table.getn(self.TargetTable)
            local n = self.FireCounter
            if self.TargetTable then
                if TableSize >= 1 then
                    if TableSize == f_count then
                        local tar = self.TargetTable[n]
                        if not tar:BeenDestroyed() and not tar.Dead then
                            self:SetTargetEntity(tar)
                        end
                    else
                        local ran = Random(1, TableSize)
                        local tar = self.TargetTable[ran]
                        if not tar:BeenDestroyed() and not tar.Dead then
                            self:SetTargetEntity(tar)
                            if tar.Pointed ~= true then
                                tar.Pointed = true
                                tar:ForkThread(self.PointedThread, self)
                            end
                        end
                    end
                end
            end
        BasiliskAAMissile02.CreateProjectileForWeapon(self, bone)
    end,

    OnWeaponFired = function(self)
        self.FireCounter = 0
        BasiliskAAMissile02.OnWeaponFired(self)
    end,

    PointedThread = function(tar, self)
        WaitSeconds(5)
        tar.Pointed = false
    end,
}

ATeleWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.TIFArtilleryMuzzleFlash
}

JuggPlasmaGatlingCannonWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = BlackOpsEffectTemplate.JuggPlasmaGatlingCannonMuzzleFlash,
    FxShellEject  = BlackOpsEffectTemplate.JuggPlasmaGatlingCannonShells,
    FxMuzzleFlashScale = 0.5,

    PlayFxMuzzleSequence = function(self, muzzle)
        DefaultProjectileWeapon.PlayFxMuzzleSequence(self, muzzle)
        for k, v in self.FxShellEject do
            CreateAttachedEmitter(self.unit, 'Left_Shells', self.unit:GetArmy(), v):ScaleEmitter(0.5)
            CreateAttachedEmitter(self.unit, 'Right_Shells', self.unit:GetArmy(), v):ScaleEmitter(0.5)
        end
    end,
}

CitadelHVMWeapon02 = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.TAAMissileLaunch,
}

CitadelHVMWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EffectTemplate.TAAMissileLaunch,

    CreateProjectileForWeapon = function(self, bone)
        local f_count = table.getn(self.Blueprint.RackBones[1].MuzzleBones)
        if not self.FireCounter or self.FireCounter == f_count then self.FireCounter = 0 end
        if not self.TargetTable then self.TargetTable = {} end

        if self.FireCounter == 0 then
            if self:GetCurrentTarget() then
                local PossibleTargetTable
                local aiBrain = self.unit:GetAIBrain()

                if self:GetCurrentTarget() then
                    PossibleTargetTable = aiBrain:GetUnitsAroundPoint(categories.AIR , self.unit:GetPosition(), self.Blueprint.MaxRadius ,'ENEMY')
                    self.TargetTable = nil
                end

                if not self.TargetTable then self.TargetTable = {} end

                local targetcount = table.getn(PossibleTargetTable)
                local tablecounter = 0

                if targetcount >= f_count then
                    local max_targets = table.getn(PossibleTargetTable)
                    local ran_values = {}
                    repeat
                        local ra = Random(1, max_targets)
                        repeat
                            if table.find(ran_values, ra) then ra = Random(1, max_targets) end
                        until not table.find(ran_values, ra)

                        table.insert(ran_values, ra)
                    until table.getn(ran_values) >= f_count

                    for k, v in ran_values do
                        table.insert(self.TargetTable, PossibleTargetTable[v])
                        tablecounter = tablecounter + 1
                        if tablecounter >= f_count then
                            break
                        end
                    end

                else
                    for k, v in PossibleTargetTable do
                        table.insert(self.TargetTable, v)
                        tablecounter = tablecounter + 1
                        if tablecounter >= targetcount then
                            break
                        end
                    end
                end
            end
        end

        self.FireCounter = self.FireCounter + 1
        local TableSize = table.getn(self.TargetTable)
        local n = self.FireCounter
        if self.TargetTable then
            if TableSize >= 1 then
                if TableSize == f_count then
                    local tar = self.TargetTable[n]
                    if not tar:BeenDestroyed() and not tar.Dead then
                        self:SetTargetEntity(tar)
                    end
                else
                    local ran = Random(1, TableSize)
                    local tar = self.TargetTable[ran]
                    if not tar:BeenDestroyed() and not tar.Dead then
                        self:SetTargetEntity(tar)
                        if tar.Pointed ~= true then
                            tar.Pointed = true
                            tar:ForkThread(self.PointedThread, self)
                        end
                    end
                end
            end
        end
        CitadelHVMWeapon02.CreateProjectileForWeapon(self, bone)
    end,

    OnWeaponFired = function(self)
        self.FireCounter = 0
        CitadelHVMWeapon02.OnWeaponFired(self)
    end,

    PointedThread = function(tar, self)
        WaitSeconds(5)
        tar.Pointed = false
    end,
}

CitadelPlasmaGatlingCannonWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = BlackOpsEffectTemplate.JuggPlasmaGatlingCannonMuzzleFlash,
    FxShellEject  = BlackOpsEffectTemplate.JuggPlasmaGatlingCannonShells,
    FxMuzzleFlashScale = 0.5,

    PlayFxMuzzleSequence = function(self, muzzle)
        DefaultProjectileWeapon.PlayFxMuzzleSequence(self, muzzle)
        for k, v in self.FxShellEject do
            CreateAttachedEmitter(self.unit, 'Gat_Shells', self.unit:GetArmy(), v):ScaleEmitter(0.5)
        end
    end,
}
