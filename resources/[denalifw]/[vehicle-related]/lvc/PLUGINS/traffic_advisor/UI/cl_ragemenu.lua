--[[
---------------------------------------------------
LUXART VEHICLE CONTROL V3 (FOR FIVEM)
---------------------------------------------------
Coded by Lt.Caine
ELS Clicks by Faction
Additional Modification by TrevorBarns
---------------------------------------------------
FILE: cl_ragemenu.lua
PURPOSE: Handle RageUI 
---------------------------------------------------
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
---------------------------------------------------
]]

RMenu.Add('lvc', 'tasettings', RageUI.CreateSubMenu(RMenu:Get('lvc', 'plugins'),'Luxart Vehicle Control', 'Traffic Advisor Settings'))
RMenu:Get('lvc', 'tasettings'):DisplayGlare(false)

Citizen.CreateThread(function()
    while true do
		--TKD SETTINGS
		RageUI.IsVisible(RMenu:Get('lvc', 'tasettings'), function()	
			--[[
			RageUI.List('Combo Key', {'Disabled', 'LSHIFT', 'LCTRL', 'LALT', 'LSHIFT OR (X)', 'LCTRL OR (L3)'}, ta_combokey_index, 'Select key that needs to be held in addition to TA Keys to activate. '~b~( )~s~' indicates controller key.', {}, true, {
			  onListChange = function(Index, Item)
				ta_combokey_index = Index
			  end,
			})	]]		
			RageUI.List('TA HUD Pattern', {'1', '2', '3', '4', '5', '6', '7'}, hud_pattern, 'Change pattern displayed on HUD traffic advisor indicators.', {}, true, {
			  onListChange = function(Index, Item)
				hud_pattern = Index
				HUD:SetItemState('ta_pattern', hud_pattern)
				HUD:SetItemState('ta', state_ta[veh])
			  end,
			})
			--[[
			RageUI.Checkbox('Disable Incorrect Combo Keys', 'Disables key mapping when a combo key that is not assigned is pressed.', block_incorrect_combo, {}, {
			  onChecked = function()
				block_incorrect_combo = true
			  end,          
			  onUnChecked = function()
				block_incorrect_combo = false
			  end
			})	]]			
			RageUI.Checkbox('Save TA State', 'Preserves traffic advisor state on lights toggling. Unchecking this will turn TA extras off when lights are turned off.', TA.preserve_ta_state, {}, {
			  onChecked = function()
				TA.preserve_ta_state = true
			  end,          
			  onUnChecked = function()
				TA.preserve_ta_state = false
			  end
			})					
			RageUI.Checkbox('Sync TA State', '~o~Coming Soon~c ~ When able, sync TA state to nearby vehicles.', false, {Enabled = false}, {
			  onChecked = function()
				TA.sync_ta_state = true
			  end,          
			  onUnChecked = function()
				TA.sync_ta_state = false
			  end
			})
        end)
        Citizen.Wait(0)
	end
end)