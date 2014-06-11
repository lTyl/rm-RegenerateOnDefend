#===============================================================================
# Regenerate HP/MP - RMVX Version
#===============================================================================
# Written by Synthesize
# Version 1.2.0
# January 19, 2008
#===============================================================================
#            *This script is not compatible with RPG Maker XP*
#===============================================================================
module SynRegen
  # Format = { Actor_ID => Percent to restore, Actor_ID2 => Percent to restore}
  HP_regen = {1 => 5, 2 =>7} # %
  # You can define how much HP each individual actor regenerates when they
  # Defend. Add new actors by seperating each returning value with a comma (,)
  #-----------------------------------------------------------------------------
  # This value determines the Default Percent growth if the Actor_ID is not 
  # in the above hash
  HP_regen.default = 5 # %
  #-----------------------------------------------------------------------------
  # Set to true to enable HP regen in battle, false to disable.
  Use_hp_regen = true
  #----------------------------------------------------------------------------
  # Format = {Actor_ID => SP to restore
  SP_regen = {1 => 5, 2 => 7} # %
  # You can define how much SP each individual actor regenerates when they
  # defend. Add new actors by seperating each returning value with a comma (,)
  #-----------------------------------------------------------------------------
  # This is the default percentage to regenerate if the Actor_ID is not in the
  # hash.
  SP_regen.default = 5 # %
  #-----------------------------------------------------------------------------
  # Set to true to enable, false to disable
  Use_mp_regen = true
  #-----------------------------------------------------------------------------
  # Draw how much HP/MP the actor regenerated?
  Draw_text = true
  #-----------------------------------------------------------------------------
  # The defense rate if the actor has 'Super Defense'
  Super_guard_rate = 4
  #-----------------------------------------------------------------------------
  # The defense rate if the actor has 'Normal Defense'
  Normal_guard_rate = 2
end
#-------------------------------------------------------------------------------
# Scene_Battle
#   This aliases the execute_action_guard method in Scene_Battle
#-------------------------------------------------------------------------------
class Scene_Battle
  # Alias execute_action_guard
  alias syn_regen_execute_guard execute_action_guard
  #-----------------------------------------------------------------------------
  # Execute Action_Guard
  #-----------------------------------------------------------------------------
  def execute_action_guard
    # Calculate the amount of HP and MP gained
    hp_restore = ((@active_battler.maxhp * SynRegen::HP_regen[@active_battler.id]) / 100) if SynRegen::Use_hp_regen == true
    sp_restore = ((@active_battler.maxmp * SynRegen::SP_regen[@active_battler.id]) / 100) if SynRegen::Use_mp_regen == true
    # Calculate the different between MaxHP, HP, MaxMP and MP
    temp_value_hp = (@active_battler.maxhp - @active_battler.hp)
    temp_value_mp = (@active_battler.maxmp - @active_battler.mp)
    # Add HP and MP
    @active_battler.hp += hp_restore if SynRegen::Use_hp_regen == true
    @active_battler.mp += sp_restore if SynRegen::Use_mp_regen == true
    # Draw how much HP/MP the actor regenerated
    if temp_value_hp != 0 and temp_value_mp != 0
      @message_window.add_instant_text("#{@active_battler.name} HP increased by #{hp_restore} and MP increased by #{sp_restore}")
    elsif temp_value_hp != 0 and temp_value_mp == 0
      @message_window.add_instant_text("#{@active_battler.name} HP increased by #{hp_restore}")
    elsif temp_value_hp == 0 and temp_value_mp != 0
      @message_window.add_instant_text("#{@active_battler.name} MP increased by #{sp_restore}")
    end
    # Call the original code
    syn_regen_execute_guard
  end
end
#-------------------------------------------------------------------------------
# Game_Battler
#   This rewrites the defense method found in Game_Battler
#-------------------------------------------------------------------------------
class Game_Battler
  #-----------------------------------------------------------------------------
  # Apply_Guard_Damage
  #-----------------------------------------------------------------------------
  def apply_guard(damage)
    if damage > 0 and guarding?
      # Divide the total damage from the effectivness of the defense rate.
      damage /= super_guard ? SynRegen::Super_guard_rate : SynRegen::Normal_guard_rate    
    end
    return damage
  end
end
#===============================================================================
# This script is not compatible with Rpg Maker XP. However, I have also made a
# RPG Maker Xp version which can be found on RPGRPG Revolution.
#===============================================================================
# Written by Synthesize
# January 19, 2008
#===============================================================================
# Regenerate HP/MP - RMVX Version
#===============================================================================