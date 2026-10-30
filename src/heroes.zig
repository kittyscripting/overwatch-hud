const cell = @import("cell.zig");
const actor = @import("overwatch").actor;

pub const icon_edge: u32 = 64;
pub const icon_bytes: usize = icon_edge * icon_edge * 4;

pub const Pixels = *const [icon_bytes]u8;

pub const SlotMeta = struct {
    kind: cell.Kind,
    slot: u8,
    ultimate: bool,
};

pub const Hero = struct {
    type_id: u64,
    portrait: Pixels,
    icons: []const Pixels,
    slots: []const SlotMeta,
};

fn icon(comptime path: []const u8) Pixels {
    const data = @embedFile(path);
    if (data.len != icon_bytes) @compileError(path ++ " is not a 64x64 BGRA icon");
    return data[0..icon_bytes];
}

fn slot(comptime Decl: type) SlotMeta {
    return .{
        .kind = switch (Decl.kind) {
            .cooldown => .cooldown,
            .charged => .charged,
            .passive => .passive,
        },
        .slot = Decl.slot,
        .ultimate = Decl.button == .ultimate,
    };
}

pub const heroes = [_]Hero{
    .{
        .type_id = actor.ana.type_id,
        .portrait = icon("portraits/ana.bmp"),
        .icons = &.{
            icon("abilities/ana/sleep_dart.bmp"),
            icon("abilities/ana/biotic_grenade.bmp"),
            icon("abilities/ana/nano_boost.bmp"),
        },
        .slots = &.{
            slot(actor.ana.sleep_dart),
            slot(actor.ana.nade),
            slot(actor.ana.ultimate),
        },
    },
    .{
        .type_id = actor.anran.type_id,
        .portrait = icon("portraits/anran.bmp"),
        .icons = &.{
            icon("abilities/anran/inferno_rush.bmp"),
            icon("abilities/anran/dancing_blaze.bmp"),
            icon("abilities/anran/vermillion_ascent.bmp"),
        },
        .slots = &.{
            slot(actor.anran.bubble),
            slot(actor.anran.dancing_blaze),
            slot(actor.anran.ultimate),
        },
    },
    .{
        .type_id = actor.ashe.type_id,
        .portrait = icon("portraits/ashe.bmp"),
        .icons = &.{
            icon("abilities/ashe/coach_gun.bmp"),
            icon("abilities/ashe/dynamite.bmp"),
            icon("abilities/ashe/b_o_b.bmp"),
        },
        .slots = &.{
            slot(actor.ashe.coach_gun),
            slot(actor.ashe.dynamite),
            slot(actor.ashe.ultimate),
        },
    },
    .{
        .type_id = actor.baptiste.type_id,
        .portrait = icon("portraits/baptiste.bmp"),
        .icons = &.{
            icon("abilities/baptiste/regenerative_burst.bmp"),
            icon("abilities/baptiste/immortality_field.bmp"),
            icon("abilities/baptiste/amplification_matrix.bmp"),
        },
        .slots = &.{
            slot(actor.baptiste.burst),
            slot(actor.baptiste.immortality_field),
            slot(actor.baptiste.ultimate),
        },
    },
    .{
        .type_id = actor.bastion.type_id,
        .portrait = icon("portraits/bastion.bmp"),
        .icons = &.{
            icon("abilities/bastion/reconfigure.bmp"),
            icon("abilities/bastion/a_36_tactical_grenade.bmp"),
            icon("abilities/bastion/configuration_artillery.bmp"),
        },
        .slots = &.{
            slot(actor.bastion.reconfigure),
            slot(actor.bastion.a36_tactical_grenade),
            slot(actor.bastion.ultimate),
        },
    },
    .{
        .type_id = actor.bastion.artillery.type_id,
        .portrait = icon("portraits/bastion.bmp"),
        .icons = &.{},
        .slots = &.{},
    },
    .{
        .type_id = actor.brigitte.type_id,
        .portrait = icon("portraits/brigitte.bmp"),
        .icons = &.{
            icon("abilities/brigitte/whip_shot.bmp"),
            icon("abilities/brigitte/repair_pack.bmp"),
            icon("abilities/brigitte/barrier_shield.bmp"),
            icon("abilities/brigitte/rally.bmp"),
        },
        .slots = &.{
            slot(actor.brigitte.whipshot),
            slot(actor.brigitte.repair_pack),
            slot(actor.brigitte.barrier_shield),
            slot(actor.brigitte.ultimate),
        },
    },
    .{
        .type_id = actor.cassidy.type_id,
        .portrait = icon("portraits/cassidy.bmp"),
        .icons = &.{
            icon("abilities/cassidy/combat_roll.bmp"),
            icon("abilities/cassidy/flashbang.bmp"),
            icon("abilities/cassidy/deadeye.bmp"),
        },
        .slots = &.{
            slot(actor.cassidy.combat_roll),
            slot(actor.cassidy.magnetic_grenade),
            slot(actor.cassidy.ultimate),
        },
    },
    .{
        .type_id = actor.dmon.type_id,
        .portrait = icon("portraits/dmon.bmp"),
        .icons = &.{
            icon("abilities/dmon/propulsors.bmp"),
            icon("abilities/dmon/fusion_repeater.bmp"),
            icon("abilities/dmon/power_barrier.bmp"),
        },
        .slots = &.{
            slot(actor.dmon.propulsors),
            slot(actor.dmon.fusion_repeater),
            slot(actor.dmon.power_barrier),
        },
    },
    .{
        .type_id = actor.doctrine.type_id,
        .portrait = icon("portraits/doctrine.bmp"),
        .icons = &.{
            icon("abilities/doctrine/shrouded_momentum.bmp"),
            icon("abilities/doctrine/invigorating_drones.bmp"),
            icon("abilities/doctrine/infuse.bmp"),
            icon("abilities/doctrine/deliverance.bmp"),
        },
        .slots = &.{
            slot(actor.doctrine.shrouded_momentum),
            slot(actor.doctrine.invigorating_drones),
            slot(actor.doctrine.infuse),
            slot(actor.doctrine.ultimate),
        },
    },
    .{
        .type_id = actor.domina.type_id,
        .portrait = icon("portraits/domina.bmp"),
        .icons = &.{
            icon("abilities/domina/sonic_repulsors.bmp"),
            icon("abilities/domina/crystal_charge.bmp"),
            icon("abilities/domina/barrier_array.bmp"),
            icon("abilities/domina/panopticon.bmp"),
        },
        .slots = &.{
            slot(actor.domina.bubble),
            slot(actor.domina.crystal_charge),
            slot(actor.domina.barrier_array),
            slot(actor.domina.ultimate),
        },
    },
    .{
        .type_id = actor.doomfist.type_id,
        .portrait = icon("portraits/doomfist.bmp"),
        .icons = &.{
            icon("abilities/doomfist/seismic_slam.bmp"),
            icon("abilities/doomfist/power_block.bmp"),
            icon("abilities/doomfist/rocket_punch.bmp"),
            icon("abilities/doomfist/meteor_strike.bmp"),
        },
        .slots = &.{
            slot(actor.doomfist.seismic_slam),
            slot(actor.doomfist.power_block),
            slot(actor.doomfist.rocket_punch),
            slot(actor.doomfist.ultimate),
        },
    },
    .{
        .type_id = actor.dva.type_id,
        .portrait = icon("portraits/dva.bmp"),
        .icons = &.{
            icon("abilities/dva/boosters.bmp"),
            icon("abilities/dva/micro_missiles.bmp"),
            icon("abilities/dva/defense_matrix.bmp"),
            icon("abilities/dva/self_destruct.bmp"),
        },
        .slots = &.{
            slot(actor.dva.boosters),
            slot(actor.dva.micro_missiles),
            slot(actor.dva.matrix),
            slot(actor.dva.ultimate),
        },
    },
    .{
        .type_id = actor.dva.hanasong.type_id,
        .portrait = icon("portraits/dva.bmp"),
        .icons = &.{},
        .slots = &.{},
    },
    .{
        .type_id = actor.echo.type_id,
        .portrait = icon("portraits/echo.bmp"),
        .icons = &.{
            icon("abilities/echo/flight.bmp"),
            icon("abilities/echo/focusing_beam.bmp"),
            icon("abilities/echo/sticky_bombs.bmp"),
            icon("abilities/echo/duplicate.bmp"),
        },
        .slots = &.{
            slot(actor.echo.flight),
            slot(actor.echo.beam),
            slot(actor.echo.sticky_bombs),
            slot(actor.echo.ultimate),
        },
    },
    .{
        .type_id = actor.emre.type_id,
        .portrait = icon("portraits/emre.bmp"),
        .icons = &.{
            icon("abilities/emre/siphon_blaster.bmp"),
            icon("abilities/emre/cyber_frag.bmp"),
            icon("abilities/emre/override_protocol.bmp"),
        },
        .slots = &.{
            slot(actor.emre.shift),
            slot(actor.emre.cyber_frag),
            slot(actor.emre.ultimate),
        },
    },
    .{
        .type_id = actor.freja.type_id,
        .portrait = icon("portraits/freja.bmp"),
        .icons = &.{
            icon("abilities/freja/quick_dash.bmp"),
            icon("abilities/freja/updraft.bmp"),
            icon("abilities/freja/bola_shot.bmp"),
        },
        .slots = &.{
            slot(actor.freja.quick_dash),
            slot(actor.freja.updraft),
            slot(actor.freja.ultimate),
        },
    },
    .{
        .type_id = actor.genji.type_id,
        .portrait = icon("portraits/genji.bmp"),
        .icons = &.{
            icon("abilities/genji/swift_strike.bmp"),
            icon("abilities/genji/deflect.bmp"),
            icon("abilities/genji/dragonblade.bmp"),
        },
        .slots = &.{
            slot(actor.genji.dash),
            slot(actor.genji.deflect),
            slot(actor.genji.ultimate),
        },
    },
    .{
        .type_id = actor.hanzo.type_id,
        .portrait = icon("portraits/hanzo.bmp"),
        .icons = &.{
            icon("abilities/hanzo/sonic_arrow.bmp"),
            icon("abilities/hanzo/storm_arrows.bmp"),
            icon("abilities/hanzo/dragonstrike.bmp"),
        },
        .slots = &.{
            slot(actor.hanzo.sonic_arrow),
            slot(actor.hanzo.stormarrow),
            slot(actor.hanzo.ultimate),
        },
    },
    .{
        .type_id = actor.hazard.type_id,
        .portrait = icon("portraits/hazard.bmp"),
        .icons = &.{
            icon("abilities/hazard/violent_leap.bmp"),
            icon("abilities/hazard/jagged_wall.bmp"),
            icon("abilities/hazard/spike_guard.bmp"),
            icon("abilities/hazard/downpour.bmp"),
        },
        .slots = &.{
            slot(actor.hazard.violent_leap),
            slot(actor.hazard.jagged_wall),
            slot(actor.hazard.spike_guard),
            slot(actor.hazard.ultimate),
        },
    },
    .{
        .type_id = actor.illari.type_id,
        .portrait = icon("portraits/illari.bmp"),
        .icons = &.{
            icon("abilities/illari/outburst.bmp"),
            icon("abilities/illari/healing_pylon.bmp"),
            icon("abilities/illari/captive_sun.bmp"),
        },
        .slots = &.{
            slot(actor.illari.outburst),
            slot(actor.illari.healing_pylon),
            slot(actor.illari.ultimate),
        },
    },
    .{
        .type_id = actor.jetpackcat.type_id,
        .portrait = icon("portraits/jetpackcat.bmp"),
        .icons = &.{
            icon("abilities/jetpackcat/lifeline.bmp"),
            icon("abilities/jetpackcat/purr.bmp"),
            icon("abilities/jetpackcat/frenetic_flight.bmp"),
            icon("abilities/jetpackcat/catnapper.bmp"),
        },
        .slots = &.{
            slot(actor.jetpackcat.bubble),
            slot(actor.jetpackcat.purr),
            slot(actor.jetpackcat.frenetic_flight),
            slot(actor.jetpackcat.ultimate),
        },
    },
    .{
        .type_id = actor.junkerqueen.type_id,
        .portrait = icon("portraits/junkerqueen.bmp"),
        .icons = &.{
            icon("abilities/junkerqueen/commanding_shout.bmp"),
            icon("abilities/junkerqueen/carnage.bmp"),
            icon("abilities/junkerqueen/jagged_blade_gracie.bmp"),
            icon("abilities/junkerqueen/rampage.bmp"),
        },
        .slots = &.{
            slot(actor.junkerqueen.commanding_shout),
            slot(actor.junkerqueen.carnage),
            slot(actor.junkerqueen.jagged_blade),
            slot(actor.junkerqueen.ultimate),
        },
    },
    .{
        .type_id = actor.junkrat.type_id,
        .portrait = icon("portraits/junkrat.bmp"),
        .icons = &.{
            icon("abilities/junkrat/concussion_mine.bmp"),
            icon("abilities/junkrat/steel_trap.bmp"),
            icon("abilities/junkrat/rip_tire.bmp"),
        },
        .slots = &.{
            slot(actor.junkrat.concussion_mine),
            slot(actor.junkrat.steel_trap),
            slot(actor.junkrat.ultimate),
        },
    },
    .{
        .type_id = actor.juno.type_id,
        .portrait = icon("portraits/juno.bmp"),
        .icons = &.{
            icon("abilities/juno/glide_boost.bmp"),
            icon("abilities/juno/hyper_ring.bmp"),
            icon("abilities/juno/pulsar_torpedoes.bmp"),
            icon("abilities/juno/orbital_ray.bmp"),
        },
        .slots = &.{
            slot(actor.juno.orbital_ray),
            slot(actor.juno.hyper_ring),
            slot(actor.juno.pulsar_torpedoes),
            slot(actor.juno.ultimate),
        },
    },
    .{
        .type_id = actor.kiriko.type_id,
        .portrait = icon("portraits/kiriko.bmp"),
        .icons = &.{
            icon("abilities/kiriko/swift_step.bmp"),
            icon("abilities/kiriko/protection_suzu.bmp"),
            icon("abilities/kiriko/kitsune_rush.bmp"),
        },
        .slots = &.{
            slot(actor.kiriko.swift_step),
            slot(actor.kiriko.protection_suzu),
            slot(actor.kiriko.ultimate),
        },
    },
    .{
        .type_id = actor.lifeweaver.type_id,
        .portrait = icon("portraits/lifeweaver.bmp"),
        .icons = &.{
            icon("abilities/lifeweaver/petal_platform.bmp"),
            icon("abilities/lifeweaver/life_grip.bmp"),
            icon("abilities/lifeweaver/tree_of_life.bmp"),
        },
        .slots = &.{
            slot(actor.lifeweaver.petal_platform),
            slot(actor.lifeweaver.life_grip),
            slot(actor.lifeweaver.ultimate),
        },
    },
    .{
        .type_id = actor.lucio.type_id,
        .portrait = icon("portraits/lucio.bmp"),
        .icons = &.{
            icon("abilities/lucio/crossfade.bmp"),
            icon("abilities/lucio/amp_it_up.bmp"),
            icon("abilities/lucio/soundwave.bmp"),
            icon("abilities/lucio/sound_barrier.bmp"),
        },
        .slots = &.{
            slot(actor.lucio.crossfade),
            slot(actor.lucio.amp_it_up),
            slot(actor.lucio.soundwave),
            slot(actor.lucio.ultimate),
        },
    },
    .{
        .type_id = actor.mauga.type_id,
        .portrait = icon("portraits/mauga.bmp"),
        .icons = &.{
            icon("abilities/mauga/overrun.bmp"),
            icon("abilities/mauga/cardiac_overdrive.bmp"),
            icon("abilities/mauga/cage_fight.bmp"),
        },
        .slots = &.{
            slot(actor.mauga.overrun),
            slot(actor.mauga.cardiac_overdrive),
            slot(actor.mauga.ultimate),
        },
    },
    .{
        .type_id = actor.mei.type_id,
        .portrait = icon("portraits/mei.bmp"),
        .icons = &.{
            icon("abilities/mei/cryo_freeze.bmp"),
            icon("abilities/mei/ice_wall.bmp"),
            icon("abilities/mei/weapon.bmp"),
        },
        .slots = &.{
            slot(actor.mei.cryo_freeze),
            slot(actor.mei.ice_wall),
            slot(actor.mei.ultimate),
        },
    },
    .{
        .type_id = actor.mercy.type_id,
        .portrait = icon("portraits/mercy.bmp"),
        .icons = &.{
            icon("abilities/mercy/guardian_angel.bmp"),
            icon("abilities/mercy/resurrect.bmp"),
            icon("abilities/mercy/valkyrie.bmp"),
        },
        .slots = &.{
            slot(actor.mercy.guardian_angel),
            slot(actor.mercy.resurrect),
            slot(actor.mercy.ultimate),
        },
    },
    .{
        .type_id = actor.mizuki.type_id,
        .portrait = icon("portraits/mizuki.bmp"),
        .icons = &.{
            icon("abilities/mizuki/katashiro_return.bmp"),
            icon("abilities/mizuki/binding_chain.bmp"),
            icon("abilities/mizuki/healing_kasa.bmp"),
            icon("abilities/mizuki/kekkai_sanctuary.bmp"),
        },
        .slots = &.{
            slot(actor.mizuki.katashiro_return),
            slot(actor.mizuki.hook),
            slot(actor.mizuki.healing_kasa),
            slot(actor.mizuki.ultimate),
        },
    },
    .{
        .type_id = actor.moira.type_id,
        .portrait = icon("portraits/moira.bmp"),
        .icons = &.{
            icon("abilities/moira/fade.bmp"),
            icon("abilities/moira/biotic_orb.bmp"),
            icon("abilities/moira/coalescence.bmp"),
        },
        .slots = &.{
            slot(actor.moira.fade),
            slot(actor.moira.biotic_orb),
            slot(actor.moira.ultimate),
        },
    },
    .{
        .type_id = actor.orisa.type_id,
        .portrait = icon("portraits/orisa.bmp"),
        .icons = &.{
            icon("abilities/orisa/fortify.bmp"),
            icon("abilities/orisa/javelin_spin.bmp"),
            icon("abilities/orisa/energy_javelin.bmp"),
            icon("abilities/orisa/terra_surge.bmp"),
        },
        .slots = &.{
            slot(actor.orisa.fortify),
            slot(actor.orisa.javelin_spin),
            slot(actor.orisa.energy_javelin),
            slot(actor.orisa.ultimate),
        },
    },
    .{
        .type_id = actor.pharah.type_id,
        .portrait = icon("portraits/pharah.bmp"),
        .icons = &.{
            icon("abilities/pharah/jump_jet.bmp"),
            icon("abilities/pharah/concussive_blast.bmp"),
            icon("abilities/pharah/jet_dash.bmp"),
            icon("abilities/pharah/barrage.bmp"),
        },
        .slots = &.{
            slot(actor.pharah.jump_jet),
            slot(actor.pharah.concussive_blast),
            slot(actor.pharah.jet_dash),
            slot(actor.pharah.ultimate),
        },
    },
    .{
        .type_id = actor.ramattra.type_id,
        .portrait = icon("portraits/ramattra.bmp"),
        .icons = &.{
            icon("abilities/ramattra/nemesis_form.bmp"),
            icon("abilities/ramattra/ravenous_vortex.bmp"),
            icon("abilities/ramattra/void_barrier_omnic_form.bmp"),
            icon("abilities/ramattra/annihilation.bmp"),
        },
        .slots = &.{
            slot(actor.ramattra.nemesis_form),
            slot(actor.ramattra.ravenous_vortex),
            slot(actor.ramattra.void_barrier),
            slot(actor.ramattra.ultimate),
        },
    },
    .{
        .type_id = actor.reaper.type_id,
        .portrait = icon("portraits/reaper.bmp"),
        .icons = &.{
            icon("abilities/reaper/wraith_form.bmp"),
            icon("abilities/reaper/shadow_step.bmp"),
            icon("abilities/reaper/dire_triggers.bmp"),
            icon("abilities/reaper/death_blossom.bmp"),
        },
        .slots = &.{
            slot(actor.reaper.wraith),
            slot(actor.reaper.shadow_step),
            slot(actor.reaper.dire_triggers),
            slot(actor.reaper.ultimate),
        },
    },
    .{
        .type_id = actor.reinhardt.type_id,
        .portrait = icon("portraits/reinhardt.bmp"),
        .icons = &.{
            icon("abilities/reinhardt/charge.bmp"),
            icon("abilities/reinhardt/fire_strike.bmp"),
            icon("abilities/reinhardt/barrier_field.bmp"),
            icon("abilities/reinhardt/earthshatter.bmp"),
        },
        .slots = &.{
            slot(actor.reinhardt.charge),
            slot(actor.reinhardt.fire_strike),
            slot(actor.reinhardt.barrier_field),
            slot(actor.reinhardt.ultimate),
        },
    },
    .{
        .type_id = actor.roadhog.type_id,
        .portrait = icon("portraits/roadhog.bmp"),
        .icons = &.{
            icon("abilities/roadhog/chain_hook.bmp"),
            icon("abilities/roadhog/take_a_breather.bmp"),
            icon("abilities/roadhog/trash_compactor.bmp"),
            icon("abilities/roadhog/whole_hog.bmp"),
        },
        .slots = &.{
            slot(actor.roadhog.chain_hook),
            slot(actor.roadhog.vape),
            slot(actor.roadhog.trash_compactor),
            slot(actor.roadhog.ultimate),
        },
    },
    .{
        .type_id = actor.shion.type_id,
        .portrait = icon("portraits/shion.bmp"),
        .icons = &.{
            icon("abilities/shion/evade.bmp"),
            icon("abilities/shion/joyride.bmp"),
            icon("abilities/shion/execution.bmp"),
            icon("abilities/shion/satsuriku_spree.bmp"),
        },
        .slots = &.{
            slot(actor.shion.ability1),
            slot(actor.shion.ability2),
            slot(actor.shion.execution),
            slot(actor.shion.ultimate),
        },
    },
    .{
        .type_id = actor.sierra.type_id,
        .portrait = icon("portraits/sierra.bmp"),
        .icons = &.{
            icon("abilities/sierra/anchor_drone.bmp"),
            icon("abilities/sierra/tremor_charge.bmp"),
            icon("abilities/sierra/tracking_shot.bmp"),
        },
        .slots = &.{
            slot(actor.sierra.anchor_drone),
            slot(actor.sierra.tremor_charge),
            slot(actor.sierra.tracking_shot),
        },
    },
    .{
        .type_id = actor.sigma.type_id,
        .portrait = icon("portraits/sigma.bmp"),
        .icons = &.{
            icon("abilities/sigma/kinetic_grasp.bmp"),
            icon("abilities/sigma/accretion.bmp"),
            icon("abilities/sigma/experimental_barrier.bmp"),
            icon("abilities/sigma/gravitic_flux.bmp"),
        },
        .slots = &.{
            slot(actor.sigma.kinetic_grasp),
            slot(actor.sigma.accretion),
            slot(actor.sigma.experimental_barrier),
            slot(actor.sigma.ultimate),
        },
    },
    .{
        .type_id = actor.sojourn.type_id,
        .portrait = icon("portraits/sojourn.bmp"),
        .icons = &.{
            icon("abilities/sojourn/power_slide.bmp"),
            icon("abilities/sojourn/disruptor_shot.bmp"),
            icon("abilities/sojourn/overclock.bmp"),
        },
        .slots = &.{
            slot(actor.sojourn.power_slide),
            slot(actor.sojourn.disruptor_shot),
            slot(actor.sojourn.ultimate),
        },
    },
    .{
        .type_id = actor.soldier76.type_id,
        .portrait = icon("portraits/soldier76.bmp"),
        .icons = &.{
            icon("abilities/soldier76/sprint.bmp"),
            icon("abilities/soldier76/biotic_field.bmp"),
            icon("abilities/soldier76/helix_rockets.bmp"),
            icon("abilities/soldier76/tactical_visor.bmp"),
        },
        .slots = &.{
            slot(actor.soldier76.sprint),
            slot(actor.soldier76.biotic_field),
            slot(actor.soldier76.helix),
            slot(actor.soldier76.ultimate),
        },
    },
    .{
        .type_id = actor.sombra.type_id,
        .portrait = icon("portraits/sombra.bmp"),
        .icons = &.{
            icon("abilities/sombra/cyberspace.bmp"),
            icon("abilities/sombra/translocator.bmp"),
            icon("abilities/sombra/hotfix.bmp"),
            icon("abilities/sombra/emp.bmp"),
        },
        .slots = &.{
            slot(actor.sombra.stealth),
            slot(actor.sombra.translocator),
            slot(actor.sombra.hotfix),
            slot(actor.sombra.ultimate),
        },
    },
    .{
        .type_id = actor.symmetra.type_id,
        .portrait = icon("portraits/symmetra.bmp"),
        .icons = &.{
            icon("abilities/symmetra/sentry_turret.bmp"),
            icon("abilities/symmetra/teleporter.bmp"),
            icon("abilities/symmetra/photon_barrier.bmp"),
        },
        .slots = &.{
            slot(actor.symmetra.sentry_turret),
            slot(actor.symmetra.teleporter),
            slot(actor.symmetra.ultimate),
        },
    },
    .{
        .type_id = actor.torbjorn.type_id,
        .portrait = icon("portraits/torbjorn.bmp"),
        .icons = &.{
            icon("abilities/torbjorn/deploy_turret.bmp"),
            icon("abilities/torbjorn/overload.bmp"),
            icon("abilities/torbjorn/molten_core.bmp"),
        },
        .slots = &.{
            slot(actor.torbjorn.deploy_turret),
            slot(actor.torbjorn.overload),
            slot(actor.torbjorn.ultimate),
        },
    },
    .{
        .type_id = actor.tracer.type_id,
        .portrait = icon("portraits/tracer.bmp"),
        .icons = &.{
            icon("abilities/tracer/blink.bmp"),
            icon("abilities/tracer/recall.bmp"),
            icon("abilities/tracer/pulse_bomb.bmp"),
        },
        .slots = &.{
            slot(actor.tracer.blink),
            slot(actor.tracer.recall),
            slot(actor.tracer.ultimate),
        },
    },
    .{
        .type_id = actor.vendetta.type_id,
        .portrait = icon("portraits/vendetta.bmp"),
        .icons = &.{
            icon("abilities/vendetta/whirlwind_dash.bmp"),
            icon("abilities/vendetta/soaring_slice.bmp"),
            icon("abilities/vendetta/sundering_blade.bmp"),
        },
        .slots = &.{
            slot(actor.vendetta.whirlwind_dash),
            slot(actor.vendetta.soaring_slice),
            slot(actor.vendetta.ultimate),
        },
    },
    .{
        .type_id = actor.venture.type_id,
        .portrait = icon("portraits/venture.bmp"),
        .icons = &.{
            icon("abilities/venture/burrow.bmp"),
            icon("abilities/venture/drill_dash.bmp"),
            icon("abilities/venture/tectonic_shock.bmp"),
        },
        .slots = &.{
            slot(actor.venture.burrow),
            slot(actor.venture.drill_dash),
            slot(actor.venture.ultimate),
        },
    },
    .{
        .type_id = actor.widowmaker.type_id,
        .portrait = icon("portraits/widowmaker.bmp"),
        .icons = &.{
            icon("abilities/widowmaker/grappling_hook.bmp"),
            icon("abilities/widowmaker/venom_mine.bmp"),
            icon("abilities/widowmaker/infra_sight.bmp"),
        },
        .slots = &.{
            slot(actor.widowmaker.grappling_hook),
            slot(actor.widowmaker.venom_mine),
            slot(actor.widowmaker.ultimate),
        },
    },
    .{
        .type_id = actor.winston.type_id,
        .portrait = icon("portraits/winston.bmp"),
        .icons = &.{
            icon("abilities/winston/jump_pack.bmp"),
            icon("abilities/winston/barrier_projector.bmp"),
            icon("abilities/winston/primal_rage.bmp"),
        },
        .slots = &.{
            slot(actor.winston.jump_pack),
            slot(actor.winston.barrier_projector),
            slot(actor.winston.ultimate),
        },
    },
    .{
        .type_id = actor.wreckingball.type_id,
        .portrait = icon("portraits/wreckingball.bmp"),
        .icons = &.{
            icon("abilities/wreckingball/roll.bmp"),
            icon("abilities/wreckingball/adaptive_shield.bmp"),
            icon("abilities/wreckingball/grappling_claw.bmp"),
            icon("abilities/wreckingball/minefield.bmp"),
        },
        .slots = &.{
            slot(actor.wreckingball.configuration),
            slot(actor.wreckingball.adaptive_shield),
            slot(actor.wreckingball.grappling_claw),
            slot(actor.wreckingball.ultimate),
        },
    },
    .{
        .type_id = actor.wuyang.type_id,
        .portrait = icon("portraits/wuyang.bmp"),
        .icons = &.{
            icon("abilities/wuyang/rushing_torrent.bmp"),
            icon("abilities/wuyang/guardian_wave.bmp"),
            icon("abilities/wuyang/tidal_blast.bmp"),
        },
        .slots = &.{
            slot(actor.wuyang.rushing_torrent),
            slot(actor.wuyang.guardian_wave),
            slot(actor.wuyang.ultimate),
        },
    },
    .{
        .type_id = actor.zarya.type_id,
        .portrait = icon("portraits/zarya.bmp"),
        .icons = &.{
            icon("abilities/zarya/particle_barrier.bmp"),
            icon("abilities/zarya/projected_barrier.bmp"),
            icon("abilities/zarya/graviton_surge.bmp"),
        },
        .slots = &.{
            slot(actor.zarya.bubble),
            slot(actor.zarya.projected_barrier),
            slot(actor.zarya.ultimate),
        },
    },
    .{
        .type_id = actor.zenyatta.type_id,
        .portrait = icon("portraits/zenyatta.bmp"),
        .icons = &.{
            icon("abilities/zenyatta/orb_of_harmony.bmp"),
            icon("abilities/zenyatta/orb_of_discord.bmp"),
            icon("abilities/zenyatta/transcendence.bmp"),
        },
        .slots = &.{
            slot(actor.zenyatta.orb_of_harmony),
            slot(actor.zenyatta.orb_of_discord),
            slot(actor.zenyatta.ultimate),
        },
    },
};

pub const count: usize = heroes.len;

pub const max_slots: usize = blk: {
    var n: usize = 0;
    for (heroes) |h| n = @max(n, h.icons.len);
    break :blk n;
};

comptime {
    @setEvalBranchQuota(200_000);
    for (heroes, 0..) |h, i| {
        if (h.slots.len != h.icons.len) @compileError("slot and icon counts differ");
        for (heroes[0..i]) |other| {
            if (other.type_id == h.type_id) @compileError("duplicate hero type id");
        }
    }
}

pub fn find(type_id: u64) ?usize {
    for (heroes, 0..) |h, i| {
        if (h.type_id == type_id) return i;
    }
    return null;
}
