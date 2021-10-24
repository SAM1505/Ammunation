ESX  = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for k,v in pairs(Config.ArmesBlanches) do
    RegisterNetEvent("esx_ammu:"..v.event)
    AddEventHandler("esx_ammu:"..v.event, function()
        local _src = source 
        local xPlayer = ESX.GetPlayerFromId(_src)
        local price = v.price

        if xPlayer.getMoney() >= price then
            xPlayer.removeMoney(price)
            xPlayer.addWeapon(v.label, v.ammo)
            TriggerClientEvent('esx:showNotification', _src,  "~b~Ammunation Achat~n~~s~Prix: ~g~"..v.price.."$~s~~n~Paiement: ~o~Liquide")
        else 
            TriggerClientEvent('esx:showNotification', _src, "~r~Achat Impossible~n~~s~Il vous manque ~g~"..price-xPlayer.getMoney().."$")
        end
    end)
end 

for k,v in pairs(Config.Accessoires) do
    RegisterNetEvent("esx_ammu:"..v.event)
    AddEventHandler("esx_ammu:"..v.event, function()
        local _src = source 
        local xPlayer = ESX.GetPlayerFromId(_src)
        local price = v.price

        if xPlayer.getMoney() >= price then
            xPlayer.removeMoney(price)
            xPlayer.addWeapon(v.label, v.ammo)
            TriggerClientEvent('esx:showNotification', _src,  "~b~Ammunation Achat~n~~s~Prix: ~g~"..v.price.."$~s~~n~Paiement: ~o~Liquide")
        else 
            TriggerClientEvent('esx:showNotification', _src, "~r~Achat Impossible~n~~s~Il vous manque ~g~"..price-xPlayer.getMoney().."$")
        end
    end)
end 

for k,v in pairs(Config.Armes) do
    RegisterNetEvent("esx_ammu:"..v.event)
    AddEventHandler("esx_ammu:"..v.event, function()
        local _src = source 
        local xPlayer = ESX.GetPlayerFromId(_src)
        local price = v.price

        if xPlayer.getMoney() >= price then
            xPlayer.removeMoney(price)
            xPlayer.addWeapon(v.label, v.ammo)
            TriggerClientEvent('esx:showNotification', _src,  "~b~Ammunation Achat~n~~s~Prix: ~g~"..v.price.."$~s~~n~Paiement: ~o~Liquide")
        else 
            TriggerClientEvent('esx:showNotification', _src, "~r~Achat Impossible~n~~s~Il vous manque ~g~"..price-xPlayer.getMoney().."$")
        end
    end)
end 

RegisterServerEvent("esx_ammu:ppa")
AddEventHandler("esx_ammu:ppa", function(weapon)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
    local price = Config.PricePPA

	if xPlayer.getMoney() >= price then
        MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
            ['@type'] = weapon,
            ['@owner'] = xPlayer.identifier
        })
	    xPlayer.removeMoney(price)
	    TriggerClientEvent('esx:showNotification', _src, "~b~Ammunation Achat~n~~s~Prix: ~g~"..price.."$~s~~n~Paiement: ~o~Liquide")
	else
		TriggerClientEvent('esx:showNotification', _src, "~r~Achat Impossible~n~~s~Il vous manque ~g~"..price-xPlayer.getMoney().."$")
	end
end)