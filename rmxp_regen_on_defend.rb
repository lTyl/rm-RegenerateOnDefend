#===============================================================================
# Regenerate HP/SP on Defend
#===============================================================================
# Written by Ty
# Version 2.0.0
# Release: November 12, 2008
#-------------------------------------------------------------------------------
# Version Changelog
#-------------------------------------------------------------------------------
=begin

    - Version 2.0.0 - November 12, 2008 * Current release
      - Fixed Incorrect Help window display
      - Fixed the enemy becomes fully healed bug
      - Added Enemy Customization Settings
      - Added 'Show Defense Battle Animation' option
      - Script length about 50% shorter
      - Rewrote the script
      
    - Version 1.0.0 - August 11, 2007
      - Original release
=end
# Version 1.0.0 - Original release build
# Version Number = {[Build Release].[Bug Fixes].[Features Added]}
#-------------------------------------------------------------------------------
# What is this script?
#-------------------------------------------------------------------------------
# This script allows actors (and enemies) to Regenerate a percentage of their
# HP and SP when they defend.
#-------------------------------------------------------------------------------
# Compatability:
#-------------------------------------------------------------------------------
# This script may not be compatible with:
#  - The Standard Development Kit (SDK)
#  - Custom battle Systems
#  - Scripts that rewrite the 'make_basic_action_result' Scene_Battle method
#-------------------------------------------------------------------------------
# Begin Customization section
#-------------------------------------------------------------------------------
module TyRegen
  #-----------------------------------------------------------------------------
  # * Actor Regeneration Settings *
  #-----------------------------------------------------------------------------
    # Set the HP Regeneration rate for each actor_id
    # Syntax: {actor_id => percent}
    Actor_HP_regen = {1 => 5, 2 => 6, 3 => 7, 4 => 8}
    # The default value (This is used if actor_id is nil in the hash above.)
    Actor_HP_regen.default = 5
    # Set the SP Regeneration rate for each actor_id
    # Syntax: (actor_id => percent}
    Actor_SP_regen = {1 => 3, 2 => 4, 3 => 5}
    # The default value (This is used if actor_id is nil in the hash above)
    Actor_SP_regen.default = 5
  #-----------------------------------------------------------------------------
  # * Enemy Regeneraton Settings *
  #-----------------------------------------------------------------------------
    # Set the enemy HP regeneration rate
    # Syntax: {enemy_id => percentage}
    Enemy_HP_regen = {2 => 25}
    # Default regeneration percentage
    Enemy_HP_regen.default = 5
    # Set the enemy SP regeneration rate
    Enemy_SP_regen = {2 => 10}
    # Set the enemy default rate (Used if enemy_id = nil)
    Enemy_SP_regen.default = 5
  #-----------------------------------------------------------------------------
  # * EXTRA *
  #-----------------------------------------------------------------------------
    # Show a Battle Animation when you use Defend?
    Use_Defense_Animation = true
    Defend_Battle_Animation_ID = 1
end
#-------------------------------------------------------------------------------
# DO NOT EDIT BELOW THIS LINE
#-------------------------------------------------------------------------------
class Scene_Battle
  # Alias method
  alias ty_regen_200 make_basic_action_result
  #-----------------------------------------------------------------------------
  # Scene_Battle:make_basic_action_result
  #-----------------------------------------------------------------------------
  def make_basic_action_result
    # If defending
    if @active_battler.current_action.basic == 1
      # Perform defense animation
      if TyRegen::Use_Defense_Animation
        @active_battler.animation_id = TyRegen::Defend_Battle_Animation_ID
        @active_battler.animation_hit = true
      end
      # Call regenerate method
      regenerate
      return
    end
    # Call the original code
    ty_regen_200
  end
  #-----------------------------------------------------------------------------
  # Scene_Battle:Regenerate - Regenerate HP/SP on defend
  #-----------------------------------------------------------------------------
  def regenerate
    hp_restore = (@active_battler.maxhp * TyRegen::Actor_HP_regen[@active_battler.id]) /100
    hp_restore = (@active_battler.maxhp * TyRegen::Enemy_HP_regen[@active_battler.id]) /100 if @active_battler.is_a?(Game_Enemy)
    sp_restore = (@active_battler.maxsp * TyRegen::Actor_SP_regen[@active_battler.id]) /100
    sp_restore = (@active_battler.maxsp * TyRegen::Enemy_SP_regen[@active_battler.id]) /100 if @active_battler.is_a?(Game_Enemy)
    hp_store1 = @active_battler.hp
    sp_store1 = @active_battler.sp
    @active_battler.hp += hp_restore
    @active_battler.sp += sp_restore
    hp_store2 = @active_battler.hp
    sp_store2 = @active_battler.sp
    hp_restore = hp_store2 - hp_store1
    sp_restore = sp_store2 - sp_store1
    @help_window.set_text("#{@active_battler.name} recovered #{hp_restore} #{$data_system.words.hp} & #{sp_restore} #{$data_system.words.sp}")
  end
end
#-------------------------------------------------------------------------------
# Terms of Use:
#-------------------------------------------------------------------------------
# Releases may be modified, but editied releases may not be re-distributed.
# Releases may be redistributed, but only if the release is unmodified
# Credit MUST be given at all times.
# Commercial projects must report to the contact email below before using.
# By using these scripts, you agree to the above.
#-------------------------------------------------------------------------------
# Written by Ty
# Contact: Tiggerville2929@gmail.com
# Original Release Date: August 11, 2007
#===============================================================================
# Regenerate HP/SP on Defend
#===============================================================================