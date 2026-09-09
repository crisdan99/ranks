-- ranks/init.lua
local S = core.get_translator(core.get_current_modname())

ranks = {}

local chat3_exists = core.get_modpath("chat3")
local registered   = {}
local default

local storage = core.get_mod_storage()

-- Get colour
local function get_colour(colour)
	if type(colour) == "table" and core.rgba then
		return core.rgba(colour.r, colour.g, colour.b, colour.a)
	elseif type(colour) == "string" then
		return colour
	else
		return "#ffffff"
	end
end

-- Register rank
function ranks.register(name, def)
	assert(name ~= "clear", "Invalid name \"clear\" for rank")

	registered[name] = def

	if def.default then
		default = name
	end
end

-- Unregister rank
function ranks.unregister(name)
	registered[name] = nil
end

-- List ranks
function ranks.list_plaintext()
	local list = ""
	for rank, i in pairs(registered) do
		if list == "" then
			list = rank
		else
			list = list..", "..rank
		end
	end
	return list
end

-- Get player rank
function ranks.get_rank(name)
	if type(name) ~= "string" then
		name = core.get_player_by_name(name)
	end

	local rank = storage:get_string(name)
	if rank ~= "" and registered[rank] then
		return rank
	end
end

-- Get rank def
function ranks.get_def(rank)
	if not rank then return end
	return registered[rank]
end

-- Update privs
function ranks.update_privs(name, trigger)
	if type(name) ~= "string" then
    	name = name:get_player_name()
	end

	local rank = ranks.get_rank(name)
	if rank ~= nil then

		local def = registered[rank]
		if not def.privs then return end

		local privs = core.get_player_privs(name)

		for priv, val in pairs(def.privs) do
			privs[priv] = val
		end

		core.set_player_privs(name, privs)
		return true
	end
end

-- Update nametag
function ranks.update_nametag(name)
	if core.settings:get("ranks.prefix_nametag") == "false" then
		return
	end

	local player = core.get_player_by_name(name)
	if not player then return end

	local rank = ranks.get_rank(name)
	if rank ~= nil then
		local def    = ranks.get_def(rank)
		local colour = get_colour(def.colour)
		local prefix = def.prefix and core.colorize(colour, def.prefix).." " or ""

		player:set_nametag_attributes({
			text = prefix..name,
		})
	end
end

function ranks.set_rank(name, rank)
	if type(name) ~= "string" then
		name = name:get_player_name()
	end

	if registered[rank] and core.player_exists(name) then
		local old_rank = ranks.get_rank(name)

		storage:set_string(name, rank)

		ranks.update_nametag(name)
		ranks.update_privs(name)

		if old_rank ~= rank then
			core.chat_send_all(core.colorize("#00FF00", S("Player @1 was promoted to @2. Congratulations!", name, rank) ) )
		end

		return true
	end
end

-- Remove rank
function ranks.remove_rank(name)
	if type(name) ~= "string" then
		name = name:get_player_name()
	end

	storage:set_string(name, "")
end

-- Chat prefix
function ranks.chat_send(name, message)
	if core.settings:get("ranks.prefix_chat") ~= "false" then
		local rank = ranks.get_rank(name)
		if rank ~= nil then
			local def = ranks.get_def(rank)
			if def.prefix and def.prefix_text then
				local colour = get_colour(def.colour)
				local prefix = core.colorize(colour, def.prefix)
				local log_prefix = def.prefix_text
				core.chat_send_all(prefix.." <"..name.."> "..message)
				core.log("action", "CHAT: " .. log_prefix .. " <" .. name .. "> " .. message)

				-- if core.get_modpath("chat_history") then
					-- chat_history.add_message(name, nil, message)
				-- end

				return true
			end
		end
	end
end

-- Privilege
core.register_privilege("rank", {
	description = S("Permission to use /rank chatcommand"),
	give_to_singleplayer = false,
})

-- Join player (Owner message agregado)
core.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local rank = ranks.get_rank(name)

	if rank == "owner" then
		core.chat_send_all(core.colorize("#FFD700", S("*** @1 (Owner) joined the game.", name) ) )
	end

	if ranks.get_rank(name) then
		ranks.update_nametag(name)
		ranks.update_privs(name)
	else
		if default then
			ranks.set_rank(name, default)
		end
	end
end)

-- Leave player (Owner message)
core.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	local rank = ranks.get_rank(name)

	if rank == "owner" then
		core.chat_send_all(core.colorize("#FF5555", S("*** @1 (Owner) left the game.", name) ) )
	end
end)

-- Chat override
if not core.get_modpath("jc_translate") then
	core.register_on_chat_message(function(name, message)
		return ranks.chat_send(name, message)
	end)
end

-- Chatcommand /rank
core.register_chatcommand("rank", {
	description = S("Set a player's rank"),
	params = S("<player> <new rank>"),
	privs = {rank = true},
	func = function(name, param)
		local param = param:split(" ")

		if #param == 2 then
			if ranks.get_def(param[2]) then
				ranks.set_rank(param[1], param[2])
				return true, S("Set @1's rank to @2", param[1], param[2])
			else
				return false, S("Invalid rank")
			end
		end

		return false, S("Usage: /rank <player> <rank>")
	end,
})

-- Load default ranks
dofile(core.get_modpath("ranks").."/ranks.lua")

local old_ban = core.registered_chatcommands["ban"].func

core.registered_chatcommands["ban"].func = function(name, param)
	if ranks.get_rank(param) == "owner" then
		return false, S("You cannot ban the Owner.")
	end
	return old_ban(name, param)
end

