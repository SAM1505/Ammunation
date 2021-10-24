ESX  = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local open = false
local mainMenu = RageUI.CreateMenu(false, " ", 0, 0, "shopui_title_gunclub", "shopui_title_gunclub")
local armesBlanches = RageUI.CreateSubMenu(mainMenu, false, " ", 0, 0, "shopui_title_gunclub", "shopui_title_gunclub")
local accessoires = RageUI.CreateSubMenu(mainMenu, false, " ", 0, 0, "shopui_title_gunclub", "shopui_title_gunclub")
local armesLourdes = RageUI.CreateSubMenu(mainMenu, false, " ", 0, 0, "shopui_title_gunclub", "shopui_title_gunclub")
mainMenu.Closed = function()
    RageUI.Visible(mainMenu, false)
    open = false 
end

--- CHECK PPA ---
local function checkLicense()
    ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
        ppa = hasWeaponLicense
    end, GetPlayerServerId(PlayerId()), 'weapon')
end 

local function OpenMenuAmmu()
    if open then 
        open = false
        RageUI.Visible(mainMenu, false)
        return
    else
        open = true 
        RageUI.Visible(mainMenu, true)
        CreateThread(function()
        while open do 
           RageUI.IsVisible(mainMenu,function() 

                checkLicense()

                RageUI.Button("Armes Blanches", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true , {}, armesBlanches)

                RageUI.Button("Accessoires", nil, {RightBadge = RageUI.BadgeStyle.Ammo}, true , {}, accessoires)

                if ppa then
                    RageUI.Button("Armes", nil, {RightBadge = RageUI.BadgeStyle.Gun}, true , {}, armesLourdes)
                else 
                    RageUI.Button("Armes", "~r~Vous devez avoir un PPA !", {RightBadge = RageUI.BadgeStyle.Gun}, false , {}, armesLourdes)
                end

                RageUI.Separator("↓ ~r~Permis Port d'Armes~s~ ↓")

                if not ppa then
                    RageUI.Button("Acheter le PPA", nil, {RightLabel = "~g~50000$"}, true , {
                        onSelected = function()
                            TriggerServerEvent("esx_ammu:ppa", "weapon")
                        end
                    })
                else
                    RageUI.Button("Acheter le PPA", "~r~Vous possédez déjà le PPA !" , {RightLabel = "→"}, false , {})
                end

            end)

            RageUI.IsVisible(armesBlanches,function()

                for k,v in pairs(Config.ArmesBlanches) do
                    RageUI.Button(v.name, "Appuyez sur ~r~[ENTRER]~s~ pour acheter !", {RightLabel = "~g~"..v.price.."$"}, true , {
                        onSelected = function()
                            TriggerServerEvent("esx_ammu:"..v.event)
                        end
                    })
                end

            end)

            RageUI.IsVisible(accessoires,function()

                for k,v in pairs(Config.Accessoires) do
                    RageUI.Button(v.name, "Appuyez sur ~r~[ENTRER]~s~ pour acheter !", {RightLabel = "~g~"..v.price.."$"}, true , {
                        onSelected = function()
                            TriggerServerEvent("esx_ammu:"..v.event)
                        end
                    })
                end

            end)

            RageUI.IsVisible(armesLourdes,function()

                for k,v in pairs(Config.Armes) do
                    RageUI.Button(v.name, "Appuyez sur ~r~[ENTRER]~s~ pour acheter !", {RightLabel = "~g~"..v.price.."$"}, true , {
                        onSelected = function()
                            TriggerServerEvent("esx_ammu:"..v.event)
                        end
                    })
                end

            end)

         Wait(0)
        end
     end)
  end
end

Citizen.CreateThread(function()
    while true do
        local interval = 250
        local playerPos = GetEntityCoords(PlayerPedId())
        for k,v in pairs(Config.PositionAmmu) do
            local dst = #(v.pos-playerPos)
            if dst <= 10.0 then
                DrawMarker(2, v.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 255, 0, 0, 255, true, false, true, true, false, false, false)
                interval = 0
                if dst <= 1.5 then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu")
                    if IsControlJustPressed(0, 51) then
                        OpenMenuAmmu()
                    end
                end
            end
        end
        Wait(interval)
    end
end)

--- PED ---
Citizen.CreateThread(function()
	for k,v in pairs(Config.Ped) do
		local hash = GetHashKey(v.PedName)
		while not HasModelLoaded(hash) do
		RequestModel(hash)
		Wait(20)
		end
		ped = CreatePed("PED_TYPE_CIVFEMALE", v.PedName, v.pos, false, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
		FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
	end
end)

--- BLIPS ---
Citizen.CreateThread(function()
    for k,v in pairs(Config.PositionAmmu) do
   
        local blip = AddBlipForCoord(v.pos)

        SetBlipSprite (blip, 110) -- Model du blip
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.65) -- Taille du blip
        SetBlipColour (blip, 3) -- Couleur du blip
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Ammunation') -- Nom du blip
        EndTextCommandSetBlipName(blip)
    end
end)