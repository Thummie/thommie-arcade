local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('arcade:playGame', function(source, cb, price)
    local paid = false
    local Player = QBCore.Functions.GetPlayer(source)
    
    if Player.Functions.RemoveMoney('cash', price, 'arcade-minigame') then
        paid = true
    else
        paid = false
    end
    
    cb(paid)
end)