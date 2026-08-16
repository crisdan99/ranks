-- ranks/init.lua

ranks = {}

local chat3_exists = minetest.get_modpath("chat3")
local registered   = {}
local default

local storage = minetest.get_mod_storage()

-- Get colour
local function get_colour(colour)
	if type(colour) == "table" and minetest.rgba then
		return minetest.rgba(colour.r, colour.g, colour.b, colour.a)
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
		name = minetest.get_player_by_name(name)
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

		local privs = minetest.get_player_privs(name)

		for priv, val in pairs(def.privs) do
			privs[priv] = val
		end

		minetest.set_player_privs(name, privs)
		return true
	end
end

-- Update nametag
function ranks.update_nametag(name)
	if minetest.settings:get("ranks.prefix_nametag") == "false" then
		return
	end

	local player = minetest.get_player_by_name(name)
	if not player then return end

	local rank = ranks.get_rank(name)
	if rank ~= nil then
		local def    = ranks.get_def(rank)
		local colour = get_colour(def.colour)
		local prefix = def.prefix and minetest.colorize(colour, def.prefix).." " or ""

		player:set_nametag_attributes({
			text = prefix..name,
		})
	end
end

function ranks.set_rank(name, rank)
	if type(name) ~= "string" then
		name = name:get_player_name()
	end

	if registered[rank] and minetest.player_exists(name) then
		local old_rank = ranks.get_rank(name)

		storage:set_string(name, rank)

		ranks.update_nametag(name)
		ranks.update_privs(name)

		if old_rank ~= rank then
			minetest.chat_send_all(
				minetest.colorize("#00FF00",
					"Player " .. name .. " was promoted to " .. rank .. ". Congratulations!"
				)
			)
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
	if minetest.settings:get("ranks.prefix_chat") ~= "false" then
		local rank = ranks.get_rank(name)
		if rank ~= nil then
			local def = ranks.get_def(rank)
			if def.prefix then
				local colour = get_colour(def.colour)
				local prefix = minetest.colorize(colour, def.prefix)
				minetest.chat_send_all(prefix.." <"..name.."> "..message)
				minetest.log("action", "CHAT: " .. def.prefix .. " <" .. name .. "> " .. message)

				-- if minetest.get_modpath("chat_history") then
					-- chat_history.add_message(name, nil, message)
				-- end

				return true
			end
		end
	end
end

-- Privilege
minetest.register_privilege("rank", {
	description = "Permission to use /rank chatcommand",
	give_to_singleplayer = false,
})

-- Join player (Owner message agregado)
minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local rank = ranks.get_rank(name)

	if rank == "owner" then
		minetest.chat_send_all(
			minetest.colorize("#FFD700",
				"*** " .. name .. " (Owner) joined the game."
			)
		)
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
minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	local rank = ranks.get_rank(name)

	if rank == "owner" then
		minetest.chat_send_all(minetest.colorize("#FF5555", "*** " .. name .. " (Owner) left the game.") )
	end
end)

-- Chat override
minetest.register_on_chat_message(function(name, message)
	return ranks.chat_send(name, message)
end)

-- Chatcommand /rank
minetest.register_chatcommand("rank", {
	description = "Set a player's rank",
	params = "<player> <new rank>",
	privs = {rank = true},
	func = function(name, param)
		local param = param:split(" ")

		if #param == 2 then
			if ranks.get_def(param[2]) then
				ranks.set_rank(param[1], param[2])
				return true, "Set "..param[1].."'s rank to "..param[2]
			else
				return false, "Invalid rank"
			end
		end

		return false, "Usage: /rank <player> <rank>"
	end,
})

-- Load default ranks
dofile(minetest.get_modpath("ranks").."/ranks.lua")

local old_ban = minetest.registered_chatcommands["ban"].func

minetest.registered_chatcommands["ban"].func = function(name, param)
	if ranks.get_rank(param) == "owner" then
		return false, "You cannot ban the Owner."
	end
	return old_ban(name, param)
end

